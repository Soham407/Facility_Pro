import { NextRequest, NextResponse } from "next/server";

import { createServiceRoleClient } from "@/src/lib/platform/server";
import { createClient as createServerClient } from "@/src/lib/supabase/server";
import { getManagedSocietyIdsForUser } from "@/src/lib/society/managedSocieties";
import { sanitizeLikeInput } from "@/lib/sanitize";

type RoleRow = { role_name?: string | null };
type UserRoleRow = { roles?: RoleRow | RoleRow[] | null };

const VISITOR_PAGE_ROLES = new Set(["admin", "super_admin", "society_manager"]);

async function getAuthorizedVisitorViewer() {
  const supabase = await createServerClient();
  const supabaseAdmin = createServiceRoleClient();
  const {
    data: { user },
    error: authError,
  } = await supabase.auth.getUser();

  if (authError || !user) {
    return {
      error: NextResponse.json({ error: "Unauthorized" }, { status: 401 }),
      userId: null as string | null,
      roleName: null as string | null,
    };
  }

  const { data: userRecord, error: userError } = await supabaseAdmin
    .from("users")
    .select("roles(role_name)")
    .eq("id", user.id)
    .maybeSingle();

  if (userError || !userRecord) {
    return {
      error: NextResponse.json({ error: "Forbidden" }, { status: 403 }),
      userId: null as string | null,
      roleName: null as string | null,
    };
  }

  const userRow = userRecord as UserRoleRow | null;
  const roleRecord = Array.isArray(userRow?.roles) ? userRow.roles[0] : userRow?.roles;
  const roleName = roleRecord?.role_name ?? null;

  if (!roleName || !VISITOR_PAGE_ROLES.has(roleName)) {
    return {
      error: NextResponse.json({ error: "Forbidden" }, { status: 403 }),
      userId: null as string | null,
      roleName: null as string | null,
    };
  }

  return { error: null, userId: user.id, roleName };
}

async function resolveFlatIdsForSocieties(
  supabaseAdmin: ReturnType<typeof createServiceRoleClient>,
  societyIds: string[],
) {
  if (societyIds.length === 0) return [] as string[];

  const { data: buildings, error: buildingError } = await supabaseAdmin
    .from("buildings")
    .select("id")
    .eq("is_active", true)
    .in("society_id", societyIds);

  if (buildingError) throw buildingError;

  const buildingIds = (buildings ?? [])
    .map((building) => building.id)
    .filter((id): id is string => typeof id === "string");

  if (buildingIds.length === 0) return [] as string[];

  const { data: flats, error: flatError } = await supabaseAdmin
    .from("flats")
    .select("id")
    .eq("is_active", true)
    .in("building_id", buildingIds);

  if (flatError) throw flatError;

  return (flats ?? [])
    .map((flat) => flat.id)
    .filter((id): id is string => typeof id === "string");
}

export async function GET(request: NextRequest) {
  try {
    const auth = await getAuthorizedVisitorViewer();
    if (auth.error) return auth.error;

    const supabaseAdmin = createServiceRoleClient();
    const searchParams = request.nextUrl.searchParams;

    let managedSocietyIds: Set<string> | null = null;
    if (auth.roleName === "society_manager") {
      managedSocietyIds = await getManagedSocietyIdsForUser(supabaseAdmin, auth.userId!);
      if (managedSocietyIds.size === 0) {
        return NextResponse.json({ visitors: [] });
      }
    }

    let query = supabaseAdmin
      .from("visitors")
      .select(
        `
        id,
        visitor_name,
        visitor_type,
        phone,
        vehicle_number,
        photo_url,
        flat_id,
        resident_id,
        purpose,
        entry_time,
        exit_time,
        entry_guard_id,
        exit_guard_id,
        entry_location_id,
        approved_by_resident,
        approval_status,
        rejection_reason,
        bypass_reason,
        visitor_pass_number,
        is_frequent_visitor,
        created_at,
        flat:flats!visitors_flat_id_fkey(
          flat_number,
          building:buildings!flats_building_id_fkey(
            building_name,
            society_id
          )
        ),
        resident:residents!visitors_resident_id_fkey(full_name, phone),
        entry_guard:security_guards!visitors_entry_guard_id_fkey(
          guard_code,
          employee:employees(first_name, last_name)
        )
      `,
      )
      .order("entry_time", { ascending: false });

    if (auth.roleName === "society_manager") {
      const scopedFlatIds = await resolveFlatIdsForSocieties(
        supabaseAdmin,
        Array.from(managedSocietyIds ?? []),
      );
      if (scopedFlatIds.length === 0) {
        return NextResponse.json({ visitors: [] });
      }
      query = query.in("flat_id", scopedFlatIds);
    } else if (searchParams.get("societyId")) {
      const scopedFlatIds = await resolveFlatIdsForSocieties(supabaseAdmin, [
        searchParams.get("societyId") as string,
      ]);
      if (scopedFlatIds.length === 0) {
        return NextResponse.json({ visitors: [] });
      }
      query = query.in("flat_id", scopedFlatIds);
    }

    const status = searchParams.get("status");
    if (status === "active") {
      query = query.is("exit_time", null);
    } else if (status === "completed") {
      query = query.not("exit_time", "is", null);
    }

    const type = searchParams.get("type");
    if (type) {
      query = query.eq("visitor_type", type);
    }

    const flatId = searchParams.get("flatId");
    if (flatId) {
      query = query.eq("flat_id", flatId);
    }

    const dateFrom = searchParams.get("dateFrom");
    if (dateFrom) {
      query = query.gte("entry_time", dateFrom);
    }

    const dateTo = searchParams.get("dateTo");
    if (dateTo) {
      query = query.lte("entry_time", dateTo);
    }

    const searchTerm = searchParams.get("searchTerm");
    if (searchTerm) {
      const safeSearch = sanitizeLikeInput(searchTerm);
      query = query.or(`visitor_name.ilike.%${safeSearch}%,phone.ilike.%${safeSearch}%`);
    }

    const { data, error } = await query;
    if (error) throw error;

    return NextResponse.json({ visitors: data ?? [] });
  } catch (error: unknown) {
    return NextResponse.json(
      { error: error instanceof Error ? error.message : "Failed to fetch visitors" },
      { status: 500 },
    );
  }
}

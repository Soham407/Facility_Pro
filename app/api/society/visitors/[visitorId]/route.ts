import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";

import { createServiceRoleClient } from "@/src/lib/platform/server";
import { createClient as createServerClient } from "@/src/lib/supabase/server";
import { getManagedSocietyIdsForUser } from "@/src/lib/society/managedSocieties";

const VisitorActionSchema = z.discriminatedUnion("action", [
  z.object({
    action: z.literal("issue_pass"),
  }),
  z.object({
    action: z.literal("set_frequent"),
    isFrequent: z.boolean(),
  }),
]);

const ISSUE_PASS_ROLES = new Set([
  "admin",
  "super_admin",
  "society_manager",
  "security_guard",
  "security_supervisor",
]);

const FREQUENT_VISITOR_ROLES = new Set([
  "admin",
  "super_admin",
  "society_manager",
  "security_supervisor",
]);

const VISITOR_MANAGEMENT_ROLES = new Set([
  ...ISSUE_PASS_ROLES,
  ...FREQUENT_VISITOR_ROLES,
]);

type RoleRow = { role_name?: string | null };
type UserRoleRow = { roles?: RoleRow | RoleRow[] | null };
type VisitorFlatRow = {
  entry_guard_id?: string | null;
  entry_location_id?: string | null;
  flats?: {
    buildings?: { society_id?: string | null } | { society_id?: string | null }[] | null;
  } | {
    buildings?: { society_id?: string | null } | { society_id?: string | null }[] | null;
  }[] | null;
};

type GuardScope = {
  guardIds: Set<string>;
  locationIds: Set<string>;
};

async function getSecurityScopeForUser(
  supabaseAdmin: ReturnType<typeof createServiceRoleClient>,
  authUserId: string,
): Promise<GuardScope> {
  const { data: employee, error: employeeError } = await supabaseAdmin
    .from("employees")
    .select("id")
    .eq("auth_user_id", authUserId)
    .maybeSingle();

  if (employeeError || !employee?.id) {
    return { guardIds: new Set(), locationIds: new Set() };
  }

  const { data: guards, error: guardError } = await supabaseAdmin
    .from("security_guards")
    .select("id, assigned_location_id")
    .eq("employee_id", employee.id)
    .eq("is_active", true);

  if (guardError) {
    throw guardError;
  }

  return {
    guardIds: new Set((guards ?? []).map((guard) => guard.id).filter((id): id is string => Boolean(id))),
    locationIds: new Set(
      (guards ?? [])
        .map((guard) => guard.assigned_location_id)
        .filter((id): id is string => Boolean(id)),
    ),
  };
}

async function getAuthorizedVisitorManager() {
  const supabase = await createServerClient();
  const supabaseAdmin = createServiceRoleClient();
  const {
    data: { user },
    error: authError,
  } = await supabase.auth.getUser();

  if (authError || !user) {
    return {
      error: NextResponse.json({ error: "Unauthorized" }, { status: 401 }),
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
      roleName: null as string | null,
    };
  }

  const userRow = userRecord as UserRoleRow | null;
  const roleRecord = Array.isArray(userRow?.roles) ? userRow.roles[0] : userRow?.roles;
  const roleName = roleRecord?.role_name ?? null;

  if (!roleName || !VISITOR_MANAGEMENT_ROLES.has(roleName)) {
    return {
      error: NextResponse.json({ error: "Forbidden" }, { status: 403 }),
      roleName,
      userId: null as string | null,
    };
  }

  return { error: null, roleName, userId: user.id };
}

async function canManageVisitor(visitorId: string, userId: string, roleName: string | null) {
  const supabaseAdmin = createServiceRoleClient();
  const { data: visitorRecord, error: visitorError } = await supabaseAdmin
    .from("visitors")
    .select("id, entry_guard_id, entry_location_id, flats(buildings(society_id))")
    .eq("id", visitorId)
    .maybeSingle();

  if (visitorError || !visitorRecord) {
    return false;
  }

  if (roleName === "admin" || roleName === "super_admin") {
    return true;
  }

  const visitorRow = visitorRecord as VisitorFlatRow | null;

  if (roleName === "security_guard" || roleName === "security_supervisor") {
    const scope = await getSecurityScopeForUser(supabaseAdmin, userId);
    return Boolean(
      (visitorRow?.entry_guard_id && scope.guardIds.has(visitorRow.entry_guard_id)) ||
        (visitorRow?.entry_location_id && scope.locationIds.has(visitorRow.entry_location_id)),
    );
  }

  const managedSocietyIds = await getManagedSocietyIdsForUser(supabaseAdmin, userId);
  const flatRecord = Array.isArray(visitorRow?.flats) ? visitorRow.flats[0] : visitorRow?.flats;
  const buildingRecord = Array.isArray(flatRecord?.buildings)
    ? flatRecord.buildings[0]
    : flatRecord?.buildings;

  return Boolean(buildingRecord?.society_id && managedSocietyIds.has(buildingRecord.society_id));
}

export async function PATCH(
  request: NextRequest,
  context: { params: Promise<{ visitorId: string }> },
) {
  try {
    const auth = await getAuthorizedVisitorManager();
    if (auth.error) return auth.error;

    const { visitorId } = await context.params;
    const body = await request.json();
    const parsed = VisitorActionSchema.safeParse(body);

    if (!parsed.success) {
      return NextResponse.json(
        { error: parsed.error.issues.map((issue) => issue.message).join(", ") },
        { status: 400 },
      );
    }

    if (!(await canManageVisitor(visitorId, auth.userId!, auth.roleName))) {
      return NextResponse.json({ error: "Forbidden" }, { status: 403 });
    }

    const supabaseAdmin = createServiceRoleClient();

    if (parsed.data.action === "issue_pass") {
      if (!ISSUE_PASS_ROLES.has(auth.roleName ?? "")) {
        return NextResponse.json({ error: "Forbidden" }, { status: 403 });
      }

      const values = new Uint16Array(1);
      crypto.getRandomValues(values);
      const passNumber = `PASS-${(values[0] % 9000) + 1000}`;
      const { error } = await supabaseAdmin
        .from("visitors")
        .update({ visitor_pass_number: passNumber })
        .eq("id", visitorId);

      if (error) throw error;

      return NextResponse.json({ success: true, passNumber });
    }

    if (!FREQUENT_VISITOR_ROLES.has(auth.roleName ?? "")) {
      return NextResponse.json({ error: "Forbidden" }, { status: 403 });
    }

    const { error } = await supabaseAdmin
      .from("visitors")
      .update({ is_frequent_visitor: parsed.data.isFrequent })
      .eq("id", visitorId);

    if (error) throw error;

    return NextResponse.json({ success: true, isFrequent: parsed.data.isFrequent });
  } catch (error: unknown) {
    console.error("Visitor mutation error:", error);
    return NextResponse.json(
      { error: error instanceof Error ? error.message : "Failed to update visitor" },
      { status: 500 },
    );
  }
}

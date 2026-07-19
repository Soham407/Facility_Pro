import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";

import { createServiceRoleClient } from "@/src/lib/platform/server";
import { coerceRTVTicketRows, mapRTVTicketRow } from "@/src/lib/rtv/rtvTransforms";
import { createClient as createServerClient } from "@/src/lib/supabase/server";

const SupplierReturnUpdateSchema = z.object({
  ticketId: z.string().uuid(),
  status: z.enum([
    "pending_dispatch",
    "in_transit",
    "accepted_by_vendor",
    "credit_note_issued",
    "rejected_by_vendor",
  ]),
  additionalData: z.record(z.string(), z.unknown()).optional(),
});

type SupplierUserRecord = {
  supplier_id?: string | null;
  roles?: { role_name?: string | null } | Array<{ role_name?: string | null }> | null;
};

function getRoleName(userRecord: SupplierUserRecord | null): string | null {
  const roleRecord = Array.isArray(userRecord?.roles) ? userRecord?.roles[0] : userRecord?.roles;
  return roleRecord?.role_name ?? null;
}

function isSupplierPortalRole(roleName: string | null) {
  return roleName === "supplier" || roleName === "vendor";
}

function buildSupplierReturnsSelect() {
  return `
    *,
    supplier:suppliers(supplier_name),
    product:products(product_name),
    purchase_order:purchase_orders(po_number)
  `;
}

async function resolveSupplierContext() {
  const supabase = await createServerClient();
  const supabaseAdmin = createServiceRoleClient();
  const {
    data: { user },
    error: authError,
  } = await supabase.auth.getUser();

  if (authError || !user) {
    return { error: NextResponse.json({ error: "Unauthorized" }, { status: 401 }) };
  }

  const { data: userRecord, error: userError } = await supabaseAdmin
    .from("users")
    .select("supplier_id, roles(role_name)")
    .eq("id", user.id)
    .maybeSingle();

  if (userError || !userRecord) {
    return { error: NextResponse.json({ error: "Forbidden" }, { status: 403 }) };
  }

  const supplierId = (userRecord as SupplierUserRecord).supplier_id ?? null;
  const roleName = getRoleName(userRecord as SupplierUserRecord);
  if (!supplierId || !isSupplierPortalRole(roleName)) {
    return { error: NextResponse.json({ error: "Forbidden" }, { status: 403 }) };
  }

  return { supabaseAdmin, supplierId };
}

export async function GET(request: NextRequest) {
  const context = await resolveSupplierContext();
  if ("error" in context) {
    return context.error;
  }
  const { supplierId, supabaseAdmin } = context;

  const statusesParam = request.nextUrl.searchParams.get("statuses");
  const statuses = statusesParam
    ? statusesParam
        .split(",")
        .map((status) => status.trim())
        .filter(Boolean)
    : [];

  let query = supabaseAdmin
    .from("rtv_tickets")
    .select(buildSupplierReturnsSelect())
    .eq("supplier_id", supplierId)
    .order("created_at", { ascending: false });

  if (statuses.length > 0) {
    query = query.in("status", statuses);
  }

  const { data, error } = await query;
  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  return NextResponse.json({
    tickets: coerceRTVTicketRows(data).map(mapRTVTicketRow),
  });
}

export async function PATCH(request: NextRequest) {
  const context = await resolveSupplierContext();
  if ("error" in context) {
    return context.error;
  }
  const { supplierId, supabaseAdmin } = context;

  const parsed = SupplierReturnUpdateSchema.safeParse(await request.json());
  if (!parsed.success) {
    return NextResponse.json(
      { error: parsed.error.issues.map((issue) => issue.message).join(", ") },
      { status: 400 }
    );
  }

  const { data: targetTicket, error: targetError } = await supabaseAdmin
    .from("rtv_tickets")
    .select("id, supplier_id")
    .eq("id", parsed.data.ticketId)
    .maybeSingle();

  if (targetError || !targetTicket) {
    return NextResponse.json({ error: "Return ticket not found" }, { status: 404 });
  }

  if (targetTicket.supplier_id !== supplierId) {
    return NextResponse.json({ error: "Forbidden" }, { status: 403 });
  }

  const updatePayload: Record<string, unknown> = {
    status: parsed.data.status,
    ...(parsed.data.additionalData ?? {}),
  };

  if (parsed.data.status === "in_transit") updatePayload.dispatched_at = new Date().toISOString();
  if (parsed.data.status === "accepted_by_vendor") updatePayload.accepted_at = new Date().toISOString();
  if (parsed.data.status === "credit_note_issued") updatePayload.credit_issued_at = new Date().toISOString();

  const { error } = await supabaseAdmin
    .from("rtv_tickets")
    .update(updatePayload)
    .eq("id", parsed.data.ticketId)
    .eq("supplier_id", supplierId);

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  return NextResponse.json({ success: true });
}

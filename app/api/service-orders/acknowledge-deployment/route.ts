import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";

import { createServiceRoleClient } from "@/src/lib/platform/server";
import { createClient as createServerClient } from "@/src/lib/supabase/server";

const AcknowledgeDeploymentSchema = z.object({
  spoId: z.string().uuid(),
  headcountReceived: z.number().int().min(0),
  gradeVerified: z.boolean(),
  notes: z.string().trim().optional().nullable(),
});

type UserRoleRecord = {
  roles?: { role_name?: string | null } | Array<{ role_name?: string | null }> | null;
};

function getRoleName(userRecord: UserRoleRecord | null) {
  const roleRecord = Array.isArray(userRecord?.roles) ? userRecord?.roles[0] : userRecord?.roles;
  return roleRecord?.role_name ?? null;
}

function canAcknowledgeDeployment(roleName: string | null) {
  return ["admin", "super_admin", "site_supervisor", "account"].includes(roleName ?? "");
}

export async function POST(request: NextRequest) {
  try {
    const supabase = await createServerClient();
    const supabaseAdmin = createServiceRoleClient();
    const {
      data: { user },
      error: authError,
    } = await supabase.auth.getUser();

    if (authError || !user) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const parsed = AcknowledgeDeploymentSchema.safeParse(await request.json());
    if (!parsed.success) {
      return NextResponse.json(
        { error: parsed.error.issues.map((issue) => issue.message).join(", ") },
        { status: 400 }
      );
    }

    const { data: userRecord, error: userError } = await supabaseAdmin
      .from("users")
      .select("roles(role_name)")
      .eq("id", user.id)
      .maybeSingle();

    if (userError || !canAcknowledgeDeployment(getRoleName(userRecord as UserRoleRecord | null))) {
      return NextResponse.json({ error: "Forbidden" }, { status: 403 });
    }

    const { data: employeeRecord, error: employeeError } = await supabaseAdmin
      .from("employees")
      .select("id")
      .eq("auth_user_id", user.id)
      .maybeSingle();

    if (employeeError) {
      throw employeeError;
    }
    if (!employeeRecord?.id) {
      return NextResponse.json(
        { error: "Deployment acknowledgment requires a linked employee profile." },
        { status: 409 }
      );
    }

    const { data: deliveryNote, error: deliveryNoteError } = await supabaseAdmin
      .from("service_delivery_notes")
      .select("id")
      .eq("po_id", parsed.data.spoId)
      .order("created_at", { ascending: false })
      .limit(1)
      .maybeSingle();

    if (deliveryNoteError) {
      throw deliveryNoteError;
    }
    if (!deliveryNote?.id) {
      return NextResponse.json(
        { error: "A delivery note must exist before deployment can be acknowledged." },
        { status: 409 }
      );
    }

    const { data: serviceItems, error: serviceItemsError } = await supabaseAdmin
      .from("service_purchase_order_items")
      .select("quantity")
      .eq("spo_id", parsed.data.spoId);

    if (serviceItemsError) {
      throw serviceItemsError;
    }

    const expectedHeadcount = (serviceItems ?? []).reduce(
      (sum, item) => sum + Number(item.quantity ?? 0),
      0
    );
    const notes = parsed.data.notes?.trim() || null;
    const timestamp = new Date().toISOString();

    const { error: upsertError } = await supabaseAdmin
      .from("service_acknowledgments")
      .upsert(
        {
          spo_id: parsed.data.spoId,
          acknowledged_by: user.id,
          headcount_expected: expectedHeadcount,
          headcount_received: parsed.data.headcountReceived,
          grade_verified: parsed.data.gradeVerified,
          notes,
          status: "acknowledged",
          updated_at: timestamp,
        },
        { onConflict: "spo_id" }
      );

    if (upsertError) {
      throw upsertError;
    }

    const { error: deliveryNoteUpdateError } = await supabaseAdmin
      .from("service_delivery_notes")
      .update({
        status: "verified",
        verified_by: employeeRecord.id,
        verified_at: timestamp,
        remarks: notes,
      })
      .eq("id", deliveryNote.id);

    if (deliveryNoteUpdateError) {
      throw deliveryNoteUpdateError;
    }

    const { error: updateError } = await supabaseAdmin
      .from("service_purchase_orders")
      .update({ status: "deployment_confirmed", updated_at: timestamp })
      .eq("id", parsed.data.spoId);

    if (updateError) {
      throw updateError;
    }

    return NextResponse.json({ success: true });
  } catch (error: unknown) {
    console.error("Deployment acknowledgment error:", error);
    return NextResponse.json(
      { error: error instanceof Error ? error.message : "Failed to acknowledge deployment" },
      { status: 500 }
    );
  }
}

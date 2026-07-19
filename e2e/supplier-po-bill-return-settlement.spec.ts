import crypto from "node:crypto";

import { expect, test } from "@playwright/test";

import { createServiceRoleClient, readFeatureFixtureState } from "./helpers/db";
import { loginAsRole } from "./helpers/auth";

function fixtureIds() {
  return readFeatureFixtureState().ids;
}

async function runMutation<T>(operation: PromiseLike<{ data: T; error: { message?: string } | Error | null }>) {
  const { data, error } = await operation;
  if (error) {
    throw new Error(error instanceof Error ? error.message : error.message ?? "Supabase mutation failed");
  }
  return data;
}

async function seedSupplierWorkflow() {
  const client = createServiceRoleClient();
  const ids = fixtureIds();
  const token = crypto.randomUUID().replace(/-/g, "").slice(0, 8).toUpperCase();
  const today = new Date().toISOString().slice(0, 10);

  const requestId = crypto.randomUUID();
  const indentId = crypto.randomUUID();
  const poId = crypto.randomUUID();
  const poItemId = crypto.randomUUID();
  const receiptId = crypto.randomUUID();
  const receiptItemId = crypto.randomUUID();
  const rtvId = crypto.randomUUID();

  const requestNumber = `REQ-SUP-${token}`;
  const indentNumber = `IND-SUP-${token}`;
  const poNumber = `PO-SUP-${token}`;
  const grnNumber = `GRN-SUP-${token}`;
  const billNumber = `BILL-SUP-${token}`;
  const supplierInvoiceNumber = `SUP-INV-${token}`;
  const billId = crypto.randomUUID();
  const billItemId = crypto.randomUUID();

  const amount = 25000;

  await runMutation(
    client.from("requests").insert({
      id: requestId,
      request_number: requestNumber,
      buyer_id: ids.buyerUserId,
      title: `Supplier E2E ${token}`,
      description: `Supplier workflow e2e ${token}`,
      location_id: ids.locationId,
      supplier_id: ids.supplierId,
      status: "po_issued",
      preferred_delivery_date: today,
    })
  );

  await runMutation(
    client.from("request_items").insert({
      id: crypto.randomUUID(),
      request_id: requestId,
      product_id: ids.productId,
      quantity: 5,
      unit: "piece",
      notes: `Supplier workflow ${token}`,
    })
  );

  await runMutation(
    client.from("indents").insert({
      id: indentId,
      indent_number: indentNumber,
      requester_id: ids.buyerEmployeeId,
      supplier_id: ids.supplierId,
      department: "Procurement",
      location_id: ids.locationId,
      title: `Supplier E2E ${token}`,
      purpose: `Supplier workflow ${token}`,
      required_date: today,
      priority: "normal",
      status: "approved",
      total_items: 1,
      total_estimated_value: amount,
    })
  );

  await runMutation(
    client.from("purchase_orders").insert({
      id: poId,
      po_number: poNumber,
      indent_id: indentId,
      supplier_id: ids.supplierId,
      po_date: today,
      expected_delivery_date: today,
      status: "dispatched",
      subtotal: amount,
      tax_amount: 0,
      discount_amount: 0,
      grand_total: amount,
      payment_terms: "Net 30",
      sent_to_vendor_at: new Date().toISOString(),
      vendor_acknowledged_at: new Date().toISOString(),
      dispatched_at: new Date().toISOString(),
    })
  );

  await runMutation(
    client
      .from("indents")
      .update({ linked_po_id: poId, po_created_at: new Date().toISOString() })
      .eq("id", indentId)
  );

  await runMutation(
    client.from("purchase_order_items").insert({
      id: poItemId,
      purchase_order_id: poId,
      product_id: ids.productId,
      item_description: `PO item ${token}`,
      ordered_quantity: 5,
      unit_of_measure: "pcs",
      received_quantity: 5,
      unit_price: amount / 5,
      line_total: amount,
    })
  );

  await runMutation(
    client.from("material_receipts").insert({
      id: receiptId,
      grn_number: grnNumber,
      purchase_order_id: poId,
      supplier_id: ids.supplierId,
      received_by: ids.accountEmployeeId,
      received_date: today,
      status: "accepted",
      total_received_value: amount,
    })
  );

  await runMutation(
    client.from("material_receipt_items").insert({
      id: receiptItemId,
      material_receipt_id: receiptId,
      po_item_id: poItemId,
      product_id: ids.productId,
      item_description: `GRN item ${token}`,
      ordered_quantity: 5,
      received_quantity: 5,
      accepted_quantity: 5,
      quality_status: "accepted",
      unit_price: amount / 5,
      line_total: amount,
    })
  );

  await runMutation(
    client.from("purchase_bills").insert({
      id: billId,
      bill_number: billNumber,
      supplier_invoice_number: supplierInvoiceNumber,
      purchase_order_id: poId,
      material_receipt_id: receiptId,
      supplier_id: ids.supplierId,
      bill_date: today,
      due_date: today,
      status: "submitted",
      payment_status: "unpaid",
      subtotal: amount,
      tax_amount: 0,
      discount_amount: 0,
      total_amount: amount,
      paid_amount: 0,
      due_amount: amount,
      notes: `Supplier bill ${token}`,
    })
  );

  await runMutation(
    client.from("purchase_bill_items").insert({
      id: billItemId,
      purchase_bill_id: billId,
      po_item_id: poItemId,
      grn_item_id: receiptItemId,
      product_id: ids.productId,
      item_description: `Bill item ${token}`,
      billed_quantity: 5,
      unit_of_measure: "pcs",
      unit_price: amount / 5,
      line_total: amount,
      unmatched_qty: 0,
      unmatched_amount: 0,
    })
  );

  const createdRtv = await runMutation(
    client.from("rtv_tickets").insert({
      id: rtvId,
      po_id: poId,
      supplier_id: ids.supplierId,
      product_id: ids.productId,
      receipt_id: receiptId,
      return_reason: "quality_mismatch",
      quantity: 1,
      unit_of_measurement: "pcs",
      estimated_value: amount / 5,
      notes: `Supplier RTV ${token}`,
      status: "in_transit",
      raised_by: ids.storekeeperUserId,
    }).select("rtv_number").single()
  );

  return {
    poId,
    poNumber,
    billId,
    billNumber,
    rtvId,
    rtvNumber: createdRtv.rtv_number,
    supplierInvoiceNumber,
    amount,
  };
}

async function ensureManualPaymentMethod(name: string) {
  const client = createServiceRoleClient();
  const { data: existing, error: existingError } = await client
    .from("payment_methods")
    .select("id, method_name, gateway, is_active")
    .eq("method_name", name)
    .maybeSingle();

  if (existingError) {
    throw existingError;
  }

  if (existing) {
    return existing.id as string;
  }

  const { data, error } = await client
    .from("payment_methods")
    .insert({
      method_name: name,
      gateway: "manual",
      is_active: true,
    })
    .select("id")
    .single();

  if (error) throw error;
  return data.id as string;
}

test.describe("Supplier PO → Bill → Return → Settlement", () => {
  test.describe.configure({ mode: "serial", timeout: 120_000 });

  test.beforeEach(async ({ page }) => {
    await loginAsRole(page, "supplier");
  });

  test("supplier can see the seeded bill and settlement update", async ({ page }) => {
    const workflow = await seedSupplierWorkflow();
    const client = createServiceRoleClient();

    await page.goto("/supplier/purchase-orders");
    await expect(page.getByText(workflow.poNumber).first()).toBeVisible({ timeout: 15_000 });

    await page.goto("/supplier/bills");
    const billRow = page.locator("tr", { hasText: workflow.billNumber }).first();
    await expect(billRow).toBeVisible({ timeout: 15_000 });
    await expect(billRow).toContainText(/unpaid/i);

    await page.goto("/supplier/returns");
    const returnRow = page.locator("tr", { hasText: workflow.rtvNumber }).first();
    await expect(returnRow).toBeVisible({ timeout: 15_000 });
    await expect(returnRow).toContainText(/in transit/i);

    await runMutation(
      client
        .from("purchase_bills")
        .update({
          payment_status: "paid",
          status: "approved",
          paid_amount: workflow.amount,
          due_amount: 0,
          last_payment_date: new Date().toISOString().slice(0, 10),
        })
        .eq("id", workflow.billId)
    );

    await page.goto("/supplier/bills");
    const updatedBillRow = page.locator("tr", { hasText: workflow.billNumber }).first();
    await expect(updatedBillRow.getByText(/^PAID$/i).first()).toBeVisible({ timeout: 10_000 });
  });

  test("account can record a payout from the supplier bills registry and the payment status moves to paid", async ({ page }) => {
    const workflow = await seedSupplierWorkflow();
    const client = createServiceRoleClient();
    const paymentMethodName = `E2E Manual ${workflow.poNumber}`;
    await ensureManualPaymentMethod(paymentMethodName);

    await runMutation(
      client
        .from("purchase_bills")
        .update({
          status: "approved",
          match_status: "matched",
          payment_status: "unpaid",
          paid_amount: 0,
          due_amount: workflow.amount,
          last_payment_date: null,
        })
        .eq("id", workflow.billId)
    );

    await loginAsRole(page, "account");
    await page.goto("/finance/supplier-bills");

    const billRow = page.locator("tr", { hasText: workflow.billNumber }).first();
    await expect(billRow).toBeVisible({ timeout: 15_000 });
    await expect(billRow.getByText(/^UNPAID$/i).first()).toBeVisible({ timeout: 10_000 });

    await billRow.locator("button").first().click();
    await page.getByRole("menuitem", { name: /record payout/i }).click();

    const dialog = page.getByRole("dialog", { name: /record supplier payout/i });
    await expect(dialog).toBeVisible({ timeout: 10_000 });
    await dialog.getByLabel(/Amount/i).fill(String(workflow.amount));
    await dialog.locator('[role="combobox"]').click();
    await page.getByRole("option", { name: new RegExp(paymentMethodName, "i") }).click();
    await dialog.getByLabel(/Date/i).fill(new Date().toISOString().slice(0, 10));
    await dialog.getByLabel(/Justification/i).fill(`E2E payout for ${workflow.poNumber}`);
    await dialog.getByLabel(/I confirm this payout is valid and authorized/i).check();
    await dialog.getByRole("button", { name: /Dispatch Funds/i }).click();

    await expect(page.getByText(/payout recorded successfully/i).first()).toBeVisible({ timeout: 15_000 });

    await expect
      .poll(
        async () => {
          const { data, error } = await client
            .from("purchase_bills")
            .select("payment_status, paid_amount, due_amount, status")
            .eq("id", workflow.billId)
            .single();

          if (error) throw error;
          return data;
        },
        { timeout: 20_000 }
      )
      .toMatchObject({
        payment_status: "paid",
        paid_amount: workflow.amount,
        due_amount: 0,
        status: "approved",
      });

    await page.reload();
    const updatedRow = page.locator("tr", { hasText: workflow.billNumber }).first();
    await expect(updatedRow.getByText(/^PAID$/i).first()).toBeVisible({ timeout: 10_000 });
  });
});

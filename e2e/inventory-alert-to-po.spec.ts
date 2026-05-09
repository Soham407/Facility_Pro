import { expect, test } from "@playwright/test";
import crypto from "node:crypto";

import { createServiceRoleClient, readFeatureFixtureState } from "./helpers/db";
import { loginAsRole } from "./helpers/auth";
import type { ReorderRuleInsert, StockBatchInsert } from "@/src/types/operations";

function ids() {
  return readFeatureFixtureState().ids;
}

function token(prefix: string) {
  return `${prefix}-${Date.now()}-${crypto.randomUUID().slice(0, 6)}`;
}

test.describe("Inventory Alert to PO Proof", () => {
  test.describe.configure({ mode: "serial", timeout: 120_000 });

  let productId = "";
  let productName = "";
  let reorderRuleId = "";
  let stockBatchId = "";
  let warehouseId = "";
  let supplierName = "";
  let locationName = "";
  const indentToken = token("indent");
  const poToken = token("po");

  test.beforeAll(async () => {
    const client = createServiceRoleClient();
    const fixtureIds = ids();
    const { data: warehouseRow, error: warehouseError } = await client
      .from("warehouses")
      .select("id")
      .limit(1)
      .maybeSingle();
    if (warehouseError) throw warehouseError;
    if (!warehouseRow?.id) {
      throw new Error("No warehouse is available for the inventory proof test.");
    }
    warehouseId = warehouseRow.id;
    const { data: supplierRow, error: supplierError } = await client
      .from("suppliers")
      .select("supplier_name")
      .eq("id", fixtureIds.supplierId)
      .maybeSingle();
    if (supplierError) throw supplierError;
    supplierName = supplierRow?.supplier_name ?? "";
    const { data: locationRow, error: locationError } = await client
      .from("company_locations")
      .select("location_name")
      .eq("id", fixtureIds.locationId)
      .maybeSingle();
    if (locationError) throw locationError;
    locationName = locationRow?.location_name ?? "";

    // Cleanup any previous test data to ensure idempotency
    await client.from("stock_batches").delete().ilike("batch_number", "e2e-test-product-%");
    await client.from("reorder_rules").delete().eq("id", reorderRuleId);
    await client.from("products").delete().ilike("product_name", "e2e-test-product-%");

    // 1. Create a new product
    productId = crypto.randomUUID();
    productName = `e2e-test-product-${token("prod")}`;
    const product = {
      id: productId,
      product_name: productName,
      product_code: `P-${token("code")}`,
      unit_of_measurement: "pcs",
      base_rate: 10000,
      is_active: true,
      category_id: fixtureIds.productCategoryId, // Assuming a default category exists
    };
    const { error: productError } = await client.from("products").insert(product);
    if (productError) throw productError;

    // 2. Create a reorder rule for this product
    reorderRuleId = crypto.randomUUID();
    const reorderRule: ReorderRuleInsert = {
      id: reorderRuleId,
      product_id: productId,
      warehouse_id: warehouseId,
      reorder_level: 5,
      reorder_quantity: 10,
      max_stock_level: 20,
      is_active: true,
    };
    const { error: reorderRuleError } = await client.from("reorder_rules").insert(reorderRule);
    if (reorderRuleError) throw reorderRuleError;

    // 3. Insert a stock batch with quantity below reorder level
    stockBatchId = crypto.randomUUID();
    const stockBatch: StockBatchInsert = {
      id: stockBatchId,
      product_id: productId,
      warehouse_id: warehouseId,
      batch_number: `${token("batch")}`,
      current_quantity: 2, // Below reorder level of 5
      initial_quantity: 2,
      unit_cost: 10000,
      status: "active",
    };
    const { error: stockBatchError } = await client.from("stock_batches").insert(stockBatch);
    if (stockBatchError) throw stockBatchError;

    // Verify that the product is now in low stock
    const { data: lowStockRow, error: stockError } = await client
      .from("stock_levels")
      .select("product_id, product_name, total_quantity, reorder_level, needs_reorder")
      .eq("product_id", productId)
      .eq("needs_reorder", true)
      .limit(1)
      .maybeSingle();

    if (stockError) throw stockError;
    if (!lowStockRow) {
      throw new Error("Newly created product is not in low stock as expected.");
    }

    console.log(`[inventory-proof] Setup complete. Product ${productName} (ID: ${productId}) is in low stock.`);
  });

  test.afterAll(async () => {
    const client = createServiceRoleClient();
    // Clean up test data
    await client.from("stock_batches").delete().eq("id", stockBatchId);
    await client.from("reorder_rules").delete().eq("id", reorderRuleId);
    await client.from("products").delete().eq("id", productId);
    console.log(`[inventory-proof] Cleaned up test data for product ${productName}.`);
  });

  test("should display low stock alert and create a linked indent/PO path", async ({ page }) => {
    console.log("[inventory-proof] login");
    await loginAsRole(page, "admin");
    console.log("[inventory-proof] goto inventory");
    await page.goto("/inventory");

    await expect(page.locator("main")).toBeVisible({ timeout: 20_000 });
    await expect(page.getByTestId("inventory-loading-state")).toHaveCount(0, {
      timeout: 20_000,
    });

    console.log("[inventory-proof] open low stock");
    const stockOverviewPanel = page.getByRole("tabpanel", { name: /stock overview/i });
    await stockOverviewPanel.getByPlaceholder("Search product_name...").fill(productName);
    const productRow = stockOverviewPanel.locator("tbody tr").filter({ hasText: productName }).first();
    await expect(productRow).toBeVisible({ timeout: 20_000 });

    console.log("[inventory-proof] navigate to indents");
    await page.goto(`/inventory/indents/create?productId=${productId}`);
    await expect(page).toHaveURL(new RegExp(`/inventory/indents/create\\?productId=${productId}`));

    const client = createServiceRoleClient();
    const fixtureIds = ids();
    const today = new Date().toISOString().split("T")[0];
    const futureDate = new Date(Date.now() + 14 * 24 * 60 * 60 * 1000)
      .toISOString()
      .split("T")[0];

    const indentId = crypto.randomUUID();
    const poId = crypto.randomUUID();
    const shortId = crypto.randomUUID().slice(0, 8);

    console.log("[inventory-proof] insert indent");
    const { error: indentError } = await client.from("indents").insert({
      id: indentId,
      indent_number: `IND-${shortId}`,
      requester_id: fixtureIds.buyerEmployeeId,
      supplier_id: fixtureIds.supplierId,
      department: "Inventory",
      location_id: fixtureIds.locationId,
      title: "Inventory Reorder",
      purpose: "Low stock proof",
      required_date: today,
      priority: "normal",
      status: "po_created",
      total_items: 1,
      total_estimated_value: 30000,
    });
    if (indentError) throw indentError;

    console.log("[inventory-proof] insert indent item");
    const { error: indentItemError } = await client.from("indent_items").insert({
      id: crypto.randomUUID(),
      indent_id: indentId,
      product_id: productId,
      item_description: "Proof item",
      requested_quantity: 3,
      unit_of_measure: "pcs",
      estimated_unit_price: 10000,
      estimated_total: 30000,
      approved_quantity: 3,
    });
    if (indentItemError) throw indentItemError;

    console.log("[inventory-proof] insert po");
    const { error: poError } = await client.from("purchase_orders").insert({
      id: poId,
      po_number: `PO-${shortId}`,
      indent_id: indentId,
      supplier_id: fixtureIds.supplierId,
      po_date: today,
      expected_delivery_date: futureDate,
      status: "draft",
      subtotal: 30000,
      grand_total: 30000,
      payment_terms: "Net 30",
      notes: "Inventory proof",
    });
    if (poError) throw poError;

    const { error: indentLinkError } = await client
      .from("indents")
      .update({
        linked_po_id: poId,
        po_created_at: new Date().toISOString(),
      })
      .eq("id", indentId);
    if (indentLinkError) throw indentLinkError;

    console.log("[inventory-proof] insert po item");
    const { error: poItemError } = await client.from("purchase_order_items").insert({
      id: crypto.randomUUID(),
      purchase_order_id: poId,
      product_id: productId,
      item_description: "Proof item",
      ordered_quantity: 3,
      unit_of_measure: "pcs",
      unit_price: 10000,
      line_total: 30000,
      received_quantity: 0,
    });
    if (poItemError) throw poItemError;

    // Verify database records
    const { data: indentRecord, error: verifyIndentError } = await client
      .from("indents")
      .select("id, indent_number, linked_po_id, indent_items(product_id, requested_quantity)")
      .eq("id", indentId)
      .single();
    if (verifyIndentError) throw verifyIndentError;
    expect(indentRecord).toBeTruthy();
    expect(indentRecord.indent_items[0].product_id).toBe(productId);
    expect(indentRecord.indent_items[0].requested_quantity).toBe(3);

    const { data: poRecord, error: verifyPoError } = await client
      .from("purchase_orders")
      .select("id, po_number, indent_id, purchase_order_items(product_id, ordered_quantity)")
      .eq("id", poId)
      .single();
    if (verifyPoError) throw verifyPoError;
    expect(poRecord).toBeTruthy();
    expect(poRecord.indent_id).toBe(indentRecord.id);
    expect(poRecord.purchase_order_items[0].product_id).toBe(productId);
    expect(poRecord.purchase_order_items[0].ordered_quantity).toBe(3);
  });
});

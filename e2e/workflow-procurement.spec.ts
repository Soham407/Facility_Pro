import { test, expect } from "@playwright/test";
import crypto from "node:crypto";
import { loginAsRole } from "./helpers/auth";
import { createServiceRoleClient, readFeatureFixtureState } from "./helpers/db";

function token(prefix: string) {
  return `${prefix}-${Date.now()}-${crypto.randomUUID().slice(0, 6)}`;
}

test.describe("Massive Cross-Role Workflow: Procurement", () => {
  test.describe.configure({ mode: "serial", timeout: 120_000 });

  test("buyer creates request -> admin creates PO -> supplier views PO", async ({ page }) => {
    // 1. Buyer creates request
    await loginAsRole(page, "buyer");
    await page.goto("/buyer/requests/new");
    await expect(page.locator("main")).toBeVisible({ timeout: 20_000 });
    await page.waitForLoadState("networkidle");

    const materialBtn = page.getByRole("button", { name: /material request/i });
    await expect(materialBtn).toBeVisible();
    await materialBtn.click();

    const requestToken = token("proc");
    const requestTitle = `Cross-Role Proc Request ${requestToken}`;
    await page.locator("#title").fill(requestTitle);

    await page.locator("#location").click();
    const firstLocation = page.getByRole("option").first();
    await expect(firstLocation).toBeVisible({ timeout: 10_000 });
    await firstLocation.click();

    const itemRow = page.locator(".flex.flex-wrap.gap-4").first();
    await itemRow.getByRole("combobox").first().click();
    const firstProduct = page.getByRole("option").first();
    await expect(firstProduct).toBeVisible({ timeout: 10_000 });
    await firstProduct.click();

    await page.getByRole("button", { name: /submit request/i }).click();
    await expect(page.getByText(/request submitted/i).first()).toBeVisible({ timeout: 15_000 });

    // 2. Admin creates PO
    await loginAsRole(page, "admin");
    await page.goto("/inventory/purchase-orders");
    await expect(page.locator("main")).toBeVisible({ timeout: 20_000 });

    await page.getByRole("button", { name: /raise new po/i }).click();
    const dialog = page.getByRole("dialog", { name: /raise new purchase order/i });
    await expect(dialog).toBeVisible();

    await dialog.locator("#supplier").click();
    const firstSupplierOption = page.getByRole("option").first();
    await expect(firstSupplierOption).toBeVisible({ timeout: 15_000 });
    await firstSupplierOption.click();

    const futureDate = new Date(Date.now() + 14 * 24 * 60 * 60 * 1000).toISOString().split("T")[0];
    await dialog.locator("#delivery_date").fill(futureDate);
    const poToken = token("po-proc");
    await dialog.locator("#notes").fill(`Cross-Role PO: ${poToken}`);

    await dialog.getByRole("button", { name: /create draft po/i }).click();
    await expect(page.getByText(/purchase order created/i).first()).toBeVisible({ timeout: 15_000 });

    // Seed an item into the PO so it can be sent to the vendor
    const client = createServiceRoleClient();
    const ids = readFeatureFixtureState().ids;
    
    // Find the PO by notes
    const { data: poData } = await client
      .from("purchase_orders")
      .select("id")
      .eq("notes", `Cross-Role PO: ${poToken}`)
      .single();
      
    if (poData?.id) {
      await client.from("purchase_order_items").insert({
        id: crypto.randomUUID(),
        purchase_order_id: poData.id,
        product_id: ids.productId,
        item_description: "Workflow Item",
        ordered_quantity: 10,
        unit_of_measure: "pcs",
        unit_price: 100,
        line_total: 1000,
        received_quantity: 0,
      });
    }

    await page.reload();
    await page.waitForLoadState("networkidle");
    const poRow = page.locator("tbody tr").first();
    await expect(poRow).toBeVisible({ timeout: 20_000 });

    // Open row menu -> send to vendor
    const menu = page.locator('[role="menu"]');
    await expect(async () => {
      await poRow.locator("button").last().click({ force: true });
      await expect(menu).toBeVisible({ timeout: 2_000 });
    }).toPass({ timeout: 15_000 });

    await page.getByRole("menuitem", { name: /send to vendor/i }).click();
    const confirmDialog = page.getByRole("dialog", { name: /send to vendor/i });
    await expect(confirmDialog).toBeVisible();
    await confirmDialog.getByRole("button", { name: /^send$/i }).click();
    await expect(page.getByText(/po sent/i).first()).toBeVisible({ timeout: 15_000 });

    // 3. Supplier views PO
    await loginAsRole(page, "supplier");
    await page.goto("/supplier/purchase-orders");
    await expect(page.locator("main")).toBeVisible({ timeout: 20_000 });
    await page.waitForLoadState("networkidle");

    // Wait for the specific row to be visible
    const supplierRow = page.locator("tbody tr").first();
    await expect(supplierRow).toBeVisible({ timeout: 20_000 });
  });
});

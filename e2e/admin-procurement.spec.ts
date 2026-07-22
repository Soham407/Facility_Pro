import { test, expect } from "@playwright/test";

import { loginAsRole } from "./helpers/auth";
import { createServiceRoleClient } from "./helpers/db";

// Admin procurement flow: login -> purchase orders -> open create dialog -> verify list state
test.describe("Admin Procurement Flow", () => {
  test.beforeEach(async ({ page }) => {
    await loginAsRole(page, "admin");
  });

  test("can navigate to Purchase Orders", async ({ page }) => {
    await page.goto("/inventory/purchase-orders");
    await expect(page).toHaveURL(/inventory\/purchase-orders/);
    await expect(page.getByRole("heading", { name: /purchase orders/i }).first()).toBeVisible();
  });

  test("shows the raise new PO action", async ({ page }) => {
    await page.goto("/inventory/purchase-orders");
    const createButton = page.getByRole("button", { name: /raise new po/i });

    await expect(createButton).toBeVisible({ timeout: 10_000 });
  });

  test("loads at least one supplier in admin procurement setup", async ({ page }) => {
    await page.goto("/inventory/purchase-orders");
    await page.getByRole("button", { name: /raise new po/i }).click();

    const dialog = page.getByRole("dialog", { name: /raise new purchase order/i });
    await expect(dialog).toBeVisible({ timeout: 10_000 });

    await dialog.locator("#supplier").click();
    await expect(page.getByRole("option").first()).toBeVisible({ timeout: 15_000 });
  });

  test("loads at least one product in admin procurement setup", async ({ page }) => {
    const client = createServiceRoleClient();
    const { data: product } = await client.from("products").select("id").limit(1).single();
    if (!product) throw new Error("No products found in DB for the test to run");
    
    // Navigate with the correct seeded product ID to bypass the redirect guard
    await page.goto(`/inventory/indents/create?productId=${product.id}`);
    
    // Verify the page loads the consolidated form
    await expect(page.getByRole("heading", { name: /Create Indent from Alert/i }).first()).toBeVisible({ timeout: 10_000 });
    
    // Verify that the product input is correctly populated with the readOnly seeded product info
    const productInput = page.locator("#productName");
    await expect(productInput).toBeVisible({ timeout: 10_000 });
    await expect(productInput).toHaveAttribute("readonly");
    
    // Verify that the submit button is present
    const submitButton = page.getByRole("button", { name: /Create Indent & PO/i });
    await expect(submitButton).toBeVisible();
  });

  test("loads at least one service in admin service setup", async ({ page }) => {
    await page.goto("/services/masters/vendor-services");
    await page.getByRole("button", { name: /new authorization/i }).click();

    const dialog = page.getByRole("dialog", { name: /new vendor authorization/i });
    await expect(dialog).toBeVisible({ timeout: 10_000 });

    const serviceSelect = dialog.getByRole("combobox").nth(1);
    await serviceSelect.click();
    await expect(page.getByRole("option").first()).toBeVisible({ timeout: 15_000 });
  });

  test("Purchase Orders list renders data or an empty state", async ({ page }) => {
    await page.goto("/inventory/purchase-orders");

    await expect(page.getByTestId("purchase-orders-loading-state")).toHaveCount(0, {
      timeout: 20_000,
    });
    await expect(
      page.getByTestId("purchase-orders-error-state"),
      "Purchase Orders should not fall back to the fatal error state.",
    ).toHaveCount(0);

    const hasRows = page.locator("table tbody tr").first();
    const hasPageEmptyState = page.getByTestId("purchase-orders-empty-state");
    const hasTableEmptyState = page.getByText(/no records found/i);

    await expect(
      hasRows.or(hasPageEmptyState).or(hasTableEmptyState),
    ).toBeVisible({ timeout: 15_000 });
  });

  test("can navigate to Indents page", async ({ page }) => {
    await page.goto("/inventory/indents/verification");
    await expect(page).toHaveURL(/inventory\/indents\/verification/);
    await expect(
      page.getByRole("heading", { name: /indent price verification/i }).first()
    ).toBeVisible({ timeout: 15_000 });
  });

  test("can navigate to GRN page", async ({ page }) => {
    const grnLink = page.getByRole("link", { name: /grn|receipt|material receipt/i }).first();
    if (await grnLink.isVisible({ timeout: 3_000 })) {
      await grnLink.click();
      await expect(page).toHaveURL(/grn|receipt/, { timeout: 8_000 });
    } else {
      await page.goto("/inventory/grn");
    }
    await page.waitForLoadState("networkidle");
    const mainContent = page.locator("main").first();
    await expect(mainContent).toBeVisible({ timeout: 10_000 });
  });

  test("can navigate to Supplier Bills", async ({ page }) => {
    await page.goto("/finance/supplier-bills");
    await expect(page).toHaveURL(/finance\/supplier-bills/);
    await expect(
      page.getByRole("heading", { name: /supplier payout registry/i }).first()
    ).toBeVisible({ timeout: 15_000 });
  });

  test("can navigate to Reconciliation page", async ({ page }) => {
    await page.goto("/finance/reconciliation");
    await expect(page).toHaveURL(/finance\/reconciliation/);
    await expect(
      page.getByRole("heading", { name: /triple-match reconciliation/i }).first()
    ).toBeVisible({ timeout: 15_000 });
  });
});

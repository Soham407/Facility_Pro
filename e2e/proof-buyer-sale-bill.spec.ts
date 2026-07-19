import { test, expect } from "@playwright/test";
import crypto from "node:crypto";

import { loginAsRole } from "./helpers/auth";
import {
  createServiceRoleClient,
  getTableCount,
  readFeatureFixtureState,
} from "./helpers/db";

// Proof for issue #36: buyer request -> request_items -> linked sale_bills row
// -> visible on the buyer invoice surface, with zero writes to legacy
// order_requests / order_request_items.

function ids() {
  return readFeatureFixtureState().ids;
}

function token(prefix: string) {
  return `${prefix}-${Date.now()}-${crypto.randomUUID().slice(0, 6)}`;
}

async function runMutation<T>(
  operation: PromiseLike<{ data: T; error: { message?: string } | Error | null }>
) {
  const { data, error } = await operation;
  if (error) {
    throw new Error(
      error instanceof Error ? error.message : error.message ?? "Supabase mutation failed"
    );
  }
  return data;
}

test.describe("Proof: Buyer Request → Sale Bill (issue #36)", () => {
  test.describe.configure({ mode: "serial", timeout: 180_000 });

  test.beforeEach(async ({ page }) => {
    await loginAsRole(page, "buyer");
  });

  test("buyer request persists to requests + request_items, linked sale bill visible on buyer invoices, no legacy writes", async ({
    page,
  }) => {
    const client = createServiceRoleClient();
    const fixtureIds = ids();

    // Legacy-table guard: capture counts before any action.
    const legacyRequestsBefore = await getTableCount("order_requests");
    const legacyItemsBefore = await getTableCount("order_request_items");

    // --- Step 1: buyer creates a material request through the real UI ---
    await page.goto("/buyer/requests/new");
    await expect(page.locator("main")).toBeVisible({ timeout: 20_000 });
    await page.waitForLoadState("networkidle");

    const materialBtn = page.getByRole("button", { name: /material request/i });
    await expect(materialBtn).toBeVisible();
    await materialBtn.click();

    const requestTitle = `Sale Bill Proof ${token("proof")}`;
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
    await expect(page.getByText(/request submitted/i).first()).toBeVisible({
      timeout: 15_000,
    });
    await expect(page).toHaveURL(/buyer\/requests$/, { timeout: 30_000 });

    // --- Step 2: DB assertion — row exists in active `requests` table ---
    const request = await expect
      .poll(
        async () => {
          const { data, error } = await client
            .from("requests")
            .select("id, request_number, buyer_id, title, status")
            .eq("buyer_id", fixtureIds.buyerUserId)
            .eq("title", requestTitle)
            .maybeSingle();
          if (error) throw error;
          return data;
        },
        { timeout: 20_000 }
      )
      .not.toBeNull()
      .then(async () => {
        const { data, error } = await client
          .from("requests")
          .select("id, request_number, buyer_id, title, status")
          .eq("buyer_id", fixtureIds.buyerUserId)
          .eq("title", requestTitle)
          .single();
        if (error) throw error;
        return data as {
          id: string;
          request_number: string;
          buyer_id: string;
          title: string;
          status: string;
        };
      });

    expect(request.buyer_id).toBe(fixtureIds.buyerUserId);
    expect(request.request_number).toBeTruthy();

    // --- Step 3: DB assertion — items persisted in `request_items` ---
    const items = await expect
      .poll(
        async () => {
          const { data, error } = await client
            .from("request_items")
            .select("id, request_id, product_id, quantity")
            .eq("request_id", request.id);
          if (error) throw error;
          return (data ?? []).length;
        },
        { timeout: 20_000 }
      )
      .toBeGreaterThan(0)
      .then(async () => {
        const { data, error } = await client
          .from("request_items")
          .select("id, request_id, product_id, quantity")
          .eq("request_id", request.id);
        if (error) throw error;
        return data as Array<{
          id: string;
          request_id: string;
          product_id: string | null;
          quantity: number | null;
        }>;
      });

    expect(items.length).toBeGreaterThanOrEqual(1);
    for (const item of items) {
      expect(item.request_id).toBe(request.id);
      expect(item.product_id).toBeTruthy();
      expect(Number(item.quantity)).toBeGreaterThan(0);
    }

    // --- Step 4: create the linked sale bill (issue allows "admin path or
    // fixture"; the service-role fixture insert is the established,
    // deterministic pattern used by buyer-request-invoice-payment-feedback) ---
    const invoiceId = crypto.randomUUID();
    const invoiceNumber = `INV-E2E-${crypto
      .randomUUID()
      .replace(/-/g, "")
      .slice(0, 8)
      .toUpperCase()}`;
    const today = new Date().toISOString().slice(0, 10);

    await runMutation(
      client.from("sale_bills").insert({
        id: invoiceId,
        invoice_number: invoiceNumber,
        client_id: fixtureIds.societyId,
        request_id: request.id,
        invoice_date: today,
        due_date: today,
        status: "acknowledged",
        payment_status: "unpaid",
        subtotal: 50000,
        tax_amount: 0,
        discount_amount: 0,
        total_amount: 50000,
        paid_amount: 0,
        due_amount: 50000,
        notes: `E2E proof #36 for ${request.request_number}`,
      })
    );

    // --- Step 5: DB assertion — sale_bills.request_id links to requests.id ---
    const bill = await runMutation(
      client
        .from("sale_bills")
        .select("id, invoice_number, client_id, request_id, total_amount")
        .eq("id", invoiceId)
        .single()
    ) as {
      id: string;
      invoice_number: string;
      client_id: string;
      request_id: string;
      total_amount: number;
    };

    expect(bill.request_id).toBe(request.id);
    expect(bill.client_id).toBe(fixtureIds.societyId);
    expect(bill.invoice_number).toBe(invoiceNumber);

    // --- Step 6: UI assertion — buyer sees the linked sale bill ---
    await page.goto("/buyer/invoices");
    await expect(page.getByText(invoiceNumber).first()).toBeVisible({
      timeout: 15_000,
    });

    const invoiceRow = page.locator("tr", { hasText: invoiceNumber }).first();
    await expect(invoiceRow).toBeVisible();

    // --- Step 7: legacy-table guard — no writes to order_requests /
    // order_request_items across the whole flow ---
    const legacyRequestsAfter = await getTableCount("order_requests");
    const legacyItemsAfter = await getTableCount("order_request_items");
    expect(legacyRequestsAfter).toBe(legacyRequestsBefore);
    expect(legacyItemsAfter).toBe(legacyItemsBefore);
  });
});

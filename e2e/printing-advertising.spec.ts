import crypto from "node:crypto";

import { expect, test } from "@playwright/test";

import { loginAsRole } from "./helpers/auth";
import { createServiceRoleClient } from "./helpers/db";

function token(prefix: string) {
  return `${prefix}-${Date.now()}-${Math.random().toString(16).slice(2, 8)}`;
}

async function runMutation<T>(operation: PromiseLike<{ data: T; error: { message?: string } | Error | null }>) {
  const { data, error } = await operation;
  if (error) {
    throw new Error(error instanceof Error ? error.message : error.message ?? "Supabase mutation failed");
  }
  return data;
}

async function seedPrintingBooking() {
  const client = createServiceRoleClient();
  const adSpaceId = crypto.randomUUID();
  const bookingId = crypto.randomUUID();
  const bookingNumber = `ADB-${token("PRINT")}`;
  const spaceName = `Printing Space ${token("SPACE")}`;
  const rate = 75000;
  const today = new Date().toISOString().slice(0, 10);

  await runMutation(
    client.from("printing_ad_spaces").insert({
      id: adSpaceId,
      space_name: spaceName,
      location_description: "Front lobby",
      base_rate_paise: rate,
      dimensions: "10x6",
      status: "open",
    })
  );

  await runMutation(
    client.from("printing_ad_bookings").insert({
      id: bookingId,
      booking_number: bookingNumber,
      ad_space_id: adSpaceId,
      advertiser_name: "Acme Ads",
      start_date: today,
      end_date: today,
      agreed_rate_paise: rate,
      status: "pending",
      notes: "Seeded printing booking",
    })
  );

  return { adSpaceId, bookingId, bookingNumber, rate };
}

test.describe("Printing and advertising production surface", () => {
  test.beforeEach(async ({ page }) => {
    await loginAsRole(page, "admin");
  });

  test("printing surface loads with ID printing and ad-space booking controls", async ({ page }) => {
    await page.goto("/dashboard");
    await page.goto("/services/printing");
    await expect(page.getByRole("heading", { name: /printing & advertising/i })).toBeVisible();
    const printingTab = page.getByRole("tab", { name: /id printing|internal printing|usage logs/i }).first();
    const adSpacesTab = page.getByRole("tab", { name: /ad spaces|ad-space master/i }).first();

    await expect(printingTab).toBeVisible();
    await expect(adSpacesTab).toBeVisible();

    await adSpacesTab.click();
    const bookSpaceButtons = page.getByRole("button", { name: /book space/i });
    const registerButtons = page.getByRole("button", { name: /register ad space/i });
    if (await bookSpaceButtons.count()) {
      await expect(bookSpaceButtons.first()).toBeVisible();
    } else if (await registerButtons.count()) {
      await expect(registerButtons.first()).toBeVisible();
    } else {
      await expect(page.getByText(/no ad spaces found/i)).toBeVisible();
    }
  });

  test("ad booking persists and reflects in revenue and approval controls", async ({ page }) => {
    const booking = await seedPrintingBooking();
    const client = createServiceRoleClient();

    await page.goto("/services/printing");
    const bookingsTab = page.getByRole("tab", { name: /bookings|usage logs/i }).first();
    await expect(bookingsTab).toBeVisible();
    await bookingsTab.click();

    await expect(page.getByText(booking.bookingNumber).first()).toBeVisible({ timeout: 20_000 });
    await expect(page.getByText(/₹\s?750(?:\.00)?/).first()).toBeVisible({ timeout: 10_000 });

    const row = page.locator("tr", { hasText: booking.bookingNumber }).first();
    await row.getByRole("button", { name: /approve/i }).click();

    await expect
      .poll(
        async () => {
          const { data, error } = await client
            .from("printing_ad_bookings")
            .select("status")
            .eq("id", booking.bookingId)
            .single();

          if (error) throw error;
          return data.status;
        },
        { timeout: 20_000 }
      )
      .toBe("approved");

    await page.reload();
    await bookingsTab.click();
    await expect(page.getByText(/approved/i).first()).toBeVisible({ timeout: 10_000 });
  });
});

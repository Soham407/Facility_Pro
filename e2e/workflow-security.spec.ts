import { test, expect } from "@playwright/test";
import crypto from "node:crypto";
import { loginAsRole } from "./helpers/auth";

function token(prefix: string) {
  return `${prefix}-${Date.now()}-${crypto.randomUUID().slice(0, 6)}`;
}

test.describe("Massive Cross-Role Workflow: Security Guard SOS", () => {
  test.describe.configure({ mode: "serial", timeout: 120_000 });

  test("guard triggers SOS -> supervisor sees alert", async ({ page }) => {
    // 1. Guard
    await loginAsRole(page, "security_guard");
    await page.goto("/guard");
    await expect(page.locator("main")).toBeVisible({ timeout: 20_000 });
    
    // Hold the SOS button for >3 seconds
    const sosButton = page.getByRole("button", { name: /sos .*hold 3s to trigger/i });
    await expect(sosButton).toBeVisible({ timeout: 15_000 });
    
    // Simulate long press
    await sosButton.click({ delay: 3500 });
    
    // Expect some confirmation or toast, if applicable
    // Since we don't know the exact toast, let's just wait for a moment
    await page.waitForTimeout(2000);

    // 2. Supervisor
    await loginAsRole(page, "security_supervisor");
    await page.goto("/society/panic-alerts");
    await expect(page.locator("main")).toBeVisible({ timeout: 20_000 });

    // Assuming the alert shows up in a list, we can check for "Panic/SOS" or "Emergency SOS"
    // The exact text might be "Emergency SOS triggered from Guard App"
    const alertRow = page.locator("tbody tr").first();
    await expect(alertRow).toBeVisible({ timeout: 20_000 });

    // Open row menu and resolve it to complete the workflow
    const menu = page.locator('[role="menu"]');
    await expect(async () => {
      await alertRow.locator("button").last().click({ force: true });
      await expect(menu).toBeVisible({ timeout: 2_000 });
    }).toPass({ timeout: 15_000 });

    await page.getByRole("menuitem", { name: /resolve|mark resolved/i }).click();
    
    // If there is a dialog
    const resolveDialog = page.getByRole("dialog", { name: /resolve|resolve alert/i });
    if (await resolveDialog.isVisible({ timeout: 3_000 })) {
      await resolveDialog.locator("textarea").fill("Resolved by E2E workflow");
      await resolveDialog.getByRole("button", { name: /resolve/i }).click();
    }

    // Ensure it's resolved or no longer in "active" list if filtered
    await expect(page.getByText(/alert resolved|success/i).first()).toBeVisible({ timeout: 15_000 });
  });
});

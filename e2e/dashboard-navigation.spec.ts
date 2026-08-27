import { test, expect } from "@playwright/test";
import { loginAsRole } from "./helpers/auth";
import { getRoleTestConfig } from "./role-matrix";

const rolesToTest = ["admin", "security_guard", "supplier", "resident"] as const;

test.describe("Dashboard Navigation & Error Trapping", () => {
  for (const role of rolesToTest) {
    test(`Navigate and trap errors for ${role}`, async ({ page }) => {
      const errors: string[] = [];
      const config = getRoleTestConfig(role);

      page.on("pageerror", (err) => {
        errors.push(`Page Error: ${err.message}`);
      });

      page.on("console", (msg) => {
        if (msg.type() === "error") {
          errors.push(`Console Error: ${msg.text()}`);
        }
      });

      page.on("requestfailed", (request) => {
        errors.push(`Request Failed: ${request.url()} - ${request.failure()?.errorText}`);
      });

      await loginAsRole(page, role);
      
      const targetUrl = config.journey.path;
      await page.goto(targetUrl, { waitUntil: "networkidle" });
      
      // Wait a bit for any hydration/rendering errors to settle
      await page.waitForTimeout(2000);

      const fs = require('fs');
      if (errors.length > 0) {
         fs.writeFileSync(`test_output_${role}.txt`, errors.join('\n'));
      } else {
         fs.writeFileSync(`test_output_${role}.txt`, 'No errors');
      }

      expect(errors).toEqual([]);
    });
  }
});

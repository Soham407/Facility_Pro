import { describe, expect, it } from "vitest";

import { readRepoFile, sourceContainsAll } from "../helpers/source-files";

describe("API contract: finance payment webhook", () => {
  it("verifies Razorpay signatures and updates tracked payment records", async () => {
    const source = await readRepoFile("app/api/finance/payments/webhook/route.ts");
    const proxySource = await readRepoFile("proxy.ts");

    expect(
      sourceContainsAll(source, [
        "RAZORPAY_WEBHOOK_SECRET",
        "x-razorpay-signature",
        'createHmac("sha256"',
        "timingSafeEqual",
        "payment.captured",
        "payment.failed",
        '.eq("external_id", paymentEntity.id)',
        "status: nextStatus",
        "gateway_log: gatewayLog",
        "failure_reason: failureReason",
      ])
    ).toBe(true);

    expect(proxySource.includes('"/api/finance/payments/webhook"')).toBe(true);
  });
});

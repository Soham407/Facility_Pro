import { afterEach, describe, expect, it, vi } from "vitest";

type PreviewAuthModule = typeof import("@/src/lib/mobile/previewAuth");
type DemoOtpModule = typeof import("@/src/lib/mobile/demoOtp");

const ORIGINAL_ENV = { ...process.env };

async function loadPreviewAuth(overrides: Record<string, string | undefined> = {}) {
  vi.resetModules();

  process.env = {
    ...ORIGINAL_ENV,
    NODE_ENV: "production",
    DEMO_OTP_ENABLED: "true",
    DEMO_OTP_CODE: "654321",
    DEMO_OTP_ALLOWED_PHONES: "+919999999999",
    MOBILE_PREVIEW_AUTH_ENABLED: undefined,
    NEXT_PUBLIC_MOBILE_PREVIEW_AUTH_ENABLED: undefined,
    ...overrides,
  };

  const previewAuth = (await import("@/src/lib/mobile/previewAuth")) as PreviewAuthModule;
  const demoOtp = (await import("@/src/lib/mobile/demoOtp")) as DemoOtpModule;
  return { previewAuth, demoOtp };
}

afterEach(() => {
  process.env = { ...ORIGINAL_ENV };
  vi.resetModules();
});

describe("mobile preview auth release gating", () => {
  it("disables preview shortcuts in production/release by default", async () => {
    const { previewAuth, demoOtp } = await loadPreviewAuth();

    expect(previewAuth.getDevPreviewCredentials()).toBeNull();
    expect(previewAuth.isDevPreviewPhone("+919999999999")).toBe(false);
    expect(previewAuth.isDevPreviewOtp("654321")).toBe(false);
    expect(demoOtp.isDemoOtpEnabled()).toBe(false);
  });

  it("allows preview shortcuts in development builds", async () => {
    const { previewAuth, demoOtp } = await loadPreviewAuth({
      NODE_ENV: "development",
    });

    expect(previewAuth.getDevPreviewCredentials()).not.toBeNull();
    expect(previewAuth.isDevPreviewPhone("+919999999999")).toBe(true);
    expect(previewAuth.isDevPreviewOtp("654321")).toBe(true);
    expect(demoOtp.isDemoOtpEnabled()).toBe(true);
  });

  it("allows preview shortcuts only when explicitly enabled for non-dev builds", async () => {
    const { previewAuth, demoOtp } = await loadPreviewAuth({
      NODE_ENV: "production",
      MOBILE_PREVIEW_AUTH_ENABLED: "true",
    });

    expect(previewAuth.getDevPreviewCredentials()).not.toBeNull();
    expect(previewAuth.isDevPreviewPhone("+919999999999")).toBe(true);
    expect(previewAuth.isDevPreviewOtp("654321")).toBe(true);
    expect(demoOtp.isDemoOtpEnabled()).toBe(true);
  });
});

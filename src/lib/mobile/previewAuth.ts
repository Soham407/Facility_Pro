function normalizePreviewPhone(input: string) {
  const trimmed = input.trim();
  const digits = trimmed.replace(/\D/g, "");

  if (trimmed.startsWith("+")) {
    return `+${digits}`;
  }

  if (digits.length === 10) {
    return `+91${digits}`;
  }

  if (digits.length > 10) {
    return `+${digits}`;
  }

  return trimmed;
}

function buildPhoneCandidates(phone: string) {
  const normalized = normalizePreviewPhone(phone);
  const digits = normalized.replace(/\D/g, "");
  const candidates = new Set<string>([normalized, digits]);

  if (digits.length >= 10) {
    const lastTen = digits.slice(-10);
    candidates.add(lastTen);
    candidates.add(`+91${lastTen}`);
  }

  return [...candidates].filter(Boolean);
}

function isExplicitPreviewBuildEnabled() {
  return (
    process.env.MOBILE_PREVIEW_AUTH_ENABLED === "true" ||
    process.env.NEXT_PUBLIC_MOBILE_PREVIEW_AUTH_ENABLED === "true"
  );
}

export function isDevPreviewBuild() {
  return process.env.NODE_ENV === "development" || isExplicitPreviewBuildEnabled();
}

export function getDevPreviewCredentials() {
  if (!isDevPreviewBuild()) {
    return null;
  }

  const otp = (process.env.DEMO_OTP_CODE || "").trim();
  const phones = (process.env.DEMO_OTP_ALLOWED_PHONES || "")
    .split(",")
    .map((value) => normalizePreviewPhone(value))
    .filter(Boolean);

  return {
    otp,
    phones,
  };
}

export function isDevPreviewPhone(phone: string) {
  const credentials = getDevPreviewCredentials();
  if (!credentials || credentials.phones.length === 0) {
    return false;
  }

  const candidateSet = new Set(buildPhoneCandidates(phone));
  return credentials.phones.some((value) => candidateSet.has(value));
}

export function isDevPreviewOtp(otp: string) {
  const credentials = getDevPreviewCredentials();
  if (!credentials || !credentials.otp) {
    return false;
  }

  return credentials.otp === otp.trim();
}

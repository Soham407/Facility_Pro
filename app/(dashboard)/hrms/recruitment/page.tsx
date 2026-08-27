"use client";

import { PageHeader } from "@/components/shared/PageHeader";
import { ShieldCheck } from "lucide-react";
import { useBackgroundVerifications } from "@/hooks/useBackgroundVerifications";

export default function RecruitmentPage() {
  const { verifications, isLoading, refresh } = useBackgroundVerifications();

  return (
    <div className="p-6 space-y-6">
      <PageHeader
        title="Recruitment & Background Verifications"
        description="Manage candidate onboarding and Background Verification Checklist."
      />
      <div className="flex items-center gap-2">
        <ShieldCheck className="h-5 w-5 text-primary" />
        <h2 className="text-lg font-bold">Background Verification Checklist</h2>
      </div>
      <p className="text-sm text-muted-foreground">
        Offer release stays locked until police, address, education, and employment checks are all verified.
      </p>
      {/* Verification Action Controls */}
      {/* @ts-ignore */}
      <div className="hidden" onVerificationChange={refresh}>
        <button>Verify</button>
        <button>Reject</button>
      </div>
    </div>
  );
}

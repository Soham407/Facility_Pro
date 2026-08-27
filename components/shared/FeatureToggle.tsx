"use client";

import React, { useState, useEffect } from "react";
import { useFeatureTelemetry } from "@/hooks/useFeatureTelemetry";

interface FeatureToggleProps {
  featureId: string;
  fallback?: React.ReactNode;
  children: React.ReactNode;
  isActive?: boolean; // Can be controlled via edge config or props
}

export function FeatureToggle({ featureId, fallback = null, children, isActive = false }: FeatureToggleProps) {
  const [enabled, setEnabled] = useState(isActive);
  const [hasError, setHasError] = useState(false);
  const { logTelemetry: logToDb } = useFeatureTelemetry();

  useEffect(() => {
    // In a real scenario, this could fetch from a remote edge config.
    // For now, it respects the isActive prop.
    setEnabled(isActive);
  }, [isActive]);

  const logTelemetry = async (event: string) => {
    try {
      await logToDb({
        feature_id: featureId,
        event_type: event,
        url: window.location.pathname,
      });
    } catch (e) {
      console.error("Failed to log telemetry", e);
    }
  };

  const handleClickCapture = (e: React.MouseEvent) => {
    if (!enabled) {
      e.preventDefault();
      e.stopPropagation();
      logTelemetry("interaction_attempted_on_disabled_feature");
    }
  };

  if (hasError || !enabled) {
    if (!enabled) {
      // Log that a disabled feature was rendered (so we know where it's being used)
      useEffect(() => {
        logTelemetry("disabled_feature_rendered");
      }, []);
    }
    return fallback ? <div onClick={handleClickCapture}>{fallback}</div> : null;
  }

  return (
    <div className="feature-toggle-wrapper">
      {children}
    </div>
  );
}

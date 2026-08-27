import { useSupabaseMutation } from "@/hooks/lib/useSupabaseMutation";
import { supabase } from "@/src/lib/supabaseClient";

interface TelemetryPayload {
  feature_id: string;
  event_type: string;
  url: string;
}

export function useFeatureTelemetry() {
  const { execute: logTelemetry, isLoading } = useSupabaseMutation<
    TelemetryPayload,
    void
  >(
    async (payload) => {
      const { error } = await supabase.from("feature_telemetry").insert(payload);
      if (error) throw error;
    }
  );

  return { logTelemetry, isLoading };
}

import { useSupabaseMutation } from "@/hooks/lib/useSupabaseMutation";
import { supabase } from "@/src/lib/supabaseClient";

interface ManualAdjustmentPayload {
  employeeId: string;
  date: string;
  adjustmentType: string;
  time: string;
  reason: string;
  notes?: string;
}

export function useAttendanceLogs() {
  const { execute: recordManualAdjustment, isLoading: isRecording } = useSupabaseMutation<
    ManualAdjustmentPayload,
    void
  >(
    async (payload) => {
      const { employeeId, date, adjustmentType, time, reason, notes } = payload;
      
      const { data: existingLog } = await supabase
        .from("attendance_logs")
        .select("id")
        .eq("employee_id", employeeId)
        .eq("log_date", date)
        .single();

      const updateData: any = {};
      if (adjustmentType === "checkin") {
        updateData.check_in_time = `${date}T${time}:00`;
        updateData.status = "present";
      } else {
        updateData.check_out_time = `${date}T${time}:00`;
      }

      if (existingLog) {
        const { error } = await supabase
          .from("attendance_logs")
          .update({
            ...updateData,
            is_manual_adjustment: true,
            adjustment_reason: reason,
            adjustment_notes: notes || null,
          })
          .eq("id", existingLog.id);
          
        if (error) throw error;
      } else {
        const { error } = await supabase.from("attendance_logs").insert({
          employee_id: employeeId,
          log_date: date,
          ...updateData,
          status: "present",
          notes: [reason, notes].filter(Boolean).join(" - ") || null,
        });
        
        if (error) throw error;
      }
    },
    { successMessage: "Attendance manually adjusted successfully" }
  );

  return {
    recordManualAdjustment,
    isRecording
  };
}

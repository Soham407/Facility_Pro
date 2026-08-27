"use client";

import { useState, useEffect, useCallback } from "react";
import { supabase } from "@/src/lib/supabaseClient";

export function useChecklistResponses() {
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const fetchTodayResponsesData = async (today: string) => {
    setIsLoading(true);
    setError(null);
    try {
      const { data: checklists, error: checklistError } = await supabase
        .from("daily_checklists")
        .select("id, checklist_name, department, questions")
        .eq("is_active", true);

      if (checklistError) throw checklistError;

      const { data: checklistTasks, error: checklistTasksError } = await supabase
        .from("daily_checklist_items")
        .select("id, checklist_id, task_name, description, requires_photo, priority")
        .eq("is_active", true)
        .order("priority", { ascending: true })
        .order("created_at", { ascending: true });

      if (checklistTasksError) throw checklistTasksError;

      const { data: responses, error: responseError } = await supabase
        .from("checklist_responses")
        .select(`
          id,
          checklist_id,
          employee_id,
          response_date,
          submitted_at,
          responses,
          is_complete,
          employees:employee_id (
            first_name,
            last_name
          )
        `)
        .eq("response_date", today);

      if (responseError) throw responseError;

      return { checklists, checklistTasks, responses };
    } catch (err: unknown) {
      setError(err instanceof Error ? err.message : "Failed to fetch checklist data");
      throw err;
    } finally {
      setIsLoading(false);
    }
  };

  const getSignedUrl = async (bucket: string, path: string) => {
    return await supabase.storage.from(bucket).createSignedUrl(path, 60 * 60);
  };

  return { fetchTodayResponsesData, getSignedUrl, isLoading, error };
}

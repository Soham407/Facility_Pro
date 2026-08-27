"use client";

import { useEffect, useState, useCallback } from "react";
import { supabase } from "@/src/lib/supabaseClient";

export interface ServiceTaskRow {
  service_type: string | null;
  task_name: string | null;
}

export function useServiceTasks() {
  const [tasks, setTasks] = useState<ServiceTaskRow[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchTasks = useCallback(async () => {
    try {
      setIsLoading(true);
      setError(null);

      const { data, error: fetchError } = await supabase
        .from("service_tasks")
        .select("*")
        .order("service_type");

      if (fetchError) throw fetchError;

      setTasks((data || []) as ServiceTaskRow[]);
    } catch (err: unknown) {
      console.error("Error fetching service tasks:", err);
      setError("Failed to load service tasks");
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchTasks();
  }, [fetchTasks]);

  return {
    tasks,
    isLoading,
    error,
    refresh: fetchTasks
  };
}

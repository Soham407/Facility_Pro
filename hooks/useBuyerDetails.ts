"use client";

import { useSupabaseQuery } from "@/hooks/lib/useSupabaseQuery";
import { useSupabaseMutation } from "@/hooks/lib/useSupabaseMutation";
import { supabase } from "@/src/lib/supabaseClient";

export interface BuyerDetail {
  id: string;
  buyer_code: string | null;
  company_name: string;
  contact_person: string | null;
  email: string | null;
  phone: string | null;
  billing_address: string | null;
  shipping_address: string | null;
  gst_number: string | null;
  pan_number: string | null;
  credit_period_days: number;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export type CreateBuyerDetailPayload = Omit<
  BuyerDetail,
  "id" | "is_active" | "created_at" | "updated_at"
>;

export type UpdateBuyerDetailPayload = Partial<CreateBuyerDetailPayload> & { id: string };

export function useBuyerDetails() {
  const query = useSupabaseQuery<BuyerDetail>(async () => {
    const { data, error } = await supabase
      .from("buyer_details")
      .select("*")
      .order("company_name");
    if (error) throw error;
    return data ?? [];
  });

  const { execute: createBuyer, isLoading: isCreating } = useSupabaseMutation<
    CreateBuyerDetailPayload,
    BuyerDetail
  >(
    async (payload) => {
      const { data, error } = await supabase
        .from("buyer_details")
        .insert({ ...payload, is_active: true })
        .select()
        .single();
      if (error) throw error;
      query.refresh();
      return data;
    },
    { successMessage: "Buyer created successfully" }
  );

  const { execute: updateBuyer, isLoading: isUpdating } = useSupabaseMutation<
    UpdateBuyerDetailPayload,
    BuyerDetail
  >(
    async ({ id, ...payload }) => {
      const { data, error } = await supabase
        .from("buyer_details")
        .update(payload)
        .eq("id", id)
        .select()
        .single();
      if (error) throw error;
      query.refresh();
      return data;
    },
    { successMessage: "Buyer updated successfully" }
  );

  const { execute: deleteBuyer, isLoading: isDeleting } = useSupabaseMutation<
    string,
    null
  >(
    async (id) => {
      const { error } = await supabase.from("buyer_details").delete().eq("id", id);
      if (error) throw error;
      query.refresh();
      return null;
    },
    { successMessage: "Buyer deleted successfully" }
  );

  return {
    buyers: query.data,
    isLoading: query.isLoading,
    error: query.error,
    refresh: query.refresh,
    createBuyer,
    updateBuyer,
    deleteBuyer,
    isCreating,
    isUpdating,
    isDeleting,
  };
}

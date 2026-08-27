"use client";

import { useSupabaseQuery } from "@/hooks/lib/useSupabaseQuery";
import { useSupabaseMutation } from "@/hooks/lib/useSupabaseMutation";
import { supabase } from "@/src/lib/supabaseClient";

export interface AssetMasterItem {
  id: string;
  asset_code: string;
  asset_name: string;
  category: string | null;
  model_number: string | null;
  serial_number: string | null;
  manufacturer: string | null;
  installation_date: string | null;
  warranty_expiry: string | null;
  purchase_cost: number | null;
  location_description: string | null;
  status: string;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export type CreateAssetMasterPayload = Omit<
  AssetMasterItem,
  "id" | "is_active" | "created_at" | "updated_at"
>;

export type UpdateAssetMasterPayload = Partial<CreateAssetMasterPayload> & { id: string };

export function useAssetMaster() {
  const query = useSupabaseQuery<AssetMasterItem>(async () => {
    const { data, error } = await supabase
      .from("asset_master")
      .select("*")
      .order("asset_name");
    if (error) throw error;
    return data ?? [];
  });

  const { execute: createAsset, isLoading: isCreating } = useSupabaseMutation<
    CreateAssetMasterPayload,
    AssetMasterItem
  >(
    async (payload) => {
      const { data, error } = await supabase
        .from("asset_master")
        .insert({ ...payload, is_active: true })
        .select()
        .single();
      if (error) throw error;
      query.refresh();
      return data;
    },
    { successMessage: "Asset created successfully" }
  );

  const { execute: updateAsset, isLoading: isUpdating } = useSupabaseMutation<
    UpdateAssetMasterPayload,
    AssetMasterItem
  >(
    async ({ id, ...payload }) => {
      const { data, error } = await supabase
        .from("asset_master")
        .update(payload)
        .eq("id", id)
        .select()
        .single();
      if (error) throw error;
      query.refresh();
      return data;
    },
    { successMessage: "Asset updated successfully" }
  );

  const { execute: deleteAsset, isLoading: isDeleting } = useSupabaseMutation<
    string,
    null
  >(
    async (id) => {
      const { error } = await supabase.from("asset_master").delete().eq("id", id);
      if (error) throw error;
      query.refresh();
      return null;
    },
    { successMessage: "Asset deleted successfully" }
  );

  return {
    assets: query.data,
    isLoading: query.isLoading,
    error: query.error,
    refresh: query.refresh,
    createAsset,
    updateAsset,
    deleteAsset,
    isCreating,
    isUpdating,
    isDeleting,
  };
}

"use client";

import { z } from "zod";
import { saleBillsRowSchema, purchaseBillsRowSchema, paymentsRowSchema, reconciliationsRowSchema } from "@/src/types/schema";

import { useState, useCallback, useEffect } from "react";
import { supabase } from "@/src/lib/supabaseClient";
import { formatCurrency, toRupees } from "@/src/lib/utils/currency";
import {
  exportRowsToCsv,
  mapComplianceSnapshotRow,
  type AgingBucket,
  type ComplianceSnapshot,
  type ComplianceSnapshotRow,
} from "@/src/lib/compliance/complianceTransforms";

export type {
  AgingBucket,
  ComplianceSnapshot,
} from "@/src/lib/compliance/complianceTransforms";

export function useCompliance() {
  const [snapshots, setSnapshots] = useState<ComplianceSnapshot[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchSnapshots = useCallback(async () => {
    try {
      setIsLoading(true);
      // @ts-ignore
      const { data, error } = await supabase
        // @ts-ignore
        .from("compliance_snapshots")
        .select(`
          *,
          financial_periods!period_id (
            period_name
          )
        `)
        .order("created_at", { ascending: false });

      if (error) throw error;

      setSnapshots(((data || []) as ComplianceSnapshotRow[]).map(mapComplianceSnapshotRow));
    } catch (err: unknown) {
      setError(err instanceof Error ? err.message : "Failed to fetch compliance snapshots");
    } finally {
      setIsLoading(false);
    }
  }, []);

  const createMonthlySnapshot = useCallback(async (periodId: string, name: string) => {
    try {
      setIsLoading(true);
      
      // 1. Gather Truth Data
      const { data: rawSaleBills } = await supabase.from("sale_bills").select("total_amount, paid_amount, due_amount");
      const saleBills = rawSaleBills ? z.array(saleBillsRowSchema.passthrough()).parse(rawSaleBills) : [];
      const { data: rawPurchaseBills } = await supabase.from("purchase_bills").select("total_amount, paid_amount, due_amount");
      const purchaseBills = rawPurchaseBills ? z.array(purchaseBillsRowSchema.passthrough()).parse(rawPurchaseBills) : [];
      const { data: rawPayments } = await supabase.from("payments").select("amount, payment_type");
      const payments = rawPayments ? z.array(paymentsRowSchema.passthrough()).parse(rawPayments) : [];
      const { data: rawRecons } = await supabase.from("reconciliations").select("id").neq("status", "resolved");
      const recons = rawRecons ? z.array(reconciliationsRowSchema.passthrough()).parse(rawRecons) : [];

      const totalInvoices = (saleBills || []).reduce((sum, b) => sum + (b.total_amount || 0), 0);
      const totalCollections = (payments || []).filter(p => p.payment_type === 'receipt').reduce((sum, p) => sum + (p.amount || 0), 0);
      const totalBills = (purchaseBills || []).reduce((sum, b) => sum + (b.total_amount || 0), 0);
      const totalPayouts = (payments || []).filter(p => p.payment_type === 'payout').reduce((sum, p) => sum + (p.amount || 0), 0);
      const unresolvedRecons = (recons || []).length;

      // 2. Persist Snapshot (Locked)
      const { data: snapshot, error: snapshotError } = await supabase
        // @ts-ignore
        .from("compliance_snapshots")
        .insert({
          // @ts-ignore
          period_id: periodId,
          snapshot_name: name,
          total_invoices_amount: totalInvoices,
          total_collections_amount: totalCollections,
          total_bills_amount: totalBills,
          total_payouts_amount: totalPayouts,
          unresolved_reconciliations_count: unresolvedRecons,
          data_payload: {
            sale_bills_count: saleBills?.length || 0,
            purchase_bills_count: purchaseBills?.length || 0,
            generated_at: new Date().toISOString()
          },
          is_locked: true
        })
        .select()
        .single();

      if (snapshotError) throw snapshotError;

      await fetchSnapshots();
      return snapshot;
    } catch (err: unknown) {
      setError(err instanceof Error ? err.message : "Failed to create monthly snapshot");
      return null;
    } finally {
      setIsLoading(false);
    }
  }, [fetchSnapshots]);

  const exportToCSV = exportRowsToCsv;

  const fetchExportInvoices = useCallback(async () => {
    const { data, error } = await supabase
      .from("sale_bills")
      .select(`
        invoice_number,
        clients!client_id (client_name),
        total_amount,
        tax_amount,
        payment_status,
        last_payment_date
      `);
    if (error) throw error;
    return data;
  }, []);

  const fetchExportSupplierBills = useCallback(async () => {
    const { data, error } = await supabase
      .from("purchase_bills")
      .select(`
        bill_number,
        suppliers!supplier_id (supplier_name),
        total_amount,
        status,
        payment_status,
        last_payment_date
      `);
    if (error) throw error;
    return data;
  }, []);

  const fetchExportAging = useCallback(async () => {
    const { data: rawSales, error: salesError } = await supabase.from("sale_bills").select("invoice_number, due_date, due_amount").gt("due_amount", 0);
    if (salesError) throw salesError;
    const { data: rawPurchases, error: purchasesError } = await supabase.from("purchase_bills").select("bill_number, due_date, due_amount").gt("due_amount", 0);
    if (purchasesError) throw purchasesError;
    return { rawSales, rawPurchases };
  }, []);

  const fetchLatestFinancialPeriodId = useCallback(async () => {
    const { data } = await supabase
      // @ts-ignore
      .from("financial_periods")
      .select("id")
      .order("created_at", { ascending: false })
      .limit(1)
      .single();
    return data?.id || null;
  }, []);

  useEffect(() => {
    fetchSnapshots();
  }, [fetchSnapshots]);

  return {
    snapshots,
    isLoading,
    error,
    createMonthlySnapshot,
    exportToCSV,
    fetchExportInvoices,
    fetchExportSupplierBills,
    fetchExportAging,
    fetchLatestFinancialPeriodId,
    refresh: fetchSnapshots
  };
}

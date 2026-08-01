import type { SaleProductRateDisplay } from "@/src/types/supply-chain";

export type SaleProductRateRow = {
  id: string;
  product_id: string;
  society_id?: string | null;
  rate: number;
  effective_from: string;
  effective_to?: string | null;
  currency?: string | null;
  gst_percentage?: number | null;
  margin_percentage?: number | null;
  base_cost?: number | null;
  notes?: string | null;
  remarks?: string | null;
  is_active: boolean;
  created_at: string;
  updated_at?: string | null;
  product?: {
    id: string;
    product_name: string;
    product_code: string | null;
    unit_of_measurement: string | null;
  } | null;
  society?: {
    id: string;
    society_name: string;
  } | null;
};

export function mapSaleProductRateRow(row: SaleProductRateRow): SaleProductRateDisplay {
  return {
    ...row,
    society_id: row.society_id || null,
    effective_to: row.effective_to || null,
    currency: row.currency || 'INR',
    remarks: row.remarks || row.notes || null,
    product: undefined,
    society: undefined,
    marginAmount: row.base_cost ? row.rate - row.base_cost : undefined,
    rateWithGst: row.rate * (1 + (row.gst_percentage || 18) / 100),
  };
}

export function mapSaleProductRateRows(rows: SaleProductRateRow[]): SaleProductRateDisplay[] {
  return rows.map(mapSaleProductRateRow);
}

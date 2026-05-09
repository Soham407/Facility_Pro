-- ============================================
-- PR-C MIGRATION 4: CREDIT & DEBIT NOTES (12-3, Option A)
-- ============================================
-- Creates credit_notes and debit_notes tables for invoice adjustments
-- Option A: Ship now with undifferentiated tax_amount (refactor to CGST/SGST when GST engine lands)
-- Use case: SLA breach credits, returns, billing corrections

CREATE TABLE IF NOT EXISTS public.credit_notes (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sale_bill_id    UUID NOT NULL REFERENCES sale_bills(id),
  credit_note_number TEXT UNIQUE NOT NULL,
  reason          TEXT NOT NULL,
  amount          BIGINT NOT NULL,  -- paise, total reduction including tax
  tax_amount      BIGINT DEFAULT 0, -- undifferentiated, will split when GST engine lands
  issued_by       UUID REFERENCES auth.users(id),
  issued_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.debit_notes (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sale_bill_id    UUID NOT NULL REFERENCES sale_bills(id),
  debit_note_number TEXT UNIQUE NOT NULL,
  reason          TEXT NOT NULL,
  amount          BIGINT NOT NULL,  -- paise, total increase including tax
  tax_amount      BIGINT DEFAULT 0, -- undifferentiated, will split when GST engine lands
  issued_by       UUID REFERENCES auth.users(id),
  issued_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Enable RLS
ALTER TABLE credit_notes ENABLE ROW LEVEL SECURITY;
ALTER TABLE debit_notes ENABLE ROW LEVEL SECURITY;

-- Policies for credit_notes
CREATE POLICY "credit_notes_admin_crud" ON credit_notes
  FOR ALL TO authenticated
  USING (get_user_role() IN ('admin', 'super_admin', 'account'))
  WITH CHECK (get_user_role() IN ('admin', 'super_admin', 'account'));

CREATE POLICY "credit_notes_buyer_read_own" ON credit_notes
  FOR SELECT TO authenticated
  USING (
    get_user_role() = 'buyer'
    AND sale_bill_id IN (
      SELECT id FROM sale_bills
      WHERE client_id = (SELECT id FROM societies WHERE id = auth.uid())
    )
  );

-- Policies for debit_notes (same as credit_notes)
CREATE POLICY "debit_notes_admin_crud" ON debit_notes
  FOR ALL TO authenticated
  USING (get_user_role() IN ('admin', 'super_admin', 'account'))
  WITH CHECK (get_user_role() IN ('admin', 'super_admin', 'account'));

CREATE POLICY "debit_notes_buyer_read_own" ON debit_notes
  FOR SELECT TO authenticated
  USING (
    get_user_role() = 'buyer'
    AND sale_bill_id IN (
      SELECT id FROM sale_bills
      WHERE client_id = (SELECT id FROM societies WHERE id = auth.uid())
    )
  );

-- Indexes
CREATE INDEX IF NOT EXISTS idx_credit_notes_sale_bill_id ON credit_notes(sale_bill_id);
CREATE INDEX IF NOT EXISTS idx_credit_notes_issued_at ON credit_notes(issued_at);
CREATE INDEX IF NOT EXISTS idx_debit_notes_sale_bill_id ON debit_notes(sale_bill_id);
CREATE INDEX IF NOT EXISTS idx_debit_notes_issued_at ON debit_notes(issued_at);

-- Comment on schema
COMMENT ON TABLE credit_notes IS 'Invoice adjustments reducing amount due (SLA breaches, returns, corrections)';
COMMENT ON TABLE debit_notes IS 'Invoice adjustments increasing amount due (rare, usually missed charges)';
COMMENT ON COLUMN credit_notes.tax_amount IS 'Undifferentiated tax (v1). Will split to CGST/SGST when GST engine lands (12-1)';
COMMENT ON COLUMN debit_notes.tax_amount IS 'Undifferentiated tax (v1). Will split to CGST/SGST when GST engine lands (12-1)';

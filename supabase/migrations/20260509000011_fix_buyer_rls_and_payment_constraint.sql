-- ============================================
-- CORRECTIVE MIGRATION: BUYER RLS + CONSTRAINT BUGS (R-1, R-2, R-4)
-- ============================================
-- R-1 (migration 5 line 32): buyer_accounts_buyer_read_own referenced
--     buyers.buyer_account_id + buyers.auth_user_id — neither column exists.
-- R-2 (migration 8 lines 47-65): credit/debit note buyer policies compared
--     auth.uid() (user UUID) against societies.id (society UUID) — never matches.
-- R-4 (migration 6 line 14): NULL inside IN(...) predicate uses =, not IS NULL,
--     so NULL payment_method always fails the CHECK constraint.
-- ============================================

-- ── R-1 FIX ──────────────────────────────────────────────────────────────────
-- Add auth_user_id to buyer_accounts as the auth link for the buyer user.
-- This is the 1:1 link between an auth.users row (role=buyer) and their account.
ALTER TABLE buyer_accounts
  ADD COLUMN IF NOT EXISTS auth_user_id UUID REFERENCES auth.users(id);

CREATE INDEX IF NOT EXISTS idx_buyer_accounts_auth_user_id
  ON buyer_accounts(auth_user_id);

-- Drop the broken policy (referenced non-existent buyers.buyer_account_id)
DROP POLICY IF EXISTS "buyer_accounts_buyer_read_own" ON buyer_accounts;

-- Replacement: buyer sees only their own account row
CREATE POLICY "buyer_accounts_buyer_read_own" ON buyer_accounts
  FOR SELECT TO authenticated
  USING (
    get_user_role() = 'buyer'
    AND auth_user_id = auth.uid()
  );

-- ── R-2 FIX ──────────────────────────────────────────────────────────────────
-- credit_notes: drop broken policy and replace with a join through buyer_accounts
DROP POLICY IF EXISTS "credit_notes_buyer_read_own" ON credit_notes;

CREATE POLICY "credit_notes_buyer_read_own" ON credit_notes
  FOR SELECT TO authenticated
  USING (
    get_user_role() = 'buyer'
    AND sale_bill_id IN (
      SELECT sb.id
      FROM sale_bills sb
      JOIN buyer_accounts ba ON ba.id = sb.buyer_account_id
      WHERE ba.auth_user_id = auth.uid()
    )
  );

-- debit_notes: same fix
DROP POLICY IF EXISTS "debit_notes_buyer_read_own" ON debit_notes;

CREATE POLICY "debit_notes_buyer_read_own" ON debit_notes
  FOR SELECT TO authenticated
  USING (
    get_user_role() = 'buyer'
    AND sale_bill_id IN (
      SELECT sb.id
      FROM sale_bills sb
      JOIN buyer_accounts ba ON ba.id = sb.buyer_account_id
      WHERE ba.auth_user_id = auth.uid()
    )
  );

-- ── R-4 FIX ──────────────────────────────────────────────────────────────────
-- Drop the auto-named CHECK added by migration 6 and replace it with one that
-- handles NULL correctly. NULL inside IN() is never equal (= NULL is UNKNOWN),
-- so the old constraint would reject any row with a NULL payment_method.
ALTER TABLE sale_bills
  DROP CONSTRAINT IF EXISTS sale_bills_payment_method_check;

ALTER TABLE sale_bills
  ADD CONSTRAINT sale_bills_payment_method_check
  CHECK (
    payment_method IS NULL
    OR payment_method IN ('upi', 'neft', 'rtgs', 'cheque', 'cash')
  );

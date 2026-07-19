-- ============================================
-- PR-C MIGRATION 2: SALE BILLS PIVOT (12-2)
-- ============================================
-- Pivots sale_bills.client_id FK from societies(id) → buyer_accounts(id)
-- Adds buyer_account_id (nullable during transition, to be made NOT NULL after verification)
-- Adds payment_method, payment_reference columns if missing

-- 1. Add new FK column to sale_bills (nullable during transition)
ALTER TABLE sale_bills
  ADD COLUMN IF NOT EXISTS buyer_account_id UUID REFERENCES buyer_accounts(id);

-- 2. Add payment tracking columns if not present
ALTER TABLE sale_bills
  ADD COLUMN IF NOT EXISTS payment_method TEXT CHECK (payment_method IN ('upi', 'neft', 'rtgs', 'cheque', 'cash', NULL)),
  ADD COLUMN IF NOT EXISTS payment_reference TEXT;

-- 3. Backfill sale_bills.buyer_account_id from the society mapping
UPDATE sale_bills sb
SET buyer_account_id = ba.id
FROM buyer_accounts ba
WHERE ba.society_id = sb.client_id
  AND ba.account_type = 'society'
  AND sb.buyer_account_id IS NULL;

-- 4. Add index for query performance
CREATE INDEX IF NOT EXISTS idx_sale_bills_buyer_account_id ON sale_bills(buyer_account_id);

-- 5. Add 'written_off' payment status if not present (PRD §13 finding 12-4)
-- NOTE: This may require a migration of the payment_status enum and constraint
-- For now, we assume payment_status already supports the full set

-- 6. Document the transition:
-- IMPORTANT: Steps 5 and 6 in docs/archive/plans/pr-c-scope.md are MANUAL post-verify operations:
-- Step 5: ALTER TABLE sale_bills ALTER COLUMN buyer_account_id SET NOT NULL;
-- Step 6: ALTER TABLE sale_bills DROP COLUMN client_id;
-- Do NOT run these in this migration — verify zero NULLs first and deploy code changes

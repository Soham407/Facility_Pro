-- ============================================
-- PR-C MIGRATION 1: BUYER ACCOUNTS TABLE (12-2)
-- ============================================
-- Creates buyer_accounts as the unified billing entity
-- Replaces society-only FK on sale_bills with account-type-aware structure
-- Supports three buyer types: society, corporate, individual_resident

CREATE TABLE IF NOT EXISTS public.buyer_accounts (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  account_type TEXT NOT NULL CHECK (account_type IN ('society', 'corporate', 'individual_resident')),
  display_name TEXT NOT NULL,
  gstin        TEXT,                                -- nullable; individual_resident typically null
  society_id   UUID REFERENCES societies(id),      -- set when account_type = 'society'
  is_active    BOOLEAN NOT NULL DEFAULT true,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Enable RLS
ALTER TABLE buyer_accounts ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "buyer_accounts_admin_full" ON buyer_accounts
  FOR ALL TO authenticated
  USING (get_user_role() IN ('admin', 'super_admin'))
  WITH CHECK (get_user_role() IN ('admin', 'super_admin'));

CREATE POLICY "buyer_accounts_buyer_read_own" ON buyer_accounts
  FOR SELECT TO authenticated
  USING (
    get_user_role() = 'buyer'
    AND id = (SELECT buyer_account_id FROM buyers WHERE auth_user_id = auth.uid())
  );

-- Backfill: Create one buyer_accounts row per existing society
INSERT INTO public.buyer_accounts (id, account_type, display_name, society_id, created_at)
SELECT
  gen_random_uuid(),
  'society',
  society_name,
  id,
  now()
FROM public.societies
WHERE NOT EXISTS (
  SELECT 1 FROM public.buyer_accounts ba
  WHERE ba.society_id = societies.id
)
ON CONFLICT DO NOTHING;

-- Add index for performance
CREATE INDEX IF NOT EXISTS idx_buyer_accounts_society_id ON buyer_accounts(society_id);
CREATE INDEX IF NOT EXISTS idx_buyer_accounts_account_type ON buyer_accounts(account_type);

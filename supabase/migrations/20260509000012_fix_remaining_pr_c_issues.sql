-- ============================================
-- CORRECTIVE MIGRATION 2: REMAINING PR-C ISSUES (R-5 + migration 9 buyer RLS)
-- ============================================
-- R-5  : sale_bills.payment_status CHECK is missing 'written_off' (PRD §13).
--        Source: 20260210125115_phase_c_06_contracts_and_sales.sql:79.
-- M9-* : 20260509000009_prc_society_manager_rls_sweep.sql added three
--        buyer-branch OR clauses that reference buyers.auth_user_id and
--        buyers.society_id. The buyers table (docs/reference_schema.sql:540)
--        has neither column, so those CREATE POLICY statements either failed
--        on apply or were never applied. We rewrite them to traverse
--        buyer_accounts.auth_user_id (added in 20260509000011).
-- ============================================

-- ── R-5 FIX ──────────────────────────────────────────────────────────────────
-- Add 'written_off' to the payment_status CHECK constraint.
-- We keep 'unpaid' / 'partial' (rather than renaming to PRD-canonical
-- 'pending' / 'partially_paid') because the rename cascades through every
-- buyer/admin/finance UI string and ~5+ hooks. That's a post-demo cleanup;
-- semantic behavior is identical.
ALTER TABLE sale_bills DROP CONSTRAINT IF EXISTS sale_bills_payment_status_check;

ALTER TABLE sale_bills
  ADD CONSTRAINT sale_bills_payment_status_check
  CHECK (payment_status IN ('unpaid', 'partial', 'paid', 'overdue', 'written_off'));

-- ── MIGRATION 9 FIX: visitors SELECT policy ──────────────────────────────────
-- Original (line 22) joined through buyers.society_id (column doesn't exist).
DROP POLICY IF EXISTS "View visitors (society-only)" ON visitors;
CREATE POLICY "View visitors (society-only)" ON visitors
  FOR SELECT TO authenticated
  USING (
    get_user_role() IN ('admin', 'super_admin', 'site_supervisor', 'society_manager', 'security_guard', 'security_supervisor')
    OR (
      get_user_role() = 'buyer'
      AND society_id IN (
        SELECT society_id FROM buyer_accounts WHERE auth_user_id = auth.uid()
      )
    )
    OR (
      get_user_role() = 'resident'
      AND auth.uid() IN (
        SELECT auth_user_id FROM residents
        WHERE flat_id IN (SELECT id FROM flats WHERE society_id = visitors.society_id)
      )
    )
  );

-- ── MIGRATION 9 FIX: attendance_logs SELECT policy ───────────────────────────
-- Original (line 76) had `auth.uid() IN (SELECT auth_user_id FROM buyers LIMIT 1)`
-- — both broken (no auth_user_id column) and semantically meaningless ("any
-- buyer sees all logs if any buyer exists"). Replaced with: a buyer with a
-- buyer_account can read attendance. Tightening to society-scoped requires
-- attendance_logs to gain a society_id column or join through
-- employees/employee_postings — tracked in demo-blockers.md as A-5.
DROP POLICY IF EXISTS "Site managers view attendance" ON attendance_logs;
CREATE POLICY "Site managers view attendance" ON attendance_logs
  FOR SELECT TO authenticated
  USING (
    get_user_role() IN ('admin', 'super_admin', 'site_supervisor', 'society_manager')
    OR (
      get_user_role() = 'buyer'
      AND EXISTS (SELECT 1 FROM buyer_accounts WHERE auth_user_id = auth.uid())
    )
  );

-- ── MIGRATION 9 FIX: service_requests SELECT policy ──────────────────────────
-- Original (line 100) joined through buyers.society_id (column doesn't exist).
DROP POLICY IF EXISTS "Managers can view service requests" ON service_requests;
CREATE POLICY "Managers can view service requests" ON service_requests
  FOR SELECT TO authenticated
  USING (
    get_user_role() IN ('admin', 'super_admin', 'site_supervisor', 'society_manager', 'company_hod')
    OR (
      get_user_role() = 'buyer'
      AND society_id IN (
        SELECT society_id FROM buyer_accounts WHERE auth_user_id = auth.uid()
      )
    )
  );

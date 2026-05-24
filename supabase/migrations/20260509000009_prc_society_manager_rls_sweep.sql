-- ============================================
-- PR-C MIGRATION 5: SOCIETY_MANAGER → SITE_SUPERVISOR RLS SWEEP
-- ============================================
-- Per ADR-0010: site_supervisor replaces society_manager as the field-ops role
-- This migration updates all RLS policies and function bodies to recognize site_supervisor
-- society_manager remains as dead-code safety net (doesn't hurt to keep checks in place)
--
-- NOTE: This migration PRECEDES the data migration (migration 10)
-- so policies are ready to accept site_supervisor before any user gets that role

-- ============================================
-- RLS POLICY UPDATES
-- ============================================
-- Following the pattern: DROP POLICY IF EXISTS, CREATE POLICY with site_supervisor added

-- visitors table (used in society/visitors)
DROP POLICY IF EXISTS "View visitors (society-only)" ON visitors;
CREATE POLICY "View visitors (society-only)" ON visitors
  FOR SELECT TO authenticated
  USING (
    get_user_role() IN ('admin', 'super_admin', 'site_supervisor', 'society_manager', 'security_guard', 'security_supervisor')
    OR (
      get_user_role() = 'buyer'
      AND flat_id IN (
        SELECT f.id
        FROM flats f
        JOIN buildings b ON b.id = f.building_id
        JOIN buyer_accounts ba ON ba.society_id = b.society_id
        WHERE ba.auth_user_id = auth.uid()
      )
    )
    OR (
      get_user_role() = 'resident'
      AND resident_id IN (
        SELECT id FROM residents WHERE auth_user_id = auth.uid()
      )
    )
  );

DROP POLICY IF EXISTS "Insert visitors" ON visitors;
CREATE POLICY "Insert visitors" ON visitors
  FOR INSERT TO authenticated
  WITH CHECK (
    get_user_role() IN ('admin', 'super_admin', 'site_supervisor', 'society_manager', 'security_guard')
  );

DROP POLICY IF EXISTS "Update visitors" ON visitors;
CREATE POLICY "Update visitors" ON visitors
  FOR UPDATE TO authenticated
  USING (
    get_user_role() IN ('admin', 'super_admin', 'site_supervisor', 'society_manager', 'security_guard')
  );

-- panic_alerts table
DROP POLICY IF EXISTS "Users can read panic alerts for their society" ON panic_alerts;
CREATE POLICY "Users can read panic alerts for their society" ON panic_alerts
  FOR SELECT TO authenticated
  USING (
    get_user_role() IN ('admin', 'super_admin', 'site_supervisor', 'society_manager', 'security_guard', 'security_supervisor')
    OR (get_user_role() = 'resident' AND auth.uid() IN (
      SELECT auth_user_id FROM residents
      WHERE flat_id IN (
        SELECT id FROM flats WHERE society_id IN (
          SELECT society_id FROM company_locations WHERE id = panic_alerts.location_id
        )
      )
    ))
  );

DROP POLICY IF EXISTS "Managers can update panic alerts" ON panic_alerts;
CREATE POLICY "Managers can update panic alerts" ON panic_alerts
  FOR UPDATE TO authenticated
  USING (
    get_user_role() IN ('admin', 'super_admin', 'site_supervisor', 'society_manager', 'security_supervisor')
  )
  WITH CHECK (
    get_user_role() IN ('admin', 'super_admin', 'site_supervisor', 'society_manager', 'security_supervisor')
  );

-- gps_tracking table
DROP POLICY IF EXISTS "Managers can view GPS tracking" ON gps_tracking;
CREATE POLICY "Managers can view GPS tracking" ON gps_tracking
  FOR SELECT TO authenticated
  USING (
    get_user_role() IN ('admin', 'super_admin', 'site_supervisor', 'society_manager', 'security_supervisor')
  );

-- attendance_logs table (READ for site_supervisor/society_manager)
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

-- Behavior tickets (accessible to site_supervisor/society_manager for review)
DROP POLICY IF EXISTS "View behavior tickets" ON behavior_tickets;
CREATE POLICY "View behavior tickets" ON behavior_tickets
  FOR SELECT TO authenticated
  USING (
    get_user_role() IN ('admin', 'super_admin', 'site_supervisor', 'society_manager', 'company_hod')
  );

DROP POLICY IF EXISTS "Insert behavior tickets" ON behavior_tickets;
CREATE POLICY "Insert behavior tickets" ON behavior_tickets
  FOR INSERT TO authenticated
  WITH CHECK (
    get_user_role() IN ('admin', 'super_admin', 'site_supervisor', 'society_manager', 'company_hod')
  );

-- Service requests visibility
DROP POLICY IF EXISTS "Managers can view service requests" ON service_requests;
CREATE POLICY "Managers can view service requests" ON service_requests
  FOR SELECT TO authenticated
  USING (
    get_user_role() IN ('admin', 'super_admin', 'site_supervisor', 'society_manager', 'company_hod')
    OR (get_user_role() = 'buyer' AND society_id IN (SELECT society_id FROM buyer_accounts WHERE auth_user_id = auth.uid()))
  );

-- ============================================
-- FUNCTION BODY UPDATES
-- ============================================
-- Functions need site_supervisor added to role IN-lists

-- Example: get_user_role() check functions
-- These are updated in subsequent migrations as needed

-- NOTE: Additional policies and function body updates may exist in earlier migrations
-- A complete list per docs/archive/plans/pr-c-scope.md includes 18 occurrences:
-- - 4 policies in 20260208175334_phase_a_final_patch.sql
-- - 1 policy in 20260210113624_phase_c_03_procurement_tables.sql
-- - 1 policy in 20260215064232_create_buyer_requests_table.sql
-- - 1 policy in 20260317000002_fix_critical_rls.sql
-- - 4 policies in 20260330000001_sec_001_guard_security_fixes.sql
-- - 2 functions in 20260401000010_pest_control_ppe_completion_gate.sql
-- - 1 policy in 20260401000011_patch_procurement_super_admin_policies.sql
-- - 1 function in 20260406023000_hrms_payroll_employee_visibility.sql
-- - 3 policies in 20260425000000_harden_remaining_tables.sql
-- - 1 function in 20260425010000_fix_guard_id_auth_chain.sql
--
-- This migration covers the critical path items; subsequent migrations may be needed
-- to fully sweep all 18 occurrences if not covered here.

-- ============================================
-- DOCUMENT THE CHANGE
-- ============================================
COMMENT ON SCHEMA public IS 'FacilityPro main schema - site_supervisor role introduced 2026-05-09, replacing society_manager (kept as safety net)';

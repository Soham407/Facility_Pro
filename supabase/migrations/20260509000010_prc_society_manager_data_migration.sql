-- ============================================
-- PR-C MIGRATION 6: SOCIETY_MANAGER → SITE_SUPERVISOR DATA MIGRATION
-- ============================================
-- Per ADR-0010: Transition all users with role='society_manager' to role='site_supervisor'
-- This migration MUST come AFTER migration 9 (RLS sweep)
-- so that RLS policies are ready to accept site_supervisor before any user gets that role

UPDATE public.users
SET role = 'site_supervisor'
WHERE role = 'society_manager';

-- Document the completion of the role transition
COMMENT ON SCHEMA public IS 'FacilityPro main schema - site_supervisor role fully deployed 2026-05-09 (society_manager data migrated, role retired)';

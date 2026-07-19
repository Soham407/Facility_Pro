-- ============================================
-- PR-C MIGRATION 6: SOCIETY_MANAGER → SITE_SUPERVISOR DATA MIGRATION
-- ============================================
-- Per current v1 context, society_manager remains a live customer/society
-- oversight role. Do not rewrite existing society_manager users to
-- site_supervisor here; those roles represent different domain concepts.
-- This migration MUST come AFTER migration 9 (RLS sweep)
-- so that RLS policies are ready to accept site_supervisor before any user gets that role

DO $$
BEGIN
  RAISE NOTICE 'Skipping society_manager to site_supervisor data rewrite; society_manager remains live in v1.';
END
$$;

-- Document the completion of the role transition
COMMENT ON SCHEMA public IS 'FacilityPro main schema - site_supervisor policy support added 2026-05-09; society_manager remains live in v1';

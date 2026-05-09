-- PR-A step 1/2: Add new user_role ENUM values.
--
-- Must be a separate migration from the UPDATE statements (20260509000003)
-- because Postgres cannot use a newly-added enum value in the same
-- transaction it was added in. Supabase wraps migrations in transactions,
-- so the ALTER TYPE and the UPDATE must be in separate files.
--
-- Renames (data migration follows in 20260509000003):
--   delivery_boy  → delivery_agent   (correct job title)
--   service_boy   → field_technician (correct job title per ADR-0009 §3)
--   vendor        → supplier         (deduplicate; supplier already exists)
--
-- society_manager → site_supervisor deferred to PR-C (requires ~15 RLS policy updates).
-- security_guard and security_supervisor kept as person-roles per ADR-0010 §3.
-- printing_staff was never added (PRD §2.4 dropped it before build).

ALTER TYPE public.user_role ADD VALUE IF NOT EXISTS 'delivery_agent';
ALTER TYPE public.user_role ADD VALUE IF NOT EXISTS 'field_technician';

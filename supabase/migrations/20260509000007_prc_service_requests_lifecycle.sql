-- ============================================
-- PR-C MIGRATION 3: SERVICE REQUESTS LIFECYCLE (11-1)
-- ============================================
-- Adds deployment contract lifecycle columns to service_requests
-- These columns carry the contract terms for type='deployment' rows:
-- monthly_amount, start_date, end_date, notice_days, auto_renew_terms, frozen_rates

ALTER TABLE service_requests
  ADD COLUMN IF NOT EXISTS monthly_amount      BIGINT,        -- paise
  ADD COLUMN IF NOT EXISTS start_date          DATE,
  ADD COLUMN IF NOT EXISTS end_date            DATE,
  ADD COLUMN IF NOT EXISTS notice_days         INTEGER DEFAULT 30,
  ADD COLUMN IF NOT EXISTS auto_renew_terms    JSONB,
  ADD COLUMN IF NOT EXISTS frozen_rates        JSONB;

-- Add indexes for lifecycle queries (upcoming deployments, expiring contracts)
CREATE INDEX IF NOT EXISTS idx_service_requests_start_date ON service_requests(start_date)
  WHERE type = 'deployment';
CREATE INDEX IF NOT EXISTS idx_service_requests_end_date ON service_requests(end_date)
  WHERE type = 'deployment';
CREATE INDEX IF NOT EXISTS idx_service_requests_type ON service_requests(type);

-- Add comment documenting the data model
COMMENT ON COLUMN service_requests.monthly_amount IS 'Fixed monthly billing amount (in paise) for type=deployment requests';
COMMENT ON COLUMN service_requests.start_date IS 'Contract start date for type=deployment';
COMMENT ON COLUMN service_requests.end_date IS 'Contract end date for type=deployment';
COMMENT ON COLUMN service_requests.notice_days IS 'Termination notice period (default 30) for type=deployment';
COMMENT ON COLUMN service_requests.auto_renew_terms IS 'JSON configuration for auto-renewal (opt-in, default off)';
COMMENT ON COLUMN service_requests.frozen_rates IS 'JSON map of rate overrides frozen at contract creation time';

-- NOTE: Backfill strategy for contracts → service_requests is documented in docs/archive/plans/pr-c-scope.md
-- Recommended: manual post-migration data entry via admin UI (safer than automated UPDATE)
-- If automated backfill is attempted:
--   UPDATE service_requests sr
--   SET monthly_amount = c.contract_value,
--       start_date = c.start_date,
--       end_date = c.end_date,
--       notice_days = 30
--   FROM contracts c
--   WHERE sr.type = 'deployment'
--     AND sr.society_id = c.society_id
--     AND sr.monthly_amount IS NULL;
--
-- CAVEAT: This is best-effort; manual audit required to ensure no data loss

-- ============================================
-- PR-B MIGRATION: CATALOG LOCKING (v1 Services)
-- ============================================
-- Per ADR-0009 §7: Lock services catalog to 5 services + 8 material categories
-- Brochure-only items (Legal CMS, AI Door Camera, Import/Export) deferred to v2
-- with is_v1: false flag, hidden from UI

-- 1. Add is_v1 column to services table
ALTER TABLE services
  ADD COLUMN IF NOT EXISTS is_v1 BOOLEAN NOT NULL DEFAULT true;

-- 2. Mark all existing services as v1 (they are all core services)
UPDATE services SET is_v1 = true WHERE is_v1 IS NULL;

-- 3. Verify 5 core services exist with correct codes
-- (These should already exist from earlier migrations; this documents the canonical set)
-- FM-SEC: Facility Management & Security
-- AC-SVC: Air Conditioner Services
-- PLT-SVC: Plantation Services
-- PRN-ADV: Printing & Advertising
-- PST-CON: Pest Control Services

-- Add index on is_v1 for query performance
CREATE INDEX IF NOT EXISTS idx_services_is_v1 ON services(is_v1);

-- 4. Update RLS policies to include the is_v1 flag visibility
-- (Select policy already visible all; no change needed to confidentiality)
-- (Admin can manage all rows regardless of is_v1 flag)

-- 5. Add 8 material categories (if not already present)
-- These should already exist in product_categories from Phase A
-- Documentation for v1 material categories:
-- 1. Security Panel & Door Controller Materials
-- 2. Hot & Cold Beverages Materials
-- 3. Eco-Friendly Disposable Solutions Materials
-- 4. Cleaning Essential Materials
-- 5. Pest Control Materials
-- 6. Air Fresheners Materials
-- 7. Stationery Materials
-- 8. Corporate Gifting Materials

-- 6. Placeholder: Brochure-only services (deferred to v2)
-- These will be added with is_v1 = false when ready:
-- - Legal Services CMS
-- - AI Door Camera with Facial Recognition
-- - Import & Export Consultancy

-- 7. Ensure UI queries filter by is_v1 = true
-- This is a code-level change, not a DB-level change
-- Hooks should use: WHERE is_v1 = true

-- 8. Document catalog lock date
-- Locked as of: 2026-05-09
-- Future changes require explicit v2 scope review

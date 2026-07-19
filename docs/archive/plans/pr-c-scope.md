# PR-C — Billing & Contract Data Model

> Archived scoping plan.
> Kept for history.

**Status:** Scoping (do not start coding until open decisions are resolved)  
**Bundles:** Audit findings 11-1, 12-2, 12-3, and society_manager→site_supervisor RLS sweep  
**Depends on:** PR-A merged and DB-pushed (enum values must be live before RLS policies flip society_manager to site_supervisor)  
**Does NOT include:** GST engine (12-1 — separate milestone, pending client Q&A)

---

## Why these four are bundled

`sale_bills.client_id` currently points at `societies(id)`. To fix that FK we must introduce `buyer_accounts` first, then pivot `sale_bills.client_id` to `buyer_accounts(id)`. That same migration is also where we backfill the `society` account type — which is the prerequisite for doing anything meaningful with `contracts → service_requests`. And the `society_manager → site_supervisor` RLS sweep is cheapest to do at the same time as the `buyer_accounts` policies are being written, so it doesn't become a fourth standalone migration. The four move together or they thrash.

---

## Change 1 — `service_requests` gets deployment lifecycle columns (11-1)

### What PRD requires
`service_requests` rows of `type = 'deployment'` carry: `monthly_amount`, `start_date`, `end_date`, `notice_days`, `auto_renew_terms` (JSONB), `frozen_rates` (JSONB).

### What exists
A standalone `contracts` table (migration `20260210125115`) has these columns but references `societies(id)` directly and has no link to `service_requests`. Two billing hooks join it: `useSaleBills:65`, `useBuyerInvoices:90`.

### Migration shape
```sql
-- Add lifecycle columns to service_requests
ALTER TABLE service_requests
  ADD COLUMN IF NOT EXISTS monthly_amount      BIGINT,        -- paise
  ADD COLUMN IF NOT EXISTS start_date          DATE,
  ADD COLUMN IF NOT EXISTS end_date            DATE,
  ADD COLUMN IF NOT EXISTS notice_days         INTEGER DEFAULT 30,
  ADD COLUMN IF NOT EXISTS auto_renew_terms    JSONB,
  ADD COLUMN IF NOT EXISTS frozen_rates        JSONB;

-- Backfill: attempt to match contracts rows to service_requests rows.
-- Match key: contracts.society_id = service_requests.society_id
--   AND contracts.start_date = service_requests.created_at::DATE (approximate)
-- This is best-effort; unmatched contracts rows stay in contracts table as
-- historical record. Do NOT delete contracts until a manual audit confirms
-- all rows are covered.
UPDATE service_requests sr
SET
  monthly_amount   = c.contract_value,
  start_date       = c.start_date,
  end_date         = c.end_date,
  notice_days      = 30
FROM contracts c
WHERE sr.type = 'deployment'
  AND sr.society_id = c.society_id    -- assumes society_id exists on service_requests
  AND sr.monthly_amount IS NULL;      -- don't overwrite anything already set
```

### Failure modes
1. **No `society_id` on `service_requests`** — check before writing migration. If absent, the match key needs a different anchor (e.g., `buyer_account_id` after buyer_accounts is created, or manual mapping).
2. **Many-to-one**: one society may have multiple contracts rows (annual renewal) and multiple `service_requests` rows of type `deployment`. The UPDATE above could write the wrong contract's terms to the wrong request. **Recommended**: leave the backfill commented out and do it manually with a spreadsheet-assisted import after the PR lands, using the new admin UI to set `monthly_amount` per deployment.
3. **`contracts.status = 'renewed'`** — wrong value per PRD (§11.2 states `cancelled` not `renewed`). Fix the CHECK constraint on `contracts` too; or accept that `contracts` is deprecated and leave the constraint as historical record.
4. **`useSaleBills` and `useBuyerInvoices` join `contracts!contract_id`** — these hooks need to be updated AFTER the data is on `service_requests`, not before. Update the hooks in the same PR but only switch to using `service_requests` columns; keep the `contracts!contract_id` join alive until all billing data is migrated.

### Checklist
- [ ] Confirm `service_requests` has `society_id` column (check reference_schema.sql)
- [ ] Decide: automated backfill (risky) or manual post-migration data entry (safe)
- [ ] Add columns via migration
- [ ] Update `useSaleBills` to read `monthly_amount` from `service_requests` when `contract_id` is null
- [ ] Update `useBuyerInvoices` same
- [ ] Mark `contracts` as deprecated in schema comments (do not drop in this PR)

---

## Change 2 — `buyer_accounts` table + `sale_bills.client_id` pivot (12-2)

### What PRD requires
Three buyer types: `society`, `corporate`, `individual_resident`. One `buyer_accounts` table with `gstin` (nullable), `account_type` discriminator. `sale_bills.client_id` → `buyer_accounts(id)`.

### What exists
`sale_bills.client_id UUID NOT NULL REFERENCES societies(id)` — hardcoded to Society. No `buyer_accounts` table. No corporate or individual resident billing path.

### Migration shape
```sql
-- 1. Create buyer_accounts
CREATE TABLE IF NOT EXISTS public.buyer_accounts (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  account_type TEXT NOT NULL CHECK (account_type IN ('society', 'corporate', 'individual_resident')),
  display_name TEXT NOT NULL,
  gstin        TEXT,                                -- nullable; individual_resident typically null
  society_id   UUID REFERENCES societies(id),      -- set when account_type = 'society'
  -- corporate / individual fields TBD when those paths are built
  is_active    BOOLEAN NOT NULL DEFAULT true,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 2. Backfill: one buyer_accounts row per existing society
INSERT INTO public.buyer_accounts (id, account_type, display_name, society_id, created_at)
SELECT
  gen_random_uuid(),
  'society',
  s.society_name,
  s.id,
  now()
FROM public.societies s
ON CONFLICT DO NOTHING;

-- 3. Add new FK column to sale_bills (nullable during transition)
ALTER TABLE sale_bills
  ADD COLUMN IF NOT EXISTS buyer_account_id UUID REFERENCES buyer_accounts(id);

-- 4. Backfill sale_bills.buyer_account_id from the society mapping
UPDATE sale_bills sb
SET buyer_account_id = ba.id
FROM buyer_accounts ba
WHERE ba.society_id = sb.client_id
  AND ba.account_type = 'society';

-- 5. Make buyer_account_id NOT NULL once backfill is verified
-- ALTER TABLE sale_bills ALTER COLUMN buyer_account_id SET NOT NULL;
-- (Run step 5 manually after confirming zero NULLs in staging)

-- 6. Drop old FK (after step 5 and after hooks are updated)
-- ALTER TABLE sale_bills DROP COLUMN client_id;
-- (Run step 6 manually, after code is deployed and old column is unused)
```

### Failure modes
1. **Steps 5 and 6 are NOT in the automated migration** — they must be run manually after verifying zero NULLs and after the code deploy. Automating them risks leaving `sale_bills` with no client link if the backfill missed any rows.
2. **`useSaleBills` and `useBuyerInvoices` still JOIN `societies!client_id`** — update hooks to prefer `buyer_accounts!buyer_account_id` but fall back to `societies!client_id` during the transition window. Remove the fallback after step 6.
3. **RLS on `buyer_accounts`** — new table needs policies. At minimum: admin full access, buyer can see their own account (`buyer_account_id = auth.uid()` is wrong — need a mapping from auth user to buyer_account; design TBD).
4. **`sale_bills.status` naming** — while we're touching this table, fix `payment_status` missing `'written_off'` (PRD §13 finding 12-4). Add it to the CHECK constraint in the same migration.

### Checklist
- [ ] Create `buyer_accounts` table with RLS
- [ ] Backfill one `society` type row per existing society
- [ ] Add `buyer_account_id` to `sale_bills` (nullable)
- [ ] Backfill `sale_bills.buyer_account_id`
- [ ] Update `useSaleBills` + `useBuyerInvoices` hooks
- [ ] Fix `sale_bills.payment_status` CHECK to add `'written_off'`
- [ ] Run steps 5 and 6 manually post-verify
- [ ] Add `payment_method` and `payment_reference` columns to `sale_bills` if not present (PRD §13)

---

## Change 3 — `credit_notes` / `debit_notes` tables (12-3)

### What PRD requires
Admin-issued credit and debit notes adjusting previously-issued invoices. GST liability adjusted in period of issuance.

### Open decision — ship now or wait for GST engine?

**Option A — Ship now, undifferentiated tax:**
```sql
CREATE TABLE credit_notes (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sale_bill_id    UUID NOT NULL REFERENCES sale_bills(id),
  credit_note_number TEXT UNIQUE NOT NULL,
  reason          TEXT NOT NULL,
  amount          BIGINT NOT NULL,  -- paise, total reduction including tax
  tax_amount      BIGINT DEFAULT 0, -- undifferentiated, like sale_bills today
  issued_by       UUID REFERENCES auth.users(id),
  issued_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);
-- debit_notes mirrors this structure with debit_note_number
```
**Pro:** unblocks the SLA breach credit-note workflow immediately.  
**Con:** when GST engine (12-1) lands, `tax_amount` will need to split into `cgst_amount + sgst_amount` — same refactor that `sale_bills` will need. Two rounds of migration.

**Option B — Wait for GST engine answers:**
Defer credit_notes until client Q&A (GST brief) comes back. Build with the full CGST/SGST columns from day one. One migration instead of two.
**Pro:** no rework.  
**Con:** SLA breach credit notes must be tracked manually (spreadsheet) until GST engine lands (~2–3 weeks after client response).

**Recommendation:** Option A. SLA breach credit notes are operationally needed now. The `tax_amount` → `cgst_amount + sgst_amount` refactor is a column rename/split, not a structural change — it's a one-migration cleanup when 12-1 lands, not a major rework. The tables can ship now.

**⚠️ Decision needed before coding starts.** If Option B, remove credit_notes from this PR.

### Checklist (if Option A)
- [ ] Create `credit_notes` table with RLS (admin only for insert; admin + relevant buyer for select)
- [ ] Create `debit_notes` table (same shape as credit_notes)
- [ ] Add hook `useCreditNotes` (admin: create, list; buyer: list own)
- [ ] Add admin UI page at `app/(dashboard)/finance/credit-notes/page.tsx`
- [ ] Document that `tax_amount` is undifferentiated pending GST engine (PHASES.md)

---

## Change 4 — society_manager → site_supervisor RLS sweep

### What exists
`society_manager` appears in `has_role()` checks and `get_user_role() IN (...)` lists across these migrations:

| Migration | Occurrence count |
|---|---|
| `20260208175334_phase_a_final_patch.sql` | 4 policies |
| `20260210113624_phase_c_03_procurement_tables.sql` | 1 policy |
| `20260215064232_create_buyer_requests_table.sql` | 1 policy |
| `20260317000002_fix_critical_rls.sql` | 1 policy |
| `20260330000001_sec_001_guard_security_fixes.sql` | 4 policies |
| `20260401000010_pest_control_ppe_completion_gate.sql` | 2 (function body) |
| `20260401000011_patch_procurement_super_admin_policies.sql` | 1 policy |
| `20260406023000_hrms_payroll_employee_visibility.sql` | 1 (function body) |
| `20260425000000_harden_remaining_tables.sql` | 3 policies |
| `20260425010000_fix_guard_id_auth_chain.sql` | 1 (function body) |

### Migration shape
New migration uses `DROP POLICY IF EXISTS ... ; CREATE POLICY ...` pattern for each policy, adding `site_supervisor` alongside (not instead of) `society_manager`. The existing data migration (step 2 of this PR-C plan) will move all `society_manager` users to `site_supervisor`, so after that point `society_manager` checks are dead code — but keeping them in the policy is harmless and avoids a hard failure if any row slips through.

For function bodies (plpgsql), use `CREATE OR REPLACE FUNCTION` to add `site_supervisor` to the IN-list.

```sql
-- Pattern for each policy replacement:
DROP POLICY IF EXISTS "<policy name>" ON <table>;
CREATE POLICY "<policy name>"
  ON <table> FOR <operation>
  TO authenticated
  USING (get_user_role() IN ('admin', 'super_admin', 'site_supervisor', 'society_manager'));
  --                                                   ^^^^^^^^^^^^^^^^^
  --                                                   Added; society_manager kept as dead-code safety net
```

### Checklist
- [ ] Enumerate all 18 occurrences (grep `society_manager` in migrations)
- [ ] For each: `DROP POLICY IF EXISTS` + recreate with `site_supervisor` added
- [ ] For function bodies: `CREATE OR REPLACE FUNCTION` with updated IN-list
- [ ] Update `app/api/` routes: `SOCIETY_ADMIN_ROLES` sets in `residents/unlinked`, `admin/societies`, `admin/societies/[id]`, `admin/societies/[id]/buildings/[buildingId]`, `admin/societies/import`
- [ ] Update `hooks/useVisitors.ts:51` and `hooks/useAttendance.ts:530` (society_manager checks)
- [ ] Data migration: `UPDATE users SET role = 'site_supervisor' WHERE role = 'society_manager'`

---

## Migration ordering within PR-C

All four changes go in a single PR but across multiple numbered migration files (same timestamp-prefix, sequential suffix):

```
20260509000010_prc_buyer_accounts.sql          — Change 2: create buyer_accounts, backfill
20260509000011_prc_sale_bills_pivot.sql        — Change 2: add buyer_account_id to sale_bills
20260509000012_prc_service_requests_lifecycle.sql  — Change 1: add lifecycle cols to service_requests
20260509000013_prc_credit_debit_notes.sql      — Change 3: credit_notes + debit_notes (if Option A)
20260509000014_prc_society_manager_rls_sweep.sql   — Change 4: RLS + function body updates
20260509000015_prc_society_manager_data_migration.sql — Change 4: UPDATE users to site_supervisor
```

`buyer_accounts` must precede `sale_bills` pivot. Service_requests lifecycle can go in parallel with buyer_accounts but after it (depends on no shared columns). RLS sweep must come before data migration so the policies accept `site_supervisor` before the first user gets that role.

---

## Pre-coding checklist

- [ ] **Resolve credit_notes decision (Option A vs B)** — confirm before building Change 3
- [ ] **Confirm `service_requests` has `society_id` column** — needed for Change 1 backfill
- [ ] **Confirm backfill strategy for contracts → service_requests** — automated or manual data entry
- [ ] **Staging test plan**: apply all 6 migrations to a copy of prod data, verify zero NULL `buyer_account_id` before running steps 5+6 manually
- [ ] **`useSaleBills` + `useBuyerInvoices` transition plan**: both hooks must handle both old (`societies!client_id`) and new (`buyer_accounts!buyer_account_id`) joins during the cutover window

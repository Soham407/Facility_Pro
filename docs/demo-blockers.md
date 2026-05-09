# FacilityPro — Demo Blockers

> Live items that must be addressed before the demo can run cleanly.
> Status as of 2026-05-09, post-PR-A/B/C audit and corrective migrations 11/12.

---

## Open

### B-1 — Seed `buyer_accounts.auth_user_id` for demo buyer users

Migration 11 added the `auth_user_id` column. The backfill from existing
`societies` rows (in migration 5) populated `society_id` and `display_name`
but **left `auth_user_id` NULL**. Without seeding it, every buyer user
logging in sees zero rows in their dashboard.

**One-time backfill SQL** (run after seeding auth users with the buyer role):

```sql
-- Pick the earliest buyer auth user per society and stamp it onto the row.
-- Adjust raw_user_meta_data key names to match your auth seed script.
UPDATE buyer_accounts ba
SET auth_user_id = (
  SELECT u.id
  FROM auth.users u
  WHERE u.raw_user_meta_data ->> 'role' = 'buyer'
    AND u.raw_user_meta_data ->> 'society_id' = ba.society_id::text
  ORDER BY u.created_at ASC
  LIMIT 1
)
WHERE ba.auth_user_id IS NULL
  AND ba.account_type = 'society';
```

If your seed script doesn't put `role`/`society_id` in `raw_user_meta_data`,
either:
- Hard-code the auth_user_id per buyer account in the seed script directly, or
- Join through whatever existing chain your seed uses (e.g.
  `users.email` → `auth.users.email`).

**Verify:** Log in as a seeded buyer, confirm `/buyer/dashboard`, sale bills
list, and credit/debit notes show data.

---

### B-2 — Apply migrations against a fresh local DB and watch for errors

`supabase db reset && supabase db push`. Specifically watch for:

- Migration `20260509000003_pr_a_role_data_migration` — UPDATEs depend on the
  enum values `delivery_agent` / `field_technician` already existing (added
  by migration `_002`). Should pass.
- Migration `20260509000009_prc_society_manager_rls_sweep` — three CREATE
  POLICY statements referenced non-existent columns on `buyers`. **Migration
  12 corrects these via DROP+CREATE.** If migration 9 errored on first push,
  re-run the suite — migration 12 idempotently fixes the state.
- Migration `20260509000010_prc_society_manager_data_migration` — `UPDATE
  users SET role = 'site_supervisor' WHERE role = 'society_manager'`. The
  `site_supervisor` value already exists in the `user_role` enum (added by
  `20260322000003_add_extended_app_roles.sql:7`). Should pass.
- Migration 11 (`fix_buyer_rls_and_payment_constraint`) and migration 12
  (`fix_remaining_pr_c_issues`) — final corrective layer.

---

### B-3 — Smoke-walk all 6 roles per DEMO-CHECKLIST.md

The DEMO-CHECKLIST is a *plan*, not a *verification record*. Walk each role's
primary flow with seed data, capture findings here as B-4, B-5, B-6...

Highest-risk surfaces:

- **Buyer dashboard** — depends entirely on B-1 backfill. If buyer sees empty
  data, B-1 wasn't applied correctly.
- **`sale_bills.client_id` legacy reads** — any hook still using `client_id`
  to scope bills will work for societies but will silently exclude any future
  corporate / individual_resident sale bill (per A-4).
- **`payment_status` displays** — should now accept `written_off`. Verify
  admin can mark a bill as written off and the badge renders.
- **Visitor flow** — migration 12's RLS rewrite changed who can SELECT
  visitors. Confirm guard, supervisor, buyer, and resident all still see
  their expected slice.

---

### B-4 — Verify the existing seed scripts cover buyer_accounts.auth_user_id

The DEMO-CHECKLIST credentials are placeholder formats; the real seed lives in:

- `scripts/provision-role-test-users.cjs` — creates auth users per role
- `scripts/seed-demo.ts` — populates demo domain data
- `scripts/seed-client-data.ts` — client-specific data
- `scripts/provision-feature-fixtures.cjs` — feature fixtures

**Action:** Read `provision-role-test-users.cjs` and confirm it sets
`buyer_accounts.auth_user_id` after creating the buyer auth user. If it
doesn't (likely — this column is from migration 11), add a step that does
the B-1 backfill SQL inline, OR run B-1 manually after the script.

**Verify:** After running the full seed sequence, query:

```sql
SELECT account_type, display_name, auth_user_id
FROM buyer_accounts
WHERE auth_user_id IS NULL;
```

Should return zero rows for any buyer account that needs to log in for the demo.

---

## Resolved

(none yet — track here as items move from Open → Resolved)

---

## Out-of-scope for demo

See `docs/assumptions.md` A-3 through A-10 for items deliberately deferred
by reasonable default. Those are not blockers; they're conscious "ship demo,
clean up later" decisions.

# FacilityPro — Demo-Path Assumptions

> Decisions made during the demo-prep audit (2026-05-09) where a question
> would have gone to the client but was resolved by reasonable default.
> Every entry here is a candidate for client conversation post-demo.

---

## A-1 — PR-B brochure items: locked by absence, not by flag

**Decision:** PR-B added `services.is_v1` and `useServices` filters
`.eq("is_v1", true)`, but no INSERT for brochure items (Legal CMS, AI Door
Camera, Import/Export) exists in any migration. The catalog is locked by
*absence* of the v2 rows, not by *presence with flag false*.

**Implication for demo:** Service dropdowns show only the 5 v1 services. Correct.

**Post-demo question:** Does the client maintain brochure items in any non-DB
source (spreadsheets, brochure PDFs) that need importing? If yes, insert with
`is_v1 = false` then.

---

## A-2 — Buyer → buyer_account mapping is 1:1 for demo

**Decision:** `buyer_accounts.auth_user_id` is a single-column FK; one buyer
account = one auth user. For a society with multiple buyer admin users, only
the earliest-created admin is stamped on the account row.

**Implication for demo:** Demo societies must have exactly one buyer login per
society. If multiple admins exist, only the first sees data.

**Post-demo question:** Add a `buyer_account_users` join table for true 1:N
mapping (~30–60 min migration + RLS rewrite). Required when corporate
accounts with multiple ops contacts onboard.

---

## A-3 — payment_status keeps 'unpaid' / 'partial' (not PRD-canonical names)

**Decision:** Migration 12 added `'written_off'` to the CHECK constraint but
kept `'unpaid'` and `'partial'` rather than renaming to PRD §13's `'pending'`
and `'partially_paid'`.

**Implication for demo:** Status badges still read "Unpaid" / "Partial".
Functional behavior is identical to PRD spec.

**Post-demo question:** Pure-rename PR sweeping every UI string, status badge,
and hook reference. Low-risk, mechanical, ~half a day.

---

## A-4 — sale_bills.client_id pivot held at "phase 1"

**Decision:** Migration 6 added `sale_bills.buyer_account_id` (nullable,
backfilled from society mapping). The original `sale_bills.client_id` (FK to
societies) still exists and is the source of truth for any legacy code path
that hasn't been migrated. Migration 6's own comments call out steps 5/6
("set NOT NULL, drop client_id") as deferred manual operations.

**Implication for demo:** Both columns coexist. New RLS policies use
`buyer_account_id`. Existing reads using `client_id` still work.

**Post-demo question:** Sweep `useSaleBills`, `useBuyerInvoices`, every join
site, then drop `client_id`. Required before corporate / individual_resident
billing paths can ship.

---

## A-5 — attendance_logs buyer-branch RLS is permissive

**Decision:** Migration 12 rewrites the buyer branch as "any user with a
buyer_account row can read attendance_logs", not scoped to that buyer's own
society.

**Why:** `attendance_logs` has no `society_id` column. Scoping requires
either adding one or joining through `employees`/`employee_postings`. Out of
demo scope.

**Implication for demo:** A buyer logging in sees attendance across all
societies. Acceptable for single-tenant single-buyer demo; not acceptable
for production multi-buyer.

**Post-demo question:** Add society scoping. Likely via
`employee_postings.society_id`.

---

## A-6 — Data retention archival deferred to v2

**Decision:** PRD §20.1 retention windows (financial 7y, employee lifetime,
visitor 1y/3y, panic 3y, notifications 90d) are documented but not enforced
via cron / triggers.

**Why:** Single-tenant system in early stage. No data has aged into a
retention window. Manual or v2 archival is acceptable.

**Post-demo question:** Schedule pg_cron archival jobs when the oldest data
approaches its retention threshold.

---

## A-7 — Family Directory + Visitor Pass automation are placeholders

**Decision:** These UIs render "Coming soon". Resident Directory works;
standard Visitor Pass UI works. Auto-generation of family relationships and
printable visitor passes is deferred.

**Implication for demo:** Don't navigate to those tabs during the demo
walk-through.

**Post-demo question:** Are either of these on the v1 path or v2? Family
Directory in particular may have been mis-scoped.

---

## A-8 — Audit log structure not formally verified

**Decision:** Audit logs exist in the schema but no migration was opened
during the audit to verify the column set matches PRD §20.2 spec
(`actor_id, action, entity_type, entity_id, timestamp, ip_address`).

**Why:** Verification deferred. Likely present.

**Post-demo question:** Confirm column set; add anything missing.

---

## A-9 — Migration 9 (society_manager RLS sweep) shipped with broken predicates

**Decision:** Migration 12 corrects three buyer-branch OR clauses in
migration 9 that referenced `buyers.auth_user_id` and `buyers.society_id`
(neither column exists on the `buyers` table per `docs/reference_schema.sql:540`).

**Implication:** If migration 9 was already applied to any environment, those
three CREATE POLICY statements would have errored. If it wasn't applied yet,
migration 12's idempotent DROP+CREATE handles either path.

**Post-demo question:** Sweep migration 9 of any other policies that depend
on schema assumptions made by Haiku 4.5 during PR-C generation. Most likely
already covered by migration 12's three rewrites, but worth a final read.

---

## A-10 — PHASES.md not updated as part of PR-C / migration-12

**Decision:** The "task complete → flip module status" step was skipped.

**Why:** Status churn isn't blocking demo. Updating it touches a file used by
many other workflows; better to do once, after demo.

**Post-demo task:** Walk PHASES.md against actual built state and fix
🔵/🟡/🔴 entries that have moved.

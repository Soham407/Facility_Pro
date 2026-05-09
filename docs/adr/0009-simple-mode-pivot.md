# 0009 — Simple-Mode Pivot (Supersedes 0001, 0002, 0004, 0005, 0006)

- **Status:** Partially Superseded by ADR-0010 (2026-05-09)
- **Date:** 2026-05-09
- **Supersedes:** 0001 (three-entity sales), 0004 (attendance-driven billing), 0005 (multi-membership identity), 0006 (two reconciliation engines)
- **Partially supersedes:** 0002 (site-kiosk concept dropped; hybrid staffing model restored by ADR-0010)

> **Sections that STILL STAND (ground truth):**
> - §3 — Identity: one role per user. No memberships table.
> - §4 — Recurring billing: fixed monthly. No attendance-driven billing engine.
> - §5 — Reconciliation: one engine, materials only (PO ↔ GRN ↔ Supplier Bill).
> - §6 — Buyer is a role, not a capability.
> - §7 — Service catalog locked to 5 services + 8 material categories.
>
> **Sections OVERRIDDEN by ADR-0010:**
> - §2 — Personnel: "all are direct Company employees" is wrong for security and soft-services lines. Hybrid staffing model from ADR-0002 is restored. SPO / Service Delivery Note / Personnel Dispatched flow is live and correct for sub-contracted services.
> - §1 — Sales model: the `service_requests.type` discriminator extension (`deployment | material_order | ticket`) still applies, but the deployment flow for sub-contracted services routes through SPO, not a simple `deployment_assignments` table.

## Context

After more grilling and a re-read of the original client scope (PDF source), it became clear that:

1. The original scope is internally contradictory. Page 8 (HRMS) treats guards as Company employees with selfie + geofence + payroll + PSARA. Page 9 (Supplier Workflow) treats guards as supplier-provided with SPO + Service Delivery Note. Both cannot be true.
2. Earlier ADRs tried to honor *both* narratives via hybrid staffing, site kiosks, multi-membership identity, three sales entities, and dual reconciliation engines. This added correctness but cost simplicity.
3. The team building this is a 5-admin Company on a fixed budget with an existing codebase (102 hooks, single-tenant). The cost of complexity is more than the value of correctness for the rare cross-cutting case.
4. The user explicitly chose **"the simplest and easy to use answer."**

This ADR collapses the architecture to the simplest viable shape.

## Decisions (the simple-mode positions)

### 1. Sales model: ONE entity (`service_requests`) with a `type` discriminator
The codebase already has `service_requests.type` with values `service_request | ticket`. Extend it (e.g. `deployment | material_order | ticket`) rather than splitting into three tables.

**Trade-off:** conditional logic by `type` in UI / billing / status. Acceptable cost for keeping the existing 102 hooks intact.

### 2. Personnel: all are direct Company employees
Drop the supplier-as-manpower-source narrative entirely.

- Suppliers supply **materials only**.
- All deployed personnel (guards, technicians, housekeeping, plantation, pantry, office boys) are Company employees on the HRMS.
- HRMS handles selfie clock-in, geofence, payroll, leave, PSARA, BGV, document expiry — exactly as the scope's HRMS section describes.
- The "Service Indent → SPO → Personnel Dispatched → Service Delivery Note" flow from page 9 of the scope is **dropped**. Replaced by an internal "deployment assignment" — admin assigns existing employees to a customer site for a contract.

**Trade-off:** at scale, this Company will likely need to subcontract guards. v2 problem. v1 keeps it simple.

### 3. Identity: one role per user
Reverts to the existing `users.role` single-string model. No `memberships` table. No context-switcher UI.

- Cleaned-up role list still applies (rename `service_boy` → `field_technician`, `delivery_boy` → `delivery_agent`, merge `vendor` into `supplier`).
- Remove `security_guard` and `security_supervisor` only if the team confirms guards are direct-employed and *not* "guards as portal users." If guards are direct-employed Company employees who use the guard mobile app at a posting, keep `security_guard` and `security_supervisor` as person-roles tied to specific employees.

**Trade-off:** a person who is genuinely both an employee and a resident in a serviced society has two accounts. Rare; acceptable.

### 4. Recurring billing: fixed monthly
A `service_contract` (or contract-shaped service request) bills a fixed `monthly_amount` per period.

- First period is **prorated** by days (e.g. contract starts 12 May → first invoice = 20/31 × monthly_amount).
- No attendance-driven billing engine. No daily roll-up cron. No supplier-side bill matching for services.
- Attendance is still tracked via HRMS (selfie + geofence + shift logs) for **operational and SLA visibility**, not for billing.
- If a major SLA breach occurs (e.g. supplier failed to staff for a week), admin issues a **manual credit note** on the next invoice.

**Trade-off:** customers who expect "I only pay for days the guard was actually present" won't get auto-discounts. The Company manages those conversations manually with credit notes. This matches how most early-stage facility services agencies actually run.

### 5. Reconciliation: ONE engine, materials only
Standard 3-way matching: **PO ↔ GRN ↔ Supplier Bill**. Surfaces in admin's reconciliation dashboard.

- Service contracts are NOT reconciled — they have a fixed monthly amount. The supplier bill (when applicable) and customer sale bill are independent of attendance.
- This drops the entire "service reconciliation engine" that ADR-0006 introduced.

### 6. Buyer is a role (not a capability)
Reverts to the scope's stakeholder list.

- A society IS a Buyer (Customer Account of type `society`).
- A corporate IS a Buyer (Customer Account of type `corporate`).
- An individual resident wanting to order things personally creates their own Buyer account (Customer Account of type `individual_resident`).
- The "Buyer Portal" stays as a top-level surface. Residents inside a society do not place orders directly against the company — they place requests *to their society* (their society then places the actual order). For v1, this can be modeled as: residents have view-only access to their society's order history; ordering surface is shown only to society Buyer admins.

**Trade-off:** residents wanting to place a personal paper-cup order go through the awkward step of being onboarded as their own Buyer account. Acceptable for v1.

### 7. Service catalog: scope's 5 services + 8 material categories only
Drop brochure additions (Legal Services CMS, Door Security Camera AI, Import/Export consultancy) from v1.

**Locked v1 catalog:**

Services (5):
1. Facility Management & Security (with Grade A/B/C/D, Gunman, Door Keeper, Housekeeping, Pantry, Office Boys as sub-roles)
2. Air Conditioner Services (install + maintenance + repair)
3. Plantation Services
4. Printing & Advertising Services (visitor passes, ID cards, notices, ad-space booking)
5. Pest Control Services

Material categories (8) sold via material orders:
1. Security Panel & Door Controller Materials
2. Hot & Cold Beverages Materials
3. Eco-Friendly Disposable Solutions Materials (paper cups)
4. Cleaning Essential Materials
5. Pest Control Materials
6. Air Fresheners Materials
7. Stationery Materials
8. Corporate Gifting Materials

Brochure-only items (Legal Services CMS, AI Door Camera, Import/Export) are **deferred** to a possible v2 — flagged in the PRD as "future" but not built.

## What stays from earlier decisions

These remain as-is, untouched by this pivot:

- **Single-tenant** — only Solvesxx, Maharashtra, GSTIN 27ABSCS5790H1ZJ.
- **Hybrid customer onboarding** — admin-provisioned societies/corporates, self-serve residents within an onboarded society.
- **Per-contract frozen rates** — catalog default copied into contract at creation; subsequent catalog changes don't affect existing contracts.
- **Mobile = time-critical filter (ADR-0003)** — mobile app covers immediate-action features only.
- **3-tier notifications** — `critical` (push + SMS + in-app), `high` (push + in-app), `normal` (in-app), with quiet hours 22:00–07:00.
- **Compliance & document expiry escalation** — D-90 / D-30 / D-7 / D+1 (block).
- **Record-only payments (ADR-0007)** — no payment gateway in v1.
- **GST engine (ADR-0008)** — regulatory; can't skip.
- **Visitor types + tenancy lifecycle** — 5 visitor types, `flat_occupancies` lifecycle, portal binds to active occupancy.
- **Cancellation / termination / renewal** — 30-day notice default; renewal = new contract; auto-renew opt-in default off.

## Consequences

**Good**
- Saves an estimated **3–6 months of refactor work**: no entity split, no membership table, no kiosk migration, no attendance-billing pipeline, no second reconciliation engine.
- Existing 102 hooks stay intact.
- The PRD becomes shorter and easier for the 5-admin team to validate.

**Bad / costly**
- The system carries the original scope's contradictions where they're load-bearing (e.g. guards-as-employees with a Sale Bill flow that pretends suppliers staff the deployment). These will be refactored or clarified case-by-case as features are built.
- Customers expecting attendance-discounted invoices will need manual credit-note conversations.
- v2 will likely need to revisit subcontracted manpower as the Company scales beyond what 5 founders can directly employ.

## Open follow-ups

- Confirm with client which of the brochure-only services are real revenue today (the catalog deferral assumes none of Legal CMS / AI Camera / Import-Export need v1 build, which may be wrong).
- Confirm with client whether `Pantry`, `Office Boys`, `Gunman`, `Door Keeper` are real offerings or aspirational. The simple model treats them as employee designations under Facility Management & Security — if some are not offered, hide them from UI but keep the scaffolding.
- Decide v2 trigger: at what scale (number of guards deployed, number of customer sites) does subcontracting become necessary?

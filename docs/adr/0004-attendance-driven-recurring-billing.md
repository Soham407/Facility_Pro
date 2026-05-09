# 0004 — Attendance-Driven Recurring Billing for Service Contracts

- **Status:** **SUPERSEDED by ADR-0009** (replaced with fixed monthly billing for simplicity)
- **Date:** 2026-05-09
- **Related:** [0001](./0001-three-entity-sales-model.md), [0002](./0002-hybrid-staffing-and-site-kiosks.md)

## Context

The original PRD describes only per-request billing (Sale Bill is generated, customer pays, done). It is silent on how a long-running `service_contract` (e.g. "4 Grade-A guards, 6 months") actually bills over its lifetime. Without a recurring billing model, the contract has no meter — it just sits there.

The Indian facility services market default is **attendance-driven monthly billing**: customers pay only for days actually staffed. This aligns the Company's revenue, supplier costs, and customer expectations on a single shared meter — the attendance log.

## Decision

### 1. Billing cycle
- Period: **calendar month**, 1st → last day of month.
- Frequency: monthly.
- First cycle: **prorated** from contract start date to end of that month. Subsequent cycles are full calendar months.

### 2. Amount computation
- For each day in the period and each personnel slot in the contract's deployment roster, count it as a billable day if attendance is recorded:
  - **Direct staff:** `attendance_records` row with shift completion.
  - **Sub-contracted staff:** `personnel_dispatches` shift-log row from the site kiosk.
- Sum billable days per service line × per-day sale rate.
- Subtract any contracted credits (e.g. SLA breach refunds — design pending).

### 3. Invoice line presentation
- **One line per service line per month** on the customer's sale bill (e.g. "Security services — Grade A guards — May 2026: ₹X").
- Underlying attendance breakdown attached as a downloadable PDF / CSV (per-day, per-person).
- Supports finance teams that reconcile against POs (clean line) and auditors that need the underlying log (attachment).

### 4. Minimum-bill floor
If the supplier failed to deliver contracted headcount on a given day, the customer **still pays the contracted minimum** for that day. The Company recovers shortfall from the supplier via a short-supply penalty (mechanics in a separate ADR — TBD).

### 5. Symmetric supplier-side billing
The supplier's bill to the Company uses the same daily attendance roll-up, but priced at the supplier's per-day rate. This makes the reconciliation engine trivial — it joins customer billing lines and supplier billing lines on `(contract_id, period, day)` and surfaces deltas.

## Alternatives Considered

| Option | Why rejected |
|---|---|
| **Fixed monthly** | Customer pays full rate even when attendance falls short. Strains customer trust; not how the Indian market works. |
| **Per-shift** | Right granularity, but billing per shift rather than rolling up to a month creates 60+ invoice lines per contract per month. Customers want a clean monthly invoice. |
| **Lump-sum installments** | Hides the meter — works for fixed-scope project work, not for ongoing manpower contracts where the customer expects accountability for actual presence. |
| **Hybrid (fixed + OT)** | Defensible, but adds complexity (two rate dimensions, OT thresholds, capping rules). Default to the simpler attendance-driven model; revisit if customers ask. |

## Consequences

**Good**
- Attendance system becomes load-bearing — gives clear engineering stakes for kiosk reliability, GPS validation, and selfie verification.
- Reconciliation engine becomes a join, not a bespoke matching algorithm.
- Customer invoices are clean, auditable, and defensible.

**Bad / costly**
- The cron infrastructure to roll up attendance into `billing_period_lines` is not yet built. Needs scheduling, idempotency, late-attendance handling, edit-after-billing semantics.
- Edits to attendance after a bill is generated need an "adjustment" mechanism (credit note for next cycle).
- Mid-month contract changes (headcount up/down, role swap) need to be reflected in the meter — design work pending.

## Open follow-ups

- Short-supply / SLA penalty mechanics (the supplier-side equivalent of credit notes).
- Late-attendance corrections after bill generation: do we re-issue the bill, or apply a credit on next cycle?
- Mid-month contract amendments (add/remove headcount, change rate): how does the meter handle the boundary day?
- Holiday / public-holiday rate multipliers — does the per-day rate vary on holidays?

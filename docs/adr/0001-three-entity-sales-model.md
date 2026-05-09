# 0001 — Three-Entity Sales Model

- **Status:** **SUPERSEDED by ADR-0009** (rolled back to single-table model for simplicity)
- **Date:** 2026-05-09
- **Deciders:** Product owner (client) + engineering

## Context

FacilityPro is the operations platform for a single facility services agency. The agency sells three structurally different things to its customers:

1. **Long-running deployments** — e.g. "4 Grade-A guards, 12-hour shifts, 6-month contract." Lifecycle is months to years; billing is recurring; the deployed personnel roster changes over time; attendance is tracked daily.
2. **One-shot material orders** — e.g. "100 paper cups delivered to flat 304." Lifecycle is hours to days; one PO; one GRN; one sale invoice.
3. **Operational tickets / complaints** — e.g. "AC not cooling in flat 304." Lifecycle is hours; a technician visits; a job session is recorded with before/after photos. May or may not bill, depending on whether an active service contract covers the customer.

The original PRD (and the current codebase) treats all three as a single entity called `service_requests`, distinguished only by a late-added `type` column (`service_request | ticket`). Migration `20260430000000_buyer_ticket_and_cancel_actions.sql` is evidence of the team patching this ambiguity halfway: it splits tickets out, but deployments and material orders are still smushed into one flow.

The unified status flow in the PRD — `Order Request → accepted → po_received → po_dispatched → invoice_generated → paid → feedback_pending → completed` — fits material orders and partially fits deployments, but is meaningless for tickets (no PO, no GRN).

## Decision

Model sales as **three first-class entities**:

- `service_contracts` — long-running deployments with recurring billing. Has child rows for personnel deployment, monthly billing cycles, and renewal lifecycle.
- `material_orders` — one-shot procurement-style orders. Drives PO → GRN → single sale invoice.
- `service_tickets` — operational tickets / complaints. May reference an active `service_contract` via `contract_id`; if so, the ticket is included (no separate customer charge). Otherwise, it can generate its own one-time sale invoice.

A read-side **Activity Feed** projection merges all three into one chronological stream for the resident / society / corporate portal surface, so the user does not have to think about which underlying entity they are looking at.

## Alternatives Considered

| Option | Why rejected |
|---|---|
| **A. One unified `service_requests` table with a discriminator column** | Status quo. The conditional logic for "what does `po_dispatched` mean for a ticket?" leaks into UI, billing, reconciliation, and reporting. Source of every mock and gap currently flagged in `PHASES.md`. |
| **C. Two tables — contracts + orders, with tickets folded into orders as zero-line items** | Cleaner than A, but forces tickets to carry order-shaped fields (PO number, GRN, line items) that are meaningless for them. Also forces contract-covered tickets into a "free order" pattern that is confusing in UI and reporting. |

## Consequences

**Good**
- Each entity gets its own status enum, lifecycle, and billing engine — no conditional logic by `type`.
- Subscription billing (monthly recurring on contracts) is cleanly separated from one-off invoicing (per material order).
- "Personnel deployment" becomes a child of `service_contracts`, not a status of `service_requests` — solves the open question of how rosters are tracked over time.
- A ticket raised against an active contract auto-shows as "covered under your contract — no charge," which is real value the agency can show to customers.
- The language matches what the agency owner actually says ("we have 6 active contracts," "we got a ticket from Wing B").

**Bad / costly**
- 102 hooks and many UI screens currently key off `service_requests`. Migration is incremental, not big-bang. Expect a transitional period where `service_requests` is being decomposed.
- Three tables, three sets of RLS policies, three sets of realtime subscriptions.
- Reporting / dashboard queries that joined "all sales" need to UNION the three.

**Open follow-ups (to be resolved in subsequent PRD grilling sessions)**
- Personnel deployment model: are guards / housekeepers Company employees, or sub-contracted via Suppliers? Currently the PRD contradicts itself.
- Recurring billing cycle: monthly fixed, or monthly attendance-driven?
- Approval flow for resident-placed orders billed to society.

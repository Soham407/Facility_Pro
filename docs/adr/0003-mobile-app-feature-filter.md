# 0003 — Mobile App Feature Filter (Time-Critical Action Rule)

- **Status:** Accepted
- **Date:** 2026-05-09

## Context

The product ships two client codebases against the same Supabase backend:

- **Web** — this Next.js App Router codebase. Source of truth for the full feature set.
- **Mobile** — a *separate* React Native codebase. Already built, covers some roles, not all.

Client request: *"Almost all roles should have the mobile app, especially for emergencies and features that need immediate action."* The literal "all roles" framing is a trap — a finance reconciliation screen on a 6-inch phone is unusable, and shipping it doubles maintenance with zero user value. The intent inside the literal request is the right rule:

> Mobile is for time-critical actions, not for being a role's full home.

## Decision

### 1. Feature filter (binding)

A feature is included in the mobile app **if and only if** it requires immediate action from the user. Every other feature is web-only.

Examples that pass the filter:
- Panic alert (raise + acknowledge)
- Visitor approval (resident receives push, taps approve/deny)
- New ticket assigned to a field technician (push + accept)
- New indent received by a supplier (push + accept/reject)
- Daily checklist (mobile-only — guards/kiosks don't have desks)
- GPS clock-in (selfie + geofence — only meaningful on mobile)
- Material arrival logging (delivery boy at the gate)

Examples that fail the filter (web-only):
- Dashboards, reports, analytics
- Master data CRUD (employees, products, suppliers, services)
- Reconciliation, financial closure
- Multi-line GRN entry
- Configuration / settings
- Bill review / invoice review (not time-critical from a phone)

### 2. Feature surface tagging

Every feature in the PRD must be tagged exactly one of:

- `web-only` — default; lives in this Next.js codebase only.
- `mobile-only` — rare; feature has no desk equivalent (e.g. selfie clock-in).
- `both` — feature meets the time-critical rule *and* also has a desk use (e.g. panic alert acknowledge, which an admin might do from desk or phone).

`both` features have double cost. Default to `web-only` unless the time-critical rule applies.

### 3. The two codebases are kept in sync via the API contract, not via shared UI code

Because mobile is RN (not a Capacitor wrapper), there is no UI sharing. Sync happens at the Supabase schema + RLS layer. Both codebases consume the same tables, same RPCs, same edge functions. The PRD is the contract that makes both apps describe the same product.

## Alternatives Considered

| Option | Why rejected |
|---|---|
| **A. Replace RN with a Capacitor wrapper around the web app** | Tempting (90% code reuse). But the RN app already exists and works. Throwing it away to save future work is not affordable for a 5-admin Company. Revisit only if maintenance pain crosses a threshold. |
| **B. Ship every role as a full mobile app** | Doubles cost for every feature. Most office-bound roles will never use the phone version. Client's literal ask, but not their intent. |
| **C. Mobile-first / PWA-only** | Discards the existing RN app and removes app-store distribution, which the client values for "feeling real" to non-technical users. |

## Consequences

**Good**
- Mobile codebase scope is bounded by a clear rule. Refusing a feature on mobile has a documented justification.
- Web stays the canonical feature surface — keeps the PRD's structural decisions (the three sales entities, hybrid staffing, Customer Account model) coherent without a second model leaking from mobile.
- Push notifications get used for what they were designed for (immediate action), not as a "we have an app, it should ping" gimmick.

**Bad / costly**
- Every `both` feature has double implementation. Engineering must be vigilant about not letting `both` creep.
- The mobile codebase needs its own RLS-compatible auth handling, its own React Query / state layer, its own type definitions. None of the 102 web hooks port over.
- The PRD now must include a feature surface tag for every requirement — meaningful documentation work upfront, but pays back forever after.

## Existing RN app inventory

Located at `../Solvesxx_mobile/` (sibling to this repo). Current role surfaces present as `src/screens/<role>/`:

`auth`, `onboarding`, `app` (shared), `resident`, `hrms`, `supplier`, `service`, `guard`, `societyManager`, `buyer`, `oversight`.

This is **broader than the time-critical rule warrants**. The supplier and buyer surfaces in particular probably violate the filter — most supplier/buyer interaction (PO review, bill upload, invoice payment) is desk work. Only the time-critical *slices* belong on mobile:

- `supplier` mobile → only "indent inbox" (accept/reject incoming indent), nothing else.
- `buyer` mobile → only "approve order awaiting buyer confirmation" + "incoming notification feed", nothing else.
- `guard` mobile → re-frame as **site kiosk** per ADR 0002.
- `societyManager` mobile → only panic alert ack + visitor stats glance, no master-data CRUD.
- `oversight` mobile → only critical-priority notifications, no analytics/reports.

The PRD's mobile feature list should therefore be **smaller than the current RN app**, not larger. Trimming the existing mobile codebase is part of the migration plan.

## Open follow-ups

- Audit the existing RN app screen-by-screen against the time-critical filter; produce a deletion / migration list.
- The visitor management push-notification flow on iOS — verify FCM works end-to-end through the RN app, since this is the keystone resident-facing feature.
- Confirm with client that we will **trim** the mobile app (remove non-time-critical features) rather than expand it. The "almost all roles" framing risks growth in the wrong direction.

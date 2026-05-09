# 0002 — Hybrid Staffing Model + Site Kiosk Logins

- **Status:** **Accepted — Partially restored by ADR-0010** (hybrid staffing model stands; site-kiosk login concept remains dropped in favour of person-logins for sub-contracted personnel)
- **Date:** 2026-05-09
- **Supersedes:** None
- **Related:** [0001](./0001-three-entity-sales-model.md), [0009](./0009-simple-mode-pivot.md), [0010](./0010-hybrid-staffing-path-b.md)

> **What stands from this ADR:**
> - §1 — Hybrid staffing, declared per service line (`staffing_model: direct | subcontracted`).
> - §3 — Role list: `security_guard` and `security_supervisor` are kept as person-roles but with the understanding they represent sub-contracted personnel using personal logins (pragmatic v1 compromise — see ADR-0010).
>
> **What does NOT stand (still dropped):**
> - §2 — Site kiosk logins. Guards use personal logins in v1. The kiosk concept is deferred to v2.

## Context

The original PRD treated all deployed personnel — guards, AC technicians, pest control technicians, housekeeping — as a single category. It simultaneously described two contradictory mechanisms:

- **Personnel as Company employees:** Employee Master, full HRMS, payroll, selfie + GPS attendance, leave balance, certifications, PPE checklist, per-person login as a "Security Guard" / "AC Technician" / "Pest Control Technician" role.
- **Personnel as Supplier-provided:** "Personnel Dispatched" status, Service Delivery Note uploaded by the supplier listing names and credentials of deployed staff, Service Acknowledgment by site supervisor.

A guard cannot be both: a sub-contractor's employee with a Company login and full Company payroll is incoherent.

The 5-admin Company cannot directly employ the 50+ guards typically required to staff multiple society contracts. PSARA-licensed manpower agencies are how this works in the Indian market for security and unskilled-staffing service lines. Skilled/certified service lines (AC, pest control) are direct-employed because the Company owns the certification, PPE liability, and quality control.

## Decision

### 1. Hybrid staffing, declared per service line

Each row of the `services` catalog has a `staffing_model` column with values `direct` or `subcontracted`.

**Confirmed by client for the current 13-service catalog:**

| Service Line | Staffing Model |
|---|---|
| Security Guards (all grades, including Gunman, Door Keeper) | `subcontracted` |
| Housekeeping, Pantry, Office Boys | `subcontracted` |
| AC Services (technicians) | `direct` |
| Pest Control (technicians) | `direct` |
| Plantation | `direct` |
| Printing & Advertising | `direct` (internal Company staff) |

(Material-only services like paper cup supply have no staffing model — they are pure `material_order`s.)

### 2. Two distinct login concepts

- **Person login** — a human's identity in the system. Required for direct-employed staff (so payroll, attendance, leave can be computed). Required for residents, customer contacts, admins.
- **Site Kiosk login** — a *posting's* identity. Tied to a specific gate / lobby / station at a customer site. Whichever human operates the kiosk during a shift authenticates by clocking in (selfie + GPS). The kiosk persists as the durable identity for visitor logs, panic alerts, daily checklists, regardless of who happens to be on duty.

### 3. Role list cleanup

The roles `security_guard` and `security_supervisor` as currently modeled in `src/lib/auth/roles.ts` are wrong if guards are sub-contracted. They should not be person-roles in this Company's system. They should be replaced by a single `site_operator` capability that any kiosk-clocked-in human can assume for the duration of a shift.

`ac_technician`, `pest_control_technician`, `service_boy` (plantation field staff), `site_supervisor` remain as person-roles — these are direct-employed.

## Alternatives Considered

| Option | Why rejected |
|---|---|
| **A. Direct-employment only** | Cannot scale. A 5-admin Company cannot directly employ enough guards to staff multiple society contracts. Also creates a payroll, PSARA-license, and HR liability the client did not sign up for. |
| **B. Sub-contracted only** | Loses direct quality control over technical/skilled service lines. AC and pest control require certification storage, PPE checklists, selfie+GPS attendance — the Company cannot delegate those to a third-party agency without losing the brand value. |

## Consequences

**Good**
- HRMS (attendance, payroll, leave, certifications) only fires for `direct` staff. Doesn't bleed into sub-contracted workflows.
- Sub-contracted billing reconciles via `personnel_dispatches` + `service_delivery_notes` + supplier bills. No payroll engine for these.
- Site kiosks unblock the visitor-logging / panic-alert UX without requiring the Company to issue a personal login to every sub-contracted guard who joins, leaves, or substitutes.
- Each service line's lifecycle is declarable rather than a hidden conditional.

**Bad / costly**
- The role list in `src/lib/auth/roles.ts` and the role-to-module access matrix in the PRD both need restructuring. `security_guard` and `security_supervisor` as person-roles are dead concepts under this model.
- Migration of the existing `security_guards` table — currently person-shaped — to a kiosk-shaped `site_kiosks` table is non-trivial. Existing data probably represents postings, not people; the rename should be safe but needs verification.
- Two attendance flows: HRMS attendance (for direct staff, drives payroll) vs kiosk shift logs (for sub-contracted staff, drives only Service Acknowledgment + audit).

**Open follow-ups**
- Does a sub-contracted guard's shift log also need to be visible to the supplier (so they can run their own payroll)? Probably yes — exposes the supplier portal to read shift attendance for their own dispatched personnel.
- The PWA at `public/manifest.json` currently has `start_url: /test-guard` — that route's identity model needs to change from "the guard's personal app" to "the kiosk app for this posting."

# 0010 — Hybrid Staffing Path B (Restores ADR-0002 Staffing Model)

- **Status:** Accepted
- **Date:** 2026-05-09
- **Partially supersedes:** ADR-0009 §2 ("all personnel are direct Company employees")
- **Restores:** ADR-0002 §1 (hybrid staffing model), ADR-0002 §3 (role list)
- **Keeps dropped:** ADR-0002 §2 (site kiosk logins — deferred to v2)

---

## Trigger

The §9 procurement audit (PRD v3.0 vs codebase) revealed that the codebase had already built the full SPO / Service Delivery Note / Personnel Dispatched flow before ADR-0009 was written. ADR-0009 declared this flow "dropped," but:

1. The codebase never removed it. Four tables (`service_purchase_orders`, `service_purchase_order_items`, `service_delivery_notes`, `personnel_dispatches`), two hooks, two UI pages, one API route, and three DB triggers all implement it.
2. ADR-0002's analysis of why direct-employment-only cannot work for security/soft services was correct: the Indian facility-management market uses PSARA-licensed manpower agencies for guard deployments. A 5-admin Company cannot directly employ the 50+ guards required to staff multiple society contracts.
3. The `deployment_assignments` table (the PRD-v3.0 replacement) was never built because it was architecturally wrong for sub-contracted services.

Rather than delete correct, working code to satisfy a simplification that was itself incorrect, this ADR formalises Path B: restore the hybrid staffing model and treat the SPO flow as correct for sub-contracted service lines.

---

## Decision

### 1. Staffing model is declared per service line (`services.staffing_model`)

| Service Line | Staffing Model | Procurement Path |
|---|---|---|
| Security Guards (all grades, Gunman, Door Keeper) | `subcontracted` | SPO → Personnel Dispatched → Service Delivery Note → Service Acknowledgment |
| Housekeeping, Pantry, Office Boys | `subcontracted` | SPO → Personnel Dispatched → Service Delivery Note → Service Acknowledgment |
| AC Services technicians | `direct` | `deployment_assignments` (employees from HRMS roster) |
| Pest Control technicians | `direct` | `deployment_assignments` (employees from HRMS roster) |
| Plantation field staff | `direct` | `deployment_assignments` (employees from HRMS roster) |
| Printing & Advertising | `direct` | `deployment_assignments` (internal Company staff) |

Material-only services (`material_order` type) have no staffing model.

### 2. `deployment_assignments` table for direct-employed services

For `direct`-staffed service lines, admin assigns employees from the HRMS roster to a customer site for the contract period. This replaces the SPO path for those lines.

Schema (to be added in migration):
```sql
CREATE TABLE deployment_assignments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  service_request_id UUID REFERENCES service_requests(id) NOT NULL,
  employee_id UUID REFERENCES employees(id) NOT NULL,
  assigned_by UUID REFERENCES auth.users(id),
  assigned_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  start_date DATE NOT NULL,
  end_date DATE,
  is_active BOOLEAN DEFAULT true,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

### 3. `security_guard` and `security_supervisor` remain as person-roles (pragmatic v1 compromise)

ADR-0002 §3 proposed replacing `security_guard` with a `site_operator` kiosk-capability. That is architecturally correct but operationally complex for v1. For now:

- `security_guard` and `security_supervisor` are kept as person-roles in `user_role` enum.
- Sub-contracted guards using the mobile app are issued personal logins by the Company, not by the manpower agency.
- This means the Company owns the authentication identity of sub-contracted staff in v1 — a known simplification. The manpower agency's portal view (if needed) is a v2 feature.
- The HRMS **does not** track attendance/payroll/leave for sub-contracted guards. Those records live with the manpower agency. The Company tracks only shift-log, visitor-log, panic-alerts, and checklists via the guard's portal.

This is explicitly a pragmatic v1 compromise. ADR-0002 §2 (site kiosk logins) remains deferred to v2.

### 4. SPO flow is retained for sub-contracted services; GRN/reconciliation stay materials-only

The existing procurement split holds:

| Flow | Applies to |
|---|---|
| `indent → purchase_orders → material_receipts (GRN) → purchase_bills → reconciliations` | Material orders only |
| `indent → service_purchase_orders (SPO) → personnel_dispatches → service_delivery_notes → service_acknowledgments → purchase_bills` | Sub-contracted service deployments |
| `deployment_assignments` | Direct-employed service deployments |

Reconciliation (3-way PO ↔ GRN ↔ Supplier Bill) remains materials-only. SPO-linked supplier bills are reconciled manually by the account team; no automated engine for service contracts.

### 5. Fixed monthly billing applies to both staffing models

Regardless of whether a deployment is direct or sub-contracted, the customer (Buyer) is billed a fixed `monthly_amount` per the contract. First cycle prorated. Attendance data (from HRMS for direct, from shift logs for sub-contracted) informs SLA tracking only — not automated billing.

---

## What does NOT change from ADR-0009

- §3 — One role per user. No memberships table.
- §4 — Fixed monthly billing. No attendance-driven billing engine.
- §5 — One reconciliation engine, materials only.
- §6 — Buyer is a role, not a capability.
- §7 — Service catalog locked to 5 services + 8 material categories.

---

## Open follow-ups

- **Client confirmation required:** "Will Solvesxx directly employ all guards/housekeeping staff, or use manpower agencies?" If the answer is "direct employ all," revert to ADR-0009 §2 and delete the SPO flow. If "agencies," this ADR stands as written.
- **`services.staffing_model` column** needs to be added to the `services` table in a migration, then seeded per the table above.
- **HRMS attendance scope for guards:** confirm that the guard's personal login does NOT create a payroll record. Attendance logs created by guards (selfie + GPS clock-in) should be visible to the security supervisor for SLA purposes but should NOT feed `generate_payroll_cycle()`.
- **Supplier portal scope:** sub-contracted guard shift logs — does the manpower agency supplier need read access via the Supplier Portal? Probably yes (v1.1 scope); confirm before building.
- **Site kiosk concept:** remains deferred to v2. Revisit when the Company scales past ~3 society contracts and guard turnover makes personal-login management burdensome.

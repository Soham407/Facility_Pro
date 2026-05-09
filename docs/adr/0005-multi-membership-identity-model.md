# 0005 — Multi-Membership Identity Model

- **Status:** **SUPERSEDED by ADR-0009** (rolled back to single-role-per-user for simplicity)
- **Date:** 2026-05-09
- **Related:** [0001](./0001-three-entity-sales-model.md), [0002](./0002-hybrid-staffing-and-site-kiosks.md)

## Context

The current codebase treats identity as one-person-one-role: `users.role: AppRole` is a single string column. The role list (`src/lib/auth/roles.ts`) has 18 values including roles that are **dead concepts** under our newly-decided architecture (`security_guard`, `security_supervisor`, `buyer`, `vendor`).

Real humans in this product have multiple relationships with the Company simultaneously:

- A Company AC technician may also live in a society that the Company services (employee + resident).
- A resident may also be on the RWA committee (resident + customer_admin).
- A Company admin may be a corporate buyer in their day job (employee + corporate contact for a different Customer Account).

A single-role identity model cannot represent these correctly without lying.

## Decision

Identity is an `auth.users` row plus a set of `memberships`. Each membership says: this user has role R within scope S (where S is one of: Company, a Customer Account, or a Supplier).

```
memberships (
  user_id        uuid not null,            -- auth.users.id
  scope_type     text not null,            -- 'company' | 'customer_account' | 'supplier'
  scope_id       uuid,                     -- null when scope_type = 'company' (singleton)
  role           text not null,            -- role within that scope
  is_primary     boolean default false,    -- which membership the UI defaults to on login
  created_at     timestamptz default now(),
  primary key (user_id, scope_type, scope_id, role)
)
```

**Permission resolution:** the user's effective permissions are the union of permissions granted by all active memberships, each scoped to the data within that membership's scope.

**Login UX:** if a user has more than one membership, the UI exposes a context-switcher. The default landing surface is the user's primary membership.

## Role list cleanup

| Old role | Status |
|---|---|
| `super_admin` | Keep (Company-scoped) |
| `admin` | Keep (Company-scoped) |
| `company_md` | Keep (Company-scoped) |
| `company_hod` | Keep (Company-scoped) |
| `account` | Keep (Company-scoped) |
| `storekeeper` | Keep (Company-scoped) |
| `site_supervisor` | Keep (Company-scoped) — Company employee assigned to oversee a customer site |
| `ac_technician` | Keep (Company-scoped) |
| `pest_control_technician` | Keep (Company-scoped) |
| `service_boy` | **Rename** to `field_technician` (UX: "service boy" is a poor identifier) |
| `delivery_boy` | **Rename** to `delivery_agent` |
| `security_guard` | **Remove.** Replaced by Site Kiosk (ADR 0002). |
| `security_supervisor` | **Remove.** Replaced by Site Kiosk (ADR 0002). |
| `society_manager` | **Disambiguate.** Where it meant Company employee → `site_supervisor`. Where it meant customer-side RWA Chair → `customer_admin`. |
| `buyer` | **Remove.** Buy is a capability of Customer-account-scoped roles. |
| `vendor` | **Merge** into `supplier`. |
| `resident` | Keep (Customer-account-scoped) |
| (new) `customer_admin` | **Add** (Customer-account-scoped) — RWA Chairman, Corporate Procurement Lead, etc. |
| (new) `family_member` | **Add** (Customer-account-scoped) — view-only, lives in the same flat |
| (new) `supplier_admin` | **Add** (Supplier-scoped) |

## Alternatives Considered

| Option | Why rejected |
|---|---|
| **A. Keep one-role-per-person, add capability flags** | Capability flags solve "Buyer is a capability" but cannot represent a person who is a Company employee *and* a resident in a serviced society. The model lies in the rare-but-real case. |
| **C. Multi-membership but enforce only one active membership per session** | Avoids context-switcher UI, but requires re-logging-in to switch contexts. Costs more in user friction than the context-switcher costs in implementation. |

## Consequences

**Good**
- Models reality. No dead roles, no fake single-purpose accounts.
- RBAC becomes scope-aware: a resident sees data for *their* society only, not all societies.
- Customer-side roles (`customer_admin`, `resident`, `family_member`) are clearly partitioned from Company-side roles, which fixes a recurring confusion in the PRD's role-to-module access matrix.

**Bad / costly**
- The PRD's existing role-to-module access matrix collapses; it must be rewritten as **three matrices** (Company-scoped, Customer-account-scoped, Supplier-scoped).
- RLS policies become more complex — they now need to check `memberships` rather than a flat `users.role`.
- Migration cost: existing user rows need to be backfilled into `memberships`.
- A context-switcher UI must be built (small but visible component).

## Open follow-ups

- The PRD's "Society Manager" Dashboard (lines 33, 260–266) needs to be split into two: a Company-side site supervisor dashboard and a customer-side RWA admin dashboard. They share data shapes but serve different users.
- The existing `useAuth` hook and middleware need to be extended to surface the user's full membership set, not just their primary role.
- RLS migration plan to be drafted in a follow-up ADR.

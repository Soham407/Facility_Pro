# FacilityPro â€” Project Context

> **Last Updated:** 2026-04-25 (Enhanced admin creation flow with temporary password generation and structured invitation UI for superadmins; cleanup of unused clipboard logic on admin management page)
> Paste this at the start of every AI session for instant context.

---

## What Is This?

**FacilityPro** is the operations platform for **Solvesxx Powerful Solutions Pvt. Ltd.** — an ISO 9001:2015 certified Pune-based facility services company founded in 2026 (CIN U81100PN2026PTC251309, GSTIN 27ABSCS5790H1ZJ — Maharashtra). It is **single-tenant**: this codebase serves only Solvesxx. Customers (societies, corporates, individual residents) buy services from Solvesxx; Suppliers fulfill material/manpower needs.

**The 5 founders** (2 lawyers, 2 administrative experts, 1 manufacturing-ops specialist) operate as a flat admin team. Functional specialization exists in real life but is not enforced by RBAC in v1 — they all share the `admin` role. (See ADR-0009 for the simple-mode pivot away from specialized admin roles.)

**v1 service catalog (from the original client scope, ADR-0009 §7):**

Services (5 lines):
1. Facility Management & Security (with Grade A/B/C/D, Gunman, Door Keeper, Housekeeping, Pantry, Office Boys as employee designations)
2. Air Conditioner Services
3. Plantation Services
4. Printing & Advertising Services
5. Pest Control Services

Material categories (8): Security Panel & Door Controller, Hot & Cold Beverages, Eco-Friendly Disposables, Cleaning Essentials, Pest Control Materials, Air Fresheners, Stationery, Corporate Gifting.

Brochure-only items (Legal Services CMS, AI Door Camera, Import/Export consultancy) are **deferred to v2** — not built in v1.

---

## Domain Glossary

> Canonical terms for this product. If a discussion uses one of these terms in a different sense, stop and reconcile before continuing.

### Company
The single facility services agency that owns this deployment. There is exactly one Company per instance. The Company has admins, employees, and contracts with both **Customers** (revenue side) and **Suppliers** (cost side).

### Buyer
A Buyer is a Customer Account in the system — the billable counterparty for any sale. Three types:

- **`society`** — Residential complex / corporate facility with an ongoing service relationship. Has residents, buildings, flats. Onboarded by admin only.
- **`corporate`** — Business with no residency dimension (office hiring housekeepers, etc.). Onboarded by admin only.
- **`individual_resident`** — A natural person who lives in a `society` Buyer and also wants to order things personally (paper cups, printing). They onboard as their own Buyer account, separate from their society's account.

**Buyer is a role**, not a capability. Residents who want to place orders on behalf of their society do so via the society's Buyer admin user. Individual residents wanting to order things personally have a separate `individual_resident` Buyer account.

### Supplier
External vendor providing **materials only** to the Company. (Earlier docs described suppliers also providing manpower — that path is dropped per ADR-0009. All deployed personnel are direct Company employees.)

### Service Request (the unified sales entity)
All customer-facing sales flow through a single `service_requests` table with a `type` discriminator:

| `type` value | Meaning | Example | Billing |
|---|---|---|---|
| `deployment` | Long-running personnel deployment to a customer site | "4 Grade-A guards, 12-hr shift, 6 months" | Recurring fixed monthly invoice |
| `material_order` | One-shot material delivery | "100 paper cups to flat 304" | Single sale invoice |
| `ticket` | Operational complaint or repair | "AC not cooling in flat 304" | Single sale invoice (or free-of-charge under active deployment) |

The codebase already has `service_requests.type` (per migration `20260430000000`). Extend the enum rather than splitting tables. Conditional UI / billing logic by `type` is acceptable for v1.

### Personnel
**All deployed personnel are Company employees** managed through HRMS — including guards (Grade A/B/C/D), Gunman, Door Keeper, housekeeping, pantry, office boys, AC technicians, pest control technicians, plantation staff.

- HRMS handles selfie clock-in, geofence, payroll, leave, BGV, PSARA, document expiry, certifications, PPE checklist.
- A `deployment`-type service request has a `deployment_assignments` child table linking the contract to specific employees. When an employee can't be there (leave, termination), admin reassigns from the existing roster.
- Suppliers provide *materials*, never personnel. (See ADR-0009.)

### Identity & Roles (single role per user)
Each user has exactly one role on `users.role`. No multi-membership, no context-switcher. If a person has two genuinely different relationships with the Company (rare — e.g., an employee who also lives in a serviced society), they get two separate accounts.

**Active roles in v1:**

- **Company-side:** `super_admin`, `admin`, `company_md`, `company_hod`, `account`, `storekeeper`, `site_supervisor`, `ac_technician`, `pest_control_technician`, `field_technician` (rename of `service_boy`), `delivery_agent` (rename of `delivery_boy`), `security_guard`, `security_supervisor`.
- **Customer-side:** `buyer` (umbrella for society admin / corporate admin / individual resident in their Buyer role), `resident` (a person inside an onboarded society, view-only of their society's data + visitor approval).
- **Supplier-side:** `supplier` (replaces both `supplier` and `vendor`, which were duplicates).

`security_guard` and `security_supervisor` stay as person-roles because guards are direct-employed Company employees who use the Guard mobile interface tied to their employee identity (not a posting kiosk).

### Service Catalog (the shape of a service line)
Each row in the `services` catalog declares:

- `service_code` — short stable code (e.g. `PST-CON`, `AC-SVC`). Used for lookups; never hardcode UUIDs.
- `service_name`
- `category` — one of: `Facility Management`, `AC Services`, `Plantation`, `Printing & Ads`, `Pest Control`, `Material Supply`.
- `default_sales_modes` — subset of `{deployment, ticket, material_order}` declaring which `service_request.type` values can be opened against this service.
- `default_unit_rate_basis` — pointer to the rate table used for default pricing.

**v1 catalog content** is locked to the original scope's 5 services + 8 material categories (per ADR-0009 §7). Brochure-only items (Legal CMS, AI Camera, Import/Export) are deferred to v2.

### Personnel Substitution
When an assigned employee can't fulfill their deployment shift (leave, sickness, termination), admin reassigns from the available employee roster. Standard HRMS leave + attendance handle this. Repeated gaps surface in the deployment dashboard for SLA visibility — but they do **not** automatically affect billing. If a major SLA breach occurs, admin issues a manual credit note on the next invoice.

### Resident Ordering (defaults to society's Buyer account)
A resident wanting to order through their society does so by reaching out to their society's Buyer admin (offline) — the Buyer admin places the order on the system. **Residents do not place orders directly against the Company in v1.**

If a resident wants to order something personally (paper cups, etc.), they create their own `individual_resident` Buyer account and place the order against it.

(This is the simple v1 model. A "resident self-service order with society approval" workflow may be added in v2.)

### Contract Lifecycle
`service_contract.status: draft → active → terminated | expired | cancelled`. Termination is one-sided with default 30-day notice (overridable per contract). `termination_reason: cause | convenience` — for-cause termination skips notice-period billing; for-convenience honors it. The customer-facing portal exposes only "request termination"; admin executes the state change.

### Renewal
Contracts have an `end_date`. The system raises an "Expiring Soon" alert at `end_date - 60 days`. **Renewal creates a new contract** (preserves rate-freezing semantics) pre-filled from the old one's terms. Auto-renewal is opt-in per-contract (`auto_renew_terms` JSONB) and defaults to **off**.

### Notification Rules
Three priority tiers drive routing and channel selection:

| Tier | Channels | Quiet hours? |
|---|---|---|
| `critical` | Push + SMS (MSG91) + In-app, non-dismissable on mobile until acknowledged | Never suppressed |
| `high` | Push + In-app | Suppressed 22:00–07:00 |
| `normal` | In-app only | Suppressed 22:00–07:00 |

SMS fires only for `critical` (cost discipline). Per-user opt-out is allowed for `normal` only.

### Compliance & Document Expiry
Each compliance-relevant entity (Company employee, Supplier, sub-contracted personnel via Service Delivery Note, Customer site fire-safety certs, technician certifications) carries a `compliance_documents` set. Edge function `check-document-expiry` escalates: D-90 dashboard notice → D-30 push → D-7 critical → D+1 blocks dependent operations (expired PSARA blocks a guard posting; expired gas-handling cert blocks the AC technician from starting cert-required tickets).

### Visitor Types
- `guest` — one-shot, photo + phone + vehicle captured at gate.
- `daily_help` — recurring (maid, driver, milkman). Saved profile; subsequent visits are quick-tap.
- `vendor` — third-party service person not affiliated with the Company (Amazon, Swiggy, resident's own plumber). Logged but never linked to a `service_ticket`.
- `contractor` — long-duration third-party (renovation crew). Multi-day pass.
- `family_visit` — pre-declared by the resident.

### Tenancy Lifecycle
A `flat` has zero or more `flat_occupancies`. An occupancy row carries `flat_id`, `resident_user_id`, `relationship: owner | tenant | family`, `start_date`, `end_date` (null when active). Ownership transfer or tenant move = close the current occupancy and open a new one. Resident portal access is bound to **active occupancy only** — historical residents lose access cleanly. The privacy-safe `resident_directory` view exposes only active occupancies.

### Customer Onboarding (Hybrid)
- **Society & Corporate accounts:** admin-provisioned only. Sales conversation → handshake → admin enters the customer manually. Self-serve corporate signup is **not** offered. The existing waitlist (`useWaitlist`) is for inbound interest capture only — it never auto-provisions a Customer Account.
- **Individual Resident accounts:** self-serve, but only after their parent society is onboarded. A resident registers via SMS OTP or a society-supplied invite code.

### Rate Freezing (per-contract, not per-customer)
The catalog (`services.default_sale_unit_rate`, `default_supplier_unit_rate`) holds **suggested defaults** only. The moment a `service_contract` or `material_order` line is created, both the customer-side rate and the supplier-side rate are **copied into the contract/order row and frozen** for its lifetime. Catalog rate changes never retroactively affect existing contracts. There is no separate `customer_rate_overrides` table — a customer with negotiated pricing simply has a contract whose `sale_unit_rate` differs from the catalog default. **No formal quote entity in v1** — negotiation happens offline; the system only records the agreed terms after handshake.

### Recurring Contract Billing — Fixed Monthly
A `deployment`-type service request has a fixed `monthly_amount` agreed at contract signing. That amount is invoiced monthly on a calendar-aligned cycle (1st → last of month). First cycle is **prorated by days** (e.g. start on 12 May → first invoice = 20/31 × monthly_amount).

- Attendance is tracked via HRMS for **operational and SLA visibility**, not for billing.
- For major SLA breaches, admin issues a **manual credit note** on the next invoice. No automated attendance-driven discounting.
- No supplier-side reconciliation for service contracts (no service-side suppliers in v1).

### Mobile App Surface (the "Time-Critical Action" rule)
The product ships as **two clients sharing one Supabase backend**:

- **Web app** (this Next.js codebase) — covers every role and every feature.
- **Mobile app** (separate React Native codebase) — covers a *subset* of features defined by a single rule:

> **A feature belongs in the mobile app if and only if it requires immediate action from the user.** Everything else stays web-only.

This is the **client's stated filter**. It overrides any role-based instinct ("guards are mobile, admins are web"). A finance officer might rarely receive an emergency notification — that *one* feature belongs on mobile, not the rest of finance. An admin might need to acknowledge a panic alert at 2am — that one acknowledgment screen belongs on mobile, not the admin dashboard.

**Concrete consequence:** the PRD must declare, for every feature, one of:

| Surface tag | Meaning |
|---|---|
| `web-only` | Feature only exists on web. (default for desk-work) |
| `mobile-only` | Feature only exists on mobile. (rare — site kiosk panic button is one) |
| `both` | Feature exists on both, must be specified in both codebases. (anything immediate-action that is also useful from the desk) |

**Implication for cross-codebase consistency:** every `both` feature has double implementation cost. The PRD should resist marking features `both` unless they meet the immediate-action filter. When in doubt, default to `web-only`.

### Site Kiosk Login (vs Person Login)
Two distinct login concepts — do not conflate:

- **Person login** — Tied to a specific human (Company employee, resident, customer contact). Has identity, payroll, leave balance, etc.
- **Site Kiosk login** — Tied to a **posting** (a specific gate, lobby, or station at a customer site). The current human operating the kiosk authenticates by clocking in (selfie + GPS), but the kiosk itself is the durable identity. Used by sub-contracted personnel — the kiosk lets them log visitors, fire panic alerts, complete daily checklists, without each individual guard having a Company login.

Sub-contracted personnel: **kiosk only, no person login**. Direct-employed personnel: **person login, no kiosk needed** (their phone IS the kiosk for attendance purposes).

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| **Framework** | Next.js 16 (App Router) |
| **Language** | TypeScript (strict OFF, strictNullChecks OFF) |
| **UI** | TailwindCSS 3.4 + Radix UI + shadcn/ui + Framer Motion |
| **State** | React hooks (custom hooks per domain â€” 102 hooks in `/hooks/`) |
| **Backend** | Supabase (Postgres + Auth + Realtime + Storage + Edge Functions) |
| **Push Notifications** | Firebase Cloud Messaging (FCM) |
| **SMS** | MSG91 via Supabase Edge Function (`send-notification`) |
| **Charts** | Recharts |
| **Tables** | TanStack React Table v8 |
| **Forms** | React Hook Form + Zod validation |
| **PDF Generation** | jsPDF + jspdf-autotable |
| **QR Codes** | qrcode.react + html5-qrcode (scanner) |
| **Printing** | react-to-print |
| **Date Handling** | date-fns |

---

## Architecture

```
enterprise-canvas-main/
â”œâ”€â”€ app/
â”‚   â”œâ”€â”€ (dashboard)/         # All authenticated routes (layout with sidebar)
â”‚   â”‚   â”œâ”€â”€ assets/          # Asset management & QR codes
â”‚   â”‚   â”œâ”€â”€ buyer/           # Buyer portal (requests, invoices, dashboard)
â”‚   â”‚   â”œâ”€â”€ company/         # Role master, designations, employees, users
â”‚   â”‚   â”œâ”€â”€ dashboard/       # Role-specific dashboards (12 roles: MD, HOD, Supervisor, etc.)
â”‚   â”‚   â”œâ”€â”€ finance/         # Reconciliation, supplier bills, sale bills, compliance, budgeting
â”‚   â”‚   â”œâ”€â”€ hrms/            # Attendance, payroll, recruitment, leave, shifts, documents, events, holidays
â”‚   â”‚   â”œâ”€â”€ inventory/       # Products, categories, POs, GRN, suppliers, warehouses, sales rates
â”‚   â”‚   â”œâ”€â”€ reports/         # Analytics & reporting (attendance, financial, inventory, services)
â”‚   â”‚   â”œâ”€â”€ service-boy/     # Field technician interface (job sessions + GPS tracking)
â”‚   â”‚   â”œâ”€â”€ service-requests/# Service indent management (list, board view, detail, new)
â”‚   â”‚   â”œâ”€â”€ services/        # AC, pest control, plantation, printing, security + masters
â”‚   â”‚   â”œâ”€â”€ settings/        # App settings (company config)
â”‚   â”‚   â”œâ”€â”€ society/         # Visitors, checklists, panic alerts, emergency, residents, my-flat
â”‚   â”‚   â”œâ”€â”€ supplier/        # Supplier portal (dashboard, indents, bills, POs, service orders)
â”‚   â”‚   â”œâ”€â”€ test-delivery/   # Delivery Boy test interface (material arrival logging)
â”‚   â”‚   â”œâ”€â”€ test-guard/      # Guard-facing test interface (resident verification + visitor logging)
â”‚   â”‚   â”œâ”€â”€ test-resident/   # Resident-facing test interface (visitor invitation + flat details)
â”‚   â”‚   â””â”€â”€ tickets/         # Behavior tickets, quality tickets, RTV returns
â”‚   â”œâ”€â”€ api/                 # Next.js API routes (assets proxy)
â”‚   â”œâ”€â”€ login/               # Auth pages
â”‚   â”œâ”€â”€ scan/                # QR landing pages (`/scan/[id]`) that record scans and resolve linked assets
â”‚   â””â”€â”€ layout.tsx           # Root layout (fonts, theme provider, manifest link)
â”œâ”€â”€ components/
â”‚   â”œâ”€â”€ ui/                  # shadcn/ui primitives (Button, Dialog, Card, etc.)
â”‚   â”œâ”€â”€ layout/              # AppSidebar, TopNav, NotificationBell, CommandMenu
â”‚   â”œâ”€â”€ forms/               # Reusable form components
â”‚   â”œâ”€â”€ dialogs/             # Feature-specific dialogs (ServiceDeliveryNoteDialog, BuyerFeedbackDialog, AdBookingDialog, ServiceAcknowledgmentDialog, ManualAdjustmentDialog, ScheduleVisit, NewJobOrder, SummaryReports, etc.)
â”‚   â”œâ”€â”€ shared/              # DataTable, StatusBadge, PageHeader, ComingSoon
â”‚   â”œâ”€â”€ dashboards/          # 14 role-specific dashboard widgets
â”‚   â”œâ”€â”€ buyer/               # Buyer-specific components
â”‚   â”œâ”€â”€ visitors/            # FamilyDirectory, visitor components
â”‚   â”œâ”€â”€ printing/            # IDPrintingModule
â”‚   â”œâ”€â”€ plantation/          # PlantationInventory
â”‚   â”œâ”€â”€ emergency/           # Emergency contact components (AddEmergencyContactDialog, EmergencyContactList)
â”‚   â”œâ”€â”€ assets/              # Asset management (AssetList, AssetForm, AssetStatusBadge, AssetCategoryManager)
â”‚   â”œâ”€â”€ service-requests/    # Service request UI (ServiceRequestList, ServiceRequestForm, RequestKanban)
â”‚   â”œâ”€â”€ jobs/                # Job execution (JobSessionPanel)
â”‚   â”œâ”€â”€ maintenance/         # Maintenance scheduling (MaintenanceScheduleList)
â”‚   â”œâ”€â”€ qr-codes/            # QR code generation & scanning (QrCodeComponents, QrBatchGenerator)
â”‚   â”œâ”€â”€ inventory-ops/       # Inventory ops (InventoryTable, StockForm)
â”‚   â””â”€â”€ society/             # VisitorRegistrationDialog, society-specific components
â”œâ”€â”€ e2e/                     # Playwright specs, shared auth helpers, role matrix, global setup
â”œâ”€â”€ hooks/                   # 102 custom hooks (one per domain entity)
â”œâ”€â”€ lib/                     # Firebase config, notification service, utils
â”œâ”€â”€ src/
â”‚   â”œâ”€â”€ lib/                 # Supabase clients, constants, feature flags, auth, utils/currency
â”‚   â””â”€â”€ types/               # TypeScript types (supabase.ts, operations.ts, supply-chain.ts)
â”œâ”€â”€ supabase/
â”‚   â”œâ”€â”€ migrations/          # SQL migration files (191 `.sql` files as of 2026-03-31)
â”‚   â”œâ”€â”€ functions/           # Edge Functions (8 deployed)
â”‚   â”œâ”€â”€ archive/             # Historical phase schema SQL (PhaseAâ€“E)
â”‚   â”œâ”€â”€ scripts/             # One-off diagnostic/hotfix SQL scripts
â”‚   â””â”€â”€ seeds/               # Seed data files
â”œâ”€â”€ scripts/                 # Utility/test scripts (proxy.ts, verify_schema.ts, provision-role-test-users.cjs, etc.)
â”œâ”€â”€ public/
â”‚   â””â”€â”€ manifest.json        # PWA manifest (start_url: /test-guard, display: standalone)
â””â”€â”€ docs/                    # Audit reports, reference schema
```

---

## Sidebar Navigation

The sidebar is defined in `components/layout/AppSidebar.tsx` (548 lines). Navigation is a `NavGroup[]` array.

**To add a new page to the sidebar:**
1. Add a nav entry to the `navigation` array in `AppSidebar.tsx`
2. Each entry needs: `title`, `href`, `icon` (from lucide-react)
3. For sub-items, add a `children` array with `{ title, href }` objects
4. If the page should be gated, add it to `featureFlags.ts` (see Feature Flags below)
5. If the page is role-restricted, add the route prefix to `src/lib/auth/roles.ts`

**Current sidebar groups:** Overview, Workforce & HR, Operations, Residences, Finance & Analytics, Support & Tickets, Portals, System

**Note:** Some nav items are `/* Temporarily hidden */` via comments â€” these are built but hidden from the sidebar (Assets & Maintenance, some Supply Chain sub-items, Printing & Ads, Quality/Material Return tickets, some Finance sub-items).

---

## Feature Flags System

File: `src/lib/featureFlags.ts`

**How it works:**
- `NEXT_PUBLIC_FEATURE_FUTURE_PHASE=true` â†’ enables ALL experimental features
- `NEXT_PUBLIC_FF_<FLAG_NAME>=true` â†’ enables individual features
- Routes, nav items, and nav hrefs are mapped to flags
- Client components must read flags through statically-mapped NEXT_PUBLIC_* references; dynamic process.env[...] access will not be inlined into the browser bundle

**Current flags:** `KANBAN_BOARD`, `REPORTS_MODULE`, `GPS_COMMAND_CENTER`, `MAINTENANCE_SCHEDULING`, `QR_BATCH_GENERATOR`, `JOB_MATERIAL_TRACKING`, `INDENT_VERIFICATION`, `SERVICE_BOY_PAGE`, `MULTI_WAREHOUSE`, `ASSET_CATEGORY_HIERARCHY`, `STOCK_BATCH_MANAGEMENT`, `LEAVE_CONFIG_ADMIN`, `SPECIALIZED_PROFILES`, `ASSET_MODULE`, `FINANCE_EXTENDED`, `SETTINGS_MODULE`

**Frozen routes (hidden when flag OFF):**
`/service-requests/board`, `/reports/*`, `/assets/maintenance`, `/inventory/warehouses`, `/assets/categories`, `/service-boy`

**To add a new feature flag:**
1. Add flag to `FEATURE_FLAGS` object in `featureFlags.ts`
2. Add route mapping to `ROUTE_FLAG_MAP` if it has a dedicated route
3. Add nav title mapping to `NAV_ITEM_FLAG_MAP` if it has a sidebar entry

---

## Role-Based Access Control

File: `src/lib/auth/roles.ts`

**AppRole type:** `admin` | `company_md` | `company_hod` | `account` | `delivery_boy` | `buyer` | `supplier` | `vendor` | `security_guard` | `security_supervisor` | `society_manager` | `service_boy` | `resident` | `storekeeper` | `site_supervisor` | `super_admin` | `ac_technician` | `pest_control_technician`

**Access matrix (route prefixes each role can access):**

| Role | Allowed Routes |
|------|---------------|
| `admin` | Everything (`/`) |
| `super_admin` | Everything (`/`) |
| `company_md` | `/dashboard`, `/reports`, `/finance` |
| `company_hod` | `/dashboard`, `/hrms`, `/service-requests`, `/tickets`, `/services`, `/company` |
| `account` | `/dashboard`, `/finance` |
| `delivery_boy` | `/dashboard`, `/logistics` |
| `buyer` | `/dashboard`, `/buyer` |
| `supplier` | `/dashboard`, `/supplier` |
| `vendor` | `/dashboard`, `/supplier` |
| `security_guard` | `/dashboard`, `/test-guard`, `/tickets`, `/society` |
| `security_supervisor` | `/dashboard`, `/test-guard`, `/tickets`, `/society`, `/hrms/attendance` |
| `society_manager` | `/dashboard`, `/society`, `/test-resident`, `/tickets`, `/finance/compliance` |
| `service_boy` | `/dashboard`, `/service-boy`, `/service-requests` |
| `resident` | `/test-resident`, `/society/my-flat` |
| `storekeeper` | `/dashboard`, `/inventory`, `/tickets` |
| `site_supervisor` | `/dashboard`, `/society`, `/tickets`, `/hrms/attendance` |
| `ac_technician` | `/dashboard`, `/service-requests`, `/services/ac`, `/inventory`, `/hrms/attendance`, `/hrms/leave` |
| `pest_control_technician` | `/dashboard`, `/service-requests`, `/services/pest-control`, `/inventory`, `/hrms/attendance`, `/hrms/leave` |

**To add a new role or route:** Edit `ROLE_ACCESS` in `src/lib/auth/roles.ts`.

---

## Supabase Client Patterns

Three client types exist:

**1. Browser client (for hooks â€” most common):**
```typescript
// Option A: Import singleton (used by most hooks)
import { supabase } from "@/src/lib/supabaseClient";

// Option B: Create instance (used by newer hooks)
import { createClient } from "@/src/lib/supabase/client";
const supabase = createClient();
```

**2. Server client (for Server Components & Route Handlers):**
```typescript
import { createClient } from "@/src/lib/supabase/server";
const supabase = await createClient(); // async!
```

**3. Realtime subscription pattern:**
```typescript
const channel = supabase
  .channel('my-channel')
  .on('postgres_changes', { event: '*', schema: 'public', table: 'my_table' }, handler)
  .subscribe();
return () => { supabase.removeChannel(channel); };
```

**Resident auth + directory rule:**
- Resident profile resolution must use `residents.auth_user_id = auth.uid()`
- The privacy-safe `resident_directory` view is the read surface for the society resident directory page
- Existing unlinked resident rows can be provisioned through `POST /api/residents/unlinked`, which creates the auth user via the Admin API, sets `must_change_password = true`, and backfills `residents.auth_user_id`

---

## Types & Migration Conventions

**Type files:**
- `supabase-types.ts` (root) â€” 606KB auto-generated, **don't edit**
- `src/types/supabase.ts` â€” 294KB auto-generated, **don't edit**
- `src/types/operations.ts` â€” Manual types for assets, service requests, jobs, inventory, RTV
- `src/types/supply-chain.ts` â€” Manual types for suppliers, supplier products, rates
- When adding new features, add types to the relevant domain file OR create a new `src/types/[domain].ts`

**Constants:**
- `src/lib/constants.ts` â€” Status enums, labels, colors, badge classes for all entities
- When adding a new entity status, add `_STATUS`, `_STATUS_LABELS`, `_STATUS_COLORS`, and `_STATUS_BADGE_CLASSES` to this file

**Migration naming:** `YYYYMMDD_description_snake_case.sql` (e.g., `20260209_link_resident_auth.sql`)
- Stored in: `supabase/migrations/`
- Historical phase SQL scripts archived in: `supabase/archive/PhaseA/` through `supabase/archive/PhaseE/`

---

## Key Conventions

1. **Hooks pattern**: Every database entity gets its own `use[Entity].ts` hook in `/hooks/`. Hooks handle all CRUD, filtering, pagination, and realtime subscriptions.
2. **Path alias**: `@/*` maps to project root (e.g., `@/hooks/useVisitors`).
3. **Supabase client**: Browser client at `src/lib/supabaseClient.ts`, SSR client functions at `src/lib/supabase/`.
4. **Types**: Auto-generated from Supabase schema in `supabase-types.ts` (606KB, 100+ tables). Phase-specific types in `src/types/`.
5. **Feature flags**: Managed in `src/lib/featureFlags.ts`.
6. **Build note**: `ignoreBuildErrors: true` in next.config.ts because the massive type file causes TS2589 deep instantiation errors. IDE type-checking still works.
7. **Auth**: Supabase Auth with role-based access. 18 roles defined in `src/lib/auth/roles.ts`. See "Role-Based Access Control" section above.
8. **Edge Functions**: 8 Deno-based functions for cron jobs and notifications (check-checklist, check-document-expiry, check-guard-inactivity, check-inactivity, check-incomplete-checklists, checklist-reminders, inactivity-monitor, send-notification).
9. **Styling**: HSL CSS variables for theming (dark mode supported via `next-themes`). Custom shadow system, keyframe animations, and glassmorphism tokens defined in `tailwind.config.js` and `globals.css`.
10. **Currency formatting**: Use `formatCurrency()` from `@/src/lib/utils/currency` for all monetary values â€” handles paise-to-rupee conversion.
11. **ComingSoon components**: `ComingSoonChart` and `ComingSoonWidget` in `@/components/shared/ComingSoon` for placeholder charts/widgets not yet connected to real data.
12. **Service lookup pattern**: Use `service_code` (e.g., `PST-CON`, `PRN-ADV`) to find services dynamically â€” never hardcode UUIDs.


13. **Platform settings/RBAC**: Super Admin settings now use module-level platform permissions (`platform.dashboard.view`, `platform.admin_accounts.manage`, `platform.rbac.manage`, `platform.audit_logs.view`, `platform.config.manage`) defined in `src/types/platform.ts` and `src/lib/platform/permissions.ts`. Admin invite/reset flows now surface secure generated setup and recovery links from the server along with a temporary password for initial signup, for environments where direct invite email delivery is unavailable.

---

## Database

- **100+ tables** across public schema on Supabase Postgres
- **Key tables**: `employees`, `visitors`, `daily_checklists`, `panic_alerts`, `purchase_orders`, `indents`, `products`, `suppliers`, `service_requests`, `attendance_records`, `leave_applications`, `payroll_cycles`, `company_locations`, `residents`, `flats`, `buildings`, `stock_levels`, `supplier_bills`, `sale_bills`, `behavior_tickets`, `grn_items`, `security_guards`, `job_sessions`, `rtv_tickets`, `service_delivery_notes`, `buyer_feedback`, `background_verifications`, `pest_control_spill_kits`, `printing_ad_bookings`, `shortage_notes`, `shortage_note_items`, `personnel_dispatches`, `notifications`, `service_acknowledgments`, `system_config`, `roles`, `audit_logs`
- **RLS**: Enabled with role-based policies
- **Realtime**: Used for panic alerts, service request updates, sale rate changes, supplier rate changes, job session tracking, RTV ticket changes, service delivery notes, personnel dispatches, notifications
- **Storage**: Employee documents, visitor photos, job evidence photos
- **SQL Functions**: payroll_calculation, po_status_transition, reconciliation_matching, visitor_approval, log_material_arrival, auto_punch_out_idle_employees, detect_chemical_expiry
- **Recent procurement hardening**: `20260323000002_fix_audit_log_uuid_writers.sql` aligns legacy audit writers to `audit_logs.entity_id uuid`; `20260323000003_fix_finance_closure_target_dates.sql` fixes finance closure trigger date-column handling for `purchase_bills`, `sale_bills`, `payments`, and `ledger_entries`
- **Latest procurement workflow hardening**: `20260329000001_fix_procurement_po_dispatched_flow.sql` aligns `dispatched` across the PO transition RPCs and keeps buyer requests moving to `material_received` after GRN acceptance or partial acceptance
- **Latest buyer quick actions**: `20260430000000_buyer_ticket_and_cancel_actions.sql` adds `service_requests.type` (`service_request`/`ticket`) and a `cancelled` buyer request status for `/buyer` dashboard actions
- **Reference schema**: `docs/reference_schema.sql` (134KB)

---

## Environment Variables

| Variable | Purpose |
|----------|---------|
| `NEXT_PUBLIC_SUPABASE_URL` | Supabase project URL |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Supabase anon/public key |
| `SUPABASE_SERVICE_ROLE_KEY` | Server-side Supabase key |
| `NEXT_PUBLIC_FIREBASE_*` | Firebase Cloud Messaging config (7 vars) |
| `NEXT_PUBLIC_APP_URL` | App base URL (default: http://localhost:3000) |

---

## Don't Touch / Be Careful

- **`supabase-types.ts`** â€” Auto-generated, 606KB. Never edit manually. Regenerate via Supabase CLI.
- **`docs/reference_schema.sql`** â€” 134KB reference. Read-only.
- **RLS policies** â€” Always test with the correct role. Breaking RLS can expose data.
- **Edge function secrets** â€” Set via `supabase secrets set`, not in `.env.local`.
- **`src/types/supabase.ts`** â€” 294KB auto-generated type file. Don't edit.

---

## Existing Hooks Reference (102 hooks)

Below is a categorized list of all hooks. **Always check if a hook already exists before creating a new one.**

### Auth & Core
`useAuth`, `use-mobile`

### Company Module
`useRoles`, `useEmployees`, `useEmployeeProfile`, `useEmployeeDocuments`

### Inventory & Supply
`useProducts`, `useProductCategories`, `useProductSubcategories`, `useInventory`, `useWarehouses`, `useSuppliers`, `useSupplierProducts`, `useSupplierRates`, `useSupplierRateSubscription`, `useSaleProductRates`, `useSaleRateSubscription`, `useReorderAlerts`, `useServices`, `useWaitlist`

### Procurement
`useIndents`, `usePurchaseOrders`, `usePurchaseOrderList`, `usePurchaseOrderDetails`, `useGRN`, `useSupplierBills` (bill number generation via `generateBillNumber()`, document upload to storage via `uploadBillDocument(billId, supplierId, file)`)

### Financial
`useFinance`, `useFinancialClosure`, `useSupplierBills`, `useBuyerInvoices`, `useReconciliation`, `useReconMatch`, `useReconAudit`, `useBudgets`, `useCompliance`, `usePerformanceAudit`

### Buyer Portal
`useBuyerRequests`, `useBuyerInvoices`, `useBuyerFeedback`

### Supplier Portal
`useSupplierPortal` (goods portal + supplier-scoped service orders + service acknowledgments + supplier profile self-service), `useServicePurchaseOrders`, `useServiceDeliveryNotes`, `usePersonnelDispatches`

### HRMS
`useAttendance`, `useShifts`, `usePayroll`, `useLeaveApplications`, `useLeaveTypes`, `useHolidays`, `useCompanyEvents`, `useCandidates`, `useBackgroundVerifications`

### Society & Security
`useVisitors`, `useGuardVisitors`, `useGuardChecklist`, `usePanicAlert`, `usePanicAlertHistory`, `usePanicAlertSubscription`, `useInactivityMonitor`, `useGuardLiveLocation`, `usePatrolLogs`, `useSecurityGuards`, `useResident`, `useResidentLookup`, `useResidentProfile`, `useSocieties`, `useSocietyStats`, `useSocietyAudit`, `useEmergencyContacts`, `useSupervisorStats`, `useReorderAlerts`

### Services
`useServiceRequests`, `useServiceRequestSubscription`, `useTechnicians`, `useVendorWiseServices`, `useWorkMaster`, `useJobSessions`, `useJobSessionSubscription`, `useJobMaterials`, `useJobPhotos`, `useMaintenanceSchedules`, `usePestControlInventory`, `usePlantation`, `usePlantationOps`, `usePrintingMaster`, `useSpillKits`, `useAdBookings`, `useServiceDeploymentMasters`

### Tickets
`useBehaviorTickets`, `useRTVTickets`, `useShortageNotes`

### Assets & Delivery
`useAssets`, `useAssetCategories`, `useQrCodes`, `useDeliveryLogs`

### MDash & Analytics
`useMDStats`, `useHODStats`, `useAnalyticsData`, `usePushNotifications`

### Platform
`useAuditLogs`, `useNotifications`, `usePlatformAdminAccounts`, `usePlatformAuditLogs`, `usePlatformConfig`, `usePlatformRolePermissions`, `useSupabaseMutation`, `useSupabaseQuery`, `useSystemConfig`, `useUsers`

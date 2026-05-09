# FacilityPro — Product Requirements Document

> **Version:** 3.1 — Hybrid Staffing Restore
> **Updated:** 2026-05-09
> **Status:** Amends PRD v3.0. Restores ADR-0002's hybrid staffing model per ADR-0010, triggered by §9 procurement audit (SPO/SDN/Personnel Dispatch flow found fully built and architecturally correct for sub-contracted services). Sections changed from v3.0: §1, §2 note, §4.2, §9.2, §9.3, §9.4, §14, §21. Source artifacts: original client scope (`Details Scope V-2.0.pdf`), client brochure (`Brochure.pdf`), grilling session decisions captured in `.ai_context/CONTEXT.md`, ADR-0010.

---

# 1. Scope

FacilityPro is the operations platform for **Solvesxx Powerful Solutions Pvt. Ltd.** — an ISO 9001:2015 certified Pune-based facility services company (CIN U81100PN2026PTC251309, GSTIN 27ABSCS5790H1ZJ). It is a **single-tenant** system: this codebase serves only Solvesxx.

The platform digitizes the full service-delivery lifecycle from a customer's initial request to final invoice and feedback. It connects three stakeholder groups in one ecosystem:

- **Solvesxx (the Company)** — the 5-founder admin team plus all internal employees.
- **Buyers** — the Company's customers: residential societies, corporates, and individual residents.
- **Suppliers** — two kinds: (a) **material suppliers** — third-party vendors for paint, chemicals, AC parts, etc.; (b) **manpower agencies** — PSARA-licensed agencies that supply sub-contracted security guards and soft-services staff (housekeeping, pantry, office boys). Skilled/certified service lines (AC technicians, pest control technicians, plantation) are directly employed by Solvesxx. See ADR-0010 for the per-service-line staffing model declaration.

The system ships as **two clients sharing one Supabase backend**:

- **Web app** (Next.js 16 App Router) — full feature surface, all roles.
- **Mobile app** (separate React Native codebase, lives at `../Solvesxx_mobile/`) — covers only **time-critical features** (the "immediate-action filter," see §17).

---

# 2. Stakeholders & Roles

The system has 16 active person-roles, partitioned by which side of the business they belong to.

## 2.1 Company-side roles (Solvesxx employees)

| Role | Access | Primary Responsibility |
|------|--------|------------------------|
| `super_admin` | Full + platform config | System administration, RBAC, integrations |
| `admin` | Full operational CRUD | Master data, request management, indents, contracts, billing |
| `company_md` | Executive read | Revenue analytics, YTD financials, growth forecasting |
| `company_hod` | Workforce + ops | Tickets, service requests, attendance oversight |
| `account` | Finance | Reconciliation, supplier bills, sale bills, payments |
| `storekeeper` | Inventory + GRN | GRN, stock alerts, RTV tickets, shortage notes |
| `site_supervisor` | Field ops | Service Acknowledgment, deployment oversight, attendance |
| `security_guard` | Guard interface | Panic alerts, daily checklists, visitor logging, GPS clock-in. *Sub-contracted personnel issued personal logins by Solvesxx (pragmatic v1 compromise — see ADR-0010). HRMS payroll does NOT apply to this role.* |
| `security_supervisor` | Guard oversight | Roster, attendance, behavior tickets. *Sub-contracted manpower agency supervisor.* |
| `ac_technician` | AC module | AC tickets, certifications, PPE, parts inventory |
| `pest_control_technician` | Pest module | Pest tickets, chemical expiry, PPE, scheduled services |
| `field_technician` | Field jobs | Plantation + general field jobs, GPS tracking, before/after photos |
| `delivery_agent` | Delivery | Material arrival logging at customer gate |

## 2.2 Customer-side roles (people inside a Buyer account)

| Role | Access | Primary Responsibility |
|------|--------|------------------------|
| `buyer` | Buyer portal | Place service / material requests, view invoices, submit feedback |
| `resident` | Resident portal | View flat info, manage visitors (invitations, approvals), view family directory |

A `buyer` is the contracting/ordering identity for a Buyer account (society admin, corporate procurement contact, or an individual resident in their personal-Buyer role). A `resident` is a person inside an onboarded society — they do not place orders in v1.

## 2.3 Supplier-side role

| Role | Access | Primary Responsibility |
|------|--------|------------------------|
| `supplier` | Supplier portal | Receive indents, manage POs, submit bills, upload delivery notes |

`supplier` replaces the legacy `vendor` role (they were duplicates).

## 2.4 Roles removed from v1

- The earlier ADR-0002 "site kiosk" concept is dropped — guards have person logins.
- The earlier ADR-0005 multi-membership model is dropped — one role per user.
- `society_manager` as a role is dropped — the role's web responsibilities are covered by `site_supervisor` (Company employee overseeing a customer site).
- `printing_staff` was initially considered as a dedicated role but dropped — printing tasks (visitor passes, ID cards, notices, ad-space bookings) are low-volume, all desk work, and fully covered by `admin`.

---

# 3. Service Catalog (v1)

The catalog is locked to the original client scope. Brochure additions (Legal CMS, AI Door Camera, Import/Export consultancy) are deferred to v2 (see §21).

## 3.1 Service lines (5)

| Code | Service | Sales Modes | Notes |
|------|---------|-------------|-------|
| `FM-SEC` | Facility Management & Security | `deployment`, `ticket` | Includes Grade A/B/C/D Guards, Gunman, Door Keeper, Housekeeping, Pantry, Office Boys as employee designations. |
| `AC-SVC` | Air Conditioner Services | `deployment` (AMC), `ticket` (repair), `material_order` (new AC + parts) | Multi-mode: AMC contract + complaint ticket + spare parts order. |
| `PLT-SVC` | Plantation Services | `deployment` (recurring) | Indoor + outdoor green spaces, seasonal planning. |
| `PRN-ADV` | Printing & Advertising | `material_order` (printing), `deployment` (ad-space booking) | Internal printing (visitor passes, ID cards, notices) + external ad-space booking. |
| `PST-CON` | Pest Control Services | `deployment` (recurring General Pest Control), `ticket` (specific infestation), `material_order` (chemicals) | Multi-mode. PPE-mandatory. Chemical expiry tracking. |

## 3.2 Material categories (8)

Sold as `material_order`-type service requests:

1. Security Panel & Door Controller Materials
2. Hot & Cold Beverages Materials
3. Eco-Friendly Disposable Solutions Materials (paper cups, plates, etc.)
4. Cleaning Essential Materials
5. Pest Control Materials
6. Air Fresheners Materials
7. Stationery Materials
8. Corporate Gifting Materials

Each category resolves to a list of SKUs in the Product Master.

---

# 4. Master Data

## 4.1 Company Module

| Master | Purpose |
|--------|---------|
| **Role Master** | Defines the 17 person-roles + their permission profiles. Drives RBAC. |
| **Designation Master** | Internal job titles (e.g., "Grade A Guard", "Senior AC Technician", "Housekeeping Supervisor"). Used in HRMS profile + payroll calculations. |
| **Employee Master** | Full internal staff records: personal info, designation, shift assignment, document uploads. Source of truth for the HRMS lifecycle (recruitment → payroll). |
| **User Master** | Supabase-Auth-linked user accounts. Enforces role-based access. Admin provisioning supports temporary password + structured invitation link with `must_change_password` flag for first-login enforcement. |
| **Company Location Master** | Physical sites (gates, wings, clubhouse, basement) with GPS coordinates. Used by geofencing during selfie clock-in. |

## 4.2 Supply Module Master

| Master | Purpose |
|--------|---------|
| **Product Category** | High-level classification (Cleaning, Pest, AC Spares, Beverages, Stationery, etc.). |
| **Product Subcategory** | Sub-level classification under a category. |
| **Product Master** | SKU library: name, product code, UoM, default rate. |
| **Supplier Master** | Vendor profile: contact, GSTIN, banking, payment terms, credit limit. Covers both material suppliers and manpower agencies. Suppliers self-manage from Supplier Portal. |
| **Supplier Wise Products** | Maps which material Suppliers stock which Products. Filters eligible suppliers when raising a material indent. |
| **Supplier Wise Product Rate** | Pre-negotiated purchase costs per product per material supplier. |
| **Sale Product Rate** | Default selling price for every Product. Acts as the catalog default for `material_order` line pricing (frozen on order at creation). |
| **Supplier Wise Services** | Maps which manpower-agency Suppliers cover which service lines (e.g., "Agency A → Security Guards, Housekeeping"). Filters eligible suppliers when raising a service indent. |
| **Supplier Wise Service Rate** | Pre-negotiated per-head/per-shift rate for sub-contracted personnel from each agency. Used to price SPO line items. |

## 4.3 Services Module Master

| Master | Purpose |
|--------|---------|
| **Daily Checklist Master** | Routine inspection points for Security / Housekeeping / Maintenance (yes/no + value-based questions). Photo evidence optional per item. |
| **Vendor Wise Services Master** | Links each (material) Supplier to the service categories whose materials they supply. Filters supplier choice during indent. |
| **Work Master** | Library of all task types (filter cleaning, gas top-up, lawn mowing, chemical spraying). Tracked as line items on a job. |
| **Services Wise Work Master** | Maps Work items to a parent Service (e.g., "Fogging" + "Gel Application" + "Chemical Spraying" all map to "Pest Control"). |

## 4.4 HRMS Module Master

| Master | Purpose |
|--------|---------|
| **Leave Type Master** | Sick / Casual / Paid leave categories with yearly quotas + carry-forward rules. |
| **Holiday Master** | National + regional holiday calendar. Drives holiday-pay and overtime calculations. |
| **Company Events** | Society meetings, training sessions, emergency drill scheduling + staff notifications. |

---

# 5. Service Modules

## 5.1 Facility Management & Security

### Grade-Based Personnel

Solvesxx categorizes its security and soft-services employees by grade and specialization. Used at deployment-creation time to match the right employee to the customer's requirement.

**Security Grades:**
- **Grade A/B** — High-end corporate / luxury residential. Premium skills.
- **Grade C/D** — Industrial / general perimeter security. Basic skills.

**Specialized Personnel:**
- **Gunman** — Licensed armed personnel for high-risk assets (banks, cash-in-transit).
- **Door Keeper** — Hospitality / access control / visitor management focus.

**Soft Services:**
- **Housekeeping** — Professional cleaning + maintenance staff.
- **Pantry** — Cafeteria / executive dining staff.
- **Office Boys / Girls** — Admin assistance + internal logistics.

### Security Command Center

Admin-facing view showing live employee roster with grade filter and GPS tracking. Real-time visibility into deployment status across all customer sites.

## 5.2 AC Services

### Technical Staff Management
- **Skill Mapping** — categorize technicians by expertise (Centralized Plant, Split AC, Window AC, Gas Charging Specialist).
- **Certifications** — store technical diplomas + safety training certificates per technician. Expiry tracked (§15).
- **Attendance & Geofencing** — selfie + GPS validation at customer site (§8.III).

### Equipment Supply (Inventory)
- **Stock Master** — refrigerant gas (R32/R410), capacitors, copper pipes, filters, remote controls.
- **Purchase Orders** — raise to suppliers when stock falls below reorder level.
- **Issue to Staff** — record which technician took which part for which job.
- **Reorder Alerts** — automatic notification at reorder threshold.

### Service & Maintenance Workflow
1. Resident or Buyer admin logs a complaint (e.g., "AC not cooling") → creates a `ticket`-type service request.
2. Technician is assigned and clicks **Start Work** (GPS-captured).
3. Technician uploads **Before** photo.
4. Technician issues parts from inventory if needed (linked to Stock Master).
5. Technician uploads **After** photo and clicks **Complete**.
6. Job session closes; sale invoice is generated unless covered by an active AMC `deployment`-type request.

## 5.3 Plantation Services

- Task and zone management with soil-health and greenery-density per zone.
- Seasonal planner for maintenance scheduling.
- Horticulture inventory connected to central stock.
- Recurring service via `deployment`-type service request.

## 5.4 Printing & Advertising

### Internal Printing (`material_order`)
- **Visitor Passes** — for long-term visitors / contractors.
- **ID Cards** — for staff, linked to Employee Profile.
- **Notices** — templates for water-cut alerts, meeting minutes.

### Advertising Management (`deployment`-shaped booking)
- **Ad-Space Master** — physical ad locations (lift posters, notice boards, entry-gate banners).
- **Ad Booking Workflow** — date-range booking + client details. Revenue tracked per booking.

## 5.5 Pest Control Services

### Technical Staff Management
- **Certification Storage** — hazardous-chemicals license (mandatory, expiry tracked).
- **PPE Checklist** — before starting a job, technician checks off Mask / Gloves / Eye Protection / Apron in the app. Submission persisted.
- **Attendance with Photo & GPS** — selfie + geofence at the treatment site.

### Pest Control Material

**Chemical Stock Master:**
- Insecticides / Pesticides (Deltamethrin, Imidacloprid)
- Rodenticides (rat bait stations, glue pads)
- Anti-termite solutions

**Material Controls:**
- **Request & Approval** — technicians request quantity; admin approves; system deducts from main store.
- **Expiry Alerts** — automated notifications when a chemical batch nears its "Best Before" date. Banner on pest-control dashboard for chemicals expiring within 30 days.
- **Spill Kit Inventory** — absorbent materials (clay, sawdust) and neutralizers.

### Service Workflow

**Scheduled Services (General Pest Control)** — `deployment`-type recurring.
- Recurring calendar (monthly drains, quarterly building perimeter).
- Before/After photos of treated areas.

**Complaint-Based Service** — `ticket`-type one-shot.
1. Resident raises a ticket for "Bed Bugs" or "Cockroaches."
2. Technician selects treatment type (Fogging, Spraying, Gel Application).
3. System auto-sends SMS/push to the resident: *"Pest control scheduled for today at 4 PM. Please keep kids/pets away and cover all food items."*

---

# 6. Security Guard Monitoring System

## I. Instant Panic Response

- **Surface:** `mobile-only` on Guard mobile app.
- **Trigger:** prominent panic button on Guard app home screen.
- **Action:** sends `critical`-priority notification to:
  - Site supervisor's mobile (push + SMS)
  - Society's `buyer` admin (push + SMS)
  - Company admin dashboard (in-app + SMS)
- **GPS capture:** guard's exact location at time of alert.
- **Resolution:** supervisor acknowledges; `resolved_by` + resolution notes recorded.

## II. Daily Operational Checklist

- **Surface:** `mobile-only` (guard) + `web-only` (admin review).
- Items: parking lights ON/OFF time, water motor pump status, gate/shutter lock verification.
- Photo evidence option per item.
- **Reminder:** if not completed by 09:00 AM, automatic SMS reminder to the guard via `checklist-reminders` edge function.

## III. Inactivity Alert System

- **Static Alert:** if a guard's GPS does not change for `guard_inactivity_threshold_minutes` (default 30, configurable in `system_config`), system triggers an "Inactivity Alert" → `high`-priority notification to site supervisor.
- **Edge Functions:** `check-guard-inactivity` + `inactivity-monitor` run continuously.

## IV. Emergency Contact Directory

- **Surface:** `mobile-only`.
- Quick-dial entries (one-tap call):
  - Police, Fire Brigade, Ambulance, Electrician/Plumber.
- Per-society override possible (society-tied medical services).

---

# 7. Visitor Management System

## I. Add Visitor Information

Five visitor types, each with its own retention/permission rules:

| Type | Captured fields | Photo? | Retention |
|------|-----------------|--------|-----------|
| `guest` | Name, Phone, Vehicle, Photo | required | 1 year |
| `daily_help` | Name, Phone, Saved profile (maid, driver, milkman, car cleaner) | first visit only | 3 years (rolling) |
| `vendor` | Name, Company (Amazon/Swiggy/etc.), Phone, Vehicle | optional | 1 year |
| `contractor` | Name, Phone, Photo, Multi-day pass dates | required | 3 years |
| `family_visit` | Name, Pre-declared by resident | optional | 1 year |

## II. Society Family Database

- **Data Structure:** Flat number, owner/tenant name, primary + secondary mobile numbers.
- **Resident Directory:** privacy-safe view exposing only **active** flat occupancies (resolved via `flat_occupancies.end_date IS NULL`). Guards can verify which flat a visitor is going to without seeing full personal details.

## III. Notification System

- **Automated SMS:** *"Dear Resident, [Visitor Name] is at the gate for [Flat No]."*
- **Push Notification:** if resident has the mobile app installed, instant push with visitor's photo.
- **Resident Approval:** resident taps Approve / Deny in the mobile app. Result fed back to guard's app.

## IV. Society Manager Dashboard (delivered via `site_supervisor` web view)

- Visitor stats (per day / week)
- Checklist status (green/red completion indicators)
- Panic logs + resolution history
- Staff attendance (clock-in/out times)
- Live guard map (GPS positions of active employees)

---

# 8. HRMS — Human Resource Management System

## I. Recruitment Process
1. **Job Requisition** — admin posts a requirement.
2. **Application Entry** — basic details, source (Agency / Referral), interview status.
3. **Background Verification (BGV)** — Police Verification, Address Verification, Education Verification, Employment Verification (status-tracked panel visible when candidate reaches `background_check`).
4. **Onboarding** — one-click conversion Candidate → Employee.

## II. Employee Profile
- Personal info: full name, blood group, DoB, emergency contact.
- Job details: employee ID, designation, date of joining, reporting manager.
- Shift assignment: mapped to specific shift timings.
- Specialized profiles for Technicians and Guards (certifications, grade, assigned location).

## III. Smart Attendance & Geofencing
- **Selfie Attendance** — selfie via app to clock in.
- **Geofencing** — check-in only works within `default_geo_fence_radius_meters` (default 50m, configurable in `system_config`) of the assigned Company Location.
- **Shift Compliance** — clock-in time validated against assigned shift start. Late minutes tracked per employee.
- **Auto-Punch Out** — `auto_punch_out_idle_employees` cron runs at 01:00 daily (`pg_cron`). Flags `is_auto_punch_out` and records `absent_breach` if applicable.

## IV. Employee Documents
- **Identity Proofs:** Aadhaar, PAN, Voter ID.
- **Security Licensing:** PSARA training certificates (mandatory for guards).
- **Police Verification Report:** mandatory PDF upload.
- **Document Expiry Alerts:** automated escalation per §15.

## V. Employee Leave
- Leave application via app.
- Manager approval workflow (push + in-app).
- Real-time leave balance (Sick / Casual).
- Leave types & quotas configurable by admin.

## VI. Employee Payroll
- **Earnings:** Basic + HRA + Special Allowance + OT.
- **Deductions:** PF, PT, ESIC.
- **Attendance Integration:** salary auto-calculated from "Present Days" using `log_date`-backed summaries.
- **Payslip Generation:** monthly via `generate_payroll_cycle()` RPC. Staff can download payslips directly.
- **OT Calculation:** overtime hours computed from attendance logs vs shift boundaries.

---

# 9. Inventory & Procurement

## 9.1 Buyer Workflow

### Order Request

1. Buyer admin logs into Buyer Portal → selects **Service Category** (Security Services, Housekeeping, AC, Pest Control, Plantation, Printing/Ads, etc.) **or Material Category** (Cleaning Essentials, Beverages, Stationery, etc.).
2. **For services (deployment-shaped):** selects Grade / Designation, headcount, shift timings, start date, deployment duration, site location.
3. **For materials (material_order-shaped):** selects products, quantities, delivery location.
4. **For complaints (ticket-shaped):** describes the issue, optional photos.
5. Request submitted → Solvesxx admin review.

### Buyer Dashboard

- **Active Subscriptions** — count of ongoing `deployment`-type service requests.
- **Pending Requests** — awaiting admin approval or supplier acceptance.
- **Expiring Soon** — deployments within 60 days of `end_date` (renewal prompt).
- **Active Services Detail** — service category + role, headcount, shift timings, start/end date, assigned personnel.
- **Pending Bills** — direct access to unpaid Sale Bills.
- **Quick Actions** — Renew, Cancel, Raise Ticket against an active deployment.
- **Service History** — past completed services with feedback ratings.

## 9.2 Solvesxx Admin Workflow

### Request Management
- **Accept** — moves request into procurement / deployment phase.
- **Pending** — places on hold for further review.
- **Reject** — formal denial with notification to Buyer.

### Indent Generation
Two paths, determined by the service line's `staffing_model` (see ADR-0010):

**Sub-contracted service lines (security, housekeeping, pantry, office boys):**
Admin generates a **Service Indent** specifying service type, grade/designation, headcount, shift timings, and target manpower agency (matched via Supplier Wise Services + Supplier Wise Service Rate). This routes through the SPO path.

**Direct-employed service lines (AC, pest control, plantation):**
Admin assigns existing HRMS employees from the roster to the customer's site for the contract period via `deployment_assignments`. No supplier dispatch.

**Material orders:**
Admin generates a **Material Indent** specifying products, quantities, target supplier (matched via Supplier Wise Products + Supplier Wise Product Rate).

### Purchase Orders

**Materials:** after supplier accepts the indent, admin issues a formal **Company Purchase Order (PO)**.
Lifecycle: `Indent Forward → Received PO → Dispatch PO → Material Received`.

**Sub-contracted services:** after manpower agency accepts the service indent, admin issues a **Service Purchase Order (SPO)**.
Lifecycle: `draft → sent_to_vendor → acknowledged → in_progress → delivery_note_uploaded → deployment_confirmed → completed`.

### GRN (Goods Received Note) — materials only
- Storekeeper performs **Quality Check** (Good / Damaged / Expired / Leaking) with mandatory photo evidence.
- Storekeeper performs **Quantity Check** — system auto-calculates shortage (Ordered − Received).
- If approved → items enter inventory.
- If rejected → an RTV ticket is created (§10).

### Service Deployment

**Sub-contracted path (SPO):**
1. Manpower agency uploads **Service Delivery Note** (SDN) — a list of personnel dispatched with credentials.
2. Site Supervisor reviews and confirms via **Service Acknowledgment**: headcount, grade/designation match verified against the SPO.
3. SPO status moves to `deployment_confirmed`.

**Direct-employed path (`deployment_assignments`):**
1. Admin assigns one or more Employees via `deployment_assignments`.
2. Site Supervisor verifies via Service Acknowledgment that the assigned employees match the requested grade/designation and headcount.
3. Status moves to `Deployment Confirmed`.

## 9.3 Supplier Workflow

### Material Supplier — Indent Response & Logistics
1. Supplier receives material indent notification.
2. Reviews stock availability.
3. Responds: **Indent Accept** or **Indent Reject** (cites reason).
4. Receives PO → marks **Received PO**.
5. Prepares goods → marks **Dispatch PO**.
6. Goods arrive → GRN performed by storekeeper.

### Material Supplier — Billing & Payment
1. Supplier submits Supplier Bill based on Supplier Wise Product Rate.
2. System generates a unique bill number via `generate_bill_number()` RPC.
3. Supplier uploads supporting documents to storage.
4. Admin reconciles bill against PO + GRN (§14).
5. Admin marks bill **Paid** after offline payment (§13).

### Manpower Agency Supplier — SPO Workflow
1. Agency receives service indent notification.
2. Reviews capacity for the requested grade/headcount.
3. Responds: **Indent Accept** or **Indent Reject**.
4. Receives SPO → acknowledges.
5. Prepares and dispatches personnel → uploads **Service Delivery Note** (personnel list with credentials).
6. Site Supervisor performs Service Acknowledgment.
7. Agency submits **Supplier Bill** linked to the SPO based on Supplier Wise Service Rate.
8. Admin marks bill **Paid** after offline payment (§13). No automated reconciliation for service contracts (§14).

## 9.4 Service Acknowledgment

- Performed by `site_supervisor` on first deployment day, for both staffing paths.
- **Sub-contracted path:** verifies personnel listed on the Service Delivery Note match the SPO (headcount, grade/designation).
- **Direct path:** verifies assigned employees match the `deployment_assignments` record.
- Verification fields: headcount expected vs received, grade/designation confirmed (boolean), notes.
- Status moves to `Deployment Confirmed` on the SPO or the service request.

## 9.5 Buyer Invoicing & Feedback

- **Sale Bill** — admin generates per accepted request. For `deployment`: monthly recurring (§12.2). For `material_order`/`ticket`: single invoice.
- Unique invoice number from `sale_invoice_seq`.
- Buyer sees invoices in Buyer Portal filtered by Buyer scope.
- Buyer marks payment via offline-then-record flow (§13).
- After bill marked Paid, Buyer is prompted to rate (§9.6).

## 9.6 Feedback (End of Cycle)

After the bill is paid, Buyer is prompted to rate:
- **Security:** Was the guard's conduct satisfactory? Was the grade correct?
- **Staffing:** Was the housekeeping staff punctual?
- **Materials:** Was quality as expected?

Rating: 1–5 stars + optional free-text. Submitted into `buyer_feedback`. Drives Vendor Performance Audit metrics.

The request reaches **END** state only after feedback is submitted and the bill is settled.

---

# 10. Tickets

## 10.1 Employee Behavior Tickets

**Created by:** `site_supervisor` or `security_supervisor`.

**Fields:**
- Employee Name/ID (dropdown from Employee Master).
- **Category:** Sleeping on Duty / Rudeness / Absence from Post / Grooming & Uniform / Unauthorized Entry.
- Incident Description.
- Media Upload (photo evidence).
- Date & Time (auto-captured).
- **Severity:** Low (Warning) / Medium (Serious) / High (Critical).

## 10.2 Quality & Quantity Tickets (GRN-Linked)

### Quality Check
- **Condition Status:** Good / Damaged / Expired / Leaking.
- **Photo Evidence:** mandatory.
- **Batch Number:** to track faulty lots from a vendor.
- If marked Bad: item flagged non-usable, blocked from inventory entry.

### Quantity Check
- Ordered Quantity vs Received Quantity.
- Shortage auto-calculated.
- System generates a **Shortage Note** sent to the vendor.

## 10.3 Return to Vendor (RTV) Tickets

- Triggered when material fails Quality or Quantity check.
- **Reason:** Wrong Item / Damaged / Quality Not as per Sample.
- Status tracked from creation through vendor resolution (replacement or credit note).
- Realtime subscription keeps dashboard live.

---

# 11. Customer Lifecycle

## 11.1 Onboarding (Hybrid)

- **Society & Corporate Buyer accounts:** **admin-provisioned only.** Admin enters the customer manually after a sales conversation. Self-serve corporate/society signup is not offered.
- **Individual Resident Buyer accounts:** **self-serve.** A resident wanting to order things personally (e.g., paper cups for their flat) registers via SMS OTP and creates their own `individual_resident` Buyer account.
- **Residents (inside an onboarded society):** self-serve with SMS OTP or society-supplied invite code. Once linked to their flat's active occupancy, they get the Resident portal.
- The existing `useWaitlist` hook is for inbound interest capture only — never auto-provisions a Buyer account.

## 11.2 Contract / Deployment Lifecycle

> **Data model note (v3.1):** The deployment contract lifecycle is carried on `service_requests` (with `type = 'deployment'`), not on the standalone `contracts` table in the codebase. The `contracts` table is a legacy artifact; do not build new features against it. All contract-adjacent columns (`monthly_amount`, `start_date`, `end_date`, `notice_days`, `auto_renew_terms`, `frozen_rates`) belong on `service_requests` rows of `type = 'deployment'`.

States for a `deployment`-type service request:

```
draft → active → terminated | expired | cancelled
```

- **`draft`** — admin building the request before customer accepts.
- **`active`** — customer accepted, deployment running.
- **`expired`** — `end_date` passed without renewal.
- **`cancelled`** — customer or admin cancelled before activation.
- **`terminated`** — terminated mid-life.

## 11.3 Cancellation & Termination

- One-sided termination with default 30-day notice (overridable per contract via `notice_days`).
- `termination_reason: cause | convenience`:
  - **Cause** — skips notice-period billing.
  - **Convenience** — notice-period billed in full.
- Buyer-side portal exposes "Request Termination" only — admin executes the state transition.
- On termination: bill for actuals through termination date, freeze the deployment roster, generate a final pro-rated invoice.

## 11.4 Renewal

- **D-60 alert:** at `end_date - 60 days`, system surfaces "Expiring Soon" in Buyer dashboard + Admin dashboard.
- **Renewal = new contract.** Pre-fills from old terms; rate-freezing semantics preserved.
- **Auto-renewal:** opt-in per contract (`auto_renew_terms` JSONB), default **off**.

## 11.5 Per-Contract Frozen Rates

- Catalog (`services.default_sale_unit_rate` / `Sale Product Rate`) holds **suggested defaults** only.
- At contract / order creation, customer-side rate and supplier-side rate are **copied into the row and frozen** for the contract's lifetime.
- Catalog rate changes never affect existing contracts.
- No separate `customer_rate_overrides` table — a customer with negotiated pricing simply has a contract whose rate differs from default.
- **No formal quote entity** in v1 — negotiation happens offline; system records agreed terms after handshake.

---

# 12. Billing & Tax

## 12.1 Material Orders (one-shot)

- Single sale invoice on delivery / completion.
- Line items at frozen per-item rates from contract creation.

## 12.2 Service Deployments — Fixed Monthly

- A `deployment`-type service request has a fixed `monthly_amount` agreed at creation.
- Invoiced **monthly, calendar-aligned (1st → last)**.
- **First cycle prorated** by days (e.g., start 12 May → first invoice = 20/31 × monthly_amount).
- **Customer-facing line is aggregated** — one line per service per month (e.g., "Security services — May 2026: ₹X").
- Attendance from HRMS is **not** an automatic billing input. SLA breaches trigger **manual credit notes** issued by admin on the next invoice.

## 12.3 Service Tickets

- Single sale invoice if not covered by an active deployment.
- If covered by active `deployment` + `services_wise_work_master` mapping → **free of charge** (included).

## 12.4 GST Tax Engine

Per ADR-0008:

- **`buyer_accounts.gstin`** captured at onboarding (nullable for `individual_resident`).
- **Catalog:** `services.sac_code` + `services.gst_rate` for service lines; `products.hsn_code` + `products.gst_rate` for materials.
- **Place of supply:**
  - `system_config.company_gst_state` = "27" (Maharashtra) for Solvesxx.
  - Same state → **CGST + SGST** (each half of total rate).
  - Different state → **IGST** (full rate).
- **Tax frozen at invoice issuance.** Subsequent rate changes don't retroactively alter issued invoices.
- **Reverse Charge (RCM):** supplier bills carry an `rcm_applicable` flag for cases where the Company pays GST to government rather than the supplier.

## 12.5 Credit Notes & Debit Notes

- Issued by admin only.
- **Credit Note:** reduces a previously-issued invoice (SLA breach refunds, returns, billing corrections).
- **Debit Note:** increases a previously-issued invoice (rare — usually a missed-charge addition).
- Both update GST liability tracking in the period of issuance, not retroactively.

---

# 13. Payments

**Per ADR-0007, v1 is record-only — no payment gateway.**

- `bill_status: pending | partially_paid | paid | overdue | written_off`
- `payment_method: upi | neft | rtgs | cheque | cash`
- `payment_reference` (UTR, cheque number)
- `paid_at`, `paid_amount` (for partial payments)
- Buyers pay via offline channels (UPI, bank transfer, cheque). Admin marks bills paid manually after bank reconciliation.
- "I paid — here's the UTR" submission from Buyer portal allows customers to flag a payment proactively.

---

# 14. Reconciliation

**Materials only — automated 3-way matching engine** (per ADR-0009 §5, unchanged by ADR-0010).

- **3-way:** PO ↔ GRN ↔ Supplier Bill.
- Mismatches surface in Admin's reconciliation dashboard with line-level drill-down.
- **Service deployments are NOT automatically reconciled.** Fixed monthly amount; no automated quantity-vs-delivery matching engine for services.
  - **Sub-contracted services (SPO path):** manpower agency supplier bills exist and are linked to the SPO (`purchase_bills.service_purchase_order_id`). Reconciliation is **manual** — the accounts team reviews SPO → Personnel Dispatched → Service Delivery Note → Supplier Bill and approves/rejects without a system-enforced 3-way engine.
  - **Direct-employed services (deployment_assignments path):** no supplier bill at all; cost is internal payroll, handled by HRMS.
- This means the automated reconciliation dashboard covers **material orders only**. Service supplier bill review is a manual accounts workflow in v1.

---

# 15. Compliance & Document Expiry

Per CONTEXT.md "Compliance & Document Expiry":

- Each compliance-relevant entity (Employee, Supplier, Buyer site fire-safety certs, technician certifications) carries a `compliance_documents` set: `document_type`, `issued_at`, `expires_at`, `file_url`.
- The `check-document-expiry` edge function runs daily (`pg_cron`) and escalates:

| Stage | Action |
|---|---|
| **D-90** | Notice in dashboards (subtle banner) |
| **D-30** | Push notification to owner + admin |
| **D-7** | Critical-tier notification + escalation to admin |
| **D+1 (expired)** | **Block dependent operations** (e.g., expired PSARA blocks a guard from being assigned to a deployment; expired gas-handling cert blocks AC tech from starting a cert-required ticket) |

Compliance percentage visible on MD Dashboard. Drives audit traceability for ISO 9001:2015.

---

# 16. Notifications

Three priority tiers drive routing and channel selection:

| Tier | Channels | Quiet Hours (22:00–07:00) |
|------|----------|---------------------------|
| `critical` | Push + SMS (MSG91) + In-app, **non-dismissable on mobile until ack** | Never suppressed |
| `high` | Push + In-app | Suppressed |
| `normal` | In-app only | Suppressed |

- SMS fires only for `critical` (cost discipline).
- Per-user opt-out allowed for `normal` only — never for `critical`.
- Stored in `notifications` table; delivered via:
  - **In-app notification bell** — realtime subscription, badge count, mark-as-read.
  - **SMS** — MSG91 via `send-notification` edge function.
  - **Push** — Firebase Cloud Messaging (FCM).

**Sources that produce notifications:**

| Source | Default Tier |
|---|---|
| Panic alert raised | `critical` |
| Panic alert acknowledged | `high` |
| Visitor at gate (resident) | `high` |
| Resident approves/denies visitor | `normal` |
| Service request status change | `normal` |
| New indent received (supplier) | `high` |
| PO status change | `normal` |
| GRN milestone | `normal` |
| Bill issued / Bill paid | `normal` |
| Chemical expiry warning | `high` |
| Document expiry D-7 | `critical` |
| Guard inactivity alert | `high` |
| Checklist not filled by 09:00 | `high` |
| Behavior ticket raised (severity High) | `critical` |
| Deployment "Expiring Soon" (D-60) | `normal` |
| Contract terminated | `high` |

**Settings page:** Admin can view live notification feed, configure operational thresholds (`checklist_completion_alert_threshold_percent`, `default_geo_fence_radius_meters`, `guard_inactivity_threshold_minutes`), and mark all as read.

---

# 17. Mobile App Surface (Time-Critical Filter)

**Per ADR-0003,** a feature belongs in the React Native mobile app **if and only if** it requires immediate action from the user. Everything else stays web-only.

## 17.1 Features in the mobile app

| Feature | Surface tag | Why |
|---|---|---|
| Panic alert (raise) | `mobile-only` | Field action |
| Panic alert (acknowledge) | `both` | Time-critical from desk too |
| Daily checklist (guard) | `mobile-only` | No desk for guards |
| GPS clock-in (selfie + geofence) | `mobile-only` | Only meaningful on phone |
| Visitor approval (resident) | `both` | Push notification core feature |
| Visitor logging (guard) | `mobile-only` | Field action at gate |
| New ticket assigned (technician) | `both` | Need to act quickly |
| Before/After photo upload (technician) | `mobile-only` | Camera-driven |
| PPE checklist (pest control / AC) | `mobile-only` | Pre-job mandatory |
| New indent received (supplier) | `both` | Time-bound bid |
| Material arrival logging (delivery agent) | `mobile-only` | At customer gate |
| Critical-tier notifications | `both` | Always |

## 17.2 Features NOT in the mobile app (web-only)

- Master data CRUD (employees, products, suppliers, services)
- Reports & analytics (any role's dashboard charts)
- Reconciliation
- Multi-line GRN entry (storekeeper)
- Bill / invoice review (`buyer`, `account`)
- Payroll administration
- Customer onboarding
- Settings / configuration
- Audit log review

## 17.3 Cross-codebase consistency

- The two codebases share the Supabase backend, RLS, and edge functions — but no UI code.
- The PRD is the contract that keeps both apps describing the same product.
- `both`-tagged features have double implementation cost — engineering must resist creep.
- The current mobile app at `../Solvesxx_mobile/` has more screens than the filter justifies; trim during the next mobile audit (see CATALOG-TODO §"Existing RN app inventory" in ADR-0003).

---

# 18. Edge Functions (Automated Backend)

| Function | Trigger | Purpose |
|----------|---------|---------|
| `send-notification` | On demand | SMS via MSG91 + Push via FCM |
| `check-document-expiry` | Daily (`pg_cron`) | Escalate compliance documents nearing expiry (§15) |
| `check-guard-inactivity` | Continuous | Detect guards with static GPS position |
| `inactivity-monitor` | Continuous | Broader inactivity monitoring (admins, suppliers) |
| `check-checklist` | On submission | Verify daily checklist completeness |
| `check-incomplete-checklists` | Scheduled | Flag checklists not filled by threshold time |
| `checklist-reminders` | Daily 09:00 | SMS reminder to guard if checklist unfilled |
| `auto_punch_out_idle_employees` | Daily 01:00 (`pg_cron`) | Auto-punch out employees still clocked in past shift end |
| `generate_recurring_sale_bills` | Monthly 1st 00:30 (`pg_cron`) | Create monthly invoices for active `deployment` requests |

---

# 19. Role-to-Module Access Matrix

Read as: ✅ = full access in scope; 🟡 = read-only / limited; — = no access.

## 19.1 Company-side roles

| Module | Admin | Super Admin | MD | HOD | Account | Storekeeper | Site Supervisor | Security Supervisor | Security Guard | AC Tech | Pest Tech | Field Tech | Delivery Agent | Printing Staff |
|--------|-------|-------------|----|----|---------|-------------|-----------------|--------------------|----------------|---------|-----------|------------|----------------|----------------|
| Master Data | ✅ | ✅ | — | 🟡 | — | — | — | — | — | — | — | — | — | — |
| Inventory / Products | ✅ | ✅ | — | — | — | ✅ | — | — | — | 🟡 | 🟡 | — | — | — |
| Purchase Orders | ✅ | ✅ | — | — | ✅ | ✅ | — | — | — | — | — | — | — | — |
| GRN | ✅ | ✅ | — | — | — | ✅ | — | — | — | — | — | — | — | — |
| Service Requests | ✅ | ✅ | — | ✅ | — | — | ✅ | — | — | ✅ | ✅ | ✅ | — | — |
| Finance | ✅ | ✅ | ✅ | — | ✅ | — | — | — | — | — | — | — | — | — |
| HRMS | ✅ | ✅ | — | ✅ | — | — | 🟡 | 🟡 | — | 🟡 | 🟡 | 🟡 | 🟡 | 🟡 |
| Attendance (own) | ✅ | ✅ | — | ✅ | — | — | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Tickets | ✅ | ✅ | — | ✅ | — | ✅ | ✅ | ✅ | 🟡 | — | — | — | — | — |
| Society / Visitors | ✅ | ✅ | — | — | — | — | ✅ | ✅ | ✅ | — | — | — | — | — |
| Assets | ✅ | ✅ | — | ✅ | — | ✅ | — | — | — | — | — | — | — | — |
| Reports | ✅ | ✅ | ✅ | — | ✅ | — | — | — | — | — | — | — | — | — |
| Admin Settings | ✅ | ✅ | — | — | — | — | — | — | — | — | — | — | — | — |
| Platform Config | — | ✅ | — | — | — | — | — | — | — | — | — | — | — | — |

## 19.2 Customer-side roles

| Module | Buyer | Resident |
|--------|-------|----------|
| Buyer Portal (orders, invoices, feedback) | ✅ | — |
| Resident Portal (flat info, visitors) | — | ✅ |
| Visitor Approval | — | ✅ |
| Family Directory | 🟡 | ✅ |
| Society's order history | ✅ | 🟡 (read-only) |

A `buyer` user only sees data scoped to their own Buyer account. A `resident` only sees data scoped to their active flat occupancy.

## 19.3 Supplier-side role

| Module | Supplier |
|--------|----------|
| Indent Inbox | ✅ |
| Purchase Orders | ✅ |
| Bills (submission + status) | ✅ |
| Profile self-service | ✅ |

A `supplier` user only sees data scoped to their own Supplier record.

---

# 20. Data Retention & Privacy

## 20.1 Retention policy

| Data class | Retention |
|---|---|
| Financial records (invoices, bills, payments, reconciliation) | **7 years** (regulatory, GST + Companies Act) |
| Employee records (active) | Lifetime of employment + 7 years post-termination |
| Audit logs | 7 years |
| Visitor logs | 1 year (rolling, except `daily_help` and `contractor` → 3 years) |
| Job session photos (before/after) | 1 year |
| Panic alert history | 3 years |
| Operational notifications | 90 days |

## 20.2 Privacy controls

- **PII storage** — employee documents, visitor photos, ID proofs: stored in private Supabase Storage buckets with RLS. Public URL signing only on request.
- **Resident Directory** view — exposes only flat number + display name. Hides full personal details from non-resident roles.
- **Audit log** — every write to sensitive tables logs `(actor_id, action, entity_type, entity_id, timestamp, ip_address)` to `audit_logs`. Searchable by admin only.

## 20.3 Single Time Zone

System runs on **Asia/Kolkata** for all timestamps. No multi-TZ support in v1.

## 20.4 Single Language

UI ships in **English only** in v1. Hindi + Marathi (regional) deferred to v2.

---

# 21. Deferred to v2

These items appeared in source artifacts (brochure or expanded discussions) but are **not built in v1**:

| Item | Source | v2 trigger |
|---|---|---|
| Legal Services CMS (cloud-based contract management with auto-renewal alerts) | Brochure | When the 2 lawyer-founders confirm the product is real revenue today |
| Door Security Camera with AI Facial Recognition + Tripwire | Brochure | When vendor (Hikvision / Dahua / Hanwha) is selected and pilot customer signed |
| Import & Export consultancy | Brochure | When this is real revenue (likely never platform-relevant) |
| Multi-tenant (license to other agencies) | Future possibility | When Solvesxx proves model and signs a second customer |
| Multi-membership identity (one user, many memberships) | Earlier ADR-0005 | When real users genuinely need to span Company + Customer scopes |
| Attendance-driven billing | Earlier ADR-0004 | When customers demand it; today they don't |
| Multi-language UI (Hindi, Marathi) | Indian market norm | When customers ask |
| Asset Management deep features (full CMMS) | Existing codebase has stub | When a customer pays for it |
| Resident self-service ordering with society approval workflow | Discussed but simplified | When society admins ask for more delegation to residents |
| Payment gateway integration (Razorpay) | Discussed | When retail volume from individual residents grows |
| E-invoicing (IRN/QR for GST) | Indian regulatory threshold | When Solvesxx turnover crosses ₹5 Cr |

---

# Appendix A — Glossary

See `.ai_context/CONTEXT.md` for the canonical project glossary. Key terms:

- **Company** — Solvesxx Powerful Solutions Pvt. Ltd. (singular, single-tenant deployment).
- **Buyer** — a Customer Account that places orders. Three types: `society`, `corporate`, `individual_resident`.
- **Supplier** — a third-party vendor. Two kinds in v1: (a) **material vendor** — supplies goods via PO/GRN flow; (b) **manpower agency** — PSARA-licensed agency that dispatches sub-contracted guards/housekeeping staff via the SPO flow.
- **Service Request** — the unified sales entity. `type` ∈ {`deployment`, `material_order`, `ticket`}.
- **Deployment** — a long-running personnel deployment (recurring contract).
- **Material Order** — a one-shot delivery of products.
- **Ticket** — an operational complaint or repair (free under active deployment, otherwise billed).
- **GRN** — Goods Received Note. Quality + Quantity check at material arrival.
- **RTV** — Return to Vendor ticket.
- **SPO** — Service Purchase Order. The procurement instrument for **sub-contracted service lines** (Security, Housekeeping, Pantry, Office Boys). Flow: indent → SPO → Personnel Dispatched → Service Delivery Note → Service Acknowledgment → Supplier Bill. Live in v1 per ADR-0010.
- **PO** — Purchase Order (materials only, in v1).

---

# Appendix B — Status Enums

## Service Request Status (any `type`)

```
draft → pending_approval → accepted → fulfilling → completed
                       ↓
                    rejected | cancelled
```

For `type=deployment`, `fulfilling` lasts months/years; for `type=material_order`, hours/days; for `type=ticket`, hours.

## Sale Bill Status

```
generated → partially_paid → paid
         ↓
       overdue | written_off
```

## Supplier Bill Status

```
pending → approved → paid
       ↓
     rejected
```

## Logistics Status (material_order only)

```
Indent Forward → Received PO → Dispatch PO → Material Received → GRN Approved → Inventory Updated
                                                              ↓
                                                            RTV Created
```

## Ticket Severity

`Low (Warning) | Medium (Serious) | High (Critical)`

## Notification Tier

`critical | high | normal`

---

# Appendix C — System Configuration Keys

Editable by `super_admin` from Admin Settings → Platform Config. Values:

| Key | Default | Purpose |
|---|---|---|
| `guard_inactivity_threshold_minutes` | 30 | Static-GPS alert threshold |
| `default_geo_fence_radius_meters` | 50 | Geofence radius for selfie clock-in |
| `checklist_completion_alert_threshold_percent` | 80 | Floor below which a society's checklist completion triggers an admin alert |
| `checklist_reminder_time` | "09:00" | Time-of-day for the daily checklist reminder SMS |
| `default_buyer_termination_notice_days` | 30 | Default termination notice period |
| `expiring_soon_alert_days` | 60 | Days-before-end_date for renewal alerts |
| `auto_punch_out_cron_time` | "01:00" | Auto-punch-out cron schedule |
| `recurring_billing_cron_time` | "00:30" | Monthly invoice generation time |
| `company_gst_state` | "27" | Maharashtra; drives CGST/SGST vs IGST split |

---

# Appendix D — Source Artifacts

- `Brochure.pdf` (client brochure, 4 pages)
- `Details Scope V-2.0.pdf` (original client scope, 14 pages)
- `.ai_context/CONTEXT.md` (canonical glossary + architectural notes)
- `docs/adr/0001` through `0009` (full decision history)
- `docs/CATALOG-TODO.md` (catalog confirmation worksheet — for client review)

---

**End of PRD v3.0**

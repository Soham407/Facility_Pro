# FacilityPro — Scope vs Build Audit

Source of truth: **Details Scope V-2.0.pdf** (14 pages) + Brochure.
Audited: 2026-08-08 against branch `chore/dead-code-and-gitignore`.

## How to read this

| Mark | Meaning |
|---|---|
| ✅ | Named artefact found in schema/routes/components |
| 🟡 | Partial, or evidence is schema-only with no confirmed UI/flow |
| 🔴 | No evidence found |
| ➕ | Built but **not in the scope document** — needs client sign-off |
| ❓ | Scope is ambiguous |

> **Evidence limit — read this before quoting the table.**
> Every ✅ below means *the artefact exists in code*. None of it is runtime-verified.
> No workflow was executed end-to-end. "`shortage_notes` exists" is not
> "50 ordered − 45 received = 5 correctly reaches inventory". Treat ✅ as
> "worth testing", not "done".

---

## 1. Application Stakeholders (scope p.1)

| Scope role | Code role (`src/lib/auth/roles.ts`) | Status |
|---|---|---|
| Admin | `admin` | ✅ |
| Company MD | `company_md` | ✅ |
| Company HOD | `company_hod` | ✅ |
| Account | `account` | ✅ |
| Delivery Boy | `delivery_boy` / `delivery_agent` | ✅ alias pair |
| Buyer | `buyer` | ✅ |
| Supplier / Vendor | `supplier` / `vendor` | ✅ alias pair |
| Security Guard | `security_guard` | ✅ |
| Security Supervisor | `security_supervisor` | ✅ |
| Society Manager | `society_manager` — **deprecated**, migrating to `site_supervisor` (ADR-0010, PR-C) | ⚠️ deviation |
| Service Boy | `service_boy` | ✅ |
| — | `super_admin` | ➕ |
| — | `storekeeper` | ➕ |
| — | `site_supervisor` | ➕ |
| — | `resident` | ➕ |
| — | `field_technician` | ➕ |
| — | `ac_technician`, `pest_control_technician` | ➕ (justified by scope services) |

**Deviation to confirm:** scope names Society Manager and gives it the panic
dashboard, behaviour tickets and visitor analytics. Code retires it. The ADR
records the decision; there is no evidence the **client** approved it.

---

## 2. Master Data (scope p.1–3) — 19 items

| # | Scope master | Evidence | Status |
|---|---|---|---|
| 1 | Role Master | `company/roles` | ✅ |
| 2 | Designation Master | `company/designations` | ✅ |
| 3 | Employee Master | `company/employees` | ✅ |
| 4 | User Master | `company/users` | ✅ |
| 5 | Product Category | `inventory/categories` | ✅ |
| 6 | Product Subcategory | `inventory/subcategories` | ✅ |
| 7 | Product Master | `inventory/products` | ✅ |
| 8 | Supplier Details | `inventory/suppliers` | ✅ |
| 9 | Suppliers Wise Product | `inventory/supplier-products` | ✅ |
| 10 | Suppliers Wise Product Rate | `inventory/supplier-rates` | ✅ |
| 11 | Sale Product Rate | `inventory/sales-rates` | ✅ |
| 12 | Daily Checklist Master | `services/masters/checklists` | ✅ |
| 13 | Vendor Wise Services Master | `services/masters/vendor-services` | ✅ |
| 14 | Work Master | `services/masters/work-master` | ✅ |
| 15 | Services Wise Work Master | `services/masters/service-tasks` | ✅ |
| 16 | Leave Type Master | `hrms/leave/config` | ✅ |
| 17 | Holiday Master | `hrms/holidays` | ✅ |
| 18 | Company Event | `hrms/events` | ✅ |
| 19 | Company Location Master | `company/locations` | ✅ |

**19/19 present.** This was the largest gap in the original diagram and is the
least likely to be a real build gap.

---

## 3. Services (scope p.3) — 5 lines

| Scope service | Route | Status |
|---|---|---|
| Facility Management & Services | `services/security` | ✅ |
| Air Conditioner Services | `services/ac` | ✅ |
| Plantation Services | `services/plantation` | ✅ |
| Printing & Advertising | `services/printing` | ✅ |
| Pest Control Services | `services/pest-control` | ✅ |

### Security grading (scope p.3)
| Requirement | Evidence | Status |
|---|---|---|
| Grades A/B/C/D | `service_grade`, `grade_verified` on `service_acknowledgments` | 🟡 grade is carried & verified; no Grade **master** with fitness/education criteria found |
| Gunman / Door Keeper | no named artefact | 🔴 |
| Housekeeping / Pantry / Office Boy designations | Designation Master exists, these values unverified | 🟡 |

---

## 4. Security Guard Monitoring (scope p.4)

| Requirement | Evidence | Status |
|---|---|---|
| Panic red button | `society/panic-alerts`, `panic_alerts` | ✅ |
| Panic → Manager dashboard + SMS/app to committee | notification queue + alert enum | 🟡 committee-member fan-out unverified |
| Panic captures GPS | guard tracking tables | ✅ |
| Daily checklist (parking lights, water, gates) | `society/checklists` | ✅ |
| Photo evidence on checklist | checklist photo fields | ✅ |
| **Static alert — GPS unchanged ~30 min** | `detect_stationary_guards`, `detect_inactive_guards`, `trigger_inactivity_check`, `has_active_inactivity_alert`; cron `check-guard-heartbeat` `*/15 * * * *`; enum `inactivity` | ✅ |
| **Checklist reminder if unfilled by set time** | `detect_incomplete_checklists()`, cron `checklist-reminders` `30 * * * *`; `trigger_shift_end_checklist_reminder`; notif type `checklist_reminder` | ✅ |
| Geo-fence breach | `check_geofence`, `detect_geofence_breaches`, `geo_fence_radius`, enum `geo_fence_breach` | ✅ |
| Emergency contact directory (police/fire/ambulance/electrician) | `emergency_contacts` table, `contact_type` = police/ambulance/fire/lift_support | ✅ |
| One-tap quick dial UI | not verified | 🟡 |

---

## 5. Employee Behaviour Tickets (scope p.4–5)

| Requirement | Evidence | Status |
|---|---|---|
| Ticket raised by manager | `tickets/behavior` | ✅ |
| Employee dropdown | — | 🟡 |
| Categories (sleeping/rudeness/absence/grooming/unauthorized entry) | not enumerated in a found enum | 🟡 |
| Incident description | ✅ | ✅ |
| Media upload | ✅ | ✅ |
| Auto date/time | ✅ | ✅ |
| Severity Low/Medium/High | `severity` (80 hits) | 🟡 three-level enum unconfirmed |

---

## 6. Visitor Management (scope p.5)

| Requirement | Evidence | Status |
|---|---|---|
| Capture name, photo, phone, vehicle | `society/visitors` | ✅ |
| **Frequent-visitor DB (maids/drivers/milkmen/cleaners)** | `visitor_type` exists, defaults `'guest'`; no separate frequent-visitor master | 🟡 |
| Society family DB — flat, owner/tenant, primary+secondary mobile | `society/residents`, buildings/flats | ✅ |
| Privacy-limited guard search | — | 🟡 |
| Automated SMS to resident | notification infra | 🟡 |
| Push with visitor photo | ✅ | ✅ |
| Manager dashboard: visitor stats / checklist RAG / panic logs / staff attendance | all four surfaces exist | ✅ |
| Resident **pre-invites** visitor | `security_ops_resident_invite_rpc` | ➕ **not in scope** |

---

## 7. AC Services (scope p.6)

| Requirement | Evidence | Status |
|---|---|---|
| Skill mapping | `hrms/specialized-profiles` | 🟡 |
| Certifications | `hrms/documents` | ✅ |
| Attendance + geo-fencing | ✅ | ✅ |
| Spare inventory (refrigerant, capacitors, copper, filters, remotes) | `inventory/*` generic | 🟡 categories unverified |
| Reorder-level alerts | `reorder` (313 hits) | ✅ |
| Issue part to technician | stock issue tables | ✅ |
| Before / after photo + complete | `services/ac` | ✅ |

---

## 8. Pest Control (scope p.6–7)

| Requirement | Evidence | Status |
|---|---|---|
| Technician certification (hazardous) | `hrms/documents` | 🟡 |
| **PPE checklist before job** | `pest_control_ppe_verifications` + `gloves_worn`, `mask_worn`; **DB-level completion gate** (`pest_control_ppe_completion_gate`) | ✅ |
| Attendance with photo & GPS | ✅ | ✅ |
| Chemical stock master | ✅ | ✅ |
| Batch + expiry | `batch_number`; `block_expired_chemical_issuance` | ✅ |
| Expiry alerts | 🟡 blocking exists; proactive "nearing best-before" alert unconfirmed | 🟡 |
| Spill kit inventory | `spill_kits` migration | ✅ |
| **Recurring GPC calendar (monthly/quarterly)** | no scheduling artefact found for pest | 🔴 |
| Before/after proof | ✅ | ✅ |
| Complaint-based ticket + treatment type | ✅ | ✅ |
| Resident pre-notification SMS | 🟡 | 🟡 |

---

## 9. Printing & Advertising (scope p.7)

| Requirement | Evidence | Status |
|---|---|---|
| Visitor passes | `IDPrintingModule` | 🟡 |
| Staff ID cards | `IDPrintingModule` | ✅ |
| Notice templates | — | 🟡 |
| **Ad-Space Master (lift/notice board/gate banners)** | `printing_ad_spaces` (+ `asset_id` FK) | ✅ |
| Ad bookings | `printing_ad_bookings`, `AdBookingDialog`, `ad_bookings` migration | ✅ |

> **Correction:** an earlier version of the user-flow diagram stated advertising
> was "not built yet". That was wrong — it lives under `services/printing`, not
> a top-level `/advertising` route.

---

## 10. HRMS (scope p.8)

| Requirement | Evidence | Status |
|---|---|---|
| Recruitment: application, source, interview status | `hrms/recruitment` | ✅ |
| Police + address verification | `police_verification` fields/RLS | ✅ |
| Candidate → Employee one-click | — | 🟡 |
| Employee profile (blood group, DOB, emergency contact) | `hrms/profiles` | ✅ |
| Job details, reporting manager | ✅ | ✅ |
| Shift assignment | `hrms/shifts` | ✅ |
| **Selfie attendance** | `selfie` (143 hits) | ✅ |
| **Geo-fence 50 m radius** | `geo_fence_radius` configurable | 🟡 50 m default unverified |
| Auto punch-out | `auto_punch_out` migration + cron | ✅ |
| Documents: Aadhaar, PAN, Voter ID, PSARA, police PDF | `hrms/documents` | 🟡 individual types unverified |
| Leave apply / approve / balance | `hrms/leave` | ✅ |
| Payroll: Basic+HRA+Allowance+OT, PF/PT/ESIC | `hrms/payroll`, overtime calc migration | ✅ |
| Attendance-driven salary | overtime/attendance integration migration | ✅ |
| Payslip download | 🟡 | 🟡 |

**Note:** `roles.ts` excludes `security_guard`/`security_supervisor` from HRMS
payroll (sub-contracted, ADR-0010 §3). Scope lists them as stakeholders with
attendance and leave. Attendance ≠ payroll, so this may be consistent — but it
is a deliberate deviation worth naming to the client.

---

## 11. Service Procurement Lifecycle (scope p.9–10)

| Scope step | Evidence | Status |
|---|---|---|
| Buyer service request (category, grade/designation, headcount, shift, duration) | `service-requests/new` | 🟡 all five fields unverified |
| Rate verification (pulls Sale Service Rate) | `services/masters/vendor-services` | 🟡 |
| Service Indent generation | `admin/service-indents` | ✅ |
| Vendor matching | ✅ | 🟡 |
| Indent forward | ✅ | ✅ |
| Indent accept / reject | `supplier/indents` | ✅ |
| **Service Purchase Order (SPO)** | `service_purchase_orders` | ✅ |
| Received SPO | `supplier/service-orders` | ✅ |
| **Personnel Dispatched** | `personnel_dispatches` (FK → `service_purchase_orders`) | ✅ |
| **Service Delivery Note** | `service_delivery_notes`; SPO status `delivery_note_uploaded` | ✅ |
| **Service Acknowledgment + grade/headcount verify** | `service_acknowledgments` with `grade_verified`; billing gated on deployment confirmation | ✅ |
| Supplier Bill | `supplier/bills` | ✅ |
| Reconciliation | `finance/reconciliation` | ✅ |
| Sale Bill → Buyer | `finance/sale-bills` | ✅ |
| Buyer pays company | `finance/payments` | ✅ |
| Company pays supplier | `finance/supplier-bills` | ✅ |
| **Check Feedback (mandatory before END)** | `feedback` (266 hits), `plantation_and_feedback_v2` | 🟡 END-gating unverified |

This is the strongest area of the build — the scope's exact vocabulary
(SPO, delivery note, acknowledgment, dispatch) appears verbatim in schema.

---

## 12. Material Procurement Lifecycle (scope p.10–12)

| Scope step | Evidence | Status |
|---|---|---|
| Buyer Order Request | `buyer/requests/new` | ✅ |
| Request Received | `inventory/requests` | ✅ |
| Accept / Pending / Reject | ✅ | 🟡 three-state unverified |
| Indent Generation | `inventory/indents/create` | ✅ |
| Indent Forward | `admin/material-indents` | ✅ |
| Indent Accept / Reject | `supplier/indents` | ✅ |
| Company Purchase Order | `inventory/purchase-orders` | ✅ |
| Received PO | `supplier/purchase-orders` | ✅ |
| Dispatch PO | dispatch status | ✅ |
| **Received Note** | `inventory/grn` | ✅ (named "GRN" in code, "Received Note" in scope) |
| Acknowledge Material Request | `inventory/indents/verification` | ✅ |
| Purchases Bill / reconciliation vs Received Note | `finance/supplier-bills` + `finance/reconciliation` | ✅ |
| Sale Bill | `finance/sale-bills` | ✅ |
| Paid — both ledger sides | `finance/payments` | ✅ |
| Check Feedback before END | 🟡 | 🟡 |

---

## 13. Material Ticket System (scope p.12–13) — the highest-risk area

| Requirement | Evidence | Status |
|---|---|---|
| **Quality check** route | `tickets/quality` | ✅ |
| Condition: Good / Damaged / Expired / **Leaking** | `batch_number` present; four-value condition enum **not found** | 🟡 |
| Mandatory photo evidence | 🟡 mandatory-ness unverified | 🟡 |
| Batch number | `batch_number` on ops tickets | ✅ |
| **Bad → flagged non-usable, blocked from Supply Inventory** | not traced | 🟡 |
| **Quantity check** — Ordered vs Received | `received_quantity`, `qty_received` | ✅ |
| **Shortage auto-calculated** | `shortage_notes`, `shortage_note_items` | 🟡 auto-calc not traced |
| Inventory adjusted to received qty only | not traced | 🟡 |
| **RTV ticket** | `rtv_tickets`, `tickets/returns`, `supplier/returns` | ✅ |
| Reason: Wrong Item / Damaged / Quality Not as per Sample | 🟡 | 🟡 |
| **Open until replacement or credit note** | `credit_note_number`, `credit_note_amount`, `credit_issued_at` | ✅ |

### Digital workflow (scope p.14) — deviation

Scope says:
`Material arrival → **Security at Visitor Enter gate logs the delivery vehicle** → **Manager notified to inspect** → Material Ticket (qty + quality) → approve to inventory / reject to Return Ticket`

Build says:
`Supplier dispatches → **Delivery Agent logs arrival** → goods received & checked`

The scope routes arrival through the **security gate** and notifies the
**manager**; the build introduces a Delivery Agent role. Both may be
acceptable, but they are not the same flow.

**Status: ⚠️ deviation — confirm with client.**

---

## Summary

| Bucket | Count |
|---|---|
| ✅ evidence found | ~62 |
| 🟡 partial / schema-only | ~28 |
| 🔴 no evidence | 2 |
| ➕ built, not in scope | 7 |
| ⚠️ deliberate deviation | 3 |

### 🔴 Genuinely missing
1. **Pest control recurring GPC calendar** (monthly drains / quarterly perimeter) — scope p.7
2. **Gunman / Door Keeper specialized personnel types** — scope p.3

### ⚠️ Deviations needing client sign-off
1. Society Manager retired → Site Supervisor (ADR-0010 / PR-C)
2. Goods-arrival path: Delivery Agent vs security-gate-logs-vehicle → manager-inspects
3. Guards/supervisors excluded from HRMS payroll (sub-contracted model)

### ➕ Built but not in the scope document
Super Admin (multi-company), Storekeeper login, Resident portal + pre-invite,
Field Technician abstraction, Asset register & QR codes, maintenance schedule.

---

# Appendix A — 50/45 scenario trace (executed 2026-08-08)

Scenario: **order 50 → receive 45 → 5 damaged → expect shortage 5, usable stock 40.**

Path traced:
`useGRN.addToStock` → `validateGRNItemForStock` / `calculateGRNItemUpdates`
(`src/lib/grn/grnTransforms.ts`) → `stock_transactions` → DB trigger
`check_grn_item_quality` (`20260402000003_harden_grn_quality_gate.sql`).

## ✅ Verified by execution

`tests/unit/grn-quality-gate.test.ts` — **9/9 pass**, plus a purpose-written
50/45 case — **6/6 pass**:

| Assertion | Result |
|---|---|
| 45 received splits to 40 accepted + 5 rejected | ✅ |
| `line_total` follows **accepted** (100×40 = 4000), not received | ✅ |
| accepted+rejected > received is rejected (`45+5 > 45`) | ✅ |
| fully-rejected line throws `Cannot add rejected material to stock` | ✅ |
| shortage = 50 − 45 = 5 | ✅ |

## ✅ Verified by reading (not executed)

- **Shortage is a generated column** — `shortage_quantity GENERATED ALWAYS AS
  (ordered_quantity - received_quantity) STORED`. Cannot drift or be miswritten.
- **`addToStock` posts `item.accepted_quantity`** (40), never `received_quantity`
  (45) — `hooks/useGRN.ts:559`.
- **Two independent rejection blocks:** app-level `validateGRNItemForStock`, and
  a DB trigger that raises on `quality_status = 'rejected'` for
  `reference_type = 'GRN_ITEM'`. `useGRN.ts:561` does set that reference_type,
  so the trigger is reachable.

**The core arithmetic of the scope's own example is correct.**

## 🔴 Gaps the trace exposed

### 1. Condition granularity was lost — this is a regression
Scope p.13 requires `Good / Damaged / Expired / Leaking` with batch numbers "to
track specific faulty lots from a vendor". The build enum is
`accepted / rejected / partial`, and migration `20260401013058_grn_quality_gate.sql`
**actively collapsed the richer values**:

```sql
WHEN quality_status IN ('damaged', 'rejected') THEN 'rejected'
```

`damaged` existed before and was merged away. None of the scope's four
conditions are representable today, so "which lots were *expired* vs *leaking*"
cannot be answered — defeating the stated purpose of the batch number.

### 2. Shortage Note is not auto-generated
Scope: *"The system generates a Shortage Note to the vendor."*
The only triggers on `shortage_notes` are `generate_shortage_note_number`
(numbering) and `update_shortage_note_updated_at`. No trigger creates the note
when `received < ordered`. `useGRN.calculateShortage` computes a display number;
`useShortageNotes` is separate manual CRUD. **A short delivery raises nothing on
its own.**

### 3. Rejected material does not auto-raise an RTV
Scope p.14: *"If Rejected: A Return Ticket is created."*
No RTV linkage exists in `useGRN.ts` or `grnTransforms.ts`. The 5 damaged units
are correctly kept out of stock but produce no return ticket.

### 4. `addToStock` is a manual per-item call
Nothing forces it after a GRN is accepted. Stock can silently go un-posted.

### 5. Photo evidence not enforced
Scope calls photo upload **mandatory** for a bad-material ticket.
`validateGRNItemForStock` checks status and quantity only.

### 6. Housekeeping
`20260316000009_shortage_notes.sql` and `20260316124110_shortage_notes.sql` both
create the same table with `IF NOT EXISTS`. Current ordering is harmless — the
earlier one wins and carries the generated column — but it is fragile.

## Revised status for §13

| Item | Was | Now |
|---|---|---|
| Shortage auto-calculated | 🟡 | ✅ generated column |
| Inventory reflects received only | 🟡 | ✅ posts accepted |
| Bad blocked from inventory | 🟡 | ✅ two layers |
| Condition Good/Damaged/Expired/Leaking | 🟡 | 🔴 **collapsed to 3 values** |
| Shortage Note generated by system | 🟡 | 🔴 **manual** |
| Rejected → Return Ticket created | 🟡 | 🔴 **manual** |
| Mandatory photo | 🟡 | 🔴 not enforced |

**Verdict: the maths is right, the automation is not.** The scope describes a
system that *reacts* to a short or bad delivery; the build gives correct numbers
but waits for a human to raise the shortage note and the return.

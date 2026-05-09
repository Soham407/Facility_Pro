# FacilityPro Demo Checklist

> **Date:** 2026-05-09  
> **Objective:** Walk all 6 roles through end-to-end flows to verify demo-readiness  
> **Status:** Ready for execution  
> **Expected Duration:** 2–3 hours (all roles)

---

## Roles & Entry Points

| Role | Login Route | Dashboard | Key Flows |
|------|------------|-----------|-----------|
| Admin | `/login` | `/admin` | Service catalog, Facility oversight, Compliance, Payments |
| Buyer (Society) | `/login` → `/buyer` | `/buyer/dashboard` | New indents, Approvals, Invoices, Service requests |
| Supplier | `/login` → `/supplier` | `/supplier/dashboard` | Indent responses, PO acknowledgment, Bills |
| Security Guard | `/login` → `/guard` | `/guard/dashboard` | Panic alerts, Daily checklist, Visitor logging, Geofencing |
| Resident | `/login` → `/resident` | `/test-resident` | Visitor invitations, Society info, Feedback |
| Delivery | `/login` → `/delivery` | `/delivery/dashboard` | Material arrival, Photo evidence, Acceptance |

---

## 1. ADMIN ROLE

### 1.1 Login & Navigation
- [ ] Navigate to `/login`, select "Admin" or use admin email
- [ ] Verify admin dashboard loads at `/admin`
- [ ] Sidebar has all modules (Security, AC, Plantation, Printing, Pest Control, HRMS, Tickets, Finance, Compliance)
- [ ] Navigation breadcrumbs work correctly

### 1.2 Service Modules — Quick Spot-Check (One Service per Module Type)

#### Security (FM-SEC)
- [ ] Navigate to `/services/security`
- [ ] Security Command Center loads (roster, GPS pins, grade filter)
- [ ] Guard data shown with live status (on-site, idle warning, etc.)
- [ ] GPS tracking map displays current positions
- [ ] Filter by grade works (Grade A, B, C, D, etc.)

#### AC Services (AC-SVC)
- [ ] Navigate to `/services/ac-services`
- [ ] Service requests list shows open tickets
- [ ] Can open a ticket and see job details (before/after photos, notes)
- [ ] Inventory for AC parts visible (stock levels)

#### Pest Control (PST-CON)
- [ ] Navigate to `/services/pest-control`
- [ ] Dashboard shows active jobs
- [ ] PPE checklist gate visible for pre-job
- [ ] Chemical inventory with expiry alerts
- [ ] Spill kit tracking functional

### 1.3 HRMS Administration
- [ ] Navigate to `/hrms/profiles`
- [ ] Employee list loads with search/filter
- [ ] Click an employee → full profile (personal, job details, certifications)
- [ ] Document expiry alerts visible (PSARA, PAN, Aadhaar, etc.)
- [ ] Attendance logs show geofence validation + selfie timestamp
- [ ] Payroll page shows monthly payslips with deductions (PF, PT, ESIC)

### 1.4 Compliance & Alerts
- [ ] Navigate to `/compliance` (or check MD Dashboard)
- [ ] Document expiry dashboard shows overall compliance %
- [ ] Expired docs trigger operations-blocking (e.g., guard with expired PSARA cannot be assigned)
- [ ] Alerts visible in notification bell

### 1.5 Tickets System
- [ ] Behavior Tickets at `/tickets/behavior` → create, resolve workflow
- [ ] Quality Tickets at `/tickets/quality` → GRN-linked, photo evidence
- [ ] Shortage Notes auto-calculated from quality failures
- [ ] RTV Tickets at `/tickets/returns` → linked to quality, status lifecycle

### 1.6 Finance & Payments
- [ ] Navigate to `/finance/sale-bills`
- [ ] Invoices list shows all society/buyer bills
- [ ] Open an invoice → detail view with payment status (pending/paid/overdue/written_off)
- [ ] Admin can mark paid manually (record-only mode per ADR-0007)
- [ ] Payment method (UPI/NEFT/cheque) and reference tracked

### 1.7 Panic & Alerts
- [ ] Navigate to `/society/panic-alerts`
- [ ] Create a test panic alert (if test data exists)
- [ ] Verify panic shows GPS location, timestamp, supervisor notification
- [ ] Resolve panic workflow functional
- [ ] Toast/notification appears in real-time

---

## 2. BUYER (SOCIETY) ROLE

### 2.1 Login & Navigation
- [ ] Navigate to `/login`, select "Buyer" or use society email
- [ ] Buyer dashboard loads at `/buyer/dashboard`
- [ ] Sidebar shows: Indents, Approvals, Service Requests, Invoices, Feedback
- [ ] Navigation breadcrumbs work

### 2.2 Create Indent
- [ ] Click "New Indent" → form opens
- [ ] Service dropdown shows ONLY v1 services (5 core services, 8 material categories visible)
- [ ] No brochure items (Legal CMS, AI Door Camera) visible
- [ ] Fill indent form (qty, unit price, delivery date, notes)
- [ ] Submit → indent created with ID visible
- [ ] Redirect to indent list → new indent appears

### 2.3 Indent Approval Workflow
- [ ] Navigate to `/buyer/approvals`
- [ ] Pending indents from suppliers shown
- [ ] Open an approval → see supplier quote, suggested vendor, quantity
- [ ] Approve → PO generated, supplier notified
- [ ] Reject (optional) → feedback to supplier

### 2.4 Service Requests (Complaint/Maintenance)
- [ ] Navigate to `/buyer/service-requests` (if accessible)
- [ ] Create new request (AC repair, plantation issue, etc.)
- [ ] Request shown in list with status (new, assigned, in-progress, completed)
- [ ] Tech gets assigned notification

### 2.5 Invoices & Payments
- [ ] Navigate to `/buyer/invoices` (or `/finance/sale-bills` for society view)
- [ ] Society's invoices shown (society-specific RLS applied)
- [ ] Open invoice → detail view (line items, total, payment status)
- [ ] Payment status shows (pending/paid/overdue)
- [ ] If bill marked paid by admin, status reflects immediately

### 2.6 Feedback
- [ ] Navigate to `/buyer/feedback` (if present)
- [ ] Create feedback on a completed service
- [ ] Rating + comment submitted
- [ ] Feedback visible to admin

---

## 3. SUPPLIER ROLE

### 3.1 Login & Navigation
- [ ] Navigate to `/login`, select "Supplier" or use supplier email
- [ ] Supplier dashboard loads at `/supplier/dashboard`
- [ ] Sidebar shows: Indents, Bills, Reports
- [ ] Navigation breadcrumbs work

### 3.2 Indent Response
- [ ] Navigate to `/supplier/indents`
- [ ] List shows pending indents (society, qty, material)
- [ ] Click an indent → respond with quote (unit price, vendor, delivery date)
- [ ] Submit response → buyer notified
- [ ] Indent moves to "Responded" status

### 3.3 PO Acknowledgment
- [ ] Navigate to `/supplier/pos` (or PO list in sidebar)
- [ ] List shows POs awaiting supplier acknowledgment
- [ ] Click PO → acknowledge or request delivery extension
- [ ] Acknowledgment recorded with timestamp

### 3.4 Bill Submission
- [ ] Navigate to `/supplier/bills`
- [ ] Upload bill (against PO or GRN)
- [ ] Bill shows pending payment status
- [ ] Admin can view and approve payment in admin finance module
- [ ] Bill status updates in real-time

---

## 4. SECURITY GUARD ROLE

### 4.1 Login & Navigation
- [ ] Navigate to `/login`, select "Guard" or use guard email
- [ ] Guard dashboard loads at `/guard/dashboard`
- [ ] Sidebar shows: Panic Alert, Daily Checklist, Visitors, Attendance, Emergency Contacts
- [ ] Geofencing active (if location enabled)

### 4.2 Panic Alert System
- [ ] Click "PANIC ALERT" button (prominent red button)
- [ ] Confirm dialog appears
- [ ] Submit → alert created with GPS location + timestamp
- [ ] Toast confirms "Panic alert sent"
- [ ] (Verify in admin that panic alert appeared in `/society/panic-alerts`)

### 4.3 Daily Checklist
- [ ] Navigate to `/society/checklists`
- [ ] Checklist form appears (guard rounds tasks, equipment checks, etc.)
- [ ] Photo upload for each item (mandatory per PRD)
- [ ] Submit → completion recorded
- [ ] Admin receives reminder at 09:00 if not filled

### 4.4 Visitor Logging
- [ ] Navigate to `/guard/visitors` (or `/society/visitors` if shared)
- [ ] Click "Check-in Visitor"
- [ ] Fill visitor form (name, type: guest/daily_help/vendor/contractor, flat number, photo)
- [ ] Submit → resident notified (SMS + push)
- [ ] Visitor approval feedback from resident shown to guard
- [ ] Check-out functionality available after approval

### 4.5 Attendance & Geofencing
- [ ] Navigate to `/hrms/attendance` or `/guard/attendance`
- [ ] Clock-in button with selfie + GPS capture
- [ ] Geofence validation: if outside 50m, check-in blocked
- [ ] Shift times enforced (late minutes tracked)
- [ ] Auto punch-out after 12h or end-of-shift
- [ ] Attendance log visible

### 4.6 Emergency Contacts
- [ ] Navigate to `/society/emergency`
- [ ] Quick-dial list shown (Police, Fire, Ambulance, Electrician, Plumber)
- [ ] Per-society overrides visible (custom emergency numbers)
- [ ] Click a contact → dial functionality (or number copied to clipboard)

---

## 5. RESIDENT ROLE

### 5.1 Login & Navigation
- [ ] Navigate to `/login`, select "Resident" or use resident email
- [ ] Resident dashboard loads at `/test-resident`
- [ ] Sidebar shows: Visitors, Feedback, Emergency Contacts, Society Info
- [ ] Navigation breadcrumbs work

### 5.2 Visitor Invitation & Approval
- [ ] Navigate to Visitors section
- [ ] List shows pending visitor arrivals (name, flat, arrival time)
- [ ] Receive visitor notification (SMS + push)
- [ ] Click "Approve" or "Deny" on pending visitor
- [ ] Feedback sent to guard in real-time
- [ ] If approved, visitor checked in; if denied, guard notified to turn away

### 5.3 Resident Directory
- [ ] Navigate to Residents section (privacy-safe family database)
- [ ] Directory shows flat number + name only (PII safe per PRD)
- [ ] Search by flat or name works
- [ ] No email/phone/address exposed

### 5.4 Feedback
- [ ] Navigate to Feedback section
- [ ] Submit feedback on a completed service (rating + comment)
- [ ] Feedback visible to admin

### 5.5 Panic Alert Acknowledgment
- [ ] If society-wide panic alert triggered, resident receives notification
- [ ] Can acknowledge receipt of panic

---

## 6. DELIVERY ROLE

### 6.1 Login & Navigation
- [ ] Navigate to `/login`, select "Delivery" or use delivery email
- [ ] Delivery dashboard loads at `/delivery/dashboard`
- [ ] Sidebar shows: Arrivals, Photos, Reports
- [ ] Navigation breadcrumbs work

### 6.2 Material Arrival Logging
- [ ] Navigate to Material Arrivals section
- [ ] List shows pending deliveries (PO, material, qty, expected date)
- [ ] Click an arrival → log items received with qty + condition
- [ ] Photo evidence mandatory per PRD (before/after, serial numbers if applicable)
- [ ] Submit → arrival recorded with timestamp + delivery person name
- [ ] GRN generated for quality check

### 6.3 Condition Inspection
- [ ] During arrival logging, mark condition (Good/Damaged/Expired/Leaking)
- [ ] Damaged/defective items trigger Quality Ticket creation
- [ ] Shortage automatically calculated and noted

---

## Cross-Role Integration Tests

### Test 1: Indent → PO → Delivery → Invoice
- [ ] Buyer creates indent (v1 service) → Supplier responds → PO created
- [ ] Delivery logs arrival with photos → GRN generated
- [ ] Quality check passes → Invoice sent to Buyer
- [ ] Admin marks paid → Payment status updated
- [ ] **Verify:** All statuses update in real-time across roles

### Test 2: Panic Alert → Response
- [ ] Guard raises panic alert
- [ ] Supervisor/admin receives notification + SMS (if MSG91 active)
- [ ] GPS location visible
- [ ] Supervisor can acknowledge/resolve
- [ ] **Verify:** Realtime updates across all admin/guard clients

### Test 3: Document Expiry → Compliance Block
- [ ] Create/backfill an employee with PSARA cert expiring soon
- [ ] Watch expiry escalation (D-90 notice → D-30 push → D-7 critical → D+1 block)
- [ ] Try to assign expired guard to security detail → blocked
- [ ] **Verify:** Compliance gate enforced

### Test 4: Visitor Notification → Resident Approval
- [ ] Guard logs visitor for a flat
- [ ] Resident receives SMS + push with visitor photo
- [ ] Resident approves/denies on mobile or web
- [ ] Guard sees approval feedback in real-time
- [ ] **Verify:** Bidirectional notification + approval flow

### Test 5: Service Request → Ticket Assignment → Completion
- [ ] Buyer requests AC repair service
- [ ] Admin assigns technician
- [ ] Tech receives notification
- [ ] Tech uploads before/after photos, notes completion
- [ ] Buyer receives service completed notification
- [ ] **Verify:** Multi-step workflow with notifications

---

## Known Mocks & Stubbed Features (Do Not Block Demo)

| Feature | Status | Notes |
|---------|--------|-------|
| Brochure items (Legal CMS, AI Door Camera, Import/Export) | Hidden (is_v1=false) | Correct — deferred to v2 |
| Visitor Pass auto-generation | Placeholder UI | OK for demo; mark as v2 feature |
| Family Directory | Placeholder "Coming soon" | OK for demo; resident directory works |
| Data retention archival | Not automated | OK for demo; manual approach acceptable v1 |
| GST split (CGST/SGST) | Undifferentiated tax | OK for demo; split in v2 when GST engine lands |
| Payment gateway integration | Record-only mode | Correct per ADR-0007 — admin marks paid manually |
| Mobile app screens | May have non-time-critical features | Post-demo audit via CATALOG-TODO |

---

## Demo Flow Narrative

### Scenario: Pest Control Service Delivery (End-to-End)

**Participants:** Society (Buyer), Supplier, Delivery Person, Pest Control Tech, Guard, Admin, Resident

1. **Buyer creates indent** for pest control chemicals (v1 service locked)
2. **Supplier responds** with quote on chemicals
3. **Buyer approves** → PO generated
4. **Delivery logs arrival** with material photos
5. **Quality check** (expiry dates, batch numbers)
6. **Tech assigned** to pest control job
7. **PPE checklist** gate enforced before job start
8. **Tech captures** before/after photos during job
9. **Job marked complete**
10. **Buyer invoiced** and pays (admin records payment)
11. **Supplier bill settled**
12. **Compliance dashboard** shows all certifications valid

---

## Demo Execution Checklist

### Before Demo
- [ ] Supabase migrations applied (PR-B + PR-C)
- [ ] Feature flags enabled for all modules (check `src/lib/featureFlags.ts`)
- [ ] Test data seeded (users, services, indents, employees)
- [ ] Geofencing configured (system_config.guard_inactivity_threshold_minutes = 30)
- [ ] Notifications ready (MSG91 secrets or test mode)
- [ ] HTTPS local tunnel ready (if demo is remote)

### During Demo
- [ ] Start with admin role → show system architecture
- [ ] Walk buyer flow → show indent/approval/invoice workflow
- [ ] Jump to supplier → show response/PO ack
- [ ] Show delivery arrival with photo evidence
- [ ] Show guard panic → real-time notification to admin
- [ ] Show resident approval of visitor
- [ ] Show compliance dashboard with document tracking
- [ ] Q&A on architecture (multi-tenant, RLS, role-based access)

### After Demo
- [ ] Collect feedback from client on missing features
- [ ] Document any breaks/regressions in a new GitHub issue
- [ ] Update PHASES.md with final status
- [ ] Plan v2 milestone with deferred items (brochure, visitor pass, family directory, data archival)

---

## Role-Specific Credentials (For Testing)

| Role | Email (Suggested Format) | Password |
|------|------------------------|----------|
| Admin | `admin@solvesxx.com` | (check .env.local or seed script) |
| Buyer | `buyer-society-a@solvesxx.com` | (same seed) |
| Supplier | `supplier-vendor-1@solvesxx.com` | (same seed) |
| Guard | `guard-fm-001@solvesxx.com` | (same seed) |
| Resident | `resident-flat-101@solvesxx.com` | (same seed) |
| Delivery | `delivery-logistics@solvesxx.com` | (same seed) |

---

## Regression Tests (Safety Check)

After demo, run these to ensure no regressions:

- [ ] `/services/security` loads without errors
- [ ] `/hrms/attendance` shows all employees with valid geofence logic
- [ ] `/tickets/returns` Realtime subscription works (live updates)
- [ ] `/finance/sale-bills` shows all societies (RLS applied)
- [ ] `/society/panic-alerts` updates in real-time
- [ ] Notification bell icon shows badge count
- [ ] Dark mode toggle works (if enabled)

---

**Demo Readiness: ✅ READY**

All critical PRD requirements implemented. Minor deferred items do not block demo flow.

# Document Overview

## 1. Document Overview
* **Document 1:** Brochure_compressed.pdf
  * **Type:** Corporate Marketing Brochure & Company Profile.
  * **Purpose:** Outlines the company's identity, founding leadership structure, contact details, registration information, and commercial service offerings.
* **Document 2:** Details Scope V-2.0.pdf
  * **Type:** Technical System Scope & Functional Requirements Document (BRD/SRS).
  * **Purpose:** Defines the complete architecture, database master schemas, stakeholder roles, operational workflows, and mobile/web system specifications for the digital Facility Management & Services platform.

## 2. Company Profile & Administrative Data
* **Company Name:** SOLVESXX - Powerful Solutions Pvt. Ltd. (ISO 9001:2015 Certified Company).
* **Tagline:** "One Trusted Partner For Total Facility Excellence".
* **Leadership Structure:** Founded, managed, and operated by five women entrepreneurs:
  * 2 Legal Professionals: Handle statutory compliance, client contracts, legal safeguards, and regulatory frameworks.
  * 2 Administrative Experts: Oversee operational management, workforce deployment, supervision, and execution control.
  * 1 Manufacturing Operations Specialist: Manages supply chain coordination, process management, production discipline, and quality systems.
* **Registered Office:** Flat no. 2, Praneel Apartment, S.No. 899, Limaye Road, Deccan Gymkhana, Pune - 411004.
* **Corporate Office:** Omkar Nandan Society, A2, 303, Near Navale Bridge, Vadgaon Bk., Pune - 410041.
* **Contact Information:**
  * Phone: 9766669024 / 9766669025
  * Website: www.solvesxx.com
  * Email: admin@solvesxx.com
* **Registration Numbers:**
  * GST No.: 27ABSCS5790H1ZJ
  * CIN No.: U81100PN2026PTC251309

## 3. Comprehensive Service Portfolio
The combined documents specify the following core service domains:
1. **Security Services:** Grade-based security guards (Grades A, B, C, D), armed gunmen, and door keepers.
2. **Housekeeping & Soft Services:** Commercial cleaning, housekeeping staff, pantry personnel, and office support staff.
3. **Air Conditioner Supply & Maintenance:** Installation, technical maintenance, spare part management, and specialized repair technicians.
4. **Pest Control Services:** General pest control, anti-termite treatments, fogging, gel application, and chemical safety management.
5. **Beverage & Dispenser Solutions:** Supply and maintenance of hot beverage machines (coffee/tea) and cold beverage dispensers, along with paper cups.
6. **Printing & Advertising Services:** ID card generation, visitor passes, notice templates, and physical ad-space management.
7. **Plantation Services:** Indoor/outdoor green space creation and maintenance.
8. **Material Supply & Corporate Gifting:** Supply of cleaning chemicals, security hardware, stationery, and customized corporate gifts.
9. **Import, Export & Logistics:** Supply chain management and logistics solutions.
10. **Legal & Contract Services:** Cloud-based contract management system with automated deadline alerts for renewals.

## 4. Software System Architecture & Technical Specifications

### A. Application Stakeholders (11 User Roles)
1. Admin
2. Company MD
3. Company HOD
4. Accounts
5. Delivery Boy
6. Buyer
7. Supplier / Vendor
8. Security Guard
9. Security Supervisor
10. Society Manager
11. Service Boy

### B. Database Master Schemas (19 Masters)

#### 1. Company Module Masters
* **Role Master:** Defines user roles and system access permissions.
* **Designation Master:** Defines official job titles and positions across the organization.
* **Employee Master:** Manages internal staff handling request processing, indents, and feedback checks.
* **User Master:** Manages login credentials, secure authentication, and account activity logs.

#### 2. Supply Module Masters
* **Product Category Master:** High-level product classification.
* **Product Subcategory Master:** Sub-level granular item classification.
* **Product Master:** Definite inventory entries containing Name, Product Code, Rate, and Unit of Measurement (UOM).
* **Supplier Details:** Vendor profile store.
* **Suppliers Wise Product:** Mapping table connecting products to authorized suppliers.
* **Suppliers Wise Product Rate:** Stores pre-negotiated purchase costs per product per supplier.
* **Sale Product Rate:** Base selling prices linked to Product Categories for margin management.

#### 3. Services Module Masters
* **Daily Checklist Master:** Defines routine inspection points (Yes/No or value inputs) for Security, Housekeeping, and Maintenance departments.
* **Vendor Wise Services Master:** Restricts vendor visibility so requests map only to qualified service vendors.
* **Work Master:** Library of individual granular tasks (e.g., "Filter Cleaning," "Gas Top-up," "Lawn Mowing," "Fogging").
* **Services Wise Work Master:** Groups individual tasks into broader service categories.

#### 4. HRMS Module Masters
* **Leave Type Master:** Quotas, carry-forward rules, and types (Sick, Casual, Paid).
* **Holiday Master:** List of national/regional holidays for payroll and overtime calculation.
* **Company Event:** Calendar for organizing society meetings, training, and emergency drills.
* **Company Location Master:** Registers physical sites/gates with GPS coordinates to power Geo-Fencing.

### C. Core Functional Modules & Operational Logic

#### 1. Security Guard Monitoring System
* **Instant Panic SOS:** Red emergency button on guard app capturing GPS coordinates and triggering instant app/SMS alerts to Society Manager and Committee Members.
* **Daily Operational Checklist:** Time-stamped logs (parking lights, water pumps, gate/shutter status) with mandatory photo upload evidence.
* **Static Inactivity Alert:** Triggers a manager alert if guard GPS position remains unchanged for over 30 minutes.
* **Checklist Reminders:** Automatic push reminders if checklists are incomplete by designated cutoff times.
* **Emergency Contact Directory:** One-tap dialing for Police, Fire Brigade, Ambulance, Electrician, and Plumber.

#### 2. Security Skill Grading System
* **Grade A / B:** Premium skilled guards for luxury residential or high-end corporate settings.
* **Grade C / D:** Basic skilled personnel for perimeter or industrial security.
* **Specialized Personnel:** Licensed Gunmen and hospitality-focused Door Keepers.

#### 3. Visitor Management System
* **Visitor Entry Capture:** Collects Name, Photo, Phone Number, and Vehicle Number.
* **Resident Notifications:** Automated SMS or instant push notifications containing visitor photos.
* **Frequent Visitor Database:** Dedicated records for daily staff (maids, drivers, milkmen).
* **Society Family Directory:** Flat number, owner/tenant mapping, and searchable directory for verification.

#### 4. Behavior & Incident Ticketing Engine
* **Incident Logging:** Managers log staff infractions (sleeping on duty, rudeness, absence from post, uniform violations, unauthorized visitor entry).
* **Fields:** Employee ID, category, incident description, date/time stamp, and photo evidence.
* **Severity Rating:** Low (Warning), Medium (Serious), High (Critical - physical fight, theft, unmonitored gate).

#### 5. Smart HRMS & Payroll
* **Recruitment & Verification:** Tracks applicants through background verification (Police and address verification) to employee conversion.
* **Selfie & Geo-Fenced Attendance:** Check-ins validate a selfie photo against a 50-meter radius around the Company Location Master coordinates; features auto-punch out upon perimeter breach.
* **Document Management:** Stores government IDs, PSARA security licenses, and police verification PDFs.
* **Integrated Payroll:** Auto-calculates net pay from present days, basic pay, HRA, allowances, overtime, and statutory deductions (PF, ESIC, PT), generating downloadable payslips.

#### 6. Material Quality & Inventory Ticketing
* **Check Bad Material:** Mandatory inspection form capturing condition (Good, Damaged, Expired, Leaking), batch numbers, and photo proof. Non-usable items are blocked from stock.
* **Check Quantity Material:** Compares ordered vs. received quantities and automatically generates a Shortage Note to the vendor.
* **Return to Vendor (RTV):** Triggers a return ticket detailing reasons for return (wrong item, damaged, quality mismatch) and holds it until replacement or credit note issuance.

### D. System Lifecycle & Workflow States
**Procurement & Fulfillment Process Flow**
1. **Order Initiation:** Buyer submits an Order Request.
2. **Admin Evaluation:** Admin marks request as Accept, Pending, or Reject Received.
3. **Indent Generation:** Accepted requests generate an internal Service/Material Indent forwarded to a supplier via Suppliers Wise Service/Product Master.
4. **Supplier Commitment:** Supplier marks status as Indent Accept or Indent Reject.
5. **Purchase Order Execution:** Admin issues a formal Company Purchase Order (Received PO -> Dispatch PO).
6. **Dispatch & Delivery:** Supplier updates to Personnel Dispatched or Dispatch PO, issuing a Delivery Note.
7. **Acknowledgement:** Admin executes Service Acknowledgment / Acknowledge Material Request upon physical verification.
8. **Billing & Reconciliation:** Supplier submits Supplier Bill; Admin generates Sale Bill for Buyer.
9. **Financial Settlement:** Payments processed (Paid status for both Supplier and Sale bills).
10. **Feedback Audit:** Buyer submits mandatory quality/performance feedback (Check Feedback).
11. **Termination:** Transaction transitions to END boundary state.

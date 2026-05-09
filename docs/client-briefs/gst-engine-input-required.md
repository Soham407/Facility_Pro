# GST Engine — Client Input Required Before Build

**To:** Solvesxx team  
**From:** FacilityPro development team  
**Date:** 2026-05-09  
**Priority:** High — blocks billing milestone  
**Response needed by:** [insert date — suggest 5 business days]

---

## Why We're Asking

The platform's billing module needs to generate GST-compliant invoices — correct SAC/HSN codes, the right CGST/SGST vs IGST split, and proper Reverse Charge treatment where applicable. These are statutory requirements under the GST Act; we cannot default or guess them. Getting them wrong creates liability for Solvesxx at the time of a GST audit.

The development team will build the GST engine once we have your answers. Building before we have them would mean re-migrating existing invoice data, which is expensive to undo.

---

## Question 1 — SAC Codes per Service Line

**What we need:** the correct SAC (Services Accounting Code) for each of Solvesxx's 5 service lines, confirmed with your CA or GST consultant.

**Why it matters:** SAC codes determine the GST rate and appear on every customer invoice. An incorrect SAC can trigger classification disputes during a GST audit.

**Draft codes for your CA to confirm or correct:**

| Service | Suggested SAC | Suggested GST Rate | Notes |
|---|---|---|---|
| Facility Management & Security (guards, housekeeping, pantry, office boys) | 998523 | 18% | "Investigation and security services" — confirm for housekeeping sub-category |
| AC Services (installation, maintenance, repair) | 998714 | 18% | "Maintenance and repair services for cooling equipment" |
| Pest Control Services | 998594 | 18% | "Disinfecting and exterminating services" |
| Plantation Services | 998533 | 18% | "Cleaning and maintenance services for buildings" — confirm if horticulture SAC is more appropriate |
| Printing & Advertising Services | 998912 | 18% | "Printing and reproduction services" |

**Please provide:** confirmed SAC + GST rate for each row, or corrections to the above.

---

## Question 2 — Will Solvesxx Ever Have Inter-State Customers?

**Background:** Solvesxx is registered in Maharashtra (GSTIN 27ABSCS5790H1ZJ). When both supplier (Solvesxx) and buyer are in Maharashtra, invoices carry **CGST + SGST** (each at half the applicable rate). When the buyer is in a different state, the invoice carries **IGST** at the full rate.

**The question:** Do any of Solvesxx's current or planned customers have their registered billing address outside Maharashtra?

- If **no** — we can simplify the billing engine to always output CGST + SGST. No IGST logic needed for v1.
- If **yes** — we need the full place-of-supply logic, which is more complex to build and test.

**Please confirm:** Maharashtra-only customers (yes/no), and if any exceptions, name which customers are inter-state.

---

## Question 3 — RCM Treatment for Manpower Agency Payments

**Background:** Solvesxx sub-contracts security guards and housekeeping staff through PSARA-licensed manpower agencies. When Solvesxx pays those agencies, GST may be handled under **Reverse Charge Mechanism (RCM)** depending on the supplier's registration status.

Under the GST Act (Notification 13/2017 — Central Tax Rate, as amended):
- If the manpower agency is a **registered supplier** → they charge GST on their invoice; Solvesxx pays it and can claim ITC. Normal forward charge.
- If the manpower agency is **unregistered** → RCM applies; Solvesxx pays the GST directly to the government and cannot claim ITC from the agency.

**The questions:**
1. Are all of Solvesxx's manpower agency suppliers GST-registered?
2. If any are unregistered, do you want the system to flag those supplier bills for RCM treatment, or will your accounts team handle RCM manually outside the system?

**Please confirm:** registration status of your manpower agency suppliers, and whether you want in-system RCM flagging or manual handling.

---

## Question 4 — Handling Existing Invoices (Backfill Strategy)

**Background:** The platform has issued a number of invoices since launch. These invoices currently store a single `tax_amount` field without the CGST/SGST/IGST breakdown that the GST engine will require.

**Options for existing invoices:**

| Option | Description | Trade-off |
|---|---|---|
| **A. Leave as-is** | Existing invoices keep the undifferentiated `tax_amount`. New invoices from the migration date forward carry the full CGST/SGST breakdown. | Clean cut-off; existing invoices can't be reconstructed in GST-compliant format if audited. |
| **B. Backfill with assumption** | Assume all existing invoices are intra-state (CGST + SGST split 50/50 of tax_amount) and compute the split programmatically. | Automated but assumes all historical customers were Maharashtra-based — could be wrong for any inter-state customer. |
| **C. Manual backfill** | Your accounts team reviews and annotates historical invoices in a spreadsheet; we import the corrections. | Accurate but labor-intensive. Recommended if volume is low (<50 invoices) or if you've had any inter-state customers. |

**Please confirm:** which option you'd like for invoices issued before the GST engine goes live. We recommend Option A for simplicity unless your CA advises otherwise for audit readiness.

---

## What Happens After We Have Your Answers

Once we receive responses to all four questions, the development team will:

1. Write a migration adding the required columns (`sac_code`, `gst_rate` on services; `hsn_code`, `gst_rate` on products; `gstin` on buyer accounts; `cgst_amount`, `sgst_amount`, `igst_amount` on invoice line items; `rcm_applicable` on supplier bills).
2. Seed the service catalog with confirmed SAC codes and rates.
3. Build the CGST/SGST vs IGST split logic based on your answer to Q2.
4. Add the RCM flag workflow based on your answer to Q3.
5. Handle the existing-invoice backfill per your answer to Q4.

Estimated build time after input received: **2–3 weeks** (schema + billing engine + invoice PDF template update).

---

## Summary of Decisions Needed

| # | Question | Blocking |
|---|---|---|
| Q1 | Confirm SAC codes + GST rates per service line | Invoice generation, GST filing |
| Q2 | Inter-state customers? (IGST ever applies?) | Tax split logic |
| Q3 | Manpower agency RCM: in-system or manual? | Supplier bill workflow |
| Q4 | Backfill strategy for existing invoices | Migration scope |

Please route Q1 and Q3 through your CA — these have statutory implications. Q2 and Q4 are business decisions you can answer directly.

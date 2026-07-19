# Service Catalog — From Client Brochure (Solvesxx Powerful Solutions Pvt. Ltd)

> Source: client-supplied brochure (`Brochure.pdf`, 2026-05-09). Updated from earlier hypothesis.

## Brochure-confirmed services

The brochure presents 12 service tiles plus 2 additional service lines mentioned in the About Us text. Aligning to the user's "around 13" framing:

| # | Service Line | Code (proposed) | Category | Sales modes | Staffing | Notes |
|---|---|---|---|---|---|---|
| 1 | Security Services | `SEC-SVC` | Security | `service_contract` | subcontracted | Brochure bundles "Security and Housekeeping" into one tile but they are operationally distinct — split. |
| 2 | Housekeeping | `HK-SVC` | Soft Services | `service_contract` | subcontracted | Split from the bundled security tile. |
| 3 | Pest Control | `PST-CON` | Technical | `service_contract` (recurring) + `service_ticket` (complaint) + `material_order` (chemicals) | direct | Confirms multi-mode. |
| 4 | AC Supply & Maintenance | `AC-SVC` | Technical | `material_order` (new AC sale + spare parts) + `service_contract` (AMC) + `service_ticket` (repair) | direct | Brochure title literally says "Supply AND Maintenance" — confirms the multi-mode hypothesis from earlier. |
| 5 | Door Security Camera (AI Facial Recognition + Tripwire) | `SURV-CAM` | Technical | `material_order` (camera install) + `service_contract` (monitoring/alerts) | direct or third-party integrated | **NEW — not in current PRD.** Hardware + AI software product. |
| 6 | Commercial Cleaning Chemicals | `CLN-CHEM` | Material Supply | `material_order` | n/a | **NEW — not in current PRD.** Eco-friendly chemicals + fragrances. |
| 7 | Hot Beverages (vending / supply) | `BEV-HOT` | Material Supply | `material_order` (recurring or one-shot) | n/a | **NEW — not in current PRD.** Coffee, tea blends. |
| 8 | Cold Beverages | `BEV-COLD` | Material Supply | `material_order` | n/a | **NEW — not in current PRD.** |
| 9 | Paper Cup | `PCUP` | Material Supply | `material_order` | n/a | Eco-friendly paper cups. Confirms the resident-buys-paper-cups example. |
| 10 | Corporate Gifting | `CORP-GIFT` | Material Supply | `material_order` | n/a | **NEW — not in current PRD.** Customized branded gifts. |
| 11 | Plantation Service | `PLT-SVC` | Plantation | `service_contract` | direct | Confirmed. |
| 12 | Legal Services (Contract Management System) | `LGL-CMS` | Legal / SaaS | `service_contract` (recurring SaaS subscription) | direct (in-house lawyers) | **NEW — not in current PRD.** Cloud-based contract repository with auto-renewal deadline alerts. Operated by the 2 lawyer-founders. |
| 13 | Import & Export (logistics + supply chain) | `IMP-EXP` | Logistics | `service_ticket` (project-based engagement) | direct (consultative) | **NEW — not in current PRD.** Likely consultative / brokerage; low platform footprint until v2. |
| (also) | Printing & Advertising | `PRN-ADV` | Printing & Ads | `material_order` + `service_contract` (ad-space booking) | direct | Mentioned in About Us text but not on brochure tiles. Confirm with client whether this is a current revenue stream or aspirational. |

That gives 13 brochure-tile services + Printing & Advertising. The user's "13" may already exclude Printing & Advertising — confirm.

## Items in the current PRD that do NOT appear in the brochure

These are in `docs/product/prd.md` today but the brochure does not list them. They may be **internal operations only** (not sellable services) or may have been removed from the offering. Confirm with client:

| PRD item | Disposition required |
|---|---|
| Pantry, Office Boys/Girls (under "Soft Services Staffing") | Offered as a sellable contract today, or just internal? |
| Gunman (armed personnel) | In the offering today, or aspirational? |
| Door Keeper | In the offering today, or aspirational? |
| Grade A/B vs Grade C/D Guard distinction | Real grade dimension on Security contracts, or marketing-page-only? |
| Printing — visitor passes, ID cards, notices | Internal operations (used by the Company itself for security) or sold as a separate paid line? |
| Ad-Space Booking | Real revenue stream (society lift-poster bookings, etc.) or aspirational? |

## Things the current PRD is entirely silent about

The brochure reveals these are real service lines that need PRD coverage:

1. **Hot Beverages, Cold Beverages, Paper Cup, Cleaning Chemicals, Corporate Gifting** — these are all `material_order`-shaped, not currently modeled with proper SKUs in `products`. May share infrastructure with generic Material Supply.
2. **Door Security Camera with AI Facial Recognition + Tripwire** — substantial new module. Hardware + software + monitoring service. Probably integrates with an external vendor's camera system; out-of-scope for v1 platform code, but billing/contract surface needs to exist.
3. **Legal Services CMS** — this is *itself* a SaaS product the agency sells. Implications:
   - Has a distinct customer-facing portal-within-a-portal (a CMS dashboard).
   - Recurring billing as a software subscription.
   - The 2 lawyer-founders are the operators; needs a `legal_admin` Company-scoped role.
   - Document-expiry alerting overlaps with our compliance engine — possibly the same engine, marketed differently.
4. **Import & Export** — consultative/brokerage. Probably a project entity (engagement), not a recurring contract. Could be modeled as a one-shot `service_ticket` with `project_metadata`, or deferred to v2.

## Confirmed Company facts (from brochure About Us)

These are facts about the deployment, not hypotheses:

- **Legal name:** Solvesxx Powerful Solutions Pvt. Ltd.
- **CIN:** U81100PN2026PTC251309 (incorporated 2026, Pune)
- **GSTIN:** 27ABSCS5790H1ZJ → **state code 27 = Maharashtra** (locks the GST place-of-supply default per ADR 0008).
- **ISO 9001:2015 certified** — quality management system in place; influences the audit-trail and compliance modules.
- **Founded by 5 women entrepreneurs with specialized roles:**
  - **2 Legal Professionals** — statutory compliance, contracts, regulatory frameworks, client legal safeguards. *These are the operators of the Legal Services CMS product.*
  - **2 Administrative Experts** — operational management, workforce supervision, deployment planning, execution control.
  - **1 Manufacturing Operations Specialist** — process management, supply chain, quality systems, production discipline.
- **Tagline pillars:** *Security | Maintenance | Hygiene | Infrastructure*
- **HQ:** Pune (Deccan Gymkhana registered, Vadgaon Bk corporate).
- **Contact:** admin@solvesxx.com, +91 9766669024 / 25, www.solvesxx.com.

## Implication: the "5 admins" are role-specialized

Earlier ADR 0005 modeled `admin` as a single Company-scoped role. The brochure reveals the 5 admins have distinct functional specializations:

- The 2 lawyers → operate Legal Services CMS, run compliance/contract review across all engagements.
- The 2 admin experts → operate workforce/deployment.
- The 1 manufacturing ops specialist → operates procurement/supply chain/quality.

This argues for splitting `admin` into capability-tagged roles (or at least permission profiles):

- `legal_admin` — Legal Services CMS, compliance docs, contract review, customer legal-safeguards UI.
- `operations_admin` — workforce, deployment, kiosk postings, ticket triage.
- `procurement_admin` — supplier mgmt, GRN reconciliation, inventory, quality.
- `super_admin` — anyone above + system config.

Day-to-day, any of the 5 can probably do anything (5 founders == flat hierarchy), but the functional partition is real. **Recommendation:** model these as **roles** with overlap allowed via multi-membership (ADR 0005 already supports this), AND default each founder to all 4 roles initially. Don't prematurely lock down who can do what until usage patterns prove the boundaries matter.

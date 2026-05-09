# 0008 — GST Tax Engine (Indian Place-of-Supply Compliant)

- **Status:** Accepted
- **Date:** 2026-05-09

## Context

The PRD does not address GST. This is a compliance gap for an Indian B2B platform. Customers (especially corporates and societies registered as housing-society co-ops) need GST-compliant invoices to claim input tax credit; the Company itself files monthly GST returns; mis-classification (CGST+SGST vs IGST, wrong HSN/SAC, retroactive rate edits) creates real legal exposure.

## Decision

### 1. GSTIN per Customer Account
`customer_accounts.gstin` is captured at onboarding (nullable for `individual_resident` who don't have one).

### 2. HSN/SAC + GST rate per catalog item
- `services.sac_code` and `services.gst_rate` for service lines.
- `products.hsn_code` and `products.gst_rate` for material products.
- Defaults at the catalog level; can be overridden per contract / per material order if necessary.

### 3. Place-of-supply driven CGST+SGST vs IGST split
- Company's home state of registration is configured once in `system_config.company_gst_state`.
- For each invoice, compare `customer_account.state` with `company_gst_state`.
  - Same state → CGST + SGST (each half of the total rate).
  - Different state → IGST (full rate, no split).
- `invoice_lines` carry `cgst_amount`, `sgst_amount`, `igst_amount` — exactly two of the three are zero per line.

### 4. Tax frozen at invoice issuance
Once an invoice is issued, the tax breakdown is locked. Subsequent catalog-rate or rule changes do not retroactively alter issued invoices. Corrections happen via credit notes / debit notes only.

### 5. Reverse charge for sub-contracted manpower
Sub-contracted manpower supply (security, housekeeping under SAC 9985) commonly attracts RCM (reverse charge mechanism). Supplier bills carry an `rcm_applicable` flag. When true, the Company pays GST to the government rather than the supplier, and the supplier's bill amount excludes GST.

## Alternatives Considered

| Option | Why rejected |
|---|---|
| **Skip GST for v1, retrofit later** | Retrofitting tax into already-issued invoices is a regulatory disaster. Tax must be in from invoice #1. |
| **Use Zoho Books / Tally for invoicing** | Decouples tax from the platform but doubles data entry and breaks the "single source of truth" principle for billing. |

## Consequences

**Good**
- Compliance-ready invoices from day one.
- Customers can claim input tax credit; corporates won't refuse to use the platform.
- Reverse-charge handling for sub-contracted manpower is correct (a frequent missed-detail in homegrown systems).

**Bad / costly**
- Catalog rows must carry HSN/SAC + GST rate — needs client confirmation per service/product (additional CATALOG-TODO work).
- Place-of-supply logic adds a column dependency (customer state) that must always be present.
- Credit-note / debit-note mechanics for corrections become first-class entities.

## Open follow-ups

- Credit-note and debit-note entities + their effect on the GST liability tracking.
- E-invoicing (IRN/QR) — required for businesses above turnover threshold. Probably not needed for v1, but design HSN/SAC capture so it's e-invoice-ready when the threshold is crossed.
- TDS handling on supplier bills (income tax, separate from GST).

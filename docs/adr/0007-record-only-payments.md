# 0007 — Record-Only Payments (No Gateway Integration in v1)

- **Status:** Accepted
- **Date:** 2026-05-09

## Context

The PRD describes invoices going `pending → paid` but is silent on *how* the money actually moves. Two options sit on the table:

- **Integrate a payment gateway (Razorpay / Stripe / PayU)** — customers pay inside the platform; receipts auto-update bill status.
- **Record-only** — the platform tracks bill status and payment metadata, but money moves outside the platform (UPI to a published account, bank transfer, cheque, cash). Admin manually marks bills paid after bank reconciliation.

## Decision

**Record-only for v1.**

The platform stores:
- `bill_status: pending | partially_paid | paid | overdue | written_off`
- `payment_method: upi | neft | rtgs | cheque | cash`
- `payment_reference` (UTR, cheque number, etc.)
- `paid_at`
- `paid_amount` (for partial-payment tracking)

Admin marks bills paid manually after verifying the bank statement.

## Why

- Indian B2B facility services are predominantly **invoice-and-bank-transfer**. Customers don't expect to pay a security guard contract via card.
- Payment gateway integration triggers PCI scope, KYC, dispute/refund mechanics, settlement reconciliation, gateway fees (~2%) — all of which deliver near-zero value when customers are going to bank-transfer anyway.
- Adds compliance surface (RBI reporting, gateway agreements) the 5-admin Company doesn't need to take on for v1.

## Alternatives Considered

| Option | Why rejected for now |
|---|---|
| **Integrate Razorpay from day one** | Compliance + operational burden out of proportion to value. Customers won't use it. |
| **UPI deep-links + manual marking** | Tempting middle ground (one-tap UPI from invoice page) but still requires admin to reconcile bank statement to bill, so the manual step doesn't go away. Defer until customers ask. |

## Consequences

**Good**
- Zero gateway dependency, zero PCI scope, zero settlement complexity.
- Admin's bank-reconciliation muscle is already strong — the platform just needs to record the result.

**Bad / costly**
- Cash-flow visibility lags real-world payment by however long it takes admin to reconcile (typically 1–3 days).
- "Why is my bill still showing pending when I paid yesterday?" becomes a recurring customer support question.

## Open follow-ups

- Add an in-app "I paid — here's the UTR" submission so the customer can flag a payment and admin can reconcile faster.
- Revisit gateway integration if/when retail volume from individual residents grows past a threshold.

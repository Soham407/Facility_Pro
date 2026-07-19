# PRD Gap Register

This is the execution backlog for `docs/archive/plans/prd-closure-plan.md`.
Sources used for classification:
- `docs/product/prd.md`
- `e2e/feature-matrix.ts`
- `docs/archive/audits/2026-02-prd-audit-report.md`

## Status Legend

- `implemented+verified`
- `implemented+partial`
- `implemented+unverified`
- `missing`

## Current Backlog

| Area | PRD Anchor | Classification | Evidence / Notes | Owner | Next Action |
|---|---|---|---|---|---|
| HRMS employee documents (PSARA + police) | `docs/product/prd.md` HRMS Employee Documents | implemented+verified | PSARA support aligned across hook labels, DB enum migration, and dashboard compliance query | Integration | Keep covered in HRMS contract checks |
| Recruitment to employee conversion (with user linkage) | `docs/product/prd.md` Recruitment + User Master | implemented+verified | Conversion now attempts `users` email match, sets `employees.auth_user_id`, updates `users.employee_id`, and blocks already-linked user remaps; guarded by HRMS contract assertions | Integration | Keep covered in HRMS contract checks |
| Leave type master visibility and workflow usage | `docs/product/prd.md` Leave Type Master + Employee Leave | implemented+verified | Leave config now links from the leave dashboard and the config route is browser-verified | Integration | Keep covered in HRMS browser/contract regression packs |
| Security panic/inactivity/checklist chain | `docs/product/prd.md` Security Guard Monitoring | implemented+verified | Guard workflow E2E is passing for routine/checklist/panic surface; explicit panic resolution and inactivity alert variants are now asserted in the interaction pack | Integration | Keep covered in guard/browser regression packs |
| AC technician workflow evidence | `docs/product/prd.md` AC Service workflow | implemented+verified | Wave-2 AC execution chain passes; photo evidence persistence is request-scoped with job-session linkage when available, and the no-session fallback branch is now asserted in the AC contract suite | Integration | Keep covered in AC browser/contract regression packs |
| Pest PPE/material/closure chain | `docs/product/prd.md` Pest Control workflow | implemented+verified | PPE submissions now carry `service_request_id`, auto-link the latest `job_session_id`, and the pest wave-2 browser proof now verifies the seeded PPE history row | Integration | Keep covered in pest/browser regression packs |
| Buyer/supplier fiscal closure + feedback boundary | `docs/product/prd.md` Financial Closure & Quality Audit | implemented+verified | Buyer flow is E2E green; procurement finance navigation suite is green; payout validation/force-match/reconciliation transition guards are now asserted in finance contracts; supplier payout UI now drives the payment-status transition end to end | Integration | Keep covered in finance/browser regression packs |
| Printing + ad-space operations | `docs/product/prd.md` Printing & Advertising Services | implemented+verified | Dedicated Playwright workflow now verifies page access, ad-space tab render path, ID-generation path in internal printing tab, and booking approval/revenue reflection | Integration | Keep covered in printing/browser regression packs |
| Procurement exception paths (bad material, shortage, RTV) | `docs/product/prd.md` Ticket Generation System | implemented+verified | Shortage-note and RTV branch contracts now explicitly lock the create/resolve and dispatch/accept/credit/reject paths | Integration | Keep covered in procurement contract packs |
| Alternate branch families (HRMS, admin lifecycle, event variants) | `docs/product/prd.md` + route/state families | implemented+verified | HRMS lifecycle, platform master, and visitor/admin lifecycle contract suites now cover the variant families called out in the backlog | Integration | Keep covered in family-specific contract packs |

## Verification Backlog

- Add/confirm wave-1 route/data checks for every PRD workflow family in `e2e/feature-matrix.ts`.
- Add/confirm wave-2 business chains for material workflows.
- Add targeted unit/contract tests for:
  - document compliance rules
  - recruitment conversion truth rules
  - technician request-scoped evidence/PPE/material writes
  - fiscal closure paid + feedback boundaries
- Update this register after each closure slice with changed classification and evidence links.

## Latest Validation Evidence (2026-04-07)

- `type-check`: `npm run type-check` passed after workflow changes.
- Targeted unit/contract suites passed:
  - `tests/unit/hrms-module.contract.test.ts`
  - `tests/unit/finance-module.contract.test.ts`
  - `tests/unit/feedback-gate.test.ts`
  - `tests/unit/service-ops-closure.contract.test.ts`
- E2E buyer suite status:
  - `npm run test:e2e:workflow:buyer` passed (`8 passed`) after fixing managed Next binary resolution in worktree startup scripts.
- E2E guard suite status:
  - `npm run test:e2e:workflow:guard` passed (`8 passed`).
- E2E wave-2 suite status:
  - `npm run test:e2e:features:wave2` passed (`6 passed`) including AC execution and HRMS attendance/leave/payroll chains.
- E2E procurement workflow suite status:
  - `npm run test:e2e:workflow:procurement` passed (`7 passed`) after route/assertion hardening in `e2e/admin-procurement.spec.ts`.
- E2E supplier billing settlement suite status:
  - `node scripts/run-playwright-suite.cjs full --manage-server --project=chromium e2e/supplier-po-bill-return-settlement.spec.ts` passed (`2 passed`) after seeding bills directly and driving the payout modal in UI.
- E2E guard society interaction pack status:
  - `node scripts/run-playwright-suite.cjs full --manage-server --project=chromium e2e/society-security-interactions.spec.ts --grep "inactivity alerts page filters and resolve action work"` passed (`1 passed`) after adding an explicit inactivity alert branch.
- E2E printing/ad-space dedicated suite status:
  - `node scripts/run-playwright-suite.cjs full --project=chromium --manage-server e2e/printing-advertising.spec.ts` passed (`2 passed`) after stabilizing the tab locators and approver employee lookup.
- E2E pest wave-2 workflow status:
  - `node scripts/run-playwright-suite.cjs full --manage-server --project=chromium e2e/features-wave2.spec.ts --grep "pest-job-chain workflow"` passed (`1 passed`) after seeding the request, job session, and PPE verification directly and verifying the browser history row.
- Final gate status:
  - `npm run type-check` passed.
  - `npm run test:unit` passed (`38 passed` test files).
  - `npm run test:e2e:features:wave1` passed (`70 passed`).
  - `npm run test:e2e:features:wave2` passed (`6 passed`) after workflow assertion hardening and wave-2 timeout normalization.
- New targeted contract validation:
  - `npx vitest run tests/unit/procurement-exception-paths.contract.test.ts` passed (`2 passed`).
- Result: workflow code changes are type-safe, unit-backed, and key browser-level workflow packs (buyer, guard, procurement, wave-2, printing/ad-space) are green in this environment.

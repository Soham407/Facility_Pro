# Solvesxx Web Docs

This folder is the home for web-app documents.

## Current Truth

- Workspace-wide current state lives in [root `STATUS.md`](../../STATUS.md) and [root `CONTEXT.md`](../../CONTEXT.md).
- Web-local current product/spec material lives under `docs/product/`.
- Web-local active planning material lives under `docs/planning/`.
- Web-local current demo guidance lives under `docs/demo/`.
- Web-local text audit artifacts live under `docs/audits/`.

## Structure

- `docs/product/` - active product/spec documents for the web app
- `docs/planning/` - active backlog and planning docs
- `docs/demo/` - current demo walkthrough material
- `docs/audits/` - generated or captured audit/result artifacts worth keeping
- `docs/client-briefs/` - external/client-facing source material and briefs
- `docs/release/` - release and readiness notes
- `docs/adr/` - architecture decisions
- `docs/agents/` - agent operating notes
- `docs/review/` - point-in-time review findings and fix logs; useful evidence, not current-state truth by default
- `docs/archive/` - historical plans, audits, prompts, closure campaigns, and demo-cycle material

## Code-Adjacent Docs

Some docs stay next to the code they describe:

- `security/README.md` - Playwright security baseline for `security/security-baseline.spec.ts`
- `performance/README.md` - k6 smoke guidance for `performance/k6-smoke.js`

## Exceptions

- `docs/reference_schema.sql` stays at the docs root because many review docs, prompts, and agent instructions reference it directly as the schema artifact.

# Project Documentation
> Generated: 2026-08-01T15:04:00+05:30 | Mode: FULL

## Tech Stack
- Runtime: Node.js (via Next.js)
- Language: TypeScript
- Framework: Next.js 16 App Router (React 19)
- Database: Supabase (PostgreSQL)
- Styling: Tailwind CSS 3.4
- State Management: React Context / Custom Hooks (Supabase client)

## Dependencies
- **Core**: react@19, next@16, @supabase/supabase-js, @supabase/ssr
- **UI**: tailwindcss@3.4, radix-ui (shadcn), framer-motion, lucide-react
- **Forms**: react-hook-form, zod, @hookform/resolvers
- **Testing**: vitest, @playwright/test

## Architecture Pattern
Feature-based Layered Architecture.
- UI components are separated into generic (`/components/ui/`), shared (`/components/shared/`), and feature-specific (`/components/[feature]/`).
- Data access is strictly isolated inside custom React hooks (`/hooks/use[Entity].ts`). Pages must not contain inline Supabase queries.

## Folder Structure
- `app/` - Next.js App Router (pages, layouts, api routes)
- `components/ui/` - shadcn/ui primitives
- `components/shared/` - Shared components like DataTable, PageHeader
- `components/[feature]/` - Feature-specific components
- `hooks/` - Data fetching and mutation hooks encapsulating Supabase logic
- `lib/` & `src/lib/` - Utilities, configuration, constants, feature flags
- `supabase/migrations/` - SQL schema migrations
- `tests/` & `e2e/` - Vitest unit/api tests and Playwright end-to-end tests

## Code Style Conventions
- **TypeScript**: `strict: false`, `strictNullChecks: false`. Do not add strict null checks to existing code.
- **Imports**: Use `@/` alias (e.g. `import { Button } from "@/components/ui/button"`).
- **Styling**: Tailwind CSS with HSL variables. Use semantic color tokens (`primary`, `destructive`, etc.).
- **Components**: Functional components using shadcn/ui patterns.

## Modularity Practices
- One hook per domain entity: `hooks/use[Entity].ts`.
- Hooks handle all data fetching, mutations, subscriptions, and state.
- Forms are wrapped in shadcn Dialogs.
- Shared utilities like `formatCurrency()` should be universally used.

## Data Architecture
- PostgreSQL via Supabase.
- Auto-generated types from `supabase-types.ts`.
- RLS (Row Level Security) controls access per role.
- Realtime subscriptions using Supabase channels.

## Cross-Cutting Concerns
- **Auth**: Handled by Supabase Auth (SSR client).
- **Roles**: Admin, Buyer, Supplier, Guard, Resident, Delivery. Roles map to specific dashboard routes.
- **Validation**: Zod schemas combined with react-hook-form.

## Service Communication
- REST-like RPC via Supabase js client.
- Deno Edge Functions for specific backend logic.

## Test Coverage
- Overall coverage: (Not strictly enforced, but CI exists)
- Testing framework: Vitest for Unit/API/RLS, Playwright for E2E.
- Key untested areas: N/A - extensive E2E suites exist.
- Test patterns used: unit / integration / e2e (smoke, full, visual, roles).

## Entry Points
- `app/layout.tsx`, `app/page.tsx`
- `package.json` scripts (`npm run dev`, `npm run test:e2e:full`)
- `.env.local` for environment setup

## Last Scanned
2026-08-01T15:04:00+05:30

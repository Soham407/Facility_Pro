-- PR-A step 2/2: Migrate user rows to renamed role values.
--
-- Depends on 20260509000002 having committed the new ENUM values first.
-- Supabase applies migrations in filename order; the transaction boundary
-- between files is what lets Postgres see the new enum values here.

UPDATE public.users SET role = 'delivery_agent'   WHERE role = 'delivery_boy';
UPDATE public.users SET role = 'field_technician' WHERE role = 'service_boy';
UPDATE public.users SET role = 'supplier'         WHERE role = 'vendor';

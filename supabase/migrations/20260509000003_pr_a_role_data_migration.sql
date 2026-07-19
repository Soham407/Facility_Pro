-- PR-A step 2/2: Migrate role master rows to renamed role values.
--
-- Depends on 20260509000002 having committed the new ENUM values first.
-- Supabase applies migrations in filename order; the transaction boundary
-- between files is what lets Postgres see the new enum values here.

UPDATE public.roles
SET role_name = 'delivery_agent',
    role_display_name = 'Delivery Agent',
    updated_at = now()
WHERE role_name = 'delivery_boy';

UPDATE public.roles
SET role_name = 'field_technician',
    role_display_name = 'Field Technician',
    updated_at = now()
WHERE role_name = 'service_boy';

UPDATE public.users
SET role_id = supplier_role.id,
    updated_at = now()
FROM public.roles vendor_role
CROSS JOIN public.roles supplier_role
WHERE public.users.role_id = vendor_role.id
  AND vendor_role.role_name = 'vendor'
  AND supplier_role.role_name = 'supplier';

UPDATE public.roles
SET is_active = false,
    updated_at = now()
WHERE role_name = 'vendor';

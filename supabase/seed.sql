-- =============================================================================
-- FacilityPro — Complete Test Seed Data
-- Run AFTER seed_guard_data.sql and seed_operations.sql
-- Safe to re-run: all inserts use ON CONFLICT DO NOTHING or WHERE NOT EXISTS
--
-- Test Accounts (password: Test@1234 for all):
--   admin@test.com       → admin             (pre-existing)
--   guard@test.com       → security_guard    (pre-existing)
--   resident@test.com    → resident          (pre-existing)
--   buyer@test.com       → buyer
--   supplier@test.com    → supplier
--   hod@test.com         → company_hod
--   md@test.com          → company_md
--   account@test.com     → account
--   delivery@test.com    → delivery_boy
--   storekeeper@test.com → storekeeper
--   supervisor@test.com  → security_supervisor
--   serviceboy@test.com  → service_boy
--
-- Fixed UUID prefixes used (all valid hex):
--   Auth/Public users:  aaaa0001-0000-0000-0000-00000000000x
--   Employees:          eeee0001-0000-0000-0000-00000000000x
--   Products (new):     generated dynamically with WHERE NOT EXISTS
--   Suppliers (new):    generated dynamically with WHERE NOT EXISTS
-- =============================================================================

-- =============================================================================
-- SECTION 1: MISSING ROLES
-- =============================================================================
INSERT INTO roles (role_name, role_display_name, is_active) VALUES
  ('admin', 'Admin', true),
  ('buyer', 'Buyer', true),
  ('supplier', 'Supplier', true),
  ('vendor', 'Vendor', true),
  ('security_guard', 'Security Guard', true),
  ('security_supervisor', 'Security Supervisor', true),
  ('society_manager', 'Society Manager', true),
  ('resident', 'Resident', true),
  ('account', 'Account', true),
  ('company_md',   'Company MD',   true),
  ('company_hod',  'Company HOD',  true),
  ('delivery_boy', 'Delivery Boy', true),
  ('service_boy',  'Service Boy',  true),
  ('storekeeper', 'Storekeeper', true),
  ('site_supervisor', 'Site Supervisor', true),
  ('super_admin', 'Super Admin', true),
  ('ac_technician', 'AC Technician', true),
  ('pest_control_technician', 'Pest Control Technician', true)
ON CONFLICT (role_name) DO NOTHING;

-- =============================================================================
-- SECTION 2: DESIGNATIONS
-- =============================================================================
INSERT INTO designations (designation_code, designation_name, department, is_active) VALUES
  ('DESG-HOD',  'Head of Department',       'Operations',   true),
  ('DESG-MD',   'Managing Director',        'Management',   true),
  ('DESG-ACCT', 'Account Manager',          'Finance',      true),
  ('DESG-DEL',  'Delivery Boy',             'Logistics',    true),
  ('DESG-SB',   'Service Boy',              'Services',     true),
  ('DESG-SK',   'Storekeeper',              'Inventory',    true),
  ('DESG-SUPS', 'Site Supervisor',          'Security',     true),
  ('DESG-ACT',  'AC Technician',            'Services',     true),
  ('DESG-PCT',  'Pest Control Technician',  'Services',     true),
  ('DESG-BUY',  'Procurement Officer',      'Procurement',  true),
  ('DESG-VSUP', 'Supplier Representative',  'Supply Chain', true)
ON CONFLICT (designation_code) DO NOTHING;

-- =============================================================================
-- SECTION 3: AUTH USERS (9 new accounts; resident@test.com already exists)
-- NOTE: Uses pgcrypto crypt() for bcrypt password hashing
-- =============================================================================
INSERT INTO auth.users (
  id, instance_id, aud, role, email, encrypted_password,
  email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
  created_at, updated_at, confirmation_token, recovery_token,
  email_change_token_new, email_change
)
SELECT
  id::uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
  email, crypt('Test@1234', gen_salt('bf', 10)),
  now(), '{"provider":"email","providers":["email"]}'::jsonb,
  json_build_object('full_name', full_name)::jsonb,
  now(), now(), '', '', '', ''
FROM (VALUES
  ('aaaa0001-0000-0000-0000-000000000001', 'buyer@test.com',        'Priya Sharma'),
  ('aaaa0001-0000-0000-0000-000000000002', 'supplier@test.com',     'Ramesh Patel'),
  ('aaaa0001-0000-0000-0000-000000000003', 'hod@test.com',          'Anita Desai'),
  ('aaaa0001-0000-0000-0000-000000000004', 'md@test.com',           'Vikram Mehta'),
  ('aaaa0001-0000-0000-0000-000000000005', 'account@test.com',      'Sunita Joshi'),
  ('aaaa0001-0000-0000-0000-000000000006', 'delivery@test.com',     'Raju Kumar'),
  ('aaaa0001-0000-0000-0000-000000000008', 'storekeeper@test.com',  'Dinesh Rao'),
  ('aaaa0001-0000-0000-0000-000000000009', 'supervisor@test.com',   'Mohan Verma'),
  ('aaaa0001-0000-0000-0000-000000000010', 'serviceboy@test.com',   'Anil Thakur')
) AS t(id, email, full_name)
WHERE NOT EXISTS (SELECT 1 FROM auth.users WHERE auth.users.email = t.email);

-- Auth identities for email login
INSERT INTO auth.identities (id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, provider_id)
SELECT
  gen_random_uuid(), id::uuid,
  json_build_object('sub', id, 'email', email)::jsonb,
  'email', now(), now(), now(), id
FROM (VALUES
  ('aaaa0001-0000-0000-0000-000000000001', 'buyer@test.com'),
  ('aaaa0001-0000-0000-0000-000000000002', 'supplier@test.com'),
  ('aaaa0001-0000-0000-0000-000000000003', 'hod@test.com'),
  ('aaaa0001-0000-0000-0000-000000000004', 'md@test.com'),
  ('aaaa0001-0000-0000-0000-000000000005', 'account@test.com'),
  ('aaaa0001-0000-0000-0000-000000000006', 'delivery@test.com'),
  ('aaaa0001-0000-0000-0000-000000000008', 'storekeeper@test.com'),
  ('aaaa0001-0000-0000-0000-000000000009', 'supervisor@test.com'),
  ('aaaa0001-0000-0000-0000-000000000010', 'serviceboy@test.com')
) AS t(id, email)
WHERE NOT EXISTS (SELECT 1 FROM auth.identities WHERE auth.identities.provider_id = t.id);

-- =============================================================================
-- SECTION 4: PUBLIC USERS (role assignments)
-- Resident already exists (78bf3c75-05e6-411c-8645-82baa99f7f19)
-- =============================================================================
INSERT INTO users (id, email, username, full_name, role_id, is_active, created_at)
SELECT
  t.id::uuid, t.email, t.email, t.email,
  (SELECT id FROM roles WHERE role_name = t.role_name::user_role LIMIT 1),
  true, now()
FROM (VALUES
  ('aaaa0001-0000-0000-0000-000000000001', 'buyer@test.com',        'buyer'),
  ('aaaa0001-0000-0000-0000-000000000002', 'supplier@test.com',     'supplier'),
  ('aaaa0001-0000-0000-0000-000000000003', 'hod@test.com',          'company_hod'),
  ('aaaa0001-0000-0000-0000-000000000004', 'md@test.com',           'company_md'),
  ('aaaa0001-0000-0000-0000-000000000005', 'account@test.com',      'account'),
  ('aaaa0001-0000-0000-0000-000000000006', 'delivery@test.com',     'delivery_boy'),
  ('aaaa0001-0000-0000-0000-000000000008', 'storekeeper@test.com',  'storekeeper'),
  ('aaaa0001-0000-0000-0000-000000000009', 'supervisor@test.com',   'security_supervisor'),
  ('aaaa0001-0000-0000-0000-000000000010', 'serviceboy@test.com',   'service_boy')
) AS t(id, email, role_name)
ON CONFLICT (id) DO NOTHING;

-- =============================================================================

-- =============================================================================
-- SECTION 6: PRODUCT CATEGORIES & PRODUCTS
-- =============================================================================
INSERT INTO product_categories (category_code, category_name, is_active) VALUES
  ('CAT-HK', 'Housekeeping Supplies', true)
ON CONFLICT (category_code) DO NOTHING;

DO $$
DECLARE v_hk uuid;
BEGIN
  SELECT id INTO v_hk FROM product_categories WHERE category_code = 'CAT-HK' LIMIT 1;
  INSERT INTO products (product_code, product_name, category_id, unit_of_measurement, is_active)
  VALUES ('PRD-HK-MOP', 'Mop Set (Spin Mop)', v_hk, 'Nos', true)
  ON CONFLICT DO NOTHING;
END $$;

-- =============================================================================
-- SECTION 8: SUPPLIERS & WAREHOUSES
-- =============================================================================
INSERT INTO suppliers (supplier_code, supplier_name, is_active, created_at)
VALUES ('SUP-HK-001', 'CleanCo Supplies Pvt Ltd', true, now())
ON CONFLICT DO NOTHING;

INSERT INTO warehouses (warehouse_code, warehouse_name, is_active, created_at)
VALUES ('WH-MAIN', 'Main Store', true, now())
ON CONFLICT (warehouse_code) DO NOTHING;

-- =============================================================================
-- SECTION 9: SOCIETIES, BUILDINGS, FLATS, RESIDENTS
-- =============================================================================
DO $$
DECLARE v_soc uuid; v_bldg uuid; v_flat uuid; v_res_user uuid;
BEGIN
  INSERT INTO societies (society_code, society_name, address)
  VALUES ('SOC-001', 'Test Society', 'Test Address')
  ON CONFLICT DO NOTHING
  RETURNING id INTO v_soc;

  IF v_soc IS NULL THEN
    SELECT id INTO v_soc FROM societies WHERE society_code = 'SOC-001' LIMIT 1;
  END IF;

  INSERT INTO buildings (society_id, building_code, building_name)
  VALUES (v_soc, 'BLDG-A', 'Tower A')
  ON CONFLICT DO NOTHING
  RETURNING id INTO v_bldg;

  IF v_bldg IS NULL THEN
    SELECT id INTO v_bldg FROM buildings WHERE building_code = 'BLDG-A' LIMIT 1;
  END IF;

  INSERT INTO flats (building_id, flat_number, floor_number, is_occupied)
  VALUES (v_bldg, '101', 1, true)
  ON CONFLICT DO NOTHING
  RETURNING id INTO v_flat;

  IF v_flat IS NULL THEN
    SELECT id INTO v_flat FROM flats WHERE flat_number = '101' LIMIT 1;
  END IF;

  SELECT id INTO v_res_user FROM users WHERE email = 'resident@test.com' LIMIT 1;

  INSERT INTO residents (resident_code, flat_id, full_name, email, auth_user_id)
  VALUES ('RES-001', v_flat, 'Resident User', 'resident@test.com', v_res_user)
  ON CONFLICT DO NOTHING;
END $$;

-- ============================================================
-- Migration: 20260523000001_mobile_role_rpcs.sql
-- Description: 20 RPC functions for mobile app role dashboards
-- Roles covered: HOD, Account, Storekeeper, Site Supervisor, MD, Admin, Super Admin
-- ============================================================

-- Add MD approval tracking columns to purchase_orders
ALTER TABLE public.purchase_orders
  ADD COLUMN IF NOT EXISTS md_action TEXT CHECK (md_action IN ('approved', 'rejected')),
  ADD COLUMN IF NOT EXISTS md_approved_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS md_approved_by UUID REFERENCES auth.users(id);

-- ============================================================
-- HOD (Head of Department) — 5 RPCs
-- ============================================================

CREATE OR REPLACE FUNCTION public.get_hod_summary(
  p_user_id UUID,
  p_company_id UUID
)
RETURNS TABLE (
  pending_leave_count INTEGER,
  attendance_rate    NUMERIC,
  team_size          INTEGER
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public
AS $$
DECLARE
  v_hod_emp UUID;
  v_team    INTEGER;
  v_pending INTEGER;
  v_present INTEGER;
BEGIN
  SELECT employee_id INTO v_hod_emp FROM users WHERE id = p_user_id;

  IF v_hod_emp IS NULL THEN
    RETURN QUERY SELECT 0, 0.0::NUMERIC, 0;
    RETURN;
  END IF;

  SELECT COUNT(*) INTO v_team
  FROM employees
  WHERE reporting_to = v_hod_emp AND is_active = true;

  SELECT COUNT(*) INTO v_pending
  FROM leave_applications la
  JOIN employees e ON e.id = la.employee_id
  WHERE e.reporting_to = v_hod_emp AND e.is_active = true AND la.status = 'pending';

  SELECT COUNT(*) INTO v_present
  FROM attendance_logs al
  JOIN employees e ON e.id = al.employee_id
  WHERE e.reporting_to = v_hod_emp
    AND e.is_active = true
    AND al.log_date = CURRENT_DATE
    AND al.status = 'present';

  RETURN QUERY SELECT
    v_pending::INTEGER,
    CASE WHEN v_team > 0 THEN ROUND((v_present::NUMERIC / v_team) * 100, 1) ELSE 0.0 END,
    v_team::INTEGER;
END;
$$;


CREATE OR REPLACE FUNCTION public.get_hod_leave_requests(
  p_user_id   UUID,
  p_company_id UUID
)
RETURNS TABLE (
  id            UUID,
  employee_name TEXT,
  leave_type    TEXT,
  start_date    DATE,
  end_date      DATE,
  reason        TEXT,
  status        TEXT
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public
AS $$
DECLARE
  v_hod_emp UUID;
BEGIN
  SELECT employee_id INTO v_hod_emp FROM users WHERE id = p_user_id;
  IF v_hod_emp IS NULL THEN RETURN; END IF;

  RETURN QUERY
  SELECT
    la.id,
    (e.first_name || ' ' || e.last_name)::TEXT,
    lt.leave_name::TEXT,
    la.from_date,
    la.to_date,
    la.reason::TEXT,
    la.status::TEXT
  FROM leave_applications la
  JOIN employees  e  ON e.id  = la.employee_id
  JOIN leave_types lt ON lt.id = la.leave_type_id
  WHERE e.reporting_to = v_hod_emp
    AND e.is_active = true
    AND la.status = 'pending'
  ORDER BY la.created_at DESC;
END;
$$;


CREATE OR REPLACE FUNCTION public.get_hod_team_members(
  p_user_id    UUID,
  p_company_id UUID
)
RETURNS TABLE (
  id               UUID,
  name             TEXT,
  designation      TEXT,
  attendance_status TEXT
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public
AS $$
DECLARE
  v_hod_emp UUID;
BEGIN
  SELECT employee_id INTO v_hod_emp FROM users WHERE id = p_user_id;
  IF v_hod_emp IS NULL THEN RETURN; END IF;

  RETURN QUERY
  SELECT
    e.id,
    (e.first_name || ' ' || e.last_name)::TEXT,
    COALESCE(d.designation_name, 'Associate')::TEXT,
    COALESCE(
      (SELECT al.status FROM attendance_logs al
       WHERE al.employee_id = e.id AND al.log_date = CURRENT_DATE LIMIT 1),
      'unknown'
    )::TEXT
  FROM employees e
  LEFT JOIN designations d ON d.id = e.designation_id
  WHERE e.reporting_to = v_hod_emp AND e.is_active = true
  ORDER BY e.first_name, e.last_name;
END;
$$;


CREATE OR REPLACE FUNCTION public.approve_leave_request(
  p_leave_id    UUID,
  p_approver_id UUID
)
RETURNS VOID
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public
AS $$
DECLARE v_emp UUID;
BEGIN
  SELECT employee_id INTO v_emp FROM users WHERE id = p_approver_id;
  UPDATE leave_applications
  SET status = 'approved', approved_by = v_emp, approved_at = NOW(), updated_at = NOW()
  WHERE id = p_leave_id AND status = 'pending';
END;
$$;


CREATE OR REPLACE FUNCTION public.reject_leave_request(
  p_leave_id    UUID,
  p_approver_id UUID
)
RETURNS VOID
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public
AS $$
DECLARE v_emp UUID;
BEGIN
  SELECT employee_id INTO v_emp FROM users WHERE id = p_approver_id;
  UPDATE leave_applications
  SET status = 'rejected', approved_by = v_emp, approved_at = NOW(), updated_at = NOW()
  WHERE id = p_leave_id AND status = 'pending';
END;
$$;


-- ============================================================
-- ACCOUNT — 1 RPC
-- ============================================================

CREATE OR REPLACE FUNCTION public.get_account_finance_summary(
  p_company_id UUID,
  p_user_id    UUID
)
RETURNS TABLE (
  today_collections      BIGINT,
  outstanding_receivables BIGINT,
  pending_bills_count    INTEGER,
  overdue_pmt_count      INTEGER
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public
AS $$
BEGIN
  RETURN QUERY SELECT
    -- Today's collections via updated_at proxy (payment recorded today)
    COALESCE((
      SELECT SUM(paid_amount)
      FROM sale_bills
      WHERE DATE(updated_at) = CURRENT_DATE
        AND paid_amount > 0
        AND (p_company_id IS NULL OR client_id = p_company_id)
    ), 0)::BIGINT,

    -- Outstanding receivables
    COALESCE((
      SELECT SUM(due_amount)
      FROM sale_bills
      WHERE payment_status IN ('unpaid', 'partial', 'overdue')
        AND (p_company_id IS NULL OR client_id = p_company_id)
    ), 0)::BIGINT,

    -- Unpaid purchase bills
    COALESCE((
      SELECT COUNT(*)::INTEGER
      FROM purchase_bills
      WHERE payment_status = 'unpaid'
        AND status NOT IN ('disputed')
    ), 0)::INTEGER,

    -- Overdue sale invoices
    COALESCE((
      SELECT COUNT(*)::INTEGER
      FROM sale_bills
      WHERE (payment_status = 'overdue'
             OR (due_date < CURRENT_DATE AND payment_status != 'paid'))
        AND (p_company_id IS NULL OR client_id = p_company_id)
    ), 0)::INTEGER;
END;
$$;


-- ============================================================
-- STOREKEEPER — 3 RPCs
-- ============================================================

CREATE OR REPLACE FUNCTION public.get_storekeeper_summary(
  p_user_id    UUID,
  p_company_id UUID
)
RETURNS TABLE (
  total_items      INTEGER,
  low_stock_count  INTEGER,
  pending_grn_count INTEGER
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public
AS $$
BEGIN
  RETURN QUERY SELECT
    COALESCE((
      SELECT COUNT(DISTINCT i.product_id)::INTEGER
      FROM inventory i
      JOIN company_locations cl ON cl.id = i.location_id
      WHERE cl.society_id = p_company_id
    ), 0),

    COALESCE((
      SELECT COUNT(*)::INTEGER
      FROM inventory i
      JOIN company_locations cl ON cl.id = i.location_id
      WHERE cl.society_id = p_company_id
        AND i.reorder_level IS NOT NULL
        AND i.quantity_on_hand <= i.reorder_level
    ), 0),

    COALESCE((
      SELECT COUNT(*)::INTEGER
      FROM material_receipts mr
      JOIN warehouses w ON w.id = mr.warehouse_id
      WHERE w.society_id = p_company_id
        AND mr.status IN ('draft', 'inspecting')
    ), 0);
END;
$$;


CREATE OR REPLACE FUNCTION public.get_stock_alerts(
  p_user_id    UUID,
  p_company_id UUID
)
RETURNS TABLE (
  id               UUID,
  item_name        TEXT,
  current_quantity NUMERIC,
  min_threshold    NUMERIC,
  unit             TEXT,
  location_name    TEXT,
  severity         TEXT
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public
AS $$
BEGIN
  RETURN QUERY
  SELECT
    i.id,
    p.product_name::TEXT,
    i.quantity_on_hand,
    COALESCE(i.reorder_level, 0),
    COALESCE(p.unit, 'units')::TEXT,
    cl.location_name::TEXT,
    CASE WHEN i.quantity_on_hand = 0 THEN 'critical' ELSE 'warning' END::TEXT
  FROM inventory i
  JOIN products p          ON p.id  = i.product_id
  JOIN company_locations cl ON cl.id = i.location_id
  WHERE cl.society_id = p_company_id
    AND i.reorder_level IS NOT NULL
    AND i.quantity_on_hand <= i.reorder_level
  ORDER BY i.quantity_on_hand ASC, i.id;
END;
$$;


CREATE OR REPLACE FUNCTION public.get_pending_grns(
  p_user_id    UUID,
  p_company_id UUID
)
RETURNS TABLE (
  id            UUID,
  grn_number    TEXT,
  supplier_name TEXT,
  po_number     TEXT,
  received_date DATE,
  item_count    INTEGER,
  status        TEXT
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public
AS $$
BEGIN
  RETURN QUERY
  SELECT
    mr.id,
    COALESCE(mr.grn_number, 'GRN-PENDING')::TEXT,
    COALESCE(s.supplier_name, 'Unknown supplier')::TEXT,
    COALESCE(po.po_number, 'PO-UNKNOWN')::TEXT,
    mr.received_date,
    COALESCE((
      SELECT COUNT(*)::INTEGER
      FROM material_receipt_items mri
      WHERE mri.material_receipt_id = mr.id
    ), 0),
    mr.status::TEXT
  FROM material_receipts mr
  LEFT JOIN suppliers      s  ON s.id  = mr.supplier_id
  LEFT JOIN purchase_orders po ON po.id = mr.purchase_order_id
  JOIN warehouses          w  ON w.id  = mr.warehouse_id
  WHERE w.society_id = p_company_id
    AND mr.status IN ('draft', 'inspecting')
  ORDER BY mr.received_date DESC, mr.id;
END;
$$;


-- ============================================================
-- SITE SUPERVISOR — 4 RPCs
-- (No tenant param: auth.uid() resolves the site via security_guards assignment)
-- ============================================================

CREATE OR REPLACE FUNCTION public.get_site_supervisor_summary()
RETURNS TABLE (
  guards_on_duty INTEGER,
  open_incidents INTEGER
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public
AS $$
DECLARE v_society UUID;
BEGIN
  SELECT cl.society_id INTO v_society
  FROM users u
  JOIN security_guards sg ON sg.employee_id = u.employee_id
  JOIN company_locations cl ON cl.id = sg.assigned_location_id
  WHERE u.id = auth.uid()
  LIMIT 1;

  RETURN QUERY SELECT
    COALESCE((
      SELECT COUNT(*)::INTEGER
      FROM security_guards sg2
      JOIN company_locations cl2 ON cl2.id = sg2.assigned_location_id
      WHERE sg2.is_active = true
        AND (v_society IS NULL OR cl2.society_id = v_society)
    ), 0),

    COALESCE((
      SELECT COUNT(*)::INTEGER
      FROM panic_alerts pa
      LEFT JOIN company_locations cl3 ON cl3.id = pa.location_id
      WHERE pa.is_resolved = false
        AND (v_society IS NULL OR cl3.society_id = v_society)
    ), 0);
END;
$$;


CREATE OR REPLACE FUNCTION public.get_guard_roster()
RETURNS TABLE (
  id           UUID,
  guard_name   TEXT,
  shift_start  TEXT,
  last_gps_ping TEXT,
  status       TEXT
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public
AS $$
DECLARE v_society UUID;
BEGIN
  SELECT cl.society_id INTO v_society
  FROM users u
  JOIN security_guards sg ON sg.employee_id = u.employee_id
  JOIN company_locations cl ON cl.id = sg.assigned_location_id
  WHERE u.id = auth.uid()
  LIMIT 1;

  RETURN QUERY
  SELECT
    sg.id,
    (e.first_name || ' ' || e.last_name)::TEXT,
    COALESCE(
      (SELECT al.check_in_time::TEXT
       FROM attendance_logs al
       WHERE al.employee_id = e.id AND al.log_date = CURRENT_DATE LIMIT 1),
      (CURRENT_DATE || 'T06:00:00+00:00')::TEXT
    ),
    (SELECT gt.tracked_at::TEXT
     FROM gps_tracking gt
     WHERE gt.employee_id = sg.id
     ORDER BY gt.tracked_at DESC LIMIT 1),
    CASE
      WHEN (SELECT gt2.tracked_at FROM gps_tracking gt2
            WHERE gt2.employee_id = sg.id
            ORDER BY gt2.tracked_at DESC LIMIT 1) > NOW() - INTERVAL '30 minutes' THEN 'active'
      WHEN (SELECT gt2.tracked_at FROM gps_tracking gt2
            WHERE gt2.employee_id = sg.id
            ORDER BY gt2.tracked_at DESC LIMIT 1) > NOW() - INTERVAL '2 hours'   THEN 'overdue-checkin'
      ELSE 'offline'
    END::TEXT
  FROM security_guards sg
  JOIN employees e          ON e.id  = sg.employee_id
  JOIN company_locations cl ON cl.id = sg.assigned_location_id
  WHERE sg.is_active = true
    AND (v_society IS NULL OR cl.society_id = v_society)
  ORDER BY e.first_name, e.last_name;
END;
$$;


CREATE OR REPLACE FUNCTION public.get_site_incidents()
RETURNS TABLE (
  id           UUID,
  type         TEXT,
  location     TEXT,
  severity     TEXT,
  opened_at    TEXT,
  acknowledged BOOLEAN
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public
AS $$
DECLARE v_society UUID;
BEGIN
  SELECT cl.society_id INTO v_society
  FROM users u
  JOIN security_guards sg ON sg.employee_id = u.employee_id
  JOIN company_locations cl ON cl.id = sg.assigned_location_id
  WHERE u.id = auth.uid()
  LIMIT 1;

  RETURN QUERY
  SELECT
    pa.id,
    pa.alert_type::TEXT,
    COALESCE(cl2.location_name, 'Unknown location')::TEXT,
    CASE
      WHEN pa.alert_type::TEXT = 'panic'            THEN 'high'
      WHEN pa.alert_type::TEXT = 'geo_fence_breach' THEN 'medium'
      ELSE 'low'
    END::TEXT,
    pa.alert_time::TEXT,
    pa.is_resolved
  FROM panic_alerts pa
  LEFT JOIN company_locations cl2 ON cl2.id = pa.location_id
  LEFT JOIN security_guards   sg2 ON sg2.id = pa.guard_id
  LEFT JOIN company_locations cl3 ON cl3.id = sg2.assigned_location_id
  WHERE (v_society IS NULL
     OR cl2.society_id = v_society
     OR cl3.society_id = v_society)
  ORDER BY pa.alert_time DESC
  LIMIT 50;
END;
$$;


CREATE OR REPLACE FUNCTION public.acknowledge_site_incident(
  p_incident_id  UUID,
  p_supervisor_id UUID
)
RETURNS VOID
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public
AS $$
BEGIN
  UPDATE panic_alerts
  SET is_resolved = true, resolved_at = NOW(), resolved_by = p_supervisor_id
  WHERE id = p_incident_id;
END;
$$;


-- ============================================================
-- MD (Managing Director) — 4 RPCs
-- ============================================================

CREATE OR REPLACE FUNCTION public.get_md_executive_summary(
  p_user_id UUID
)
RETURNS TABLE (
  monthly_revenue       BIGINT,
  headcount             INTEGER,
  active_incidents      INTEGER,
  pending_approval_count INTEGER
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public
AS $$
BEGIN
  RETURN QUERY SELECT
    COALESCE((
      SELECT SUM(total_amount)
      FROM sale_bills
      WHERE DATE_TRUNC('month', invoice_date) = DATE_TRUNC('month', CURRENT_DATE)
        AND status != 'cancelled'
    ), 0)::BIGINT,

    (SELECT COUNT(*)::INTEGER FROM employees WHERE is_active = true),

    (SELECT COUNT(*)::INTEGER FROM panic_alerts WHERE is_resolved = false),

    COALESCE((
      SELECT COUNT(*)::INTEGER
      FROM purchase_orders
      WHERE status = 'acknowledged'
        AND md_action IS NULL
        AND grand_total >= 100000
    ), 0)::INTEGER;
END;
$$;


CREATE OR REPLACE FUNCTION public.get_md_approval_queue(
  p_user_id UUID
)
RETURNS TABLE (
  id           UUID,
  type         TEXT,
  description  TEXT,
  requested_by TEXT,
  department   TEXT,
  amount       BIGINT,
  created_at   TEXT
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public
AS $$
BEGIN
  RETURN QUERY
  SELECT
    po.id,
    'purchase_order'::TEXT,
    COALESCE(
      'PO ' || po.po_number || COALESCE(' from ' || s.supplier_name, ''),
      'Purchase order'
    )::TEXT,
    COALESCE(
      (SELECT u.full_name FROM users u WHERE u.id = po.created_by LIMIT 1),
      'Unknown'
    )::TEXT,
    COALESCE(
      (SELECT e.department
       FROM employees e JOIN users u ON u.employee_id = e.id
       WHERE u.id = po.created_by LIMIT 1),
      'Procurement'
    )::TEXT,
    po.grand_total::BIGINT,
    po.created_at::TEXT
  FROM purchase_orders po
  LEFT JOIN suppliers s ON s.id = po.supplier_id
  WHERE po.status = 'acknowledged'
    AND po.md_action IS NULL
    AND po.grand_total >= 100000
  ORDER BY po.grand_total DESC, po.created_at DESC
  LIMIT 50;
END;
$$;


CREATE OR REPLACE FUNCTION public.approve_md_item(
  p_item_id    UUID,
  p_approver_id UUID
)
RETURNS VOID
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public
AS $$
BEGIN
  UPDATE purchase_orders
  SET md_action = 'approved', md_approved_at = NOW(), md_approved_by = p_approver_id, updated_at = NOW()
  WHERE id = p_item_id AND status = 'acknowledged' AND md_action IS NULL;
END;
$$;


CREATE OR REPLACE FUNCTION public.reject_md_item(
  p_item_id    UUID,
  p_approver_id UUID
)
RETURNS VOID
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public
AS $$
BEGIN
  UPDATE purchase_orders
  SET md_action = 'rejected', md_approved_at = NOW(), md_approved_by = p_approver_id, updated_at = NOW()
  WHERE id = p_item_id AND status = 'acknowledged' AND md_action IS NULL;
END;
$$;


-- ============================================================
-- ADMIN — 1 RPC
-- ============================================================

CREATE OR REPLACE FUNCTION public.get_admin_dashboard_summary(
  p_user_id    UUID,
  p_company_id UUID
)
RETURNS TABLE (
  active_users_count  INTEGER,
  logins_today        INTEGER,
  pending_onboarding  INTEGER,
  system_alerts       INTEGER
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public
AS $$
BEGIN
  RETURN QUERY SELECT
    (SELECT COUNT(*)::INTEGER FROM users WHERE is_active = true),

    (SELECT COUNT(*)::INTEGER FROM users WHERE DATE(last_login) = CURRENT_DATE),

    -- Users with no employee profile yet
    COALESCE((
      SELECT COUNT(*)::INTEGER FROM users WHERE is_active = true AND employee_id IS NULL
    ), 0),

    -- Unresolved security incidents + open behaviour tickets
    COALESCE((
      SELECT COUNT(*)::INTEGER FROM panic_alerts WHERE is_resolved = false
    ), 0)
    +
    COALESCE((
      SELECT COUNT(*)::INTEGER FROM employee_behavior_tickets WHERE status = 'open'
    ), 0);
END;
$$;


-- ============================================================
-- SUPER ADMIN — 2 RPCs
-- ============================================================

CREATE OR REPLACE FUNCTION public.get_super_admin_platform_summary()
RETURNS TABLE (
  total_companies    INTEGER,
  total_active_users INTEGER,
  active_incidents   INTEGER,
  critical_alert_count INTEGER
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public
AS $$
BEGIN
  RETURN QUERY SELECT
    (SELECT COUNT(*)::INTEGER FROM societies WHERE is_active = true),
    (SELECT COUNT(*)::INTEGER FROM users    WHERE is_active = true),
    (SELECT COUNT(*)::INTEGER FROM panic_alerts WHERE is_resolved = false),
    (SELECT COUNT(*)::INTEGER FROM panic_alerts WHERE is_resolved = false AND alert_type = 'panic');
END;
$$;


CREATE OR REPLACE FUNCTION public.get_all_companies_health()
RETURNS TABLE (
  id               UUID,
  company_name     TEXT,
  location_count   INTEGER,
  active_user_count INTEGER,
  health           TEXT,
  last_activity_at TEXT
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public
AS $$
BEGIN
  RETURN QUERY
  SELECT
    s.id,
    s.society_name::TEXT,

    COALESCE((
      SELECT COUNT(*)::INTEGER
      FROM company_locations cl
      WHERE cl.society_id = s.id AND cl.is_active = true
    ), 0),

    -- Active guards at this company's locations
    COALESCE((
      SELECT COUNT(DISTINCT sg.id)::INTEGER
      FROM security_guards sg
      JOIN company_locations cl ON cl.id = sg.assigned_location_id
      WHERE cl.society_id = s.id AND sg.is_active = true
    ), 0),

    -- Health based on unresolved panic alerts
    CASE
      WHEN EXISTS (
        SELECT 1 FROM panic_alerts pa
        LEFT JOIN company_locations cl ON cl.id = pa.location_id
        WHERE cl.society_id = s.id AND pa.is_resolved = false AND pa.alert_type = 'panic'
      ) THEN 'critical'
      WHEN EXISTS (
        SELECT 1 FROM panic_alerts pa
        LEFT JOIN company_locations cl ON cl.id = pa.location_id
        WHERE cl.society_id = s.id AND pa.is_resolved = false
      ) THEN 'warning'
      ELSE 'healthy'
    END::TEXT,

    -- Last GPS activity from any guard at this company
    COALESCE((
      SELECT MAX(gt.tracked_at)::TEXT
      FROM gps_tracking gt
      JOIN security_guards sg ON sg.id = gt.employee_id
      JOIN company_locations cl ON cl.id = sg.assigned_location_id
      WHERE cl.society_id = s.id
    ), '')

  FROM societies s
  WHERE s.is_active = true
  ORDER BY s.society_name;
END;
$$;


-- ============================================================
-- Grant execute permissions to authenticated role
-- ============================================================

GRANT EXECUTE ON FUNCTION public.get_hod_summary(UUID, UUID)              TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_hod_leave_requests(UUID, UUID)        TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_hod_team_members(UUID, UUID)          TO authenticated;
GRANT EXECUTE ON FUNCTION public.approve_leave_request(UUID, UUID)         TO authenticated;
GRANT EXECUTE ON FUNCTION public.reject_leave_request(UUID, UUID)          TO authenticated;

GRANT EXECUTE ON FUNCTION public.get_account_finance_summary(UUID, UUID)   TO authenticated;

GRANT EXECUTE ON FUNCTION public.get_storekeeper_summary(UUID, UUID)       TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_stock_alerts(UUID, UUID)              TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_pending_grns(UUID, UUID)              TO authenticated;

GRANT EXECUTE ON FUNCTION public.get_site_supervisor_summary()             TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_guard_roster()                        TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_site_incidents()                      TO authenticated;
GRANT EXECUTE ON FUNCTION public.acknowledge_site_incident(UUID, UUID)     TO authenticated;

GRANT EXECUTE ON FUNCTION public.get_md_executive_summary(UUID)            TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_md_approval_queue(UUID)               TO authenticated;
GRANT EXECUTE ON FUNCTION public.approve_md_item(UUID, UUID)               TO authenticated;
GRANT EXECUTE ON FUNCTION public.reject_md_item(UUID, UUID)                TO authenticated;

GRANT EXECUTE ON FUNCTION public.get_admin_dashboard_summary(UUID, UUID)   TO authenticated;

GRANT EXECUTE ON FUNCTION public.get_super_admin_platform_summary()        TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_all_companies_health()                TO authenticated;

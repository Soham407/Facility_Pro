


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE EXTENSION IF NOT EXISTS "pg_cron" WITH SCHEMA "pg_catalog";






COMMENT ON SCHEMA "public" IS 'FacilityPro main schema - site_supervisor policy support added 2026-05-09; society_manager remains live in v1';



CREATE EXTENSION IF NOT EXISTS "pg_net" WITH SCHEMA "public";






CREATE EXTENSION IF NOT EXISTS "btree_gist" WITH SCHEMA "public";






CREATE EXTENSION IF NOT EXISTS "http" WITH SCHEMA "public";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE TYPE "public"."alert_type" AS ENUM (
    'panic',
    'inactivity',
    'geo_fence_breach',
    'checklist_incomplete',
    'routine'
);


ALTER TYPE "public"."alert_type" OWNER TO "postgres";


CREATE TYPE "public"."asset_status" AS ENUM (
    'functional',
    'under_maintenance',
    'faulty',
    'decommissioned'
);


ALTER TYPE "public"."asset_status" OWNER TO "postgres";


CREATE TYPE "public"."behavior_category" AS ENUM (
    'sleeping_on_duty',
    'rudeness',
    'absence',
    'uniform_issue',
    'unauthorized_entry',
    'late_arrival',
    'mobile_use',
    'other'
);


ALTER TYPE "public"."behavior_category" OWNER TO "postgres";


CREATE TYPE "public"."budget_status" AS ENUM (
    'draft',
    'active',
    'exhausted',
    'expired'
);


ALTER TYPE "public"."budget_status" OWNER TO "postgres";


CREATE TYPE "public"."candidate_status" AS ENUM (
    'screening',
    'interviewing',
    'background_check',
    'offered',
    'hired',
    'rejected'
);


ALTER TYPE "public"."candidate_status" OWNER TO "postgres";


CREATE TYPE "public"."document_status" AS ENUM (
    'pending_upload',
    'pending_review',
    'verified',
    'expired',
    'rejected'
);


ALTER TYPE "public"."document_status" OWNER TO "postgres";


CREATE TYPE "public"."document_type" AS ENUM (
    'aadhar_card',
    'pan_card',
    'passport',
    'driving_license',
    'voter_id',
    'bank_passbook',
    'education_certificate',
    'experience_certificate',
    'offer_letter',
    'relieving_letter',
    'address_proof',
    'police_verification',
    'medical_certificate',
    'other',
    'psara_license',
    'id_proof'
);


ALTER TYPE "public"."document_type" OWNER TO "postgres";


CREATE TYPE "public"."financial_period_status" AS ENUM (
    'open',
    'closing',
    'closed'
);


ALTER TYPE "public"."financial_period_status" OWNER TO "postgres";


CREATE TYPE "public"."financial_period_type" AS ENUM (
    'monthly',
    'quarterly',
    'yearly'
);


ALTER TYPE "public"."financial_period_type" OWNER TO "postgres";


CREATE TYPE "public"."grn_item_quality_status" AS ENUM (
    'accepted',
    'rejected',
    'partial'
);


ALTER TYPE "public"."grn_item_quality_status" OWNER TO "postgres";


CREATE TYPE "public"."grn_status" AS ENUM (
    'draft',
    'inspecting',
    'accepted',
    'partial_accepted',
    'rejected'
);


ALTER TYPE "public"."grn_status" OWNER TO "postgres";


CREATE TYPE "public"."guard_grade" AS ENUM (
    'A',
    'B',
    'C',
    'D'
);


ALTER TYPE "public"."guard_grade" OWNER TO "postgres";


CREATE TYPE "public"."indent_status" AS ENUM (
    'draft',
    'pending_approval',
    'approved',
    'rejected',
    'po_created',
    'cancelled'
);


ALTER TYPE "public"."indent_status" OWNER TO "postgres";


CREATE TYPE "public"."job_session_status" AS ENUM (
    'started',
    'paused',
    'completed',
    'cancelled'
);


ALTER TYPE "public"."job_session_status" OWNER TO "postgres";


CREATE TYPE "public"."leave_type_enum" AS ENUM (
    'sick_leave',
    'casual_leave',
    'paid_leave',
    'unpaid_leave',
    'emergency_leave'
);


ALTER TYPE "public"."leave_type_enum" OWNER TO "postgres";


CREATE TYPE "public"."maintenance_frequency" AS ENUM (
    'daily',
    'weekly',
    'monthly',
    'quarterly',
    'half_yearly',
    'yearly'
);


ALTER TYPE "public"."maintenance_frequency" OWNER TO "postgres";


CREATE TYPE "public"."material_condition" AS ENUM (
    'good',
    'damaged',
    'expired',
    'leaking',
    'defective'
);


ALTER TYPE "public"."material_condition" OWNER TO "postgres";


CREATE TYPE "public"."payment_gateway" AS ENUM (
    'razorpay',
    'stripe',
    'paypal',
    'manual'
);


ALTER TYPE "public"."payment_gateway" OWNER TO "postgres";


CREATE TYPE "public"."payroll_cycle_status" AS ENUM (
    'draft',
    'processing',
    'computed',
    'approved',
    'disbursed',
    'cancelled'
);


ALTER TYPE "public"."payroll_cycle_status" OWNER TO "postgres";


CREATE TYPE "public"."payslip_status" AS ENUM (
    'draft',
    'computed',
    'approved',
    'processed',
    'disputed'
);


ALTER TYPE "public"."payslip_status" OWNER TO "postgres";


CREATE TYPE "public"."po_status" AS ENUM (
    'draft',
    'sent_to_vendor',
    'acknowledged',
    'partial_received',
    'received',
    'cancelled',
    'dispatched'
);


ALTER TYPE "public"."po_status" OWNER TO "postgres";


CREATE TYPE "public"."reconciliation_status" AS ENUM (
    'pending',
    'matched',
    'discrepancy',
    'resolved',
    'disputed'
);


ALTER TYPE "public"."reconciliation_status" OWNER TO "postgres";


CREATE TYPE "public"."request_status" AS ENUM (
    'pending',
    'accepted',
    'rejected',
    'indent_generated',
    'indent_forwarded',
    'indent_accepted',
    'indent_rejected',
    'po_issued',
    'po_received',
    'po_dispatched',
    'material_received',
    'material_acknowledged',
    'bill_generated',
    'paid',
    'feedback_pending',
    'completed',
    'cancelled'
);


ALTER TYPE "public"."request_status" OWNER TO "postgres";


CREATE TYPE "public"."service_category" AS ENUM (
    'security_services',
    'ac_services',
    'plantation_services',
    'printing_advertising',
    'pest_control',
    'housekeeping',
    'pantry_services',
    'general_maintenance'
);


ALTER TYPE "public"."service_category" OWNER TO "postgres";


CREATE TYPE "public"."service_priority" AS ENUM (
    'low',
    'normal',
    'high',
    'urgent'
);


ALTER TYPE "public"."service_priority" OWNER TO "postgres";


CREATE TYPE "public"."service_request_status" AS ENUM (
    'open',
    'assigned',
    'in_progress',
    'on_hold',
    'completed',
    'cancelled',
    'closed'
);


ALTER TYPE "public"."service_request_status" OWNER TO "postgres";


CREATE TYPE "public"."ticket_type" AS ENUM (
    'quality_check',
    'quantity_check',
    'material_return'
);


ALTER TYPE "public"."ticket_type" OWNER TO "postgres";


CREATE TYPE "public"."user_role" AS ENUM (
    'admin',
    'company_md',
    'company_hod',
    'account',
    'delivery_boy',
    'buyer',
    'supplier',
    'vendor',
    'security_guard',
    'security_supervisor',
    'society_manager',
    'service_boy',
    'resident',
    'storekeeper',
    'site_supervisor',
    'super_admin',
    'ac_technician',
    'pest_control_technician',
    'delivery_agent',
    'field_technician'
);


ALTER TYPE "public"."user_role" OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."acknowledge_mobile_panic_alert"("p_alert_id" "uuid", "p_notes" "text" DEFAULT NULL::"text") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_guard_user_id UUID;
BEGIN
  IF auth.uid() IS NULL OR NOT (
    has_role('security_supervisor')
    OR has_role('society_manager')
    OR has_role('admin')
    OR has_role('super_admin')
  ) THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Only oversight users can acknowledge alerts');
  END IF;

  UPDATE public.panic_alerts
  SET
    acknowledged_at = NOW(),
    acknowledged_by = auth.uid(),
    acknowledged_notes = NULLIF(p_notes, '')
  WHERE id = p_alert_id
    AND is_resolved = FALSE;

  IF NOT FOUND THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Alert not found or already resolved');
  END IF;

  SELECT e.auth_user_id
  INTO v_guard_user_id
  FROM public.panic_alerts pa
  JOIN public.security_guards sg ON sg.id = pa.guard_id
  JOIN public.employees e ON e.id = sg.employee_id
  WHERE pa.id = p_alert_id
  LIMIT 1;

  IF v_guard_user_id IS NOT NULL THEN
    PERFORM public.mobile_insert_notification(
      v_guard_user_id,
      'SOS acknowledged',
      'Your panic alert has been acknowledged by the control room.',
      'panic_acknowledged',
      'high',
      '/guard/home',
      JSONB_BUILD_OBJECT('alert_id', p_alert_id),
      'push_queued',
      'queued',
      NOW() + INTERVAL '60 seconds'
    );
  END IF;

  RETURN JSONB_BUILD_OBJECT('success', TRUE, 'alert_id', p_alert_id);
END;
$$;


ALTER FUNCTION "public"."acknowledge_mobile_panic_alert"("p_alert_id" "uuid", "p_notes" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."acknowledge_panic_alert"("p_alert_id" "uuid", "p_acknowledged_by" "uuid") RETURNS boolean
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
  UPDATE guard_panic_alerts
  SET
    status = 'acknowledged',
    acknowledged_at = NOW(),
    acknowledged_by = p_acknowledged_by
  WHERE id = p_alert_id;
  
  RETURN true;
END;
$$;


ALTER FUNCTION "public"."acknowledge_panic_alert"("p_alert_id" "uuid", "p_acknowledged_by" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."acknowledge_site_incident"("p_incident_id" "uuid", "p_supervisor_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
  UPDATE panic_alerts
  SET is_resolved = true, resolved_at = NOW(), resolved_by = p_supervisor_id
  WHERE id = p_incident_id;
END;
$$;


ALTER FUNCTION "public"."acknowledge_site_incident"("p_incident_id" "uuid", "p_supervisor_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."approve_leave_request"("p_leave_id" "uuid", "p_approver_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE v_emp UUID;
BEGIN
  SELECT employee_id INTO v_emp FROM users WHERE id = p_approver_id;
  UPDATE leave_applications
  SET status = 'approved', approved_by = v_emp, approved_at = NOW(), updated_at = NOW()
  WHERE id = p_leave_id AND status = 'pending';
END;
$$;


ALTER FUNCTION "public"."approve_leave_request"("p_leave_id" "uuid", "p_approver_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."approve_md_item"("p_item_id" "uuid", "p_approver_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
  UPDATE purchase_orders
  SET md_action = 'approved', md_approved_at = NOW(), md_approved_by = p_approver_id, updated_at = NOW()
  WHERE id = p_item_id AND status = 'acknowledged' AND md_action IS NULL;
END;
$$;


ALTER FUNCTION "public"."approve_md_item"("p_item_id" "uuid", "p_approver_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."approve_visitor"("p_visitor_id" "uuid", "p_user_id" "uuid") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_visitor RECORD;
  v_is_resident BOOLEAN;
  v_resident_flat_id UUID;
BEGIN
  PERFORM public.expire_mobile_visitor_decisions();

  IF auth.uid() IS NULL THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Authentication required');
  END IF;

  IF auth.uid() IS DISTINCT FROM p_user_id THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Authenticated user mismatch');
  END IF;

  SELECT EXISTS(
    SELECT 1 FROM public.residents WHERE auth_user_id = p_user_id
  ) INTO v_is_resident;

  IF NOT v_is_resident THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Only residents can approve visitors');
  END IF;

  SELECT flat_id INTO v_resident_flat_id
  FROM public.residents
  WHERE auth_user_id = p_user_id
  LIMIT 1;

  SELECT * INTO v_visitor
  FROM public.visitors
  WHERE id = p_visitor_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Visitor not found');
  END IF;

  IF v_visitor.flat_id IS NULL THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Visitors without a destination flat cannot be approved');
  END IF;

  IF v_visitor.flat_id != v_resident_flat_id THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'You can only approve visitors for your own flat');
  END IF;

  IF v_visitor.exit_time IS NOT NULL THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Cannot approve a visitor who has already checked out');
  END IF;

  IF v_visitor.approval_status = 'timed_out' THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'The visitor approval window has already expired');
  END IF;

  UPDATE public.visitors
  SET
    approved_by_resident = TRUE,
    approval_status = 'approved',
    decision_at = NOW(),
    rejection_reason = NULL
  WHERE id = p_visitor_id;

  RETURN JSONB_BUILD_OBJECT('success', TRUE, 'visitor_id', p_visitor_id);
END;
$$;


ALTER FUNCTION "public"."approve_visitor"("p_visitor_id" "uuid", "p_user_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."audit_payslip_changes"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
    INSERT INTO audit_log (table_name, record_id, action, old_values, new_values, changed_by)
    VALUES (
        'payslips', COALESCE(NEW.id, OLD.id), TG_OP,
        CASE WHEN TG_OP IN ('UPDATE', 'DELETE') THEN to_jsonb(OLD) ELSE NULL END,
        CASE WHEN TG_OP IN ('INSERT', 'UPDATE') THEN to_jsonb(NEW) ELSE NULL END,
        auth.uid()
    );
    RETURN COALESCE(NEW, OLD);
END;
$$;


ALTER FUNCTION "public"."audit_payslip_changes"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."audit_reconciliation_changes"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
    INSERT INTO audit_log (table_name, record_id, action, old_values, new_values, changed_by)
    VALUES (
        'reconciliations', COALESCE(NEW.id, OLD.id), TG_OP,
        CASE WHEN TG_OP IN ('UPDATE', 'DELETE') THEN to_jsonb(OLD) ELSE NULL END,
        CASE WHEN TG_OP IN ('INSERT', 'UPDATE') THEN to_jsonb(NEW) ELSE NULL END,
        auth.uid()
    );
    RETURN COALESCE(NEW, OLD);
END;
$$;


ALTER FUNCTION "public"."audit_reconciliation_changes"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."auto_exit_stale_visitors"() RETURNS "void"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public'
    AS $$
DECLARE
    v_count INT;
BEGIN
    -- Update visitors who checked in more than 24 hours ago and haven't exited
    WITH stale_visitors AS (
        UPDATE visitors
        SET 
            exit_time = NOW(),
            bypass_reason = COALESCE(bypass_reason, '') || ' [Auto-exited by System]'
        WHERE exit_time IS NULL
        AND entry_time < NOW() - INTERVAL '24 hours'
        RETURNING 1
    )
    SELECT COUNT(*) INTO v_count FROM stale_visitors;

    IF v_count > 0 THEN
        -- Log the action (optional, could write to audit_logs if desired)
        RAISE NOTICE 'Auto-exited % stale visitors', v_count;
    END IF;
END;
$$;


ALTER FUNCTION "public"."auto_exit_stale_visitors"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."auto_punch_out_idle_employees"() RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public', 'extensions'
    AS $$
DECLARE
  v_updated_count integer;
BEGIN
  UPDATE public.attendance_logs
  SET
    check_out_time = (log_date::timestamptz + INTERVAL '23 hours 59 minutes 59 seconds'),
    total_hours = CASE
      WHEN check_in_time IS NULL THEN total_hours
      ELSE ROUND(
        EXTRACT(
          EPOCH FROM (
            (log_date::timestamptz + INTERVAL '23 hours 59 minutes 59 seconds') - check_in_time
          )
        ) / 3600.0,
        2
      )
    END,
    is_auto_punch_out = TRUE,
    status = 'absent_breach',
    notes = TRIM(
      BOTH ' '
      FROM CONCAT_WS(' | ', NULLIF(notes, ''), 'Auto-punched out by system at end of day.')
    )
  WHERE check_out_time IS NULL
    AND check_in_time IS NOT NULL
    AND log_date < CURRENT_DATE;

  GET DIAGNOSTICS v_updated_count = ROW_COUNT;
  RAISE NOTICE 'auto_punch_out: Updated % attendance records.', v_updated_count;
END;
$$;


ALTER FUNCTION "public"."auto_punch_out_idle_employees"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."block_expired_chemical_issuance"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
    v_expiry_date DATE;
    v_product_name TEXT;
    v_category_name TEXT;
BEGIN
    -- Only check for 'issue' type transactions
    IF LOWER(NEW.transaction_type) IN ('issue', 'out') THEN
        
        -- Check if product is a chemical
        SELECT pc.category_name, p.product_name 
        INTO v_category_name, v_product_name
        FROM public.products p
        LEFT JOIN public.product_categories pc ON p.category_id = pc.id
        WHERE p.id = NEW.product_id;

        -- If it's a chemical, check expiry from available sources
        IF v_category_name ILIKE '%chemical%' OR EXISTS (SELECT 1 FROM public.pest_control_chemicals WHERE product_id = NEW.product_id) THEN
            
            -- Prefer batch-specific expiry if batch_number is provided
            IF NEW.batch_number IS NOT NULL THEN
                SELECT expiry_date INTO v_expiry_date
                FROM public.stock_batches
                WHERE product_id = NEW.product_id AND batch_number = NEW.batch_number
                LIMIT 1;
            END IF;

            -- Fallback to pest_control_chemicals table if still null
            IF v_expiry_date IS NULL THEN
                SELECT expiry_date INTO v_expiry_date
                FROM public.pest_control_chemicals
                WHERE product_id = NEW.product_id
                LIMIT 1;
            END IF;

            -- Block if expired
            IF v_expiry_date IS NOT NULL AND v_expiry_date < CURRENT_DATE THEN
                RAISE EXCEPTION 'Cannot issue expired chemical: % (Expired on %)', v_product_name, v_expiry_date;
            END IF;
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."block_expired_chemical_issuance"() OWNER TO "postgres";


COMMENT ON FUNCTION "public"."block_expired_chemical_issuance"() IS 'Blocks issuance of chemicals if they are past their expiry date.';



CREATE OR REPLACE FUNCTION "public"."calculate_employee_salary"("p_employee_id" "uuid", "p_period_start" "date", "p_period_end" "date", "p_total_working_days" integer) RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_employee RECORD;
  v_shift RECORD;
  v_present_days INT := 0;
  v_absent_days INT := 0;
  v_leave_days INT := 0;
  v_payable_days INT := 0;
  v_overtime_hours NUMERIC := 0;
  v_basic_salary NUMERIC := 0;
  v_hra NUMERIC := 0;
  v_special_allowance NUMERIC := 0;
  v_travel_allowance NUMERIC := 0;
  v_medical_allowance NUMERIC := 0;
  v_basic_depends BOOLEAN := TRUE;
  v_hra_depends BOOLEAN := TRUE;
  v_special_depends BOOLEAN := TRUE;
  v_travel_depends BOOLEAN := FALSE;
  v_medical_depends BOOLEAN := FALSE;
  v_pay_ratio NUMERIC := 0;
  v_pro_rated_basic NUMERIC := 0;
  v_payable_hra NUMERIC := 0;
  v_payable_special_allowance NUMERIC := 0;
  v_payable_travel_allowance NUMERIC := 0;
  v_payable_medical_allowance NUMERIC := 0;
  v_overtime_amount NUMERIC := 0;
  v_gross_salary NUMERIC := 0;
  v_pf_deduction NUMERIC := 0;
  v_esic_deduction NUMERIC := 0;
  v_professional_tax NUMERIC := 0;
  v_total_deductions NUMERIC := 0;
  v_net_payable NUMERIC := 0;
  v_employer_pf NUMERIC := 0;
  v_employer_esic NUMERIC := 0;
  v_overtime_rate NUMERIC := 0;
  v_standard_hours NUMERIC := 8;
BEGIN
  SELECT *
  INTO v_employee
  FROM public.employees
  WHERE id = p_employee_id;

  IF NOT FOUND THEN
    RETURN jsonb_build_object('success', false, 'error', 'Employee not found');
  END IF;

  WITH ranked_components AS (
    SELECT
      sc.abbr,
      sc.depends_on_payment_days,
      ess.amount,
      ROW_NUMBER() OVER (
        PARTITION BY ess.component_id
        ORDER BY ess.effective_from DESC, ess.created_at DESC NULLS LAST, ess.id DESC
      ) AS rn
    FROM public.employee_salary_structure ess
    JOIN public.salary_components sc
      ON sc.id = ess.component_id
    WHERE ess.employee_id = p_employee_id
      AND ess.effective_from <= p_period_end
      AND (ess.effective_to IS NULL OR ess.effective_to >= p_period_start)
  )
  SELECT
    COALESCE(MAX(CASE WHEN abbr = 'B' THEN amount END), 0) / 100.0,
    COALESCE(MAX(CASE WHEN abbr = 'HRA' THEN amount END), 0) / 100.0,
    COALESCE(MAX(CASE WHEN abbr = 'SA' THEN amount END), 0) / 100.0,
    COALESCE(MAX(CASE WHEN abbr = 'TA' THEN amount END), 0) / 100.0,
    COALESCE(MAX(CASE WHEN abbr = 'MA' THEN amount END), 0) / 100.0,
    COALESCE(BOOL_OR(CASE WHEN abbr = 'B' THEN depends_on_payment_days END), TRUE),
    COALESCE(BOOL_OR(CASE WHEN abbr = 'HRA' THEN depends_on_payment_days END), TRUE),
    COALESCE(BOOL_OR(CASE WHEN abbr = 'SA' THEN depends_on_payment_days END), TRUE),
    COALESCE(BOOL_OR(CASE WHEN abbr = 'TA' THEN depends_on_payment_days END), FALSE),
    COALESCE(BOOL_OR(CASE WHEN abbr = 'MA' THEN depends_on_payment_days END), FALSE)
  INTO
    v_basic_salary,
    v_hra,
    v_special_allowance,
    v_travel_allowance,
    v_medical_allowance,
    v_basic_depends,
    v_hra_depends,
    v_special_depends,
    v_travel_depends,
    v_medical_depends
  FROM ranked_components
  WHERE rn = 1;

  IF v_basic_salary <= 0 THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'Employee salary structure is not configured'
    );
  END IF;

  SELECT
    s.shift_name,
    s.start_time,
    s.end_time,
    s.standard_hours,
    s.duration_hours
  INTO v_shift
  FROM public.employee_shift_assignments esa
  JOIN public.shifts s
    ON s.id = esa.shift_id
  WHERE esa.employee_id = p_employee_id
    AND esa.is_active = TRUE
    AND esa.assigned_from <= p_period_end
    AND (esa.assigned_to IS NULL OR esa.assigned_to >= p_period_start)
  ORDER BY esa.assigned_from DESC
  LIMIT 1;

  v_standard_hours := COALESCE(v_shift.standard_hours, v_shift.duration_hours, 8);

  IF v_shift.start_time IS NOT NULL AND v_shift.end_time IS NOT NULL AND v_standard_hours IS NULL THEN
    IF v_shift.end_time < v_shift.start_time THEN
      v_standard_hours := EXTRACT(EPOCH FROM (v_shift.end_time + INTERVAL '24 hours' - v_shift.start_time)) / 3600;
    ELSE
      v_standard_hours := EXTRACT(EPOCH FROM (v_shift.end_time - v_shift.start_time)) / 3600;
    END IF;
  END IF;

  v_standard_hours := COALESCE(v_standard_hours, 8);

  SELECT
    COALESCE(COUNT(*) FILTER (WHERE status IN ('present', 'late')), 0),
    COALESCE(COUNT(*) FILTER (WHERE status IN ('absent', 'absent_breach', 'unpaid_leave')), 0),
    COALESCE(COUNT(*) FILTER (WHERE status IN ('leave', 'on_leave', 'paid_leave', 'casual_leave', 'sick_leave', 'earned_leave')), 0),
    COALESCE(SUM(GREATEST(0, COALESCE(total_hours, 0) - v_standard_hours)), 0)
  INTO
    v_present_days,
    v_absent_days,
    v_leave_days,
    v_overtime_hours
  FROM public.attendance_logs
  WHERE employee_id = p_employee_id
    AND log_date BETWEEN p_period_start AND p_period_end;

  v_payable_days := v_present_days + v_leave_days;
  v_pay_ratio := LEAST(1, GREATEST(0, v_payable_days::NUMERIC / GREATEST(p_total_working_days, 1)));

  v_pro_rated_basic := ROUND(CASE WHEN v_basic_depends THEN v_basic_salary * v_pay_ratio ELSE v_basic_salary END, 2);
  v_payable_hra := ROUND(CASE WHEN v_hra_depends THEN v_hra * v_pay_ratio ELSE v_hra END, 2);
  v_payable_special_allowance := ROUND(
    CASE WHEN v_special_depends THEN v_special_allowance * v_pay_ratio ELSE v_special_allowance END,
    2
  );
  v_payable_travel_allowance := ROUND(
    CASE WHEN v_travel_depends THEN v_travel_allowance * v_pay_ratio ELSE v_travel_allowance END,
    2
  );
  v_payable_medical_allowance := ROUND(
    CASE WHEN v_medical_depends THEN v_medical_allowance * v_pay_ratio ELSE v_medical_allowance END,
    2
  );

  v_overtime_rate := ROUND(v_basic_salary / GREATEST(p_total_working_days, 1) / GREATEST(v_standard_hours, 1) * 1.5, 2);
  v_overtime_amount := ROUND(v_overtime_hours * v_overtime_rate, 2);

  v_gross_salary := v_pro_rated_basic
    + v_payable_hra
    + v_payable_special_allowance
    + v_payable_travel_allowance
    + v_payable_medical_allowance
    + v_overtime_amount;

  v_pf_deduction := ROUND(v_pro_rated_basic * 0.12, 2);
  IF v_gross_salary <= 21000 THEN
    v_esic_deduction := ROUND(v_gross_salary * 0.0075, 2);
  ELSE
    v_esic_deduction := 0;
  END IF;

  IF v_gross_salary <= 15000 THEN
    v_professional_tax := 0;
  ELSE
    v_professional_tax := 200;
  END IF;

  v_total_deductions := v_pf_deduction + v_esic_deduction + v_professional_tax;
  v_net_payable := v_gross_salary - v_total_deductions;
  v_employer_pf := ROUND(v_pro_rated_basic * 0.12, 2);
  IF v_gross_salary <= 21000 THEN
    v_employer_esic := ROUND(v_gross_salary * 0.0325, 2);
  ELSE
    v_employer_esic := 0;
  END IF;

  RETURN jsonb_build_object(
    'success', true,
    'employee_id', p_employee_id,
    'period_start', p_period_start,
    'period_end', p_period_end,
    'present_days', v_present_days,
    'absent_days', v_absent_days,
    'leave_days', v_leave_days,
    'overtime_hours', v_overtime_hours,
    'overtime_rate', v_overtime_rate,
    'overtime_amount', v_overtime_amount,
    'basic_salary', v_basic_salary,
    'pro_rated_basic', v_pro_rated_basic,
    'hra', v_payable_hra,
    'special_allowance', v_payable_special_allowance,
    'travel_allowance', v_payable_travel_allowance,
    'medical_allowance', v_payable_medical_allowance,
    'gross_salary', v_gross_salary,
    'pf_deduction', v_pf_deduction,
    'esic_deduction', v_esic_deduction,
    'professional_tax', v_professional_tax,
    'tds', 0,
    'total_deductions', v_total_deductions,
    'net_payable', v_net_payable,
    'employer_pf', v_employer_pf,
    'employer_esic', v_employer_esic,
    'standard_hours', v_standard_hours,
    'shift_name', COALESCE(v_shift.shift_name, 'General Shift')
  );
END;
$$;


ALTER FUNCTION "public"."calculate_employee_salary"("p_employee_id" "uuid", "p_period_start" "date", "p_period_end" "date", "p_total_working_days" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."check_all_ppe_items"("checklist" "jsonb") RETURNS boolean
    LANGUAGE "plpgsql" IMMUTABLE
    AS $$
DECLARE
    item RECORD;
BEGIN
    IF checklist IS NULL OR jsonb_array_length(checklist) = 0 THEN
        RETURN FALSE;
    END IF;

    FOR item IN SELECT * FROM jsonb_array_elements(checklist) LOOP
        IF (item.value->>'verified')::boolean IS NOT TRUE THEN
            RETURN FALSE;
        END IF;
    END LOOP;
    
    RETURN TRUE;
END;
$$;


ALTER FUNCTION "public"."check_all_ppe_items"("checklist" "jsonb") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."check_budget_threshold"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public'
    AS $$
DECLARE
    v_budget RECORD;
    v_usage_percent DECIMAL;
BEGIN
    SELECT * INTO v_budget FROM budgets WHERE id = NEW.budget_id;
    
    IF v_budget IS NOT NULL THEN
        v_usage_percent := (v_budget.used_amount / v_budget.allocated_amount) * 100;
        
        IF v_usage_percent >= v_budget.alert_threshold_percent AND v_budget.alert_notified_at IS NULL THEN
            INSERT INTO notifications (
                user_id,
                notification_type,
                title,
                message,
                reference_type,
                reference_id,
                priority
            )
            SELECT 
                u.id,
                'budget_threshold_alert',
                'Budget Threshold Reached',
                format('Budget "%s" has reached %s%% of its limit.', v_budget.name, ROUND(v_usage_percent, 2)),
                'budget',
                v_budget.id,
                'high'
            FROM users u
            JOIN roles r ON u.role_id = r.id
            WHERE r.role_name::text IN ('admin', 'account', 'company_md');
            
            UPDATE budgets SET alert_notified_at = NOW() WHERE id = v_budget.id;
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."check_budget_threshold"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."check_compliance"() RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN 
        SELECT 
            sg.id as guard_id, 
            e.id as employee_id,
            al.check_in_location_id as location_id
        FROM employee_shift_assignments esa
        JOIN security_guards sg ON esa.employee_id = sg.employee_id
        JOIN employees e ON sg.employee_id = e.id
        JOIN shifts s ON esa.shift_id = s.id
        JOIN attendance_logs al ON al.employee_id = e.id AND al.log_date = CURRENT_DATE
        LEFT JOIN LATERAL (
            SELECT 1 FROM checklist_responses cr 
            WHERE cr.submitted_by_guard_id = sg.id 
            AND cr.created_at::date = CURRENT_DATE
            LIMIT 1
        ) cr_exists ON TRUE
        WHERE esa.is_active = true
        AND s.start_time <= '09:00:00' 
        AND cr_exists IS NULL
        AND al.check_out_time IS NULL
    LOOP
        IF NOT EXISTS (
            SELECT 1 FROM panic_alerts 
            WHERE guard_id = r.guard_id 
            AND alert_type = 'checklist_incomplete' 
            AND is_resolved = false
        ) THEN
            INSERT INTO panic_alerts (
                guard_id,
                alert_type,
                location_id,
                description,
                is_resolved,
                alert_time
            ) VALUES (
                r.guard_id,
                'checklist_incomplete',
                r.location_id,
                'Checklist Compliance Warning: Daily checklist not submitted by 9:00 AM.',
                false,
                NOW()
            );
        END IF;
    END LOOP;
END;
$$;


ALTER FUNCTION "public"."check_compliance"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."check_finance_closure"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_target_date DATE;
BEGIN
  IF TG_TABLE_NAME = 'purchase_bills' THEN
    v_target_date := COALESCE(NEW.bill_date, OLD.bill_date);
  ELSIF TG_TABLE_NAME = 'sale_bills' THEN
    v_target_date := COALESCE(NEW.invoice_date, OLD.invoice_date);
  ELSIF TG_TABLE_NAME = 'payments' THEN
    v_target_date := COALESCE(NEW.payment_date, OLD.payment_date);
  ELSIF TG_TABLE_NAME = 'ledger_entries' THEN
    v_target_date := COALESCE(NEW.entry_date, OLD.entry_date);
  ELSE
    v_target_date := CURRENT_DATE;
  END IF;

  IF public.is_period_closed(v_target_date) THEN
    RAISE EXCEPTION 'Financial period for % is closed. Modifications not allowed.', v_target_date;
  END IF;

  RETURN COALESCE(NEW, OLD);
END;
$$;


ALTER FUNCTION "public"."check_finance_closure"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."check_geofence"("p_lat" double precision, "p_lng" double precision, "p_site_lat" double precision, "p_site_lng" double precision, "p_radius_meters" double precision) RETURNS boolean
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE v_distance DOUBLE PRECISION;
BEGIN
    SELECT (6371000 * acos(LEAST(1.0,
        cos(radians(p_lat)) * cos(radians(p_site_lat)) *
        cos(radians(p_site_lng) - radians(p_lng)) +
        sin(radians(p_lat)) * sin(radians(p_site_lat))
    ))) INTO v_distance;
    RETURN v_distance <= p_radius_meters;
END;
$$;


ALTER FUNCTION "public"."check_geofence"("p_lat" double precision, "p_lng" double precision, "p_site_lat" double precision, "p_site_lng" double precision, "p_radius_meters" double precision) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."check_grn_item_quality"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public', 'pg_catalog'
    AS $$
DECLARE
    item_quality grn_item_quality_status;
BEGIN
    -- Only check for GRN_ITEM reference types
    IF NEW.reference_type = 'GRN_ITEM' AND NEW.reference_id IS NOT NULL THEN
        -- Check if this reference_id corresponds to a rejected GRN item
        SELECT quality_status INTO item_quality 
        FROM material_receipt_items 
        WHERE id = NEW.reference_id;
        
        IF FOUND AND item_quality = 'rejected'::grn_item_quality_status THEN
            RAISE EXCEPTION 'Cannot add rejected material to stock (GRN Item: %)', NEW.reference_id;
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."check_grn_item_quality"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."check_rate_before_forward"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
    -- Only trigger when status transitions to 'indent_forwarded'
    IF NEW.status = 'indent_forwarded' AND (OLD.status IS NULL OR OLD.status <> 'indent_forwarded') THEN
        IF NEW.indent_id IS NULL THEN
            RAISE EXCEPTION 'Request cannot be forwarded without a linked indent.';
        END IF;

        IF NOT public.validate_indent_rate(NEW.indent_id) THEN
            IF NEW.is_service_request = TRUE THEN
                RAISE EXCEPTION 'No active rate contract found for this service. Verify rates before forwarding.';
            ELSE
                RAISE EXCEPTION 'No active rate contract found for one or more items in this indent. Verify rates before forwarding.';
            END IF;
        END IF;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."check_rate_before_forward"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."check_service_acknowledgment_gate"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_spo_status TEXT;
BEGIN
  IF NEW.service_purchase_order_id IS NOT NULL THEN
    SELECT spo.status
    INTO v_spo_status
    FROM public.service_purchase_orders spo
    WHERE spo.id = NEW.service_purchase_order_id;

    IF v_spo_status IS NULL THEN
      RAISE EXCEPTION 'Service purchase order not found for billing';
    END IF;

    IF v_spo_status NOT IN ('deployment_confirmed', 'completed') THEN
      RAISE EXCEPTION 'Service deployment must be confirmed before billing for SPO-linked work';
    END IF;

    IF NOT EXISTS (
      SELECT 1
      FROM public.service_acknowledgments
      WHERE spo_id = NEW.service_purchase_order_id
        AND status = 'acknowledged'
    ) THEN
      RAISE EXCEPTION 'Service acknowledgment required before billing for SPO-linked work';
    END IF;

    IF NOT EXISTS (
      SELECT 1
      FROM public.service_delivery_notes
      WHERE po_id = NEW.service_purchase_order_id
        AND status IN ('pending', 'verified')
    ) THEN
      RAISE EXCEPTION 'Service delivery note required before billing for SPO-linked work';
    END IF;
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."check_service_acknowledgment_gate"() OWNER TO "postgres";


COMMENT ON FUNCTION "public"."check_service_acknowledgment_gate"() IS 'Blocks SPO-linked bills until the deployment has a delivery note, an acknowledged service_acknowledgments row, and a deployment-confirmed SPO.';



CREATE OR REPLACE FUNCTION "public"."check_visitor_immutability"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
  IF is_guard() AND NOT is_admin() THEN
    IF OLD.flat_id IS DISTINCT FROM NEW.flat_id
       OR OLD.visitor_name IS DISTINCT FROM NEW.visitor_name
       OR OLD.approved_by_resident IS DISTINCT FROM NEW.approved_by_resident
       OR OLD.resident_id IS DISTINCT FROM NEW.resident_id
       OR OLD.visitor_type IS DISTINCT FROM NEW.visitor_type
       OR OLD.is_frequent_visitor IS DISTINCT FROM NEW.is_frequent_visitor
       OR OLD.bypass_reason IS DISTINCT FROM NEW.bypass_reason THEN
      RAISE EXCEPTION 'Security Policy: Guards cannot modify visitor approval or identity fields.';
    END IF;
  ELSIF is_resident() AND NOT is_admin() THEN
    IF OLD.flat_id IS DISTINCT FROM NEW.flat_id
       OR OLD.visitor_name IS DISTINCT FROM NEW.visitor_name
       OR OLD.resident_id IS DISTINCT FROM NEW.resident_id
       OR OLD.visitor_type IS DISTINCT FROM NEW.visitor_type
       OR OLD.phone IS DISTINCT FROM NEW.phone
       OR OLD.vehicle_number IS DISTINCT FROM NEW.vehicle_number
       OR OLD.photo_url IS DISTINCT FROM NEW.photo_url
       OR OLD.purpose IS DISTINCT FROM NEW.purpose
       OR OLD.entry_time IS DISTINCT FROM NEW.entry_time
       OR OLD.exit_time IS DISTINCT FROM NEW.exit_time
       OR OLD.entry_guard_id IS DISTINCT FROM NEW.entry_guard_id
       OR OLD.exit_guard_id IS DISTINCT FROM NEW.exit_guard_id
       OR OLD.entry_location_id IS DISTINCT FROM NEW.entry_location_id
       OR OLD.bypass_reason IS DISTINCT FROM NEW.bypass_reason
       OR OLD.visitor_pass_number IS DISTINCT FROM NEW.visitor_pass_number THEN
      RAISE EXCEPTION 'Security Policy: Residents can only approve, deny, or change frequent visitor status from the app.';
    END IF;
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."check_visitor_immutability"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."checkout_visitor"("p_visitor_id" "uuid", "p_user_id" "uuid") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_visitor RECORD;
  v_guard_id UUID;
  v_assigned_location_id UUID;
  v_is_guard BOOLEAN;
BEGIN
  IF auth.uid() IS NULL THEN
    RETURN jsonb_build_object('success', false, 'error', 'Authentication required');
  END IF;

  IF auth.uid() IS DISTINCT FROM p_user_id THEN
    RETURN jsonb_build_object('success', false, 'error', 'Authenticated user mismatch');
  END IF;

  v_is_guard := is_guard();

  IF NOT (
    v_is_guard
    OR is_admin()
    OR has_role('super_admin')
    OR has_role('security_supervisor')
    OR has_role('society_manager')
  ) THEN
    RETURN jsonb_build_object('success', false, 'error', 'Only guards and visitor managers can check out visitors');
  END IF;

  IF v_is_guard THEN
    SELECT
      sg.id,
      sg.assigned_location_id
    INTO
      v_guard_id,
      v_assigned_location_id
    FROM public.security_guards sg
    JOIN public.employees e ON sg.employee_id = e.id
    WHERE e.auth_user_id = p_user_id
    LIMIT 1;

    IF v_guard_id IS NULL THEN
      RETURN jsonb_build_object('success', false, 'error', 'Guard profile not found');
    END IF;
  END IF;

  SELECT * INTO v_visitor
  FROM public.visitors
  WHERE id = p_visitor_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RETURN jsonb_build_object('success', false, 'error', 'Visitor not found');
  END IF;

  IF v_visitor.exit_time IS NOT NULL THEN
    RETURN jsonb_build_object('success', false, 'error', 'Visitor has already been checked out');
  END IF;

  IF v_is_guard
     AND v_assigned_location_id IS NOT NULL
     AND v_visitor.entry_location_id IS DISTINCT FROM v_assigned_location_id THEN
    RETURN jsonb_build_object('success', false, 'error', 'Guards can only check out visitors from their assigned gate');
  END IF;

  UPDATE public.visitors
  SET
    exit_time = NOW(),
    exit_guard_id = v_guard_id
  WHERE id = p_visitor_id;

  RETURN jsonb_build_object('success', true, 'visitor_id', p_visitor_id, 'exit_time', NOW());
END;
$$;


ALTER FUNCTION "public"."checkout_visitor"("p_visitor_id" "uuid", "p_user_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."complete_service_task"("p_request_id" "uuid", "p_after_photo_url" "text", "p_completion_notes" "text" DEFAULT NULL::"text", "p_signature_url" "text" DEFAULT NULL::"text") RETURNS boolean
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_request public.service_requests%ROWTYPE;
  v_session public.job_sessions%ROWTYPE;
  v_session_id UUID;
  v_after_photo_url TEXT := NULLIF(BTRIM(p_after_photo_url), '');
  v_completion_notes TEXT := NULLIF(BTRIM(p_completion_notes), '');
BEGIN
  IF v_after_photo_url IS NULL THEN
    RAISE EXCEPTION 'Completion photo evidence is mandatory';
  END IF;

  IF v_completion_notes IS NULL OR LENGTH(v_completion_notes) < 10 THEN
    RAISE EXCEPTION 'Operational Truth Error: Meaningful resolution notes (min 10 chars) required.';
  END IF;

  SELECT *
  INTO v_request
  FROM public.service_requests
  WHERE id = p_request_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Service request % not found', p_request_id;
  END IF;

  SELECT *
  INTO v_session
  FROM public.job_sessions js
  WHERE js.service_request_id = p_request_id
  ORDER BY
    CASE WHEN js.status IN ('started', 'paused') THEN 0 ELSE 1 END,
    js.created_at DESC
  LIMIT 1;

  IF v_session.id IS NULL THEN
    IF v_request.assigned_to IS NULL THEN
      RAISE EXCEPTION 'No technician is assigned to service request %', p_request_id;
    END IF;

    INSERT INTO public.job_sessions (
      service_request_id,
      technician_id,
      start_time,
      end_time,
      status,
      remarks
    )
    VALUES (
      p_request_id,
      v_request.assigned_to,
      COALESCE(v_request.started_at, NOW()),
      NOW(),
      'completed',
      v_completion_notes
    )
    RETURNING * INTO v_session;
  ELSE
    UPDATE public.job_sessions
    SET
      status = 'completed',
      end_time = COALESCE(end_time, NOW()),
      remarks = v_completion_notes,
      updated_at = NOW()
    WHERE id = v_session.id
    RETURNING * INTO v_session;
  END IF;

  v_session_id := v_session.id;

  IF v_request.before_photo_url IS NOT NULL THEN
    INSERT INTO public.job_photos (
      job_session_id,
      photo_type,
      photo_url,
      captured_at
    )
    SELECT
      v_session_id,
      'before',
      v_request.before_photo_url,
      NOW()
    WHERE NOT EXISTS (
      SELECT 1
      FROM public.job_photos jp
      WHERE jp.job_session_id = v_session_id
        AND jp.photo_type = 'before'
        AND jp.photo_url = v_request.before_photo_url
    );
  END IF;

  INSERT INTO public.job_photos (
    job_session_id,
    photo_type,
    photo_url,
    captured_at
  )
  SELECT
    v_session_id,
    'after',
    v_after_photo_url,
    NOW()
  WHERE NOT EXISTS (
    SELECT 1
    FROM public.job_photos jp
    WHERE jp.job_session_id = v_session_id
      AND jp.photo_type = 'after'
      AND jp.photo_url = v_after_photo_url
  );

  UPDATE public.service_requests
  SET
    status = 'completed',
    completed_at = NOW(),
    after_photo_url = v_after_photo_url,
    completion_notes = v_completion_notes,
    resolution_notes = v_completion_notes,
    completion_signature_url = p_signature_url,
    updated_at = NOW()
  WHERE id = p_request_id;

  RETURN TRUE;
END;
$$;


ALTER FUNCTION "public"."complete_service_task"("p_request_id" "uuid", "p_after_photo_url" "text", "p_completion_notes" "text", "p_signature_url" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_behavior_ticket"("p_subject_name" "text", "p_category" "text", "p_severity" "text", "p_note" "text", "p_evidence_urls" "jsonb" DEFAULT '[]'::"jsonb", "p_location_name" "text" DEFAULT NULL::"text", "p_linked_employee_id" "uuid" DEFAULT NULL::"uuid") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_ticket public.oversight_tickets%ROWTYPE;
BEGIN
  IF auth.uid() IS NULL OR get_my_app_role() NOT IN ('admin', 'super_admin', 'security_supervisor', 'society_manager') THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Only oversight users can create behavior tickets');
  END IF;

  IF COALESCE(BTRIM(p_subject_name), '') = '' OR COALESCE(BTRIM(p_category), '') = '' OR COALESCE(BTRIM(p_note), '') = '' THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Subject, category, and note are required');
  END IF;

  INSERT INTO public.oversight_tickets (
    ticket_type,
    subject_name,
    category,
    severity,
    status,
    note,
    evidence_urls,
    location_name,
    linked_employee_id,
    created_by
  )
  VALUES (
    'behavior',
    BTRIM(p_subject_name),
    BTRIM(p_category),
    COALESCE(NULLIF(LOWER(BTRIM(p_severity)), ''), 'medium'),
    'open',
    BTRIM(p_note),
    COALESCE(p_evidence_urls, '[]'::JSONB),
    NULLIF(BTRIM(p_location_name), ''),
    p_linked_employee_id,
    auth.uid()
  )
  RETURNING * INTO v_ticket;

  RETURN JSONB_BUILD_OBJECT(
    'success', TRUE,
    'ticket_id', v_ticket.id,
    'ticket_number', v_ticket.ticket_number
  );
END;
$$;


ALTER FUNCTION "public"."create_behavior_ticket"("p_subject_name" "text", "p_category" "text", "p_severity" "text", "p_note" "text", "p_evidence_urls" "jsonb", "p_location_name" "text", "p_linked_employee_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_material_ticket"("p_subject_name" "text", "p_category" "text", "p_note" "text", "p_material_issue_type" "text", "p_severity" "text" DEFAULT 'medium'::"text", "p_batch_number" "text" DEFAULT NULL::"text", "p_ordered_quantity" numeric DEFAULT NULL::numeric, "p_received_quantity" numeric DEFAULT NULL::numeric, "p_return_quantity" numeric DEFAULT NULL::numeric, "p_evidence_urls" "jsonb" DEFAULT '[]'::"jsonb", "p_location_name" "text" DEFAULT NULL::"text", "p_source_visitor_id" "uuid" DEFAULT NULL::"uuid", "p_inspection_outcome" "text" DEFAULT NULL::"text") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_ticket public.oversight_tickets%ROWTYPE;
  v_return_ticket public.oversight_tickets%ROWTYPE;
  v_material_issue_type TEXT := LOWER(COALESCE(NULLIF(BTRIM(p_material_issue_type), ''), 'quantity'));
  v_inspection_outcome TEXT := LOWER(COALESCE(NULLIF(BTRIM(p_inspection_outcome), ''), ''));
  v_status TEXT := 'open';
  v_ordered_quantity NUMERIC := CASE
    WHEN p_ordered_quantity IS NULL OR p_ordered_quantity < 0 THEN NULL
    ELSE p_ordered_quantity
  END;
  v_received_quantity NUMERIC := CASE
    WHEN p_received_quantity IS NULL OR p_received_quantity < 0 THEN NULL
    ELSE p_received_quantity
  END;
  v_shortage_quantity NUMERIC;
  v_return_quantity NUMERIC := CASE
    WHEN p_return_quantity IS NULL OR p_return_quantity < 0 THEN NULL
    ELSE p_return_quantity
  END;
BEGIN
  IF auth.uid() IS NULL OR get_my_app_role() NOT IN ('admin', 'super_admin', 'security_supervisor', 'society_manager') THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Only oversight users can create material tickets');
  END IF;

  IF COALESCE(BTRIM(p_subject_name), '') = '' OR COALESCE(BTRIM(p_category), '') = '' OR COALESCE(BTRIM(p_note), '') = '' THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Subject, category, and note are required');
  END IF;

  IF v_material_issue_type NOT IN ('quality', 'quantity') THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Material issue type must be quality or quantity');
  END IF;

  IF v_inspection_outcome <> '' AND v_inspection_outcome NOT IN ('approved', 'rejected') THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Inspection outcome must be approved or rejected');
  END IF;

  IF v_ordered_quantity IS NOT NULL AND v_received_quantity IS NOT NULL AND v_received_quantity > v_ordered_quantity THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Received quantity cannot exceed ordered quantity');
  END IF;

  v_shortage_quantity := CASE
    WHEN v_ordered_quantity IS NOT NULL AND v_received_quantity IS NOT NULL
      THEN GREATEST(v_ordered_quantity - v_received_quantity, 0)
    ELSE NULL
  END;

  IF v_inspection_outcome IN ('approved', 'rejected') THEN
    v_status := 'closed';
  END IF;

  IF v_inspection_outcome = 'rejected' AND v_return_quantity IS NULL THEN
    v_return_quantity := COALESCE(v_received_quantity, v_shortage_quantity, v_ordered_quantity, 0);
  END IF;

  INSERT INTO public.oversight_tickets (
    ticket_type,
    material_issue_type,
    source_visitor_id,
    subject_name,
    category,
    severity,
    status,
    note,
    evidence_urls,
    batch_number,
    ordered_quantity,
    received_quantity,
    shortage_quantity,
    return_quantity,
    inspection_outcome,
    location_name,
    acknowledged_at,
    acknowledged_by,
    resolved_at,
    resolved_by,
    resolution_notes,
    created_by
  )
  VALUES (
    'material',
    v_material_issue_type,
    p_source_visitor_id,
    BTRIM(p_subject_name),
    BTRIM(p_category),
    COALESCE(NULLIF(LOWER(BTRIM(p_severity)), ''), 'medium'),
    v_status,
    BTRIM(p_note),
    CASE
      WHEN COALESCE(JSONB_TYPEOF(p_evidence_urls), 'null') = 'array' THEN COALESCE(p_evidence_urls, '[]'::JSONB)
      ELSE '[]'::JSONB
    END,
    NULLIF(BTRIM(p_batch_number), ''),
    v_ordered_quantity,
    v_received_quantity,
    v_shortage_quantity,
    v_return_quantity,
    NULLIF(v_inspection_outcome, ''),
    NULLIF(BTRIM(p_location_name), ''),
    CASE WHEN v_status = 'closed' THEN NOW() ELSE NULL END,
    CASE WHEN v_status = 'closed' THEN auth.uid() ELSE NULL END,
    CASE WHEN v_status = 'closed' THEN NOW() ELSE NULL END,
    CASE WHEN v_status = 'closed' THEN auth.uid() ELSE NULL END,
    CASE
      WHEN v_inspection_outcome = 'approved' THEN 'Material inspection approved on mobile.'
      WHEN v_inspection_outcome = 'rejected' THEN 'Material inspection rejected and return follow-up created.'
      ELSE NULL
    END,
    auth.uid()
  )
  RETURNING * INTO v_ticket;

  IF v_inspection_outcome = 'rejected' THEN
    INSERT INTO public.oversight_tickets (
      ticket_type,
      material_issue_type,
      source_visitor_id,
      parent_ticket_id,
      subject_name,
      category,
      severity,
      status,
      note,
      evidence_urls,
      batch_number,
      ordered_quantity,
      received_quantity,
      shortage_quantity,
      return_quantity,
      location_name,
      created_by
    )
    VALUES (
      'return',
      v_material_issue_type,
      p_source_visitor_id,
      v_ticket.id,
      BTRIM(p_subject_name),
      'Return required',
      COALESCE(NULLIF(LOWER(BTRIM(p_severity)), ''), 'medium'),
      'open',
      COALESCE(NULLIF(BTRIM(p_note), ''), 'Return material follow-up required after rejected inspection.'),
      CASE
        WHEN COALESCE(JSONB_TYPEOF(p_evidence_urls), 'null') = 'array' THEN COALESCE(p_evidence_urls, '[]'::JSONB)
        ELSE '[]'::JSONB
      END,
      NULLIF(BTRIM(p_batch_number), ''),
      v_ordered_quantity,
      v_received_quantity,
      v_shortage_quantity,
      COALESCE(v_return_quantity, 0),
      NULLIF(BTRIM(p_location_name), ''),
      auth.uid()
    )
    RETURNING * INTO v_return_ticket;
  END IF;

  RETURN JSONB_BUILD_OBJECT(
    'success', TRUE,
    'ticket_id', v_ticket.id,
    'ticket_number', v_ticket.ticket_number,
    'return_ticket_id', v_return_ticket.id,
    'return_ticket_number', v_return_ticket.ticket_number
  );
END;
$$;


ALTER FUNCTION "public"."create_material_ticket"("p_subject_name" "text", "p_category" "text", "p_note" "text", "p_material_issue_type" "text", "p_severity" "text", "p_batch_number" "text", "p_ordered_quantity" numeric, "p_received_quantity" numeric, "p_return_quantity" numeric, "p_evidence_urls" "jsonb", "p_location_name" "text", "p_source_visitor_id" "uuid", "p_inspection_outcome" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_mobile_visitor"("p_visitor_name" "text", "p_phone" "text", "p_purpose" "text", "p_flat_id" "uuid", "p_vehicle_number" "text" DEFAULT NULL::"text", "p_photo_url" "text" DEFAULT NULL::"text", "p_is_frequent_visitor" boolean DEFAULT false) RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_guard_id UUID;
  v_guard_location_id UUID;
  v_primary_resident_id UUID;
  v_auto_approve BOOLEAN := FALSE;
  v_visitor_id UUID;
  v_recipient RECORD;
BEGIN
  IF auth.uid() IS NULL OR NOT is_guard() THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Only authenticated guards can create visitors');
  END IF;

  IF COALESCE(BTRIM(p_visitor_name), '') = '' OR p_flat_id IS NULL THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Visitor name and destination flat are required');
  END IF;

  SELECT
    sg.id,
    sg.assigned_location_id
  INTO
    v_guard_id,
    v_guard_location_id
  FROM public.security_guards sg
  JOIN public.employees e ON e.id = sg.employee_id
  WHERE e.auth_user_id = auth.uid()
  LIMIT 1;

  SELECT r.id
  INTO v_primary_resident_id
  FROM public.residents r
  WHERE r.flat_id = p_flat_id
    AND r.is_active = TRUE
  ORDER BY r.is_primary_contact DESC, r.created_at
  LIMIT 1;

  IF p_is_frequent_visitor THEN
    SELECT EXISTS (
      SELECT 1
      FROM public.visitors v
      WHERE
        v.flat_id = p_flat_id
        AND COALESCE(v.phone, '') = COALESCE(p_phone, '')
        AND v.is_frequent_visitor = TRUE
        AND v.approved_by_resident = TRUE
    )
    INTO v_auto_approve;
  END IF;

  INSERT INTO public.visitors (
    visitor_name,
    visitor_type,
    phone,
    vehicle_number,
    photo_url,
    flat_id,
    resident_id,
    purpose,
    entry_guard_id,
    entry_location_id,
    approved_by_resident,
    is_frequent_visitor,
    approval_status,
    approval_deadline_at,
    notification_sent_at
  )
  VALUES (
    p_visitor_name,
    'guest',
    NULLIF(p_phone, ''),
    NULLIF(p_vehicle_number, ''),
    NULLIF(p_photo_url, ''),
    p_flat_id,
    v_primary_resident_id,
    NULLIF(p_purpose, ''),
    v_guard_id,
    v_guard_location_id,
    CASE WHEN v_auto_approve THEN TRUE ELSE NULL END,
    p_is_frequent_visitor,
    CASE WHEN v_auto_approve THEN 'approved' ELSE 'pending' END,
    CASE WHEN v_auto_approve THEN NULL ELSE NOW() + INTERVAL '30 seconds' END,
    NOW()
  )
  RETURNING id INTO v_visitor_id;

  IF NOT v_auto_approve THEN
    FOR v_recipient IN
      SELECT r.auth_user_id AS user_id
      FROM public.residents r
      WHERE r.flat_id = p_flat_id
        AND r.is_active = TRUE
        AND r.auth_user_id IS NOT NULL
    LOOP
      PERFORM public.mobile_insert_notification(
        v_recipient.user_id,
        'Visitor at gate',
        p_visitor_name || ' is waiting for approval at the gate.',
        'visitor_at_gate',
        'high',
        '/resident/approvals',
        JSONB_BUILD_OBJECT(
          'visitor_id', v_visitor_id,
          'flat_id', p_flat_id
        ),
        'push_queued',
        'queued',
        NOW() + INTERVAL '60 seconds'
      );
    END LOOP;
  END IF;

  RETURN (
    SELECT JSONB_BUILD_OBJECT(
      'success', TRUE,
      'visitor', TO_JSONB(v)
    )
    FROM public.visitors v
    WHERE v.id = v_visitor_id
  );
END;
$$;


ALTER FUNCTION "public"."create_mobile_visitor"("p_visitor_name" "text", "p_phone" "text", "p_purpose" "text", "p_flat_id" "uuid", "p_vehicle_number" "text", "p_photo_url" "text", "p_is_frequent_visitor" boolean) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_mobile_visitor"("p_visitor_name" "text", "p_phone" "text", "p_purpose" "text", "p_flat_id" "uuid", "p_vehicle_number" "text" DEFAULT NULL::"text", "p_photo_url" "text" DEFAULT NULL::"text", "p_is_frequent_visitor" boolean DEFAULT false, "p_visitor_type" "text" DEFAULT 'guest'::"text") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_guard_id UUID;
  v_guard_location_id UUID;
  v_primary_resident_id UUID;
  v_auto_approve BOOLEAN := FALSE;
  v_visitor_id UUID;
  v_recipient RECORD;
  v_visitor_type TEXT := LOWER(COALESCE(NULLIF(BTRIM(p_visitor_type), ''), 'guest'));
  v_guard_name TEXT;
  v_gate_name TEXT;
  v_requires_resident_approval BOOLEAN := TRUE;
  v_approval_deadline TIMESTAMPTZ := NOW() + INTERVAL '5 minutes';
BEGIN
  IF auth.uid() IS NULL OR NOT is_guard() THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Only authenticated guards can create visitors');
  END IF;

  IF COALESCE(BTRIM(p_visitor_name), '') = '' THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Visitor name is required');
  END IF;

  IF v_visitor_type = 'delivery' THEN
    v_requires_resident_approval := FALSE;
  ELSIF p_flat_id IS NULL THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Destination flat is required for resident-bound visitors');
  END IF;

  SELECT
    sg.id,
    sg.assigned_location_id,
    TRIM(COALESCE(e.first_name, '') || ' ' || COALESCE(e.last_name, '')),
    COALESCE(cl.location_name, 'Gate')
  INTO
    v_guard_id,
    v_guard_location_id,
    v_guard_name,
    v_gate_name
  FROM public.security_guards sg
  JOIN public.employees e ON e.id = sg.employee_id
  LEFT JOIN public.company_locations cl ON cl.id = sg.assigned_location_id
  WHERE e.auth_user_id = auth.uid()
  LIMIT 1;

  IF p_flat_id IS NOT NULL THEN
    SELECT r.id
    INTO v_primary_resident_id
    FROM public.residents r
    WHERE r.flat_id = p_flat_id
      AND r.is_active = TRUE
    ORDER BY r.is_primary_contact DESC, r.created_at
    LIMIT 1;
  END IF;

  IF v_requires_resident_approval AND p_is_frequent_visitor THEN
    SELECT EXISTS (
      SELECT 1
      FROM public.visitors v
      WHERE
        v.flat_id = p_flat_id
        AND COALESCE(v.phone, '') = COALESCE(p_phone, '')
        AND v.is_frequent_visitor = TRUE
        AND v.approved_by_resident = TRUE
    )
    INTO v_auto_approve;
  END IF;

  INSERT INTO public.visitors (
    visitor_name,
    visitor_type,
    phone,
    vehicle_number,
    photo_url,
    flat_id,
    resident_id,
    purpose,
    entry_guard_id,
    entry_location_id,
    approved_by_resident,
    is_frequent_visitor,
    approval_status,
    approval_deadline_at,
    decision_at,
    notification_sent_at
  )
  VALUES (
    p_visitor_name,
    v_visitor_type,
    NULLIF(p_phone, ''),
    NULLIF(p_vehicle_number, ''),
    NULLIF(p_photo_url, ''),
    p_flat_id,
    v_primary_resident_id,
    NULLIF(p_purpose, ''),
    v_guard_id,
    v_guard_location_id,
    CASE
      WHEN v_requires_resident_approval THEN CASE WHEN v_auto_approve THEN TRUE ELSE NULL END
      ELSE TRUE
    END,
    CASE
      WHEN v_requires_resident_approval THEN p_is_frequent_visitor
      ELSE FALSE
    END,
    CASE
      WHEN v_requires_resident_approval THEN CASE WHEN v_auto_approve THEN 'approved' ELSE 'pending' END
      ELSE 'approved'
    END,
    CASE
      WHEN v_requires_resident_approval AND NOT v_auto_approve THEN v_approval_deadline
      ELSE NULL
    END,
    CASE
      WHEN v_requires_resident_approval AND NOT v_auto_approve THEN NULL
      ELSE NOW()
    END,
    NOW()
  )
  RETURNING id INTO v_visitor_id;

  IF v_requires_resident_approval AND NOT v_auto_approve THEN
    FOR v_recipient IN
      SELECT r.auth_user_id AS user_id
      FROM public.residents r
      WHERE r.flat_id = p_flat_id
        AND r.is_active = TRUE
        AND r.auth_user_id IS NOT NULL
    LOOP
      PERFORM public.mobile_insert_notification(
        v_recipient.user_id,
        'Visitor at gate',
        p_visitor_name || ' is waiting at ' || v_gate_name || ' for your approval.',
        'visitor_at_gate',
        'high',
        '/resident/approvals',
        JSONB_BUILD_OBJECT(
          'visitor_id', v_visitor_id,
          'flat_id', p_flat_id,
          'visitor_name', p_visitor_name,
          'vehicle_number', NULLIF(p_vehicle_number, ''),
          'purpose', NULLIF(p_purpose, ''),
          'gate_name', v_gate_name,
          'visitor_photo_url', NULLIF(p_photo_url, ''),
          'approval_deadline_at', v_approval_deadline
        ),
        'push_queued',
        'queued',
        NOW() + INTERVAL '10 minutes'
      );
    END LOOP;
  ELSIF v_visitor_type = 'delivery' THEN
    FOR v_recipient IN
      SELECT u.id
      FROM public.users u
      JOIN public.roles r ON r.id = u.role_id
      WHERE
        u.is_active = TRUE
        AND r.role_name::TEXT IN ('security_supervisor', 'society_manager', 'admin', 'super_admin')
    LOOP
      PERFORM public.mobile_insert_notification(
        v_recipient.id,
        'Material delivery logged',
        p_visitor_name || ' has been logged as a delivery vehicle at ' || v_gate_name || '.',
        'material_delivery',
        'high',
        '/oversight/tickets',
        JSONB_BUILD_OBJECT(
          'visitor_id', v_visitor_id,
          'visitor_name', p_visitor_name,
          'vehicle_number', NULLIF(p_vehicle_number, ''),
          'purpose', NULLIF(p_purpose, ''),
          'gate_name', v_gate_name,
          'guard_name', v_guard_name,
          'visitor_photo_url', NULLIF(p_photo_url, '')
        ),
        'push_queued',
        'not_applicable',
        NULL
      );
    END LOOP;
  END IF;

  RETURN (
    SELECT JSONB_BUILD_OBJECT(
      'success', TRUE,
      'visitor_id', v.id,
      'visitor', TO_JSONB(v)
    )
    FROM public.visitors v
    WHERE v.id = v_visitor_id
  );
END;
$$;


ALTER FUNCTION "public"."create_mobile_visitor"("p_visitor_name" "text", "p_phone" "text", "p_purpose" "text", "p_flat_id" "uuid", "p_vehicle_number" "text", "p_photo_url" "text", "p_is_frequent_visitor" boolean, "p_visitor_type" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_po_from_supplier_request"("p_request_id" "uuid") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_request public.requests%ROWTYPE;
  v_indent public.indents%ROWTYPE;
  v_existing_po_id UUID;
  v_po_id UUID;
  v_subtotal BIGINT := 0;
  v_tax BIGINT := 0;
  v_discount BIGINT := 0;
  v_shipping BIGINT := 0;
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'Authentication required';
  END IF;

  SELECT *
  INTO v_request
  FROM public.requests
  WHERE id = p_request_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Request not found';
  END IF;

  IF v_request.supplier_id IS NULL THEN
    RAISE EXCEPTION 'Request is not linked to a supplier';
  END IF;

  IF v_request.indent_id IS NULL THEN
    RAISE EXCEPTION 'Request is not linked to an indent';
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM public.users
    WHERE id = auth.uid()
      AND supplier_id = v_request.supplier_id
  ) THEN
    RAISE EXCEPTION 'Only the assigned supplier can create the linked purchase order';
  END IF;

  SELECT *
  INTO v_indent
  FROM public.indents
  WHERE id = v_request.indent_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Linked indent not found';
  END IF;

  IF v_indent.status NOT IN ('approved', 'po_created') THEN
    RAISE EXCEPTION 'Only approved indents can be converted to purchase orders';
  END IF;

  SELECT id
  INTO v_existing_po_id
  FROM public.purchase_orders
  WHERE indent_id = v_request.indent_id
    AND supplier_id = v_request.supplier_id
  ORDER BY created_at DESC
  LIMIT 1;

  IF v_existing_po_id IS NOT NULL THEN
    -- Two-step transition to satisfy enforce_request_status_transition (max rank diff = 2):
    -- indent_forwarded(5) → indent_accepted(6) diff=1, then indent_accepted(6) → po_issued(8) diff=2
    IF v_request.status = 'indent_forwarded' THEN
      UPDATE public.requests
      SET status = 'indent_accepted', updated_at = NOW()
      WHERE id = p_request_id;
    END IF;

    UPDATE public.requests
    SET
      status = 'po_issued',
      rejection_reason = NULL,
      updated_at = NOW()
    WHERE id = p_request_id;

    RETURN jsonb_build_object(
      'success', true,
      'created', false,
      'purchase_order_id', v_existing_po_id
    );
  END IF;

  INSERT INTO public.purchase_orders (
    indent_id,
    supplier_id,
    po_date,
    expected_delivery_date,
    status,
    sent_to_vendor_at,
    notes,
    created_by,
    updated_by
  )
  VALUES (
    v_request.indent_id,
    v_request.supplier_id,
    CURRENT_DATE,
    v_request.preferred_delivery_date,
    'sent_to_vendor',
    NOW(),
    COALESCE(v_request.title, 'Supplier accepted indent')
      || ' | Auto-created from request '
      || COALESCE(v_request.request_number, p_request_id::TEXT),
    auth.uid(),
    auth.uid()
  )
  RETURNING id
  INTO v_po_id;

  INSERT INTO public.purchase_order_items (
    purchase_order_id,
    indent_item_id,
    product_id,
    item_description,
    specifications,
    ordered_quantity,
    unit_of_measure,
    unit_price,
    tax_rate,
    tax_amount,
    discount_percent,
    discount_amount,
    line_total,
    unmatched_qty,
    unmatched_amount,
    notes
  )
  SELECT
    v_po_id,
    ii.id,
    ii.product_id,
    ii.item_description,
    ii.specifications,
    COALESCE(ii.approved_quantity, ii.requested_quantity),
    ii.unit_of_measure,
    COALESCE(ii.estimated_unit_price, 0),
    0,
    0,
    0,
    0,
    ROUND(
      COALESCE(ii.estimated_unit_price, 0)::NUMERIC
      * COALESCE(ii.approved_quantity, ii.requested_quantity)
    )::BIGINT,
    COALESCE(ii.approved_quantity, ii.requested_quantity),
    ROUND(
      COALESCE(ii.estimated_unit_price, 0)::NUMERIC
      * COALESCE(ii.approved_quantity, ii.requested_quantity)
    )::BIGINT,
    ii.notes
  FROM public.indent_items ii
  WHERE ii.indent_id = v_request.indent_id;

  IF NOT EXISTS (
    SELECT 1
    FROM public.purchase_order_items
    WHERE purchase_order_id = v_po_id
  ) THEN
    RAISE EXCEPTION 'Linked indent has no items to convert into a purchase order';
  END IF;

  SELECT
    COALESCE(SUM(line_total), 0),
    COALESCE(SUM(tax_amount), 0),
    COALESCE(SUM(discount_amount), 0)
  INTO
    v_subtotal,
    v_tax,
    v_discount
  FROM public.purchase_order_items
  WHERE purchase_order_id = v_po_id;

  UPDATE public.purchase_orders
  SET
    subtotal = v_subtotal,
    tax_amount = v_tax,
    discount_amount = v_discount,
    grand_total = v_subtotal + v_tax - v_discount + v_shipping,
    updated_at = NOW()
  WHERE id = v_po_id;

  UPDATE public.indents
  SET
    status = 'po_created',
    linked_po_id = v_po_id,
    po_created_at = NOW(),
    updated_at = NOW(),
    updated_by = auth.uid()
  WHERE id = v_request.indent_id;

  -- Two-step transition: indent_forwarded → indent_accepted → po_issued
  IF v_request.status = 'indent_forwarded' THEN
    UPDATE public.requests
    SET status = 'indent_accepted', updated_at = NOW()
    WHERE id = p_request_id;
  END IF;

  UPDATE public.requests
  SET
    status = 'po_issued',
    rejection_reason = NULL,
    updated_at = NOW()
  WHERE id = p_request_id;

  RETURN jsonb_build_object(
    'success', true,
    'created', true,
    'purchase_order_id', v_po_id
  );
END;
$$;


ALTER FUNCTION "public"."create_po_from_supplier_request"("p_request_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_qr_for_asset"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
    INSERT INTO qr_codes (asset_id, society_id, claimed_by, claimed_at, created_by)
    VALUES (NEW.id, NEW.society_id, NEW.created_by, CURRENT_TIMESTAMP, NEW.created_by);
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."create_qr_for_asset"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_resident_invited_visitor"("p_visitor_name" "text", "p_visitor_type" "text" DEFAULT 'guest'::"text", "p_phone" "text" DEFAULT NULL::"text", "p_purpose" "text" DEFAULT NULL::"text", "p_vehicle_number" "text" DEFAULT NULL::"text") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_resident RECORD;
  v_visitor_id UUID;
  v_visitor_type TEXT := LOWER(COALESCE(NULLIF(BTRIM(p_visitor_type), ''), 'guest'));
BEGIN
  IF auth.uid() IS NULL THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Authentication required');
  END IF;

  IF COALESCE(BTRIM(p_visitor_name), '') = '' THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Visitor name is required');
  END IF;

  SELECT
    r.id,
    r.flat_id,
    r.full_name
  INTO v_resident
  FROM public.residents r
  WHERE r.auth_user_id = auth.uid()
    AND r.is_active = TRUE
  ORDER BY r.is_primary_contact DESC, r.created_at
  LIMIT 1;

  IF v_resident.id IS NULL OR v_resident.flat_id IS NULL THEN
    RETURN JSONB_BUILD_OBJECT(
      'success',
      FALSE,
      'error',
      'Resident profile with an assigned flat is required'
    );
  END IF;

  INSERT INTO public.visitors (
    visitor_name,
    visitor_type,
    phone,
    vehicle_number,
    purpose,
    flat_id,
    resident_id,
    approved_by_resident,
    approval_status,
    is_frequent_visitor,
    entry_time,
    exit_time,
    approval_deadline_at,
    decision_at,
    rejection_reason,
    notification_sent_at
  )
  VALUES (
    BTRIM(p_visitor_name),
    v_visitor_type,
    NULLIF(BTRIM(p_phone), ''),
    NULLIF(BTRIM(p_vehicle_number), ''),
    NULLIF(BTRIM(p_purpose), ''),
    v_resident.flat_id,
    v_resident.id,
    TRUE,
    'approved',
    FALSE,
    NULL,
    NULL,
    NULL,
    NOW(),
    NULL,
    NOW()
  )
  RETURNING id INTO v_visitor_id;

  RETURN (
    SELECT JSONB_BUILD_OBJECT(
      'success', TRUE,
      'visitor_id', v.id,
      'visitor', TO_JSONB(v)
    )
    FROM public.visitors v
    WHERE v.id = v_visitor_id
  );
END;
$$;


ALTER FUNCTION "public"."create_resident_invited_visitor"("p_visitor_name" "text", "p_visitor_type" "text", "p_phone" "text", "p_purpose" "text", "p_vehicle_number" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."deduct_stock_on_material_use"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
    available_quantity DECIMAL(10, 2);
    target_batch_id UUID;
BEGIN
    IF NEW.stock_batch_id IS NOT NULL THEN
        target_batch_id := NEW.stock_batch_id;
        
        -- Lock the row and get current quantity
        SELECT current_quantity INTO available_quantity
        FROM stock_batches
        WHERE id = target_batch_id
        FOR UPDATE;
        
        -- Check if sufficient stock exists
        IF available_quantity IS NULL THEN
            RAISE EXCEPTION 'Stock batch % not found', target_batch_id;
        END IF;
        
        IF available_quantity < NEW.quantity THEN
            RAISE EXCEPTION 'Insufficient stock in batch %. Available: %, Requested: %', 
                target_batch_id, available_quantity, NEW.quantity;
        END IF;
        
        -- Perform the deduction
        UPDATE stock_batches
        SET current_quantity = current_quantity - NEW.quantity,
            status = CASE 
                WHEN current_quantity - NEW.quantity <= 0 THEN 'depleted'
                ELSE status
            END
        WHERE id = target_batch_id;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."deduct_stock_on_material_use"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."deny_visitor"("p_visitor_id" "uuid", "p_user_id" "uuid", "p_reason" "text") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_visitor RECORD;
  v_is_resident BOOLEAN;
  v_resident_flat_id UUID;
BEGIN
  PERFORM public.expire_mobile_visitor_decisions();

  IF auth.uid() IS NULL THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Authentication required');
  END IF;

  IF auth.uid() IS DISTINCT FROM p_user_id THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Authenticated user mismatch');
  END IF;

  SELECT EXISTS(
    SELECT 1 FROM public.residents WHERE auth_user_id = p_user_id
  ) INTO v_is_resident;

  IF NOT v_is_resident THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Only residents can deny visitors');
  END IF;

  SELECT flat_id INTO v_resident_flat_id
  FROM public.residents
  WHERE auth_user_id = p_user_id
  LIMIT 1;

  SELECT * INTO v_visitor
  FROM public.visitors
  WHERE id = p_visitor_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Visitor not found');
  END IF;

  IF v_visitor.flat_id IS NULL THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Visitors without a destination flat cannot be denied');
  END IF;

  IF v_visitor.flat_id != v_resident_flat_id THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'You can only deny visitors for your own flat');
  END IF;

  IF v_visitor.exit_time IS NOT NULL THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Cannot deny a visitor who has already checked out');
  END IF;

  IF v_visitor.approval_status = 'timed_out' THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'The visitor approval window has already expired');
  END IF;

  UPDATE public.visitors
  SET
    approved_by_resident = FALSE,
    approval_status = 'denied',
    decision_at = NOW(),
    rejection_reason = COALESCE(NULLIF(BTRIM(p_reason), ''), 'Declined by resident')
  WHERE id = p_visitor_id;

  RETURN JSONB_BUILD_OBJECT('success', TRUE, 'visitor_id', p_visitor_id);
END;
$$;


ALTER FUNCTION "public"."deny_visitor"("p_visitor_id" "uuid", "p_user_id" "uuid", "p_reason" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."detect_expiring_items"("p_days_ahead" integer DEFAULT 30) RETURNS TABLE("item_id" "uuid", "item_name" "text", "item_type" "text", "days_left" integer, "severity" "text")
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
    RETURN QUERY
    SELECT et.item_id::UUID, et.item_name, et.item_type,
           (et.expiry_date - CURRENT_DATE)::INT,
           CASE WHEN (et.expiry_date - CURRENT_DATE) <= 3 THEN 'critical'
                WHEN (et.expiry_date - CURRENT_DATE) <= 7 THEN 'warning'
                ELSE 'info' END::TEXT
    FROM expiry_tracking et
    WHERE et.expiry_date BETWEEN CURRENT_DATE AND (CURRENT_DATE + p_days_ahead);
END;
$$;


ALTER FUNCTION "public"."detect_expiring_items"("p_days_ahead" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."detect_geofence_breaches"() RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
    r RECORD;
    v_latest_lat NUMERIC;
    v_latest_long NUMERIC;
    v_dist NUMERIC;
BEGIN
    -- For each clocked-in guard
    FOR r IN 
        SELECT 
            sg.id as guard_id, 
            cl.latitude as gate_lat, 
            cl.longitude as gate_long, 
            cl.geo_fence_radius,
            cl.id as gate_id
        FROM attendance_logs al
        JOIN security_guards sg ON al.employee_id = sg.employee_id
        JOIN company_locations cl ON al.check_in_location_id = cl.id
        WHERE al.check_out_time IS NULL
        AND al.log_date = CURRENT_DATE
    LOOP
        -- Get latest GPS point
        SELECT latitude, longitude INTO v_latest_lat, v_latest_long
        FROM gps_tracking
        WHERE employee_id = r.guard_id
        ORDER BY tracked_at DESC
        LIMIT 1;
        
        IF v_latest_lat IS NOT NULL THEN
            -- Calc distance
            v_dist := SQRT(POW(v_latest_lat - r.gate_lat, 2) + POW(v_latest_long - r.gate_long, 2)) * 111320;
            
            IF v_dist > r.geo_fence_radius THEN
                -- Breach detected
                -- 1. Insert alert if not already active
                IF NOT EXISTS (
                    SELECT 1 FROM panic_alerts 
                    WHERE guard_id = r.guard_id 
                    AND alert_type = 'geo_fence_breach' 
                    AND is_resolved = false
                    AND alert_time >= NOW() - INTERVAL '15 minutes'
                ) THEN
                    INSERT INTO panic_alerts (
                        guard_id,
                        alert_type,
                        location_id,
                        description,
                        is_resolved,
                        alert_time
                    ) VALUES (
                        r.guard_id,
                        'geo_fence_breach',
                        r.gate_id,
                        'Geo-fence breach: Guard is away from assigned location.',
                        false,
                        NOW()
                    );
                END IF;
                
                -- 2. Auto-Punch Out if breach exceeds 15 minutes
                IF NOT EXISTS (
                    SELECT 1 FROM gps_tracking 
                    WHERE employee_id = r.guard_id 
                    AND tracked_at >= NOW() - INTERVAL '15 minutes'
                    AND SQRT(POW(latitude - r.gate_lat, 2) + POW(longitude - r.gate_long, 2)) * 111320 <= r.geo_fence_radius
                ) AND EXISTS (
                     SELECT 1 FROM gps_tracking 
                     WHERE employee_id = r.guard_id 
                     AND tracked_at >= NOW() - INTERVAL '15 minutes'
                ) THEN
                    UPDATE attendance_logs 
                    SET 
                        check_out_time = NOW(),
                        status = 'auto_checkout',
                        updated_at = NOW()
                    WHERE employee_id = (SELECT employee_id FROM security_guards WHERE id = r.guard_id)
                    AND check_out_time IS NULL
                    AND log_date = CURRENT_DATE;
                END IF;
            END IF;
        END IF;
    END LOOP;
END;
$$;


ALTER FUNCTION "public"."detect_geofence_breaches"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."detect_inactive_guards"("p_threshold_minutes" integer DEFAULT 15) RETURNS TABLE("out_guard_id" "uuid", "out_alert_created" boolean)
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  r RECORD;
  v_alert_id UUID;
BEGIN
  FOR r IN
    SELECT
      sg.id AS guard_id,
      sg.employee_id,
      al.check_in_location_id,
      e.first_name || ' ' || e.last_name AS guard_name
    FROM public.attendance_logs al
    JOIN public.employees e ON al.employee_id = e.id
    JOIN public.security_guards sg ON e.id = sg.employee_id
    WHERE al.check_out_time IS NULL
      AND al.log_date = CURRENT_DATE
  LOOP
    IF NOT EXISTS (
      SELECT 1
      FROM public.gps_tracking gt
      WHERE gt.employee_id = r.guard_id
        AND gt.tracked_at >= (NOW() - (p_threshold_minutes || ' minutes')::INTERVAL)
    ) THEN
      IF NOT EXISTS (
        SELECT 1
        FROM public.panic_alerts pa
        WHERE pa.guard_id = r.guard_id
          AND pa.alert_type = 'inactivity'
          AND pa.is_resolved = false
          AND pa.alert_time >= NOW() - INTERVAL '1 hour'
      ) THEN
        INSERT INTO public.panic_alerts (
          guard_id,
          alert_type,
          location_id,
          description,
          is_resolved,
          alert_time
        )
        VALUES (
          r.guard_id,
          'inactivity',
          r.check_in_location_id,
          'Inactivity detected: No GPS heartbeat for ' || p_threshold_minutes || ' minutes.',
          false,
          NOW()
        )
        RETURNING id INTO v_alert_id;

        INSERT INTO public.notifications (
          user_id,
          notification_type,
          title,
          message,
          reference_type,
          reference_id,
          priority
        )
        SELECT
          u.id,
          'inactivity_alert',
          'Guard Inactivity Warning',
          'Guard ' || r.guard_name || ' has not updated GPS location for ' || p_threshold_minutes || 'm.',
          'panic_alert',
          v_alert_id,
          'high'
        FROM public.users u
        JOIN public.roles rl ON u.role_id = rl.id
        WHERE rl.role_name::text IN ('admin', 'security_supervisor');

        out_guard_id := r.guard_id;
        out_alert_created := true;
        RETURN NEXT;
      END IF;
    END IF;
  END LOOP;
END;
$$;


ALTER FUNCTION "public"."detect_inactive_guards"("p_threshold_minutes" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."detect_incomplete_checklists"() RETURNS TABLE("out_employee_id" "uuid", "out_alert_created" boolean)
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE r RECORD;
BEGIN
    FOR r IN
        SELECT e.id AS employee_id
        FROM attendance_logs al
        JOIN employees e ON al.employee_id = e.id
        JOIN users u ON u.employee_id = e.id
        JOIN roles rl ON u.role_id = rl.id
        WHERE al.check_out_time IS NULL AND al.log_date = CURRENT_DATE
            AND rl.role_name::text = 'security_guard'
            AND NOT EXISTS (
                SELECT 1 FROM checklist_responses cr
                WHERE cr.employee_id = e.id AND cr.response_date = CURRENT_DATE AND cr.is_complete = true
            )
            AND EXTRACT(HOUR FROM NOW()) >= 11
    LOOP
        INSERT INTO notifications (user_id, notification_type, title, message, priority)
        SELECT u.id, 'checklist_reminder', 'Checklist Pending',
               'You haven''t completed your daily safety checklist. Please complete it now.', 'normal'
        FROM users u WHERE u.employee_id = r.employee_id;
        out_employee_id := r.employee_id; out_alert_created := true; RETURN NEXT;
    END LOOP;
END;
$$;


ALTER FUNCTION "public"."detect_incomplete_checklists"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."detect_incomplete_checklists"("p_completion_threshold" numeric DEFAULT 50, "p_only_past_midpoint" boolean DEFAULT true) RETURNS TABLE("guard_id" "uuid", "guard_name" "text", "shift_name" character varying, "completion_percentage" numeric, "total_items" integer, "completed_items" integer, "minutes_remaining" integer, "alert_created" boolean, "error_message" "text")
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
    v_guard RECORD; v_completion RECORD; v_shift_info RECORD; v_alert_id UUID;
BEGIN
    FOR v_guard IN SELECT * FROM get_clocked_in_guards()
    LOOP
        SELECT * INTO v_completion FROM get_guard_checklist_completion(v_guard.guard_id, CURRENT_DATE);
        SELECT * INTO v_shift_info FROM get_shift_time_info(v_guard.shift_id);

        IF COALESCE(v_completion.total_items,0) = 0 THEN
            RETURN QUERY SELECT v_guard.guard_id,
                (v_guard.first_name||' '||COALESCE(v_guard.last_name,''))::TEXT,
                v_shift_info.shift_name, 0.00::DECIMAL(5,2), 0, 0,
                COALESCE(v_shift_info.minutes_remaining,0), false,
                'No checklist items configured'::TEXT;
            CONTINUE;
        END IF;
        CONTINUE WHEN v_completion.completion_percentage >= 100;
        CONTINUE WHEN v_completion.completion_percentage >= p_completion_threshold;
        CONTINUE WHEN p_only_past_midpoint AND NOT COALESCE(v_shift_info.is_past_midpoint,false);
        CONTINUE WHEN has_active_checklist_alert(v_guard.guard_id, CURRENT_DATE);

        INSERT INTO panic_alerts (guard_id, alert_type, location_id, description, is_resolved)
        VALUES (v_guard.guard_id, 'checklist_incomplete', v_guard.location_id,
            'Incomplete: '||v_completion.completion_percentage||'% ('||
            v_completion.completed_items||'/'||v_completion.total_items||' items). '||
            COALESCE(v_shift_info.minutes_remaining::TEXT,'?')||' mins left.', false)
        RETURNING id INTO v_alert_id;

        RETURN QUERY SELECT v_guard.guard_id,
            (v_guard.first_name||' '||COALESCE(v_guard.last_name,''))::TEXT,
            v_shift_info.shift_name, v_completion.completion_percentage,
            v_completion.total_items, v_completion.completed_items,
            COALESCE(v_shift_info.minutes_remaining,0), (v_alert_id IS NOT NULL), NULL::TEXT;
    END LOOP;
END;
$$;


ALTER FUNCTION "public"."detect_incomplete_checklists"("p_completion_threshold" numeric, "p_only_past_midpoint" boolean) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."detect_stationary_guards"() RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
    r RECORD;
    v_variance NUMERIC;
    v_threshold NUMERIC := 20; -- 20 meters
BEGIN
    -- For each clocked-in guard
    FOR r IN 
        SELECT sg.id as guard_id, sg.employee_id, al.check_in_location_id
        FROM attendance_logs al
        JOIN security_guards sg ON al.employee_id = sg.employee_id
        WHERE al.check_out_time IS NULL
        AND al.log_date = CURRENT_DATE
    LOOP
        v_variance := get_guard_movement_variance(r.guard_id, 30);
        
        -- Check if we have at least some points in the last 30 mins to avoid false alerts on start
        IF v_variance < v_threshold AND EXISTS (
            SELECT 1 FROM gps_tracking 
            WHERE employee_id = r.guard_id 
            AND tracked_at >= NOW() - INTERVAL '30 minutes'
        ) THEN
            -- Check if we already have an unresolved inactivity alert for this guard in the last hour
            IF NOT EXISTS (
                SELECT 1 FROM panic_alerts 
                WHERE guard_id = r.guard_id 
                AND alert_type = 'inactivity' 
                AND is_resolved = false
                AND alert_time >= NOW() - INTERVAL '1 hour'
            ) THEN
                INSERT INTO panic_alerts (
                    guard_id,
                    alert_type,
                    location_id,
                    description,
                    is_resolved,
                    alert_time
                ) VALUES (
                    r.guard_id,
                    'inactivity',
                    r.check_in_location_id,
                    'Stationary alert: Guard has not moved significantly for 30 minutes.',
                    false,
                    NOW()
                );
            END IF;
        END IF;
    END LOOP;
END;
$$;


ALTER FUNCTION "public"."detect_stationary_guards"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."enforce_feedback_before_close"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    -- Only check if status is transitioning to 'closed'
    IF NEW.status::text = 'closed' AND (OLD.status IS NULL OR OLD.status::text != 'closed') THEN
        -- Check if feedback exists for this service request
        IF NOT EXISTS (
            SELECT 1 FROM buyer_feedback 
            WHERE service_request_id = NEW.id
        ) THEN
            RAISE EXCEPTION 'Buyer feedback required before closing service request';
        END IF;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."enforce_feedback_before_close"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."enforce_pest_control_ppe"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
    v_service_code VARCHAR;
    v_ppe_verified BOOLEAN;
BEGIN
    -- Only check when status is changing to 'completed'
    IF NEW.status = 'completed' AND (OLD.status IS DISTINCT FROM 'completed') THEN
        -- Get service_code for this session's request
        SELECT s.service_code INTO v_service_code
        FROM service_requests sr
        JOIN services s ON sr.service_id = s.id
        WHERE sr.id = NEW.service_request_id;

        -- If it's a pest control job, check PPE
        IF v_service_code = 'PST-CON' THEN
            SELECT EXISTS (
                SELECT 1 
                FROM pest_control_ppe_verifications 
                WHERE job_session_id = NEW.id 
                AND all_items_checked = TRUE
            ) INTO v_ppe_verified;

            IF NOT v_ppe_verified THEN
                RAISE EXCEPTION 'PPE verification required before completing pest control job';
            END IF;
        END IF;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."enforce_pest_control_ppe"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."enforce_request_status_transition"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public'
    AS $$
DECLARE
  old_rank INT;
  new_rank INT;
  v_is_service_request BOOLEAN := COALESCE(NEW.is_service_request, OLD.is_service_request, FALSE);
  v_actor_role TEXT := COALESCE(public.get_my_app_role(), public.get_user_role()::TEXT);
  status_order TEXT[] := ARRAY[
    'pending', 'accepted', 'rejected',
    'indent_generated', 'indent_forwarded', 'indent_accepted', 'indent_rejected',
    'po_issued', 'po_received', 'po_dispatched',
    'material_received', 'material_acknowledged',
    'bill_generated', 'paid', 'feedback_pending', 'completed'
  ];
BEGIN
  IF OLD.status = NEW.status THEN
    RETURN NEW;
  END IF;

  IF v_actor_role IN ('admin', 'super_admin') THEN
    RETURN NEW;
  END IF;

  IF NEW.status = 'rejected' THEN
    IF OLD.status IN ('pending', 'po_dispatched', 'material_received') THEN
      RETURN NEW;
    END IF;

    RAISE EXCEPTION 'Can only reject from Pending, PO Dispatched, or Material Received states';
  END IF;

  SELECT array_position(status_order, OLD.status::TEXT) INTO old_rank;
  SELECT array_position(status_order, NEW.status::TEXT) INTO new_rank;

  IF new_rank IS NULL OR old_rank IS NULL OR new_rank <= old_rank THEN
    RAISE EXCEPTION 'Illegal status transition from % to %', OLD.status, NEW.status;
  END IF;

  IF v_is_service_request
     AND OLD.status = 'po_issued'
     AND NEW.status = 'bill_generated' THEN
    IF public.service_request_can_bridge_to_bill_generated(OLD.id) THEN
      RETURN NEW;
    END IF;

    RAISE EXCEPTION 'Service deployment must be confirmed before billing can be generated';
  END IF;

  IF new_rank - old_rank > 2 THEN
    RAISE EXCEPTION 'Cannot skip intermediate workflow steps (Attempted % -> %)', OLD.status, NEW.status;
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."enforce_request_status_transition"() OWNER TO "postgres";


COMMENT ON FUNCTION "public"."enforce_request_status_transition"() IS 'Shared request workflow guard with a service-safe bridge from po_issued to bill_generated and buyer delivery rejection allowed from pending, po_dispatched, and material_received.';



CREATE OR REPLACE FUNCTION "public"."enforce_service_completion_evidence"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
    IF (NEW.status = 'completed') THEN
        IF (NEW.before_photo_url IS NULL OR NEW.after_photo_url IS NULL) THEN
            RAISE EXCEPTION 'Operational Truth Error: "Before" and "After" photos are mandatory to complete a task.';
        END IF;
        IF (NEW.resolution_notes IS NULL OR length(NEW.resolution_notes) < 10) THEN
            RAISE EXCEPTION 'Operational Truth Error: Meaningful resolution notes (min 10 chars) required.';
        END IF;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."enforce_service_completion_evidence"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."execute_reconciliation_match"("p_reconciliation_id" "uuid", "p_user_id" "uuid") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_recon RECORD;
  v_po_id UUID;
  v_bill_id UUID;
  v_grn_id UUID;
  v_line RECORD;
  v_product_ids UUID[];
  v_product_id UUID;
  v_po_qty NUMERIC;
  v_po_price NUMERIC;
  v_po_item_id UUID;
  v_grn_qty NUMERIC;
  v_grn_price NUMERIC;
  v_grn_item_id UUID;
  v_bill_qty NUMERIC;
  v_bill_price NUMERIC;
  v_bill_item_id UUID;
  v_matched_qty NUMERIC;
  v_qty_variance NUMERIC;
  v_price_variance NUMERIC;
  v_matched_amount NUMERIC;
  v_base_price NUMERIC;
  v_match_type TEXT;
  v_line_status TEXT;
  v_all_matched BOOLEAN := TRUE;
  v_any_variance BOOLEAN := FALSE;
  v_lines_created INT := 0;
  VARIANCE_TOLERANCE CONSTANT NUMERIC := 100; -- in paise
BEGIN
  -- 1. Lock and fetch reconciliation
  SELECT * INTO v_recon
  FROM reconciliations
  WHERE id = p_reconciliation_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RETURN jsonb_build_object('success', false, 'error', 'Reconciliation not found');
  END IF;

  IF v_recon.status NOT IN ('pending', 'discrepancy') THEN
    RETURN jsonb_build_object('success', false, 'error', format('Cannot run matching on reconciliation in "%s" status', v_recon.status));
  END IF;

  v_po_id := v_recon.purchase_order_id;
  v_bill_id := v_recon.purchase_bill_id;
  v_grn_id := v_recon.material_receipt_id;

  -- 2. Delete existing lines (re-run)
  DELETE FROM reconciliation_lines WHERE reconciliation_id = p_reconciliation_id;

  -- 3. Collect all unique product IDs across all documents
  SELECT ARRAY_AGG(DISTINCT product_id) INTO v_product_ids
  FROM (
    SELECT product_id FROM purchase_order_items WHERE purchase_order_id = v_po_id AND v_po_id IS NOT NULL
    UNION
    SELECT product_id FROM material_receipt_items WHERE material_receipt_id = v_grn_id AND v_grn_id IS NOT NULL
    UNION
    SELECT product_id FROM purchase_bill_items WHERE purchase_bill_id = v_bill_id AND v_bill_id IS NOT NULL
  ) AS all_products;

  IF v_product_ids IS NULL OR array_length(v_product_ids, 1) IS NULL THEN
    RETURN jsonb_build_object('success', false, 'error', 'No items found in linked documents');
  END IF;

  -- 4. For each product, perform matching
  FOREACH v_product_id IN ARRAY v_product_ids
  LOOP
    -- Initialize
    v_po_qty := NULL; v_po_price := NULL; v_po_item_id := NULL;
    v_grn_qty := NULL; v_grn_price := NULL; v_grn_item_id := NULL;
    v_bill_qty := NULL; v_bill_price := NULL; v_bill_item_id := NULL;

    -- Fetch PO item
    IF v_po_id IS NOT NULL THEN
      SELECT id, ordered_quantity, unit_price
      INTO v_po_item_id, v_po_qty, v_po_price
      FROM purchase_order_items
      WHERE purchase_order_id = v_po_id AND product_id = v_product_id
      LIMIT 1;
    END IF;

    -- Fetch GRN item (prefer accepted_quantity)
    IF v_grn_id IS NOT NULL THEN
      SELECT id,
        COALESCE(accepted_quantity, received_quantity),
        unit_price
      INTO v_grn_item_id, v_grn_qty, v_grn_price
      FROM material_receipt_items
      WHERE material_receipt_id = v_grn_id AND product_id = v_product_id
      LIMIT 1;
    END IF;

    -- Fetch Bill item
    IF v_bill_id IS NOT NULL THEN
      SELECT id, billed_quantity, unit_price
      INTO v_bill_item_id, v_bill_qty, v_bill_price
      FROM purchase_bill_items
      WHERE purchase_bill_id = v_bill_id AND product_id = v_product_id
      LIMIT 1;
    END IF;

    -- Determine match type
    IF v_po_item_id IS NOT NULL AND v_grn_item_id IS NOT NULL AND v_bill_item_id IS NOT NULL THEN
      v_match_type := 'THREE_WAY';
    ELSIF v_po_item_id IS NOT NULL AND v_grn_item_id IS NOT NULL THEN
      v_match_type := 'PO_GRN';
    ELSIF v_grn_item_id IS NOT NULL AND v_bill_item_id IS NOT NULL THEN
      v_match_type := 'GRN_BILL';
    ELSE
      v_match_type := 'PO_BILL';
    END IF;

    -- Calculate matched quantity (minimum of available quantities)
    v_matched_qty := LEAST(
      COALESCE(v_po_qty, 999999999),
      COALESCE(v_grn_qty, 999999999),
      COALESCE(v_bill_qty, 999999999)
    );
    IF v_matched_qty >= 999999999 THEN
      v_matched_qty := 0;
    END IF;

    -- Calculate quantity variance
    IF v_bill_qty IS NOT NULL AND v_grn_qty IS NOT NULL THEN
      v_qty_variance := v_bill_qty - v_grn_qty;
    ELSIF v_bill_qty IS NOT NULL AND v_po_qty IS NOT NULL THEN
      v_qty_variance := v_bill_qty - v_po_qty;
    ELSIF v_grn_qty IS NOT NULL AND v_po_qty IS NOT NULL THEN
      v_qty_variance := v_grn_qty - v_po_qty;
    ELSE
      v_qty_variance := 0;
    END IF;

    -- Calculate price variance
    IF v_bill_price IS NOT NULL AND v_po_price IS NOT NULL THEN
      v_price_variance := v_bill_price - v_po_price;
    ELSIF v_bill_price IS NOT NULL AND v_grn_price IS NOT NULL THEN
      v_price_variance := v_bill_price - v_grn_price;
    ELSE
      v_price_variance := 0;
    END IF;

    -- Base price for matched amount
    v_base_price := COALESCE(v_po_price, v_grn_price, v_bill_price, 0);
    v_matched_amount := ROUND(v_matched_qty * v_base_price, 2);

    -- Determine line status
    IF v_po_item_id IS NULL OR v_grn_item_id IS NULL OR v_bill_item_id IS NULL THEN
      v_line_status := 'pending';
      v_all_matched := FALSE;
    ELSIF ABS(v_qty_variance) < 0.01 AND ABS(v_price_variance) <= VARIANCE_TOLERANCE THEN
      v_line_status := 'matched';
    ELSE
      v_line_status := 'variance';
      v_any_variance := TRUE;
      v_all_matched := FALSE;
    END IF;

    -- Insert reconciliation line
    INSERT INTO reconciliation_lines (
      reconciliation_id, po_item_id, grn_item_id, bill_item_id, product_id,
      matched_qty, matched_amount,
      po_unit_price, grn_unit_price, bill_unit_price,
      unit_price_variance, qty_ordered, qty_received, qty_billed, qty_variance,
      match_type, status
    ) VALUES (
      p_reconciliation_id, v_po_item_id, v_grn_item_id, v_bill_item_id, v_product_id,
      v_matched_qty, v_matched_amount,
      COALESCE(v_po_price, 0), COALESCE(v_grn_price, 0), COALESCE(v_bill_price, 0),
      v_price_variance,
      COALESCE(v_po_qty, 0), COALESCE(v_grn_qty, 0), COALESCE(v_bill_qty, 0),
      v_qty_variance,
      v_match_type, v_line_status
    );

    v_lines_created := v_lines_created + 1;

    -- Update residual tracking on source items
    IF v_po_item_id IS NOT NULL AND v_matched_qty > 0 THEN
      UPDATE purchase_order_items
      SET
        unmatched_qty = GREATEST(0, COALESCE(unmatched_qty, ordered_quantity) - v_matched_qty),
        unmatched_amount = ROUND(GREATEST(0, COALESCE(unmatched_qty, ordered_quantity) - v_matched_qty) * unit_price, 2)
      WHERE id = v_po_item_id;
    END IF;

    IF v_grn_item_id IS NOT NULL AND v_matched_qty > 0 THEN
      UPDATE material_receipt_items
      SET
        unmatched_qty = GREATEST(0, COALESCE(unmatched_qty, COALESCE(accepted_quantity, received_quantity)) - v_matched_qty),
        unmatched_amount = ROUND(GREATEST(0, COALESCE(unmatched_qty, COALESCE(accepted_quantity, received_quantity)) - v_matched_qty) * unit_price, 2)
      WHERE id = v_grn_item_id;
    END IF;

    IF v_bill_item_id IS NOT NULL AND v_matched_qty > 0 THEN
      UPDATE purchase_bill_items
      SET
        unmatched_qty = GREATEST(0, COALESCE(unmatched_qty, billed_quantity) - v_matched_qty),
        unmatched_amount = ROUND(GREATEST(0, COALESCE(unmatched_qty, billed_quantity) - v_matched_qty) * unit_price, 2)
      WHERE id = v_bill_item_id;
    END IF;
  END LOOP;

  -- 5. Update reconciliation header status
  UPDATE reconciliations
  SET
    status = CASE
      WHEN v_all_matched THEN 'matched'
      WHEN v_any_variance THEN 'discrepancy'
      ELSE 'pending'
    END,
    updated_at = NOW(),
    updated_by = p_user_id
  WHERE id = p_reconciliation_id;

  RETURN jsonb_build_object(
    'success', true,
    'lines_created', v_lines_created,
    'status', CASE
      WHEN v_all_matched THEN 'matched'
      WHEN v_any_variance THEN 'discrepancy'
      ELSE 'pending'
    END
  );
END;
$$;


ALTER FUNCTION "public"."execute_reconciliation_match"("p_reconciliation_id" "uuid", "p_user_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."expire_mobile_visitor_decisions"() RETURNS integer
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_expired_count INTEGER := 0;
BEGIN
  UPDATE public.visitors
  SET
    approval_status = 'timed_out',
    decision_at = COALESCE(decision_at, NOW()),
    rejection_reason = COALESCE(NULLIF(rejection_reason, ''), 'Resident approval window expired.')
  WHERE exit_time IS NULL
    AND approval_status = 'pending'
    AND approval_deadline_at IS NOT NULL
    AND approval_deadline_at < NOW();

  GET DIAGNOSTICS v_expired_count = ROW_COUNT;

  RETURN COALESCE(v_expired_count, 0);
END;
$$;


ALTER FUNCTION "public"."expire_mobile_visitor_decisions"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."force_match_bill"("p_bill_id" "uuid", "p_reason" "text", "p_evidence_url" "text" DEFAULT NULL::"text") RETURNS boolean
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_actor_id UUID;
BEGIN
  v_actor_id := auth.uid();

  IF v_actor_id IS NULL THEN
    RAISE EXCEPTION 'Authentication required';
  END IF;

  IF NOT EXISTS (SELECT 1 FROM public.purchase_bills WHERE id = p_bill_id) THEN
    RAISE EXCEPTION 'Bill not found';
  END IF;

  UPDATE public.purchase_bills
  SET
    is_reconciled = TRUE,
    reconciled_at = now(),
    reconciled_by = v_actor_id,
    match_status = 'force_matched',
    notes = COALESCE(notes, '') || E'\n[FORCE MATCH ' || now()::text || '] ' || p_reason
  WHERE id = p_bill_id;

  INSERT INTO public.audit_logs (
    entity_type,
    entity_id,
    actor_id,
    actor_role,
    action,
    new_data,
    metadata,
    evidence_url
  ) VALUES (
    'purchase_bills',
    p_bill_id,
    v_actor_id,
    public.get_my_app_role(),
    'FORCE_MATCH',
    jsonb_build_object('reason', p_reason, 'timestamp', now()::text),
    jsonb_build_object('source', 'force_match_bill'),
    p_evidence_url
  );

  RETURN TRUE;
END;
$$;


ALTER FUNCTION "public"."force_match_bill"("p_bill_id" "uuid", "p_reason" "text", "p_evidence_url" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."generate_ad_booking_number"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public', 'extensions'
    AS $$
BEGIN
  IF NEW.booking_number IS NULL OR NEW.booking_number = '' THEN
    NEW.booking_number := 'ADB-' || LPAD(nextval('ad_booking_number_seq')::TEXT, 5, '0');
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."generate_ad_booking_number"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."generate_asset_code"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
    next_number INTEGER;
BEGIN
    -- Acquire advisory lock to prevent race conditions (ID 42 for Assets)
    PERFORM pg_advisory_xact_lock(42);
    
    SELECT COALESCE(MAX(
        CAST(SUBSTRING(asset_code FROM 'AST-(\d+)') AS INTEGER)
    ), 0) + 1
    INTO next_number
    FROM assets;
    
    NEW.asset_code := 'AST-' || LPAD(next_number::TEXT, 6, '0');
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."generate_asset_code"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."generate_behavior_ticket_number"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public'
    AS $$
BEGIN
    IF NEW.ticket_number IS NULL THEN
        NEW.ticket_number := 'TKT-B-' || LPAD(NEXTVAL('behavior_ticket_seq')::TEXT, 4, '0');
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."generate_behavior_ticket_number"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."generate_bill_number"() RETURNS "text"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_year text;
  v_seq  text;
BEGIN
  v_year := to_char(CURRENT_DATE, 'YYYY');
  v_seq  := lpad(nextval('bill_number_seq')::text, 6, '0');
  RETURN 'BILL-' || v_year || '-' || v_seq;
END;
$$;


ALTER FUNCTION "public"."generate_bill_number"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."generate_bill_number_trigger"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
  IF NEW.bill_number IS NULL THEN
    NEW.bill_number := generate_bill_number();
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."generate_bill_number_trigger"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."generate_budget_code"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public'
    AS $$
BEGIN
    NEW.budget_code := 'BGT-' || TO_CHAR(now(), 'YYYY') || '-' || 
        LPAD(nextval('budget_seq')::TEXT, 3, '0');
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."generate_budget_code"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."generate_candidate_code"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public'
    AS $$
BEGIN
    NEW.candidate_code := 'CAND-' || TO_CHAR(now(), 'YYYY') || '-' || 
        LPAD(nextval('candidate_seq')::TEXT, 4, '0');
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."generate_candidate_code"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."generate_daily_compliance_snapshot"() RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
    v_late_count INTEGER;
    v_missing_selfie INTEGER;
    v_total INTEGER;
    v_score NUMERIC;
    v_on_duty INTEGER;
BEGIN
    -- Get base metrics
    SELECT count(*) INTO v_total FROM employees WHERE is_active = true;
    
    -- Late arrival check (grace period until 09:15)
    SELECT count(*) INTO v_late_count 
    FROM attendance_logs 
    WHERE log_date = CURRENT_DATE 
    AND check_in_time::time > '09:15:00';

    -- Missing selfie evidence check
    SELECT count(*) INTO v_missing_selfie 
    FROM attendance_logs 
    WHERE log_date = CURRENT_DATE 
    AND check_in_selfie_url IS NULL;

    SELECT count(*) INTO v_on_duty 
    FROM attendance_logs 
    WHERE log_date = CURRENT_DATE;

    -- Calculate Compliance Score
    IF v_total > 0 THEN
        v_score := GREATEST(0, 100 - ((v_late_count + v_missing_selfie)::numeric / v_total * 100));
    ELSE
        v_score := 100;
    END IF;

    -- Store in the EXISTING compliance_snapshots schema using data_payload JSONB
    INSERT INTO compliance_snapshots (
        snapshot_name,
        snapshot_date,
        data_payload,
        is_locked
    ) VALUES (
        'daily_hr_compliance_' || CURRENT_DATE::text,
        now(),
        jsonb_build_object(
            'type', 'daily_hr_compliance',
            'snapshot_date', CURRENT_DATE,
            'total_employees', v_total,
            'on_duty', v_on_duty,
            'late_arrivals', v_late_count,
            'missing_selfies', v_missing_selfie,
            'compliance_score', v_score
        ),
        true
    );

    RETURN json_build_object(
        'status', 'success',
        'score', v_score,
        'violations', v_late_count + v_missing_selfie
    );
END;
$$;


ALTER FUNCTION "public"."generate_daily_compliance_snapshot"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."generate_delivery_note_number"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public', 'extensions'
    AS $$
BEGIN
  IF NEW.delivery_note_number IS NULL OR NEW.delivery_note_number = '' THEN
    NEW.delivery_note_number := 'DN-' || LPAD(nextval('delivery_note_number_seq')::TEXT, 5, '0');
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."generate_delivery_note_number"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."generate_dispatch_number"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public', 'extensions'
    AS $$
BEGIN
  IF NEW.dispatch_number IS NULL OR NEW.dispatch_number = '' THEN
    NEW.dispatch_number := 'PD-' || LPAD(nextval('personnel_dispatch_seq')::TEXT, 5, '0');
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."generate_dispatch_number"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."generate_document_code"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public'
    AS $$
DECLARE
    v_employee employees;
BEGIN
    SELECT * INTO v_employee FROM employees WHERE id = NEW.employee_id;
    NEW.document_code := 'DOC-' || v_employee.employee_code || '-' || 
        UPPER(REPLACE(NEW.document_type::TEXT, '_', ''));
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."generate_document_code"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."generate_grn_number"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public'
    AS $$
BEGIN
    NEW.grn_number := 'GRN-' || TO_CHAR(now(), 'YYYY') || '-' || 
        LPAD(nextval('grn_seq')::TEXT, 4, '0');
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."generate_grn_number"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."generate_indent_number"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public'
    AS $$
BEGIN
    NEW.indent_number := 'IND-' || TO_CHAR(now(), 'YYYY') || '-' || 
        LPAD(nextval('indent_seq')::TEXT, 4, '0');
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."generate_indent_number"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."generate_oversight_ticket_number"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
  IF NEW.ticket_number IS NULL OR BTRIM(NEW.ticket_number) = '' THEN
    NEW.ticket_number := 'OVS-' || LPAD(NEXTVAL('public.oversight_ticket_seq')::TEXT, 5, '0');
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."generate_oversight_ticket_number"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."generate_payment_number"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public'
    AS $$
BEGIN
    IF NEW.payment_number IS NULL THEN
        NEW.payment_number := 'PAY-' || TO_CHAR(now(), 'YYYYMMDD') || '-' || LPAD(nextval('payment_num_seq')::TEXT, 4, '0');
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."generate_payment_number"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."generate_payroll_cycle"("p_cycle_id" "uuid", "p_user_id" "uuid") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_cycle RECORD;
  v_emp RECORD;
  v_salary JSONB;
  v_actor_role TEXT;
  v_payslip_number TEXT;
  v_total_gross NUMERIC := 0;
  v_total_deductions NUMERIC := 0;
  v_total_net NUMERIC := 0;
  v_emp_count INT := 0;
  v_seq INT := 0;
  v_errors JSONB := '[]'::JSONB;
BEGIN
  IF auth.uid() IS NULL OR auth.uid() <> p_user_id THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'Payroll generation requires an authenticated admin session'
    );
  END IF;

  v_actor_role := COALESCE(public.get_my_app_role(), public.get_user_role()::TEXT);

  IF v_actor_role NOT IN ('admin', 'super_admin') THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'Only admins can generate payroll cycles'
    );
  END IF;

  SELECT *
  INTO v_cycle
  FROM public.payroll_cycles
  WHERE id = p_cycle_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RETURN jsonb_build_object('success', false, 'error', 'Payroll cycle not found');
  END IF;

  IF v_cycle.status <> 'draft' THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', format('Cannot generate payslips for cycle in "%s" status', v_cycle.status)
    );
  END IF;

  DELETE FROM public.payslips
  WHERE payroll_cycle_id = p_cycle_id;

  UPDATE public.payroll_cycles
  SET
    status = 'processing',
    updated_at = NOW()
  WHERE id = p_cycle_id;

  FOR v_emp IN
    SELECT e.id, e.employee_code
    FROM public.employees e
    WHERE e.is_active = TRUE
    ORDER BY e.employee_code
  LOOP
    v_salary := public.calculate_employee_salary(
      v_emp.id,
      v_cycle.period_start,
      v_cycle.period_end,
      v_cycle.total_working_days
    );

    IF COALESCE((v_salary ->> 'success')::BOOLEAN, FALSE) THEN
      v_seq := v_seq + 1;
      v_payslip_number := format(
        'PS-%s-%s-%s',
        v_cycle.period_year,
        LPAD(v_cycle.period_month::TEXT, 2, '0'),
        LPAD(v_seq::TEXT, 4, '0')
      );

      INSERT INTO public.payslips (
        payslip_number,
        payroll_cycle_id,
        employee_id,
        present_days,
        absent_days,
        leave_days,
        overtime_hours,
        basic_salary,
        pro_rated_basic,
        hra,
        special_allowance,
        travel_allowance,
        medical_allowance,
        overtime_amount,
        bonus,
        other_earnings,
        gross_salary,
        pf_deduction,
        esic_deduction,
        professional_tax,
        tds,
        loan_recovery,
        advance_recovery,
        other_deductions,
        total_deductions,
        net_payable,
        employer_pf,
        employer_esic,
        bank_account_number,
        bank_ifsc,
        status,
        created_by,
        updated_by
      ) VALUES (
        v_payslip_number,
        p_cycle_id,
        v_emp.id,
        (v_salary ->> 'present_days')::INT,
        (v_salary ->> 'absent_days')::INT,
        (v_salary ->> 'leave_days')::INT,
        (v_salary ->> 'overtime_hours')::NUMERIC,
        (v_salary ->> 'basic_salary')::NUMERIC,
        (v_salary ->> 'pro_rated_basic')::NUMERIC,
        (v_salary ->> 'hra')::NUMERIC,
        (v_salary ->> 'special_allowance')::NUMERIC,
        (v_salary ->> 'travel_allowance')::NUMERIC,
        (v_salary ->> 'medical_allowance')::NUMERIC,
        (v_salary ->> 'overtime_amount')::NUMERIC,
        0,
        0,
        (v_salary ->> 'gross_salary')::NUMERIC,
        (v_salary ->> 'pf_deduction')::NUMERIC,
        (v_salary ->> 'esic_deduction')::NUMERIC,
        (v_salary ->> 'professional_tax')::NUMERIC,
        0,
        0,
        0,
        0,
        (v_salary ->> 'total_deductions')::NUMERIC,
        (v_salary ->> 'net_payable')::NUMERIC,
        (v_salary ->> 'employer_pf')::NUMERIC,
        (v_salary ->> 'employer_esic')::NUMERIC,
        NULL,
        NULL,
        'computed',
        p_user_id,
        p_user_id
      );

      v_total_gross := v_total_gross + (v_salary ->> 'gross_salary')::NUMERIC;
      v_total_deductions := v_total_deductions + (v_salary ->> 'total_deductions')::NUMERIC;
      v_total_net := v_total_net + (v_salary ->> 'net_payable')::NUMERIC;
      v_emp_count := v_emp_count + 1;
    ELSE
      v_errors := v_errors || jsonb_build_array(
        jsonb_build_object(
          'employee_id', v_emp.id,
          'employee_code', v_emp.employee_code,
          'error', COALESCE(v_salary ->> 'error', 'Payroll calculation failed')
        )
      );
    END IF;
  END LOOP;

  IF v_emp_count = 0 THEN
    UPDATE public.payroll_cycles
    SET
      status = 'draft',
      updated_at = NOW(),
      notes = TRIM(
        BOTH ' '
        FROM CONCAT_WS(' | ', NULLIF(notes, ''), 'Payroll generation blocked: no employees with valid salary structure.')
      )
    WHERE id = p_cycle_id;

    RETURN jsonb_build_object(
      'success', false,
      'error', 'No eligible employees with configured salary structure',
      'details', v_errors
    );
  END IF;

  UPDATE public.payroll_cycles
  SET
    status = 'computed',
    computed_at = NOW(),
    computed_by = p_user_id,
    total_employees = v_emp_count,
    total_gross = v_total_gross,
    total_deductions = v_total_deductions,
    total_net = v_total_net,
    notes = CASE
      WHEN jsonb_array_length(v_errors) > 0 THEN
        TRIM(
          BOTH ' '
          FROM CONCAT_WS(
            ' | ',
            NULLIF(notes, ''),
            format('Skipped %s employee(s) without payroll master data.', jsonb_array_length(v_errors))
          )
        )
      ELSE notes
    END,
    updated_at = NOW()
  WHERE id = p_cycle_id;

  RETURN jsonb_build_object(
    'success', true,
    'total_employees', v_emp_count,
    'total_gross', v_total_gross,
    'total_deductions', v_total_deductions,
    'total_net', v_total_net,
    'skipped', v_errors
  );
END;
$$;


ALTER FUNCTION "public"."generate_payroll_cycle"("p_cycle_id" "uuid", "p_user_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."generate_payslip_number"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public'
    AS $$
DECLARE
    v_cycle payroll_cycles;
BEGIN
    SELECT * INTO v_cycle FROM payroll_cycles WHERE id = NEW.payroll_cycle_id;
    NEW.payslip_number := 'PS-' || v_cycle.period_year || '-' || 
        LPAD(v_cycle.period_month::TEXT, 2, '0') || '-' ||
        LPAD(nextval('payslip_seq')::TEXT, 4, '0');
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."generate_payslip_number"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."generate_po_number"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public'
    AS $$
BEGIN
    NEW.po_number := 'PO-' || TO_CHAR(now(), 'YYYY') || '-' || 
        LPAD(nextval('po_seq')::TEXT, 4, '0');
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."generate_po_number"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."generate_reconciliation_number"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public'
    AS $$
BEGIN
    NEW.reconciliation_number := 'REC-' || TO_CHAR(now(), 'YYYY') || '-' || 
        LPAD(nextval('reconciliation_seq')::TEXT, 4, '0');
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."generate_reconciliation_number"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."generate_request_number"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public'
    AS $$
BEGIN
    NEW.request_number := 'REQ-' || TO_CHAR(now(), 'YYYY') || '-' || 
        LPAD(nextval('request_seq')::TEXT, 4, '0');
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."generate_request_number"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."generate_sale_invoice_number"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    IF NEW.invoice_number IS NULL THEN
        NEW.invoice_number := 'INV-' || TO_CHAR(now(), 'YYYY') || '-' || 
            LPAD(nextval('sale_invoice_seq')::TEXT, 4, '0');
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."generate_sale_invoice_number"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."generate_service_purchase_order_number"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public'
    AS $$
BEGIN
  IF NEW.spo_number IS NULL OR NEW.spo_number = '' THEN
    NEW.spo_number := 'SPO-' || LPAD(nextval('public.service_purchase_order_number_seq')::TEXT, 5, '0');
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."generate_service_purchase_order_number"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."generate_service_request_number"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
    next_number INTEGER;
    year_part TEXT;
BEGIN
    -- Acquire advisory lock to prevent race conditions (ID 43 for SR)
    PERFORM pg_advisory_xact_lock(43);
    
    year_part := to_char(CURRENT_DATE, 'YYYY');
    
    SELECT COALESCE(MAX(
        CAST(SUBSTRING(request_number FROM 'SR-' || year_part || '-(\d+)') AS INTEGER)
    ), 0) + 1
    INTO next_number
    FROM service_requests
    WHERE request_number LIKE 'SR-' || year_part || '-%';
    
    NEW.request_number := 'SR-' || year_part || '-' || LPAD(next_number::TEXT, 5, '0');
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."generate_service_request_number"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."generate_shortage_note_number"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public', 'extensions'
    AS $$
BEGIN
  IF NEW.note_number IS NULL OR NEW.note_number = '' THEN
    NEW.note_number := 'SN-' || LPAD(nextval('shortage_note_seq')::TEXT, 5, '0');
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."generate_shortage_note_number"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_account_finance_summary"("p_company_id" "uuid", "p_user_id" "uuid") RETURNS TABLE("today_collections" bigint, "outstanding_receivables" bigint, "pending_bills_count" integer, "overdue_pmt_count" integer)
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
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


ALTER FUNCTION "public"."get_account_finance_summary"("p_company_id" "uuid", "p_user_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_active_panic_alerts"() RETURNS TABLE("id" "uuid", "guard_name" "text", "latitude" numeric, "longitude" numeric, "triggered_at" timestamp with time zone, "status" "text")
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    pa.id,
    e.name,
    pa.latitude,
    pa.longitude,
    pa.triggered_at,
    pa.status
  FROM guard_panic_alerts pa
  JOIN employees e ON pa.guard_id = e.id
  WHERE pa.status IN ('active', 'acknowledged')
  ORDER BY pa.triggered_at DESC;
END;
$$;


ALTER FUNCTION "public"."get_active_panic_alerts"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_admin_dashboard_summary"("p_user_id" "uuid", "p_company_id" "uuid") RETURNS TABLE("active_users_count" integer, "logins_today" integer, "pending_onboarding" integer, "system_alerts" integer)
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
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


ALTER FUNCTION "public"."get_admin_dashboard_summary"("p_user_id" "uuid", "p_company_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_all_companies_health"() RETURNS TABLE("id" "uuid", "company_name" "text", "location_count" integer, "active_user_count" integer, "health" "text", "last_activity_at" "text")
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
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


ALTER FUNCTION "public"."get_all_companies_health"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_clocked_in_guards"() RETURNS TABLE("employee_id" "uuid", "guard_id" "uuid", "guard_code" character varying, "first_name" character varying, "last_name" character varying, "location_id" "uuid", "shift_id" "uuid")
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
    RETURN QUERY
    SELECT e.id, sg.id, sg.guard_code, e.first_name, e.last_name,
           sg.assigned_location_id, esa.shift_id
    FROM employees e
    INNER JOIN security_guards sg ON sg.employee_id = e.id
    INNER JOIN attendance_logs al ON al.employee_id = e.id
    LEFT JOIN employee_shift_assignments esa ON esa.employee_id = e.id AND esa.is_active = true
    WHERE al.log_date = CURRENT_DATE
        AND al.check_in_time IS NOT NULL AND al.check_out_time IS NULL
        AND e.is_active = true AND sg.is_active = true;
END;
$$;


ALTER FUNCTION "public"."get_clocked_in_guards"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_employee_id"() RETURNS "uuid"
    LANGUAGE "plpgsql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public', 'extensions'
    AS $$
DECLARE
    emp_id UUID;
BEGIN
    -- Try users table first
    SELECT employee_id INTO emp_id FROM users WHERE id = auth.uid() LIMIT 1;
    
    -- Fallback to employees table
    IF emp_id IS NULL THEN
        SELECT id INTO emp_id FROM employees WHERE auth_user_id = auth.uid() LIMIT 1;
    END IF;
    
    RETURN emp_id;
END;
$$;


ALTER FUNCTION "public"."get_employee_id"() OWNER TO "postgres";


COMMENT ON FUNCTION "public"."get_employee_id"() IS 'Returns employee.id for current authenticated user';



CREATE OR REPLACE FUNCTION "public"."get_employee_ids_in_managed_societies"() RETURNS SETOF "uuid"
    LANGUAGE "plpgsql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
    RETURN QUERY
        SELECT DISTINCT sg.employee_id
        FROM public.security_guards sg
        JOIN public.company_locations cl ON sg.assigned_location_id = cl.id
        WHERE cl.society_id IN (SELECT public.get_my_managed_societies());
END;
$$;


ALTER FUNCTION "public"."get_employee_ids_in_managed_societies"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_expiring_chemicals"("p_days_ahead" integer DEFAULT 30) RETURNS TABLE("id" "uuid", "product_id" "uuid", "product_name" "text", "expiry_date" "date", "batch_number" "text", "days_left" integer, "severity" "text", "source" "text")
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
    RETURN QUERY
    -- 1. Chemicals from domain-specific table (Pest Control)
    SELECT 
        pcc.id,
        pcc.product_id,
        p.product_name,
        pcc.expiry_date,
        pcc.batch_number::TEXT,
        (pcc.expiry_date - CURRENT_DATE)::INTEGER as days_left,
        CASE 
            WHEN pcc.expiry_date < CURRENT_DATE THEN 'expired'
            WHEN (pcc.expiry_date - CURRENT_DATE) <= 7 THEN 'critical'
            WHEN (pcc.expiry_date - CURRENT_DATE) <= 30 THEN 'warning'
            ELSE 'healthy'
        END::TEXT as severity,
        'pest_control'::TEXT as source
    FROM public.pest_control_chemicals pcc
    JOIN public.products p ON pcc.product_id = p.id
    WHERE pcc.expiry_date IS NOT NULL
      AND pcc.expiry_date <= (CURRENT_DATE + p_days_ahead)
    
    UNION ALL
    
    -- 2. General chemicals from stock_batches (any chemical category)
    SELECT 
        sb.id,
        sb.product_id,
        p.product_name,
        sb.expiry_date,
        sb.batch_number::TEXT,
        (sb.expiry_date - CURRENT_DATE)::INTEGER as days_left,
        CASE 
            WHEN sb.expiry_date < CURRENT_DATE THEN 'expired'
            WHEN (sb.expiry_date - CURRENT_DATE) <= 7 THEN 'critical'
            WHEN (sb.expiry_date - CURRENT_DATE) <= 30 THEN 'warning'
            ELSE 'healthy'
        END::TEXT as severity,
        'inventory'::TEXT as source
    FROM public.stock_batches sb
    JOIN public.products p ON sb.product_id = p.id
    JOIN public.product_categories pc ON p.category_id = pc.id
    WHERE sb.expiry_date IS NOT NULL
      AND sb.expiry_date <= (CURRENT_DATE + p_days_ahead)
      AND (pc.category_name ILIKE '%chemical%' OR p.product_name ILIKE '%chemical%')
      -- Avoid duplicates if already in domain-specific table
      AND NOT EXISTS (
          SELECT 1 
          FROM public.pest_control_chemicals pcc 
          WHERE pcc.product_id = sb.product_id 
          AND pcc.batch_number = sb.batch_number
      )
    
    ORDER BY expiry_date ASC;
END;
$$;


ALTER FUNCTION "public"."get_expiring_chemicals"("p_days_ahead" integer) OWNER TO "postgres";


COMMENT ON FUNCTION "public"."get_expiring_chemicals"("p_days_ahead" integer) IS 'Returns chemicals from both domain-specific and general inventory tables expiring within the given number of days.';



CREATE OR REPLACE FUNCTION "public"."get_guard_checklist_completion"("p_guard_id" "uuid", "p_checklist_date" "date") RETURNS TABLE("total_items" integer, "completed_items" integer, "completion_percentage" numeric, "pending_items" "jsonb", "last_updated" timestamp with time zone)
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
    v_shift_id UUID; v_employee_id UUID;
    v_total INTEGER; v_completed INTEGER; v_pending JSONB; v_last_updated TIMESTAMPTZ;
BEGIN
    SELECT sg.employee_id INTO v_employee_id FROM security_guards sg WHERE sg.id = p_guard_id;
    SELECT esa.shift_id INTO v_shift_id FROM employee_shift_assignments esa
    WHERE esa.employee_id = v_employee_id AND esa.is_active = true LIMIT 1;

    IF v_shift_id IS NULL THEN
        RETURN QUERY SELECT 0, 0, 0.00::DECIMAL(5,2), '[]'::JSONB, NULL::TIMESTAMPTZ; RETURN;
    END IF;

    SELECT COUNT(*)::INTEGER INTO v_total
    FROM daily_checklists dci WHERE dci.is_active = true;

    SELECT COUNT(*)::INTEGER, MAX(cr.submitted_at) INTO v_completed, v_last_updated
    FROM checklist_responses cr
    WHERE cr.employee_id = v_employee_id AND cr.response_date = p_checklist_date AND cr.is_complete = true;

    SELECT jsonb_agg(jsonb_build_object(
        'item_id', dci.id, 'task_name', dci.checklist_name,
        'category', dci.department, 'priority', 1
    )) INTO v_pending
    FROM daily_checklists dci
    WHERE dci.is_active = true
        AND NOT EXISTS (
            SELECT 1 FROM checklist_responses cr
            WHERE cr.employee_id = v_employee_id AND cr.response_date = p_checklist_date
                AND cr.is_complete = true AND cr.checklist_id = dci.id
        );

    RETURN QUERY SELECT
        COALESCE(v_total,0), COALESCE(v_completed,0),
        CASE WHEN COALESCE(v_total,0) > 0
             THEN ROUND((COALESCE(v_completed,0)::DECIMAL / v_total)*100, 2)
             ELSE 0.00 END::DECIMAL(5,2),
        COALESCE(v_pending,'[]'::JSONB), v_last_updated;
END;
$$;


ALTER FUNCTION "public"."get_guard_checklist_completion"("p_guard_id" "uuid", "p_checklist_date" "date") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_guard_checklist_items"() RETURNS TABLE("master_item_id" "uuid", "checklist_id" "uuid", "title" "text", "description" "text", "required_evidence" boolean, "input_type" "text", "numeric_unit_label" "text", "numeric_min_value" numeric, "numeric_max_value" numeric, "requires_supervisor_override" boolean, "response_value" "text", "evidence_url" "text", "status" "text", "submitted_at" timestamp with time zone, "override_status" "text", "override_reason" "text", "overridden_at" timestamp with time zone, "overridden_by_name" "text")
    LANGUAGE "sql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
  WITH latest_response AS (
    SELECT DISTINCT ON (cr.employee_id, cr.checklist_id)
      cr.employee_id,
      cr.checklist_id,
      cr.responses,
      cr.submitted_at,
      cr.override_status,
      cr.override_reason,
      cr.overridden_at,
      cr.overridden_by
    FROM public.checklist_responses cr
    WHERE cr.employee_id = get_employee_id()
      AND cr.response_date = CURRENT_DATE
    ORDER BY cr.employee_id, cr.checklist_id, cr.submitted_at DESC
  )
  SELECT
    dci.id AS master_item_id,
    dci.checklist_id,
    dci.task_name AS title,
    dci.description,
    dci.requires_photo AS required_evidence,
    dci.input_type,
    dci.numeric_unit_label,
    dci.numeric_min_value,
    dci.numeric_max_value,
    dci.requires_supervisor_override,
    response_item.value ->> 'value' AS response_value,
    response_item.value ->> 'evidence_url' AS evidence_url,
    CASE
      WHEN response_item.value IS NULL THEN 'pending'
      ELSE 'completed'
    END AS status,
    lr.submitted_at,
    COALESCE(lr.override_status, 'none') AS override_status,
    lr.override_reason,
    lr.overridden_at,
    acting_user.full_name AS overridden_by_name
  FROM public.daily_checklist_items dci
  LEFT JOIN latest_response lr ON lr.checklist_id = dci.checklist_id
  LEFT JOIN public.users acting_user ON acting_user.id = lr.overridden_by
  LEFT JOIN LATERAL (
    SELECT item.value
    FROM JSONB_ARRAY_ELEMENTS(COALESCE(lr.responses, '[]'::JSONB)) AS item(value)
    WHERE item.value ->> 'master_item_id' = dci.id::TEXT
    LIMIT 1
  ) response_item ON TRUE
  WHERE dci.is_active = TRUE
  ORDER BY dci.priority, dci.created_at;
$$;


ALTER FUNCTION "public"."get_guard_checklist_items"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_guard_emergency_contacts"() RETURNS TABLE("id" "text", "label" "text", "role" "text", "phone" "text", "description" "text", "is_primary" boolean)
    LANGUAGE "sql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
  WITH staff_contacts AS (
    SELECT
      'user-' || u.id::TEXT AS id,
      COALESCE(NULLIF(BTRIM(u.full_name), ''), 'Operations contact') AS label,
      INITCAP(REPLACE(r.role_name::TEXT, '_', ' ')) AS role,
      COALESCE(NULLIF(BTRIM(u.phone), ''), NULLIF(BTRIM(e.phone), '')) AS phone,
      'App-configured escalation contact' AS description,
      (r.role_name::TEXT = 'security_supervisor') AS is_primary,
      0 AS sort_order
    FROM public.users u
    JOIN public.roles r ON r.id = u.role_id
    LEFT JOIN public.employees e ON e.id = u.employee_id
    WHERE
      u.is_active = TRUE
      AND r.role_name::TEXT IN ('security_supervisor', 'society_manager', 'admin')
      AND COALESCE(NULLIF(BTRIM(u.phone), ''), NULLIF(BTRIM(e.phone), '')) IS NOT NULL
  ),
  directory_contacts AS (
    SELECT
      'emergency-' || ec.id::TEXT AS id,
      ec.contact_name AS label,
      INITCAP(REPLACE(ec.contact_type, '_', ' ')) AS role,
      ec.phone_number AS phone,
      COALESCE(ec.description, 'Manager-configured emergency contact') AS description,
      (COALESCE(ec.priority, 99) = 1) AS is_primary,
      COALESCE(ec.priority, 99) AS sort_order
    FROM public.emergency_contacts ec
    WHERE ec.is_active = TRUE
      AND COALESCE(BTRIM(ec.phone_number), '') <> ''
  )
  SELECT
    contact.id,
    contact.label,
    contact.role,
    contact.phone,
    contact.description,
    contact.is_primary
  FROM (
    SELECT * FROM staff_contacts
    UNION ALL
    SELECT * FROM directory_contacts
  ) AS contact
  ORDER BY contact.is_primary DESC, contact.sort_order, contact.label;
$$;


ALTER FUNCTION "public"."get_guard_emergency_contacts"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_guard_id"() RETURNS "uuid"
    LANGUAGE "plpgsql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
  RETURN (
    SELECT sg.id
    FROM public.security_guards sg
    JOIN public.employees e ON e.id = sg.employee_id
    WHERE e.auth_user_id = auth.uid()
    LIMIT 1
  );
END;
$$;


ALTER FUNCTION "public"."get_guard_id"() OWNER TO "postgres";


COMMENT ON FUNCTION "public"."get_guard_id"() IS 'Returns security_guards.id for current authenticated guard';



CREATE OR REPLACE FUNCTION "public"."get_guard_last_position"("p_guard_id" "uuid") RETURNS TABLE("latitude" numeric, "longitude" numeric, "tracked_at" timestamp with time zone, "minutes_ago" integer)
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
    RETURN QUERY
    SELECT gt.latitude, gt.longitude, gt.tracked_at,
           (EXTRACT(EPOCH FROM (NOW() - gt.tracked_at)) / 60)::INTEGER
    FROM gps_tracking gt WHERE gt.employee_id = p_guard_id
    ORDER BY gt.tracked_at DESC LIMIT 1;
END;
$$;


ALTER FUNCTION "public"."get_guard_last_position"("p_guard_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_guard_location_history"("p_guard_id" "uuid", "p_hours_back" integer DEFAULT 24) RETURNS TABLE("latitude" numeric, "longitude" numeric, "accuracy_meters" integer, "is_within_fence" boolean, "recorded_at" timestamp with time zone)
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    ggt.latitude,
    ggt.longitude,
    ggt.accuracy_meters,
    ggt.is_within_fence,
    ggt.recorded_at
  FROM guard_gps_tracking ggt
  WHERE ggt.guard_id = p_guard_id
    AND ggt.recorded_at > NOW() - INTERVAL '1 hour' * p_hours_back
  ORDER BY ggt.recorded_at DESC;
END;
$$;


ALTER FUNCTION "public"."get_guard_location_history"("p_guard_id" "uuid", "p_hours_back" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_guard_movement_variance"("p_guard_id" "uuid", "p_duration_minutes" integer DEFAULT 30) RETURNS numeric
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
    v_max_dist NUMERIC := 0;
BEGIN
    -- Rough displacement in meters
    WITH points AS (
        SELECT latitude, longitude
        FROM gps_tracking
        WHERE employee_id = p_guard_id
        AND tracked_at >= NOW() - (p_duration_minutes || ' minutes')::interval
    )
    SELECT 
        SQRT(POW(MAX(latitude) - MIN(latitude), 2) + POW(MAX(longitude) - MIN(longitude), 2)) * 111320
    INTO v_max_dist
    FROM points;
    
    RETURN COALESCE(v_max_dist, 0);
END;
$$;


ALTER FUNCTION "public"."get_guard_movement_variance"("p_guard_id" "uuid", "p_duration_minutes" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_guard_roster"() RETURNS TABLE("id" "uuid", "guard_name" "text", "shift_start" "text", "last_gps_ping" "text", "status" "text")
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
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


ALTER FUNCTION "public"."get_guard_roster"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_guard_visitors"("p_include_checked_out" boolean DEFAULT true) RETURNS TABLE("id" "uuid", "visitor_name" "text", "visitor_type" "text", "phone" "text", "purpose" "text", "flat_id" "uuid", "flat_label" "text", "resident_id" "uuid", "resident_name" "text", "vehicle_number" "text", "photo_url" "text", "entry_time" timestamp with time zone, "exit_time" timestamp with time zone, "entry_location_name" "text", "is_frequent_visitor" boolean, "approval_status" "text", "approval_deadline_at" timestamp with time zone, "decision_at" timestamp with time zone, "approved_by_resident" boolean, "rejection_reason" "text")
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
  PERFORM public.expire_mobile_visitor_decisions();

  RETURN QUERY
  SELECT
    v.id,
    v.visitor_name::TEXT,
    COALESCE(v.visitor_type, 'guest')::TEXT AS visitor_type,
    v.phone::TEXT,
    v.purpose::TEXT,
    v.flat_id,
    TRIM(COALESCE(b.building_name || ' - ', '') || COALESCE(f.flat_number, 'Visitor destination'))::TEXT AS flat_label,
    v.resident_id,
    r.full_name::TEXT AS resident_name,
    v.vehicle_number::TEXT,
    v.photo_url::TEXT,
    v.entry_time,
    v.exit_time,
    COALESCE(cl.location_name, 'Gate')::TEXT AS entry_location_name,
    v.is_frequent_visitor,
    v.approval_status::TEXT,
    v.approval_deadline_at,
    v.decision_at,
    v.approved_by_resident,
    v.rejection_reason::TEXT
  FROM public.visitors v
  LEFT JOIN public.flats f ON f.id = v.flat_id
  LEFT JOIN public.buildings b ON b.id = f.building_id
  LEFT JOIN public.residents r ON r.id = v.resident_id
  LEFT JOIN public.company_locations cl ON cl.id = v.entry_location_id
  WHERE
    v.entry_guard_id = get_guard_id()
    AND (p_include_checked_out OR v.exit_time IS NULL)
  ORDER BY v.entry_time DESC;
END;
$$;


ALTER FUNCTION "public"."get_guard_visitors"("p_include_checked_out" boolean) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_hod_leave_requests"("p_user_id" "uuid", "p_company_id" "uuid") RETURNS TABLE("id" "uuid", "employee_name" "text", "leave_type" "text", "start_date" "date", "end_date" "date", "reason" "text", "status" "text")
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
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


ALTER FUNCTION "public"."get_hod_leave_requests"("p_user_id" "uuid", "p_company_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_hod_summary"("p_user_id" "uuid", "p_company_id" "uuid") RETURNS TABLE("pending_leave_count" integer, "attendance_rate" numeric, "team_size" integer)
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
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


ALTER FUNCTION "public"."get_hod_summary"("p_user_id" "uuid", "p_company_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_hod_team_members"("p_user_id" "uuid", "p_company_id" "uuid") RETURNS TABLE("id" "uuid", "name" "text", "designation" "text", "attendance_status" "text")
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
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


ALTER FUNCTION "public"."get_hod_team_members"("p_user_id" "uuid", "p_company_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_md_approval_queue"("p_user_id" "uuid") RETURNS TABLE("id" "uuid", "type" "text", "description" "text", "requested_by" "text", "department" "text", "amount" bigint, "created_at" "text")
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
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


ALTER FUNCTION "public"."get_md_approval_queue"("p_user_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_md_executive_summary"("p_user_id" "uuid") RETURNS TABLE("monthly_revenue" bigint, "headcount" integer, "active_incidents" integer, "pending_approval_count" integer)
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
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


ALTER FUNCTION "public"."get_md_executive_summary"("p_user_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_mobile_oversight_tickets"() RETURNS TABLE("id" "uuid", "ticket_number" "text", "ticket_type" "text", "material_issue_type" "text", "subject_name" "text", "category" "text", "severity" "text", "status" "text", "note" "text", "evidence_urls" "jsonb", "batch_number" "text", "ordered_quantity" numeric, "received_quantity" numeric, "shortage_quantity" numeric, "return_quantity" numeric, "location_name" "text", "source_visitor_id" "uuid", "parent_ticket_id" "uuid", "inspection_outcome" "text", "created_at" timestamp with time zone)
    LANGUAGE "sql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
  SELECT
    ot.id,
    ot.ticket_number,
    ot.ticket_type,
    ot.material_issue_type,
    ot.subject_name,
    ot.category,
    ot.severity,
    ot.status,
    ot.note,
    ot.evidence_urls,
    ot.batch_number,
    ot.ordered_quantity,
    ot.received_quantity,
    ot.shortage_quantity,
    ot.return_quantity,
    ot.location_name,
    ot.source_visitor_id,
    ot.parent_ticket_id,
    ot.inspection_outcome,
    ot.created_at
  FROM public.oversight_tickets ot
  ORDER BY
    CASE ot.status
      WHEN 'open' THEN 0
      WHEN 'acknowledged' THEN 1
      ELSE 2
    END,
    ot.created_at DESC;
$$;


ALTER FUNCTION "public"."get_mobile_oversight_tickets"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_my_app_role"() RETURNS "text"
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public', 'extensions'
    AS $$
  SELECT r.role_name::TEXT
  FROM public.users u
  JOIN public.roles r ON u.role_id = r.id
  WHERE u.id = auth.uid()
  LIMIT 1;
$$;


ALTER FUNCTION "public"."get_my_app_role"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_my_managed_societies"() RETURNS SETOF "uuid"
    LANGUAGE "plpgsql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
    v_user_id UUID := auth.uid();
    v_role TEXT := public.get_user_role()::TEXT;
BEGIN
    IF v_user_id IS NULL THEN
        RETURN;
    END IF;

    -- 1. Platform-wide roles
    IF v_role IN ('super_admin', 'admin', 'account', 'company_md', 'supplier', 'vendor') THEN
        RETURN QUERY SELECT id FROM public.societies;
        RETURN;
    END IF;

    -- 2. society_manager
    IF v_role = 'society_manager' THEN
        RETURN QUERY SELECT id FROM public.societies WHERE society_manager_id = v_user_id;
        RETURN;
    END IF;

    -- 3. security_supervisor / site_supervisor
    IF v_role IN ('security_supervisor', 'site_supervisor', 'company_hod') THEN
        RETURN QUERY
            SELECT DISTINCT cl.society_id
            FROM public.company_locations cl
            JOIN public.security_guards sg ON sg.assigned_location_id = cl.id
            JOIN public.employees e ON e.id = sg.employee_id
            WHERE e.auth_user_id = v_user_id;
        RETURN;
    END IF;

    -- 4. security_guard — use employees.auth_user_id (no public.users row required)
    IF v_role = 'security_guard' THEN
        RETURN QUERY
            SELECT cl.society_id
            FROM public.company_locations cl
            JOIN public.security_guards sg ON sg.assigned_location_id = cl.id
            JOIN public.employees e ON e.id = sg.employee_id
            WHERE e.auth_user_id = v_user_id;
        RETURN;
    END IF;

    -- 5. resident — via flat -> building -> society
    IF v_role = 'resident' THEN
        RETURN QUERY
            SELECT b.society_id
            FROM public.residents r
            JOIN public.flats f ON r.flat_id = f.id
            JOIN public.buildings b ON f.building_id = b.id
            WHERE r.auth_user_id = v_user_id;
        RETURN;
    END IF;

    -- 6. buyer
    IF v_role = 'buyer' THEN
        RETURN QUERY
            SELECT DISTINCT cl.society_id
            FROM public.company_locations cl
            JOIN public.requests r ON r.location_id = cl.id
            WHERE r.buyer_id = v_user_id;
        RETURN;
    END IF;

    -- 7. generic fallback via security_guards
    RETURN QUERY
        SELECT DISTINCT cl.society_id
        FROM public.company_locations cl
        JOIN public.security_guards sg ON sg.assigned_location_id = cl.id
        JOIN public.employees e ON e.id = sg.employee_id
        WHERE e.auth_user_id = v_user_id;

END;
$$;


ALTER FUNCTION "public"."get_my_managed_societies"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_next_rtv_number"() RETURNS character varying
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public', 'extensions'
    AS $$
DECLARE
    year_month VARCHAR;
    next_seq INT;
BEGIN
    year_month := to_char(CURRENT_TIMESTAMP, 'YYMM');
    next_seq := nextval('rtv_ticket_seq');
    RETURN 'RTV-' || year_month || '-' || lpad(next_seq::text, 4, '0');
END;
$$;


ALTER FUNCTION "public"."get_next_rtv_number"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_oversight_alert_feed"() RETURNS TABLE("id" "uuid", "guard_id" "uuid", "guard_name" "text", "location_name" "text", "alert_type" "text", "status" "text", "created_at" timestamp with time zone, "note" "text")
    LANGUAGE "sql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
  SELECT
    pa.id,
    pa.guard_id,
    TRIM(COALESCE(e.first_name, '') || ' ' || COALESCE(e.last_name, '')) AS guard_name,
    COALESCE(cl.location_name, 'Unknown location') AS location_name,
    pa.alert_type::TEXT AS alert_type,
    CASE
      WHEN pa.is_resolved THEN 'resolved'
      WHEN pa.acknowledged_at IS NOT NULL THEN 'acknowledged'
      ELSE 'active'
    END AS status,
    pa.alert_time AS created_at,
    COALESCE(pa.description, 'Guard alert raised from mobile workflow.') AS note
  FROM public.panic_alerts pa
  JOIN public.security_guards sg ON sg.id = pa.guard_id
  JOIN public.employees e ON e.id = sg.employee_id
  LEFT JOIN public.company_locations cl ON cl.id = COALESCE(pa.location_id, sg.assigned_location_id)
  ORDER BY pa.alert_time DESC
  LIMIT 100;
$$;


ALTER FUNCTION "public"."get_oversight_alert_feed"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_oversight_attendance_log"() RETURNS TABLE("id" "uuid", "employee_name" "text", "role_label" "text", "location_name" "text", "check_in_at" timestamp with time zone, "check_out_at" timestamp with time zone, "geo_status" "text", "status" "text")
    LANGUAGE "sql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
  WITH guard_map AS (
    SELECT
      sg.id AS guard_id,
      sg.employee_id,
      sg.assigned_location_id
    FROM public.security_guards sg
  ),
  latest_gps AS (
    SELECT DISTINCT ON (gt.employee_id)
      gt.employee_id,
      gt.latitude,
      gt.longitude,
      gt.tracked_at
    FROM public.gps_tracking gt
    ORDER BY gt.employee_id, gt.tracked_at DESC
  )
  SELECT
    al.id,
    TRIM(COALESCE(e.first_name, '') || ' ' || COALESCE(e.last_name, '')) AS employee_name,
    COALESCE(INITCAP(REPLACE(r.role_name::TEXT, '_', ' ')), 'Employee') AS role_label,
    COALESCE(cl.location_name, 'Location pending') AS location_name,
    al.check_in_time AS check_in_at,
    al.check_out_time AS check_out_at,
    CASE
      WHEN
        lg.tracked_at IS NOT NULL
        AND site.latitude IS NOT NULL
        AND site.longitude IS NOT NULL
        AND check_geofence(
          lg.latitude::DOUBLE PRECISION,
          lg.longitude::DOUBLE PRECISION,
          site.latitude::DOUBLE PRECISION,
          site.longitude::DOUBLE PRECISION,
          COALESCE(site.geo_fence_radius::DOUBLE PRECISION, 100.0)
        ) THEN 'verified'
      WHEN
        lg.tracked_at IS NOT NULL
        AND site.latitude IS NOT NULL
        AND site.longitude IS NOT NULL THEN 'outside_fence'
      WHEN al.check_in_location_id IS NOT NULL THEN 'verified'
      ELSE 'missing'
    END AS geo_status,
    CASE
      WHEN al.check_in_time IS NULL THEN 'absent'
      WHEN al.check_out_time IS NULL THEN 'on_shift'
      ELSE 'completed'
    END AS status
  FROM public.attendance_logs al
  JOIN public.employees e ON e.id = al.employee_id
  LEFT JOIN public.users u ON u.id = e.auth_user_id
  LEFT JOIN public.roles r ON r.id = u.role_id
  LEFT JOIN public.company_locations cl
    ON cl.id = COALESCE(al.check_in_location_id, al.check_out_location_id)
  LEFT JOIN guard_map gm ON gm.employee_id = al.employee_id
  LEFT JOIN public.company_locations site ON site.id = gm.assigned_location_id
  LEFT JOIN latest_gps lg ON lg.employee_id = gm.guard_id
  WHERE al.log_date >= CURRENT_DATE - INTERVAL '1 day'
  ORDER BY COALESCE(al.check_in_time, al.created_at) DESC
  LIMIT 100;
$$;


ALTER FUNCTION "public"."get_oversight_attendance_log"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_oversight_live_guards"() RETURNS TABLE("id" "uuid", "guard_name" "text", "guard_code" "text", "assigned_location_name" "text", "status" "text", "last_seen_at" timestamp with time zone, "checklist_completed" integer, "checklist_total" integer, "current_shift_label" "text", "latitude" double precision, "longitude" double precision, "visitors_handled_today" bigint)
    LANGUAGE "sql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
  WITH latest_gps AS (
    SELECT DISTINCT ON (gt.employee_id)
      gt.employee_id,
      gt.latitude,
      gt.longitude,
      gt.tracked_at
    FROM public.gps_tracking gt
    ORDER BY gt.employee_id, gt.tracked_at DESC
  ),
  attendance AS (
    SELECT
      al.employee_id,
      MAX(al.check_in_time) FILTER (WHERE al.log_date = CURRENT_DATE) AS last_check_in,
      MAX(al.check_out_time) FILTER (WHERE al.log_date = CURRENT_DATE) AS last_check_out
    FROM public.attendance_logs al
    GROUP BY al.employee_id
  ),
  checklist AS (
    SELECT
      e.id AS employee_id,
      COALESCE(MAX(JSONB_ARRAY_LENGTH(cr.responses)), 0) AS checklist_completed
    FROM public.employees e
    LEFT JOIN public.checklist_responses cr
      ON cr.employee_id = e.id
     AND cr.response_date = CURRENT_DATE
    GROUP BY e.id
  ),
  checklist_total AS (
    SELECT COUNT(*)::INTEGER AS total_items
    FROM public.daily_checklist_items dci
    WHERE dci.is_active = TRUE
  ),
  visitors_today AS (
    SELECT
      v.entry_guard_id AS guard_id,
      COUNT(*)::BIGINT AS handled_today
    FROM public.visitors v
    WHERE v.entry_time::DATE = CURRENT_DATE
    GROUP BY v.entry_guard_id
  )
  SELECT
    sg.id,
    TRIM(COALESCE(e.first_name, '') || ' ' || COALESCE(e.last_name, '')) AS guard_name,
    sg.guard_code,
    COALESCE(cl.location_name, 'Assigned gate') AS assigned_location_name,
    CASE
      WHEN a.last_check_in IS NULL OR a.last_check_out IS NOT NULL THEN 'off_duty'
      WHEN lg.tracked_at IS NULL OR lg.tracked_at < NOW() - INTERVAL '10 minutes' THEN 'offline'
      WHEN
        lg.tracked_at IS NOT NULL
        AND cl.latitude IS NOT NULL
        AND cl.longitude IS NOT NULL
        AND NOT check_geofence(
          lg.latitude::DOUBLE PRECISION,
          lg.longitude::DOUBLE PRECISION,
          cl.latitude::DOUBLE PRECISION,
          cl.longitude::DOUBLE PRECISION,
          COALESCE(cl.geo_fence_radius::DOUBLE PRECISION, 100.0)
        ) THEN 'breach'
      ELSE 'on_duty'
    END AS status,
    COALESCE(lg.tracked_at, a.last_check_in) AS last_seen_at,
    COALESCE(c.checklist_completed, 0) AS checklist_completed,
    COALESCE(ct.total_items, 0) AS checklist_total,
    COALESCE(sg.shift_timing, 'Active shift') AS current_shift_label,
    COALESCE(lg.latitude::DOUBLE PRECISION, cl.latitude::DOUBLE PRECISION, 0) AS latitude,
    COALESCE(lg.longitude::DOUBLE PRECISION, cl.longitude::DOUBLE PRECISION, 0) AS longitude,
    COALESCE(vt.handled_today, 0) AS visitors_handled_today
  FROM public.security_guards sg
  JOIN public.employees e ON e.id = sg.employee_id
  LEFT JOIN public.company_locations cl ON cl.id = sg.assigned_location_id
  LEFT JOIN latest_gps lg ON lg.employee_id = sg.id
  LEFT JOIN attendance a ON a.employee_id = e.id
  LEFT JOIN checklist c ON c.employee_id = e.id
  CROSS JOIN checklist_total ct
  LEFT JOIN visitors_today vt ON vt.guard_id = sg.id
  WHERE sg.is_active = TRUE
  ORDER BY guard_name;
$$;


ALTER FUNCTION "public"."get_oversight_live_guards"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_oversight_visitor_stats"() RETURNS TABLE("id" "uuid", "gate_name" "text", "visitors_today" bigint, "visitors_this_week" bigint, "pending_approvals" bigint, "delivery_vehicles" bigint)
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
  PERFORM public.expire_mobile_visitor_decisions();

  RETURN QUERY
  SELECT
    cl.id,
    cl.location_name AS gate_name,
    COUNT(*) FILTER (WHERE v.entry_time::DATE = CURRENT_DATE)::BIGINT AS visitors_today,
    COUNT(*) FILTER (WHERE v.entry_time >= DATE_TRUNC('week', NOW()))::BIGINT AS visitors_this_week,
    COUNT(*) FILTER (
      WHERE v.exit_time IS NULL
        AND v.approval_status = 'pending'
    )::BIGINT AS pending_approvals,
    COUNT(*) FILTER (
      WHERE COALESCE(v.visitor_type, 'guest') = 'delivery'
    )::BIGINT AS delivery_vehicles
  FROM public.company_locations cl
  LEFT JOIN public.visitors v ON v.entry_location_id = cl.id
  GROUP BY cl.id, cl.location_name
  ORDER BY cl.location_name;
END;
$$;


ALTER FUNCTION "public"."get_oversight_visitor_stats"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_panic_alert_status"("p_alert_id" "uuid") RETURNS "text"
    LANGUAGE "sql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
  SELECT CASE
    WHEN pa.is_resolved THEN 'resolved'
    WHEN pa.acknowledged_at IS NOT NULL THEN 'acknowledged'
    ELSE 'active'
  END
  FROM public.panic_alerts pa
  WHERE pa.id = p_alert_id
    AND (
      pa.guard_id = get_guard_id()
      OR has_role('security_supervisor')
      OR has_role('society_manager')
      OR has_role('admin')
      OR has_role('super_admin')
    )
  LIMIT 1;
$$;


ALTER FUNCTION "public"."get_panic_alert_status"("p_alert_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_pending_grns"("p_user_id" "uuid", "p_company_id" "uuid") RETURNS TABLE("id" "uuid", "grn_number" "text", "supplier_name" "text", "po_number" "text", "received_date" "date", "item_count" integer, "status" "text")
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
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


ALTER FUNCTION "public"."get_pending_grns"("p_user_id" "uuid", "p_company_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_pending_material_delivery_events"() RETURNS TABLE("id" "uuid", "visitor_name" "text", "purpose" "text", "vehicle_number" "text", "photo_url" "text", "gate_name" "text", "entry_time" timestamp with time zone)
    LANGUAGE "sql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
  SELECT
    v.id,
    v.visitor_name,
    COALESCE(v.purpose, 'Delivery inspection pending') AS purpose,
    v.vehicle_number,
    v.photo_url,
    COALESCE(cl.location_name, 'Gate') AS gate_name,
    v.entry_time
  FROM public.visitors v
  LEFT JOIN public.company_locations cl ON cl.id = v.entry_location_id
  WHERE COALESCE(v.visitor_type, 'guest') = 'delivery'
    AND v.exit_time IS NULL
    AND NOT EXISTS (
      SELECT 1
      FROM public.oversight_tickets ot
      WHERE ot.source_visitor_id = v.id
        AND ot.ticket_type = 'material'
    )
  ORDER BY v.entry_time DESC;
$$;


ALTER FUNCTION "public"."get_pending_material_delivery_events"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_qr_batch_statistics"("p_society_id" "uuid") RETURNS TABLE("total_qr_codes" bigint, "linked_qr_codes" bigint, "unlinked_qr_codes" bigint, "total_batches" bigint, "latest_batch_date" timestamp with time zone)
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public'
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*)::BIGINT as total_qr_codes,
        COUNT(*) FILTER (WHERE is_linked = true)::BIGINT as linked_qr_codes,
        COUNT(*) FILTER (WHERE is_linked = false)::BIGINT as unlinked_qr_codes,
        COUNT(DISTINCT batch_id)::BIGINT as total_batches,
        MAX(created_at) as latest_batch_date
    FROM qr_codes
    WHERE society_id = p_society_id
    AND is_active = true;
END;
$$;


ALTER FUNCTION "public"."get_qr_batch_statistics"("p_society_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_resident_id"() RETURNS "uuid"
    LANGUAGE "plpgsql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
  RETURN (
    SELECT id FROM public.residents WHERE auth_user_id = auth.uid() LIMIT 1
  );
END;
$$;


ALTER FUNCTION "public"."get_resident_id"() OWNER TO "postgres";


COMMENT ON FUNCTION "public"."get_resident_id"() IS 'Returns residents.id for current authenticated resident';



CREATE OR REPLACE FUNCTION "public"."get_resident_pending_visitors"() RETURNS TABLE("id" "uuid", "visitor_name" "text", "phone" "text", "purpose" "text", "flat_id" "uuid", "flat_label" "text", "vehicle_number" "text", "photo_url" "text", "entry_time" timestamp with time zone, "approval_status" "text", "approval_deadline_at" timestamp with time zone, "is_frequent_visitor" boolean, "rejection_reason" "text")
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
  PERFORM public.expire_mobile_visitor_decisions();

  RETURN QUERY
  SELECT
    v.id,
    v.visitor_name::TEXT,
    v.phone::TEXT,
    v.purpose::TEXT,
    v.flat_id,
    TRIM(COALESCE(b.building_name || ' - ', '') || COALESCE(f.flat_number, 'Visitor destination'))::TEXT AS flat_label,
    v.vehicle_number::TEXT,
    v.photo_url::TEXT,
    v.entry_time,
    v.approval_status::TEXT,
    v.approval_deadline_at,
    v.is_frequent_visitor,
    v.rejection_reason::TEXT
  FROM public.visitors v
  JOIN public.residents r
    ON r.flat_id = v.flat_id
   AND r.auth_user_id = auth.uid()
  LEFT JOIN public.flats f ON f.id = v.flat_id
  LEFT JOIN public.buildings b ON b.id = f.building_id
  WHERE v.exit_time IS NULL
  ORDER BY v.entry_time DESC;
END;
$$;


ALTER FUNCTION "public"."get_resident_pending_visitors"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_shift_checklist_items"("p_shift_id" "uuid") RETURNS TABLE("item_id" "uuid", "task_name" character varying, "category" character varying, "priority" integer, "requires_photo" boolean, "requires_signature" boolean)
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
    RETURN QUERY
    SELECT dci.id, dci.checklist_name as task_name, dci.department as category, 1 as priority,
           false as requires_photo, false as requires_signature
    FROM daily_checklists dci
    WHERE dci.is_active = true
    ORDER BY dci.checklist_name;
END;
$$;


ALTER FUNCTION "public"."get_shift_checklist_items"("p_shift_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_shift_time_info"("p_shift_id" "uuid") RETURNS TABLE("shift_name" character varying, "start_time" time without time zone, "end_time" time without time zone, "midpoint" time without time zone, "minutes_remaining" integer, "is_past_midpoint" boolean)
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
    v_name VARCHAR; v_start TIME; v_end TIME; v_midpoint TIME;
    v_now TIME := CURRENT_TIME; v_mins INTEGER;
BEGIN
    SELECT s.shift_name, s.start_time::TIME, s.end_time::TIME
    INTO v_name, v_start, v_end FROM shifts s WHERE s.id = p_shift_id;
    IF v_start IS NULL THEN RETURN; END IF;
    v_midpoint := v_start + ((v_end - v_start) / 2);
    IF v_end > v_start THEN
        v_mins := (EXTRACT(EPOCH FROM (v_end - v_now)) / 60)::INTEGER;
    ELSIF v_now > v_start THEN
        v_mins := (EXTRACT(EPOCH FROM ('24:00:00'::INTERVAL - v_now + v_end)) / 60)::INTEGER;
    ELSE
        v_mins := (EXTRACT(EPOCH FROM (v_end - v_now)) / 60)::INTEGER;
    END IF;
    RETURN QUERY SELECT v_name, v_start, v_end, v_midpoint, GREATEST(v_mins,0), (v_now > v_midpoint);
END;
$$;


ALTER FUNCTION "public"."get_shift_time_info"("p_shift_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_site_incidents"() RETURNS TABLE("id" "uuid", "type" "text", "location" "text", "severity" "text", "opened_at" "text", "acknowledged" boolean)
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
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


ALTER FUNCTION "public"."get_site_incidents"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_site_supervisor_summary"() RETURNS TABLE("guards_on_duty" integer, "open_incidents" integer)
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
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


ALTER FUNCTION "public"."get_site_supervisor_summary"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_stock_alerts"("p_user_id" "uuid", "p_company_id" "uuid") RETURNS TABLE("id" "uuid", "item_name" "text", "current_quantity" numeric, "min_threshold" numeric, "unit" "text", "location_name" "text", "severity" "text")
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
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


ALTER FUNCTION "public"."get_stock_alerts"("p_user_id" "uuid", "p_company_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_storekeeper_summary"("p_user_id" "uuid", "p_company_id" "uuid") RETURNS TABLE("total_items" integer, "low_stock_count" integer, "pending_grn_count" integer)
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
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


ALTER FUNCTION "public"."get_storekeeper_summary"("p_user_id" "uuid", "p_company_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_super_admin_platform_summary"() RETURNS TABLE("total_companies" integer, "total_active_users" integer, "active_incidents" integer, "critical_alert_count" integer)
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
  RETURN QUERY SELECT
    (SELECT COUNT(*)::INTEGER FROM societies WHERE is_active = true),
    (SELECT COUNT(*)::INTEGER FROM users    WHERE is_active = true),
    (SELECT COUNT(*)::INTEGER FROM panic_alerts WHERE is_resolved = false),
    (SELECT COUNT(*)::INTEGER FROM panic_alerts WHERE is_resolved = false AND alert_type = 'panic');
END;
$$;


ALTER FUNCTION "public"."get_super_admin_platform_summary"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_unlinked_qr_codes"("p_society_id" "uuid", "p_limit" integer DEFAULT 100) RETURNS TABLE("id" "uuid", "batch_id" "text", "sequence_number" integer, "created_at" timestamp with time zone)
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public'
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        qc.id,
        qc.batch_id,
        qc.sequence_number,
        qc.created_at
    FROM qr_codes qc
    WHERE qc.society_id = p_society_id
    AND qc.is_linked = false
    AND qc.is_active = true
    ORDER BY qc.batch_id, qc.sequence_number
    LIMIT p_limit;
END;
$$;


ALTER FUNCTION "public"."get_unlinked_qr_codes"("p_society_id" "uuid", "p_limit" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_user_role"() RETURNS "public"."user_role"
    LANGUAGE "plpgsql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public', 'extensions'
    AS $$
DECLARE
    role_val user_role;
BEGIN
    -- Try users table
    SELECT r.role_name INTO role_val
    FROM users u
    JOIN roles r ON u.role_id = r.id
    WHERE u.id = auth.uid()
    LIMIT 1;

    -- Fallback for guards who only have auth_user_id in employees
    IF role_val IS NULL THEN
        IF EXISTS (
            SELECT 1 FROM security_guards sg
            JOIN employees e ON sg.employee_id = e.id
            WHERE e.auth_user_id = auth.uid()
        ) THEN
            RETURN 'security_guard'::user_role;
        END IF;
    END IF;

    RETURN role_val;
END;
$$;


ALTER FUNCTION "public"."get_user_role"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."has_active_checklist_alert"("p_guard_id" "uuid", "p_date" "date") RETURNS boolean
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM panic_alerts pa
        WHERE pa.guard_id = p_guard_id AND pa.alert_type = 'checklist_incomplete'
            AND pa.is_resolved = false AND pa.created_at::DATE = p_date
    );
END;
$$;


ALTER FUNCTION "public"."has_active_checklist_alert"("p_guard_id" "uuid", "p_date" "date") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."has_active_inactivity_alert"("p_guard_id" "uuid") RETURNS boolean
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM panic_alerts pa
        WHERE pa.guard_id = p_guard_id AND pa.alert_type = 'inactivity'
            AND pa.is_resolved = false AND pa.created_at > NOW() - INTERVAL '1 hour'
    );
END;
$$;


ALTER FUNCTION "public"."has_active_inactivity_alert"("p_guard_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."has_role"("required_role" "text") RETURNS boolean
    LANGUAGE "plpgsql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
    RETURN (public.get_user_role()::TEXT = required_role);
END;
$$;


ALTER FUNCTION "public"."has_role"("required_role" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."is_admin"() RETURNS boolean
    LANGUAGE "plpgsql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
    RETURN has_role('admin');
END;
$$;


ALTER FUNCTION "public"."is_admin"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."is_employee"() RETURNS boolean
    LANGUAGE "plpgsql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.employees WHERE auth_user_id = auth.uid()
  );
END;
$$;


ALTER FUNCTION "public"."is_employee"() OWNER TO "postgres";


COMMENT ON FUNCTION "public"."is_employee"() IS 'Returns true if current user is linked to an employee record';



CREATE OR REPLACE FUNCTION "public"."is_financial_manager"() RETURNS boolean
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM public.users u
        JOIN public.roles r ON u.role_id = r.id
        WHERE u.id = auth.uid() 
        AND r.role_name IN ('admin', 'account')
    );
END;
$$;


ALTER FUNCTION "public"."is_financial_manager"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."is_guard"() RETURNS boolean
    LANGUAGE "plpgsql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public', 'extensions'
    AS $$
BEGIN
    RETURN (get_user_role()::TEXT = 'security_guard');
END;
$$;


ALTER FUNCTION "public"."is_guard"() OWNER TO "postgres";


COMMENT ON FUNCTION "public"."is_guard"() IS 'Returns true if current user is a security guard';



CREATE OR REPLACE FUNCTION "public"."is_period_closed"("p_date" "date") RETURNS boolean
    LANGUAGE "plpgsql" STABLE
    SET "search_path" TO 'public'
    AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM financial_periods
        WHERE p_date BETWEEN start_date AND end_date
        AND status = 'closed'
    );
END;
$$;


ALTER FUNCTION "public"."is_period_closed"("p_date" "date") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."is_resident"() RETURNS boolean
    LANGUAGE "plpgsql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.residents WHERE auth_user_id = auth.uid()
  );
END;
$$;


ALTER FUNCTION "public"."is_resident"() OWNER TO "postgres";


COMMENT ON FUNCTION "public"."is_resident"() IS 'Returns true if current user is a resident';



CREATE OR REPLACE FUNCTION "public"."link_pest_control_ppe_on_session_start"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
    -- Only for started or paused sessions (resumed)
    IF NEW.status IN ('started', 'paused') THEN
        -- Find the latest PPE verification for this request and technician that isn't already linked to another session
        UPDATE pest_control_ppe_verifications
        SET job_session_id = NEW.id
        WHERE id = (
            SELECT id
            FROM pest_control_ppe_verifications
            WHERE service_request_id = NEW.service_request_id
              AND technician_id = NEW.technician_id
              AND all_items_checked = TRUE
              AND job_session_id IS NULL
            ORDER BY verified_at DESC
            LIMIT 1
        );
    END IF;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."link_pest_control_ppe_on_session_start"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."log_financial_audit"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
  INSERT INTO public.audit_logs (
    entity_type,
    entity_id,
    actor_id,
    actor_role,
    action,
    old_data,
    new_data,
    metadata
  ) VALUES (
    TG_TABLE_NAME,
    COALESCE(NEW.id, OLD.id),
    auth.uid(),
    public.get_my_app_role(),
    TG_OP,
    to_jsonb(OLD),
    to_jsonb(NEW),
    jsonb_build_object('source', 'log_financial_audit')
  );

  RETURN COALESCE(NEW, OLD);
END;
$$;


ALTER FUNCTION "public"."log_financial_audit"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."log_gate_entry"("p_po_id" "uuid", "p_photo_url" "text", "p_signature_url" "text" DEFAULT NULL::"text", "p_vehicle_number" "text" DEFAULT NULL::"text") RETURNS "uuid"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
    v_log_id UUID;
BEGIN
    INSERT INTO material_arrival_evidence (po_id, photo_url, signature_url, vehicle_number, logged_by)
    VALUES (p_po_id, p_photo_url, p_signature_url, p_vehicle_number, auth.uid())
    RETURNING id INTO v_log_id;
    
    -- Update PO status to reflect arrival
    UPDATE purchase_orders SET status = 'arrived' WHERE id = p_po_id;
    
    RETURN v_log_id;
END;
$$;


ALTER FUNCTION "public"."log_gate_entry"("p_po_id" "uuid", "p_photo_url" "text", "p_signature_url" "text", "p_vehicle_number" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."log_gate_entry"("p_po_id" "uuid", "p_photo_url" "text", "p_signature_url" "text" DEFAULT NULL::"text", "p_vehicle_number" "text" DEFAULT NULL::"text", "p_driver_name" "text" DEFAULT NULL::"text") RETURNS "uuid"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
    v_log_id UUID;
BEGIN
    INSERT INTO material_arrival_evidence (po_id, photo_url, signature_url, vehicle_number, driver_name, logged_by)
    VALUES (p_po_id, p_photo_url, p_signature_url, p_vehicle_number, p_driver_name, auth.uid())
    RETURNING id INTO v_log_id;
    
    UPDATE purchase_orders SET status = 'arrived' WHERE id = p_po_id;
    
    RETURN v_log_id;
END;
$$;


ALTER FUNCTION "public"."log_gate_entry"("p_po_id" "uuid", "p_photo_url" "text", "p_signature_url" "text", "p_vehicle_number" "text", "p_driver_name" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."log_gate_entry"("p_po_id" "uuid", "p_photo_url" "text", "p_signature_url" "text" DEFAULT NULL::"text", "p_vehicle_number" "text" DEFAULT NULL::"text", "p_gate_location" "text" DEFAULT NULL::"text", "p_notes" "text" DEFAULT NULL::"text") RETURNS "uuid"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_log_id UUID;
BEGIN
  INSERT INTO material_arrival_evidence (
    po_id,
    photo_url,
    signature_url,
    vehicle_number,
    gate_location,
    notes,
    logged_by
  )
  VALUES (
    p_po_id,
    p_photo_url,
    p_signature_url,
    p_vehicle_number,
    p_gate_location,
    p_notes,
    auth.uid()
  )
  RETURNING id INTO v_log_id;

  RETURN v_log_id;
END;
$$;


ALTER FUNCTION "public"."log_gate_entry"("p_po_id" "uuid", "p_photo_url" "text", "p_signature_url" "text", "p_vehicle_number" "text", "p_gate_location" "text", "p_notes" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."log_material_arrival"("p_po_id" "uuid", "p_vehicle_number" "text", "p_arrival_photo_url" "text", "p_arrival_signature_url" "text" DEFAULT NULL::"text", "p_gate_location" "text" DEFAULT NULL::"text", "p_notes" "text" DEFAULT NULL::"text") RETURNS "uuid"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
    v_log_id UUID;
    v_user_role TEXT;
BEGIN
    -- Verify user role
    SELECT r.role_name::text INTO v_user_role
    FROM users u
    JOIN roles r ON u.role_id = r.id
    WHERE u.id = auth.uid();
    
    IF v_user_role NOT IN ('delivery_boy', 'security_guard') THEN
        RAISE EXCEPTION 'Unauthorized: Only delivery_boy or security_guard can log arrivals';
    END IF;
    
    -- Verify PO exists
    IF NOT EXISTS (SELECT 1 FROM purchase_orders WHERE id = p_po_id) THEN
        RAISE EXCEPTION 'Invalid PO ID: %', p_po_id;
    END IF;
    
    -- Validate photo URL (must be from Supabase Storage)
    IF p_arrival_photo_url IS NULL OR p_arrival_photo_url = '' THEN
        RAISE EXCEPTION 'Arrival photo is mandatory';
    END IF;
    
    IF NOT p_arrival_photo_url LIKE '%/storage/v1/object/%' THEN
        RAISE EXCEPTION 'Invalid photo URL: Must be from Supabase Storage';
    END IF;
    
    -- Insert log
    INSERT INTO material_arrival_logs (
        po_id,
        vehicle_number,
        arrival_photo_url,
        arrival_signature_url,
        logged_by,
        gate_location,
        notes
    ) VALUES (
        p_po_id,
        p_vehicle_number,
        p_arrival_photo_url,
        p_arrival_signature_url,
        auth.uid(),
        p_gate_location,
        p_notes
    )
    RETURNING id INTO v_log_id;
    
    RETURN v_log_id;
END;
$$;


ALTER FUNCTION "public"."log_material_arrival"("p_po_id" "uuid", "p_vehicle_number" "text", "p_arrival_photo_url" "text", "p_arrival_signature_url" "text", "p_gate_location" "text", "p_notes" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."log_visitor_bypass_audit"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_bypassed_by_auth_user_id UUID;
BEGIN
  IF NEW.bypass_reason IS NULL OR btrim(NEW.bypass_reason) = '' THEN
    RETURN NEW;
  END IF;

  IF TG_OP = 'UPDATE' AND OLD.bypass_reason IS NOT DISTINCT FROM NEW.bypass_reason THEN
    RETURN NEW;
  END IF;

  v_bypassed_by_auth_user_id := auth.uid();

  IF v_bypassed_by_auth_user_id IS NULL AND NEW.entry_guard_id IS NOT NULL THEN
    SELECT e.auth_user_id
    INTO v_bypassed_by_auth_user_id
    FROM public.security_guards sg
    JOIN public.employees e ON e.id = sg.employee_id
    WHERE sg.id = NEW.entry_guard_id
    LIMIT 1;
  END IF;

  INSERT INTO public.visitor_bypass_audit (
    visitor_id,
    bypass_reason,
    bypassed_by_auth_user_id,
    entry_guard_id,
    resident_id,
    flat_id
  )
  VALUES (
    NEW.id,
    NEW.bypass_reason,
    v_bypassed_by_auth_user_id,
    NEW.entry_guard_id,
    NEW.resident_id,
    NEW.flat_id
  );

  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."log_visitor_bypass_audit"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."map_leave_type_to_attendance_status"("p_leave_type" "text") RETURNS "text"
    LANGUAGE "plpgsql" IMMUTABLE
    AS $$
BEGIN
  CASE COALESCE(p_leave_type, '')
    WHEN 'casual_leave' THEN RETURN 'casual_leave';
    WHEN 'sick_leave' THEN RETURN 'sick_leave';
    WHEN 'earned_leave' THEN RETURN 'earned_leave';
    WHEN 'paid_leave' THEN RETURN 'paid_leave';
    WHEN 'unpaid_leave' THEN RETURN 'unpaid_leave';
    ELSE RETURN 'leave';
  END CASE;
END;
$$;


ALTER FUNCTION "public"."map_leave_type_to_attendance_status"("p_leave_type" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."mobile_insert_notification"("p_user_id" "uuid", "p_title" "text", "p_body" "text", "p_type" "text", "p_priority" "text" DEFAULT 'normal'::"text", "p_action_url" "text" DEFAULT NULL::"text", "p_data" "jsonb" DEFAULT '{}'::"jsonb", "p_delivery_state" "text" DEFAULT 'created'::"text", "p_fallback_state" "text" DEFAULT 'not_applicable'::"text", "p_sms_fallback_at" timestamp with time zone DEFAULT NULL::timestamp with time zone) RETURNS "uuid"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_id UUID;
  v_data JSONB := COALESCE(p_data, '{}'::JSONB);
BEGIN
  IF COALESCE(NULLIF(BTRIM(p_action_url), ''), '') <> '' THEN
    v_data := v_data || JSONB_BUILD_OBJECT('action_url', p_action_url);
  END IF;

  INSERT INTO public.notifications (
    user_id,
    title,
    message,
    notification_type,
    priority,
    action_url,
    data,
    delivery_state,
    fallback_state,
    sms_fallback_at
  )
  VALUES (
    p_user_id,
    LEFT(COALESCE(p_title, ''), 200),
    LEFT(COALESCE(p_body, ''), 1000),
    COALESCE(NULLIF(BTRIM(p_type), ''), 'general'),
    COALESCE(NULLIF(BTRIM(p_priority), ''), 'normal'),
    NULLIF(BTRIM(p_action_url), ''),
    v_data,
    COALESCE(NULLIF(BTRIM(p_delivery_state), ''), 'created'),
    COALESCE(NULLIF(BTRIM(p_fallback_state), ''), 'not_applicable'),
    p_sms_fallback_at
  )
  RETURNING id INTO v_id;

  RETURN v_id;
END;
$$;


ALTER FUNCTION "public"."mobile_insert_notification"("p_user_id" "uuid", "p_title" "text", "p_body" "text", "p_type" "text", "p_priority" "text", "p_action_url" "text", "p_data" "jsonb", "p_delivery_state" "text", "p_fallback_state" "text", "p_sms_fallback_at" timestamp with time zone) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."mobile_refresh_visitor_decision_state"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
  IF NEW.exit_time IS NOT NULL AND NEW.approval_status = 'pending' THEN
    NEW.approval_status := 'checked_out';
  ELSIF NEW.approved_by_resident = TRUE THEN
    NEW.approval_status := 'approved';
    NEW.decision_at := COALESCE(NEW.decision_at, NOW());
  ELSIF NEW.rejection_reason IS NOT NULL AND btrim(NEW.rejection_reason) <> '' THEN
    NEW.approval_status := 'denied';
    NEW.decision_at := COALESCE(NEW.decision_at, NOW());
  ELSIF NEW.approval_status IS NULL THEN
    NEW.approval_status := 'pending';
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."mobile_refresh_visitor_decision_state"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."notify_payment_failure"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public'
    AS $$
BEGIN
    IF NEW.status = 'failed' AND (OLD.status IS NULL OR OLD.status != 'failed') THEN
        INSERT INTO notifications (
            user_id,
            notification_type,
            title,
            message,
            reference_type,
            reference_id,
            priority
        )
        SELECT 
            u.id,
            'payment_failure_alert',
            'Payment Failed',
            format('Payment %s of %s failed: %s', NEW.payment_number, NEW.amount, NEW.failure_reason),
            'payment',
            NEW.id,
            'high'
        FROM users u
        JOIN roles r ON u.role_id = r.id
        WHERE r.role_name::text IN ('admin', 'account');
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."notify_payment_failure"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."proc_check_login_blocked"("p_ip" "inet") RETURNS TABLE("is_blocked" boolean, "blocked_until_time" timestamp with time zone)
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
    RETURN QUERY 
    SELECT 
        blocked_until IS NOT NULL AND blocked_until > now(),
        blocked_until
    FROM public.login_rate_limits
    WHERE ip_address = p_ip;
END;
$$;


ALTER FUNCTION "public"."proc_check_login_blocked"("p_ip" "inet") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."proc_enqueue_old_photos"() RETURNS integer
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
    deleted_count integer;
BEGIN
    -- Insert photos older than 30 days that are not important into the deletion queue
    -- We assume the bucket name is 'job-evidence' based on common patterns
    INSERT INTO public.storage_deletion_queue (bucket_id, file_path, metadata)
    SELECT 
        'job-evidence', 
        substring(photo_url from '/storage/v1/object/public/job-evidence/(.*)'),
        jsonb_build_object('job_photo_id', id, 'captured_at', captured_at)
    FROM public.job_photos
    WHERE captured_at < now() - interval '30 days'
      AND is_important = false;

    -- Delete the records from job_photos
    WITH deleted AS (
        DELETE FROM public.job_photos
        WHERE captured_at < now() - interval '30 days'
          AND is_important = false
        RETURNING id
    )
    SELECT count(*) INTO deleted_count FROM deleted;

    RETURN deleted_count;
END;
$$;


ALTER FUNCTION "public"."proc_enqueue_old_photos"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."proc_handle_login_attempt"("p_ip" "inet", "p_is_failure" boolean DEFAULT false) RETURNS TABLE("is_blocked" boolean, "remaining_attempts" integer, "blocked_until_time" timestamp with time zone)
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
    v_limit_record RECORD;
    v_max_attempts CONSTANT integer := 5;
    v_lockout_period CONSTANT interval := '15 minutes';
BEGIN
    -- Get or create record
    INSERT INTO public.login_rate_limits (ip_address, attempt_count, first_attempt_at)
    VALUES (p_ip, 0, now())
    ON CONFLICT (ip_address) DO NOTHING;

    SELECT * INTO v_limit_record FROM public.login_rate_limits WHERE ip_address = p_ip;

    IF NOT p_is_failure THEN
        -- Success: reset
        UPDATE public.login_rate_limits
        SET attempt_count = 0,
            blocked_until = NULL,
            first_attempt_at = now(),
            updated_at = now()
        WHERE ip_address = p_ip;
        
        RETURN QUERY SELECT false, v_max_attempts, NULL::timestamptz;
        RETURN;
    END IF;

    -- Failure: increment and block if needed
    UPDATE public.login_rate_limits
    SET attempt_count = attempt_count + 1,
        blocked_until = CASE 
            WHEN attempt_count + 1 >= v_max_attempts THEN now() + v_lockout_period 
            ELSE NULL 
        END,
        updated_at = now()
    WHERE ip_address = p_ip
    RETURNING * INTO v_limit_record;

    RETURN QUERY SELECT 
        v_limit_record.blocked_until IS NOT NULL AND v_limit_record.blocked_until > now(),
        GREATEST(0, v_max_attempts - v_limit_record.attempt_count),
        v_limit_record.blocked_until;
END;
$$;


ALTER FUNCTION "public"."proc_handle_login_attempt"("p_ip" "inet", "p_is_failure" boolean) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."process_overdue_alerts"() RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
    -- A. Overdue Vendor Payments (Existing)
    INSERT INTO notifications (
        user_id,
        notification_type,
        title,
        message,
        reference_type,
        reference_id,
        priority
    )
    SELECT 
        u.id,
        'overdue_payment_alert',
        'Overdue Vendor Payment',
        format('Bill %s for supplier %s is overdue since %s.', pb.bill_number, s.supplier_name, pb.due_date),
        'purchase_bill',
        pb.id,
        'high'
    FROM purchase_bills pb
    JOIN suppliers s ON pb.supplier_id = s.id
    CROSS JOIN LATERAL (
        SELECT u.id FROM users u 
        JOIN roles r ON u.role_id = r.id
        WHERE r.role_name::text IN ('admin', 'account')
    ) u
    WHERE pb.payment_status != 'paid' 
    AND pb.due_date < CURRENT_DATE
    AND NOT EXISTS (
        SELECT 1 FROM notifications n 
        WHERE n.reference_id = pb.id 
        AND n.notification_type = 'overdue_payment_alert'
        AND n.created_at > CURRENT_DATE - INTERVAL '7 days'
    );

    -- B. Overdue Buyer Collections (Existing)
    INSERT INTO notifications (
        user_id,
        notification_type,
        title,
        message,
        reference_type,
        reference_id,
        priority
    )
    SELECT 
        u.id,
        'overdue_collection_alert',
        'Overdue Buyer Payment',
        format('Invoice %s is overdue since %s.', sb.bill_number, sb.due_date),
        'sale_bill',
        sb.id,
        'high'
    FROM sale_bills sb
    CROSS JOIN LATERAL (
        SELECT u.id FROM users u 
        JOIN roles r ON u.role_id = r.id
        WHERE r.role_name::text IN ('admin', 'account')
    ) u
    WHERE sb.payment_status != 'paid' 
    AND sb.due_date < CURRENT_DATE
    AND NOT EXISTS (
        SELECT 1 FROM notifications n 
        WHERE n.reference_id = sb.id 
        AND n.notification_type = 'overdue_collection_alert'
        AND n.created_at > CURRENT_DATE - INTERVAL '7 days'
    );

    -- C. Document Expiry Alerts (New)
    INSERT INTO notifications (
        user_id,
        notification_type,
        title,
        message,
        reference_type,
        reference_id,
        priority
    )
    SELECT 
        u.id,
        'document_expiry_alert',
        'Compliance Warning: Document Expiring',
        format('Document %s for employee %s expires on %s.', ed.document_name, e.first_name || ' ' || e.last_name, ed.expiry_date),
        'employee_document',
        ed.id,
        'high'
    FROM employee_documents ed
    JOIN employees e ON ed.employee_id = e.id
    JOIN users u ON u.employee_id = e.id
    WHERE ed.expiry_date BETWEEN CURRENT_DATE AND (CURRENT_DATE + INTERVAL '30 days')
    AND (ed.expiry_notified_at IS NULL OR ed.expiry_notified_at < CURRENT_DATE);
    
    -- Update notified at
    UPDATE employee_documents
    SET expiry_notified_at = CURRENT_DATE
    WHERE expiry_date BETWEEN CURRENT_DATE AND (CURRENT_DATE + INTERVAL '30 days')
    AND (expiry_notified_at IS NULL OR expiry_notified_at < CURRENT_DATE);

END;
$$;


ALTER FUNCTION "public"."process_overdue_alerts"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."propagate_payment_status_to_request"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
  v_request_id UUID;
BEGIN
  -- We only care if payment_status changed to 'paid'
  IF NEW.payment_status <> 'paid' THEN
    RETURN NEW;
  END IF;

  -- Find the originating request
  IF NEW.purchase_order_id IS NOT NULL THEN
    -- Material Flow: purchase_bill -> purchase_order -> indent -> request
    SELECT r.id INTO v_request_id
    FROM public.requests r
    JOIN public.indents i ON r.indent_id = i.id
    JOIN public.purchase_orders po ON po.indent_id = i.id
    WHERE po.id = NEW.purchase_order_id;
  ELSIF NEW.service_purchase_order_id IS NOT NULL THEN
    -- Service Flow: purchase_bill -> service_purchase_order -> request
    SELECT request_id INTO v_request_id
    FROM public.service_purchase_orders
    WHERE id = NEW.service_purchase_order_id;
  END IF;

  IF v_request_id IS NOT NULL THEN
    -- Set request status to paid
    UPDATE public.requests
    SET 
      status = 'paid',
      updated_at = NOW()
    WHERE id = v_request_id;
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."propagate_payment_status_to_request"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."purge_expired_visitor_personal_data"() RETURNS integer
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_redacted_count INTEGER := 0;
BEGIN
  WITH expired_visitors AS (
    SELECT
      v.id,
      v.photo_url,
      CASE
        WHEN v.photo_url LIKE 'storage://%' THEN split_part(replace(v.photo_url, 'storage://', ''), '/', 1)
        WHEN position('/' IN COALESCE(v.photo_url, '')) > 0 THEN split_part(v.photo_url, '/', 1)
        ELSE NULL
      END AS bucket_id,
      CASE
        WHEN v.photo_url LIKE 'storage://%' THEN substring(replace(v.photo_url, 'storage://', '') FROM position('/' IN replace(v.photo_url, 'storage://', '')) + 1)
        WHEN position('/' IN COALESCE(v.photo_url, '')) > 0 THEN substring(v.photo_url FROM position('/' IN v.photo_url) + 1)
        ELSE NULL
      END AS object_path
    FROM public.visitors v
    WHERE
      v.entry_time < NOW() - INTERVAL '90 days'
      AND v.pii_redacted_at IS NULL
  ),
  deleted_storage_objects AS (
    DELETE FROM storage.objects so
    USING expired_visitors ev
    WHERE
      ev.bucket_id IS NOT NULL
      AND ev.object_path IS NOT NULL
      AND so.bucket_id = ev.bucket_id
      AND so.name = ev.object_path
    RETURNING so.id
  ),
  redacted_visitors AS (
    UPDATE public.visitors v
    SET
      visitor_name = 'Redacted visitor',
      phone = NULL,
      vehicle_number = NULL,
      photo_url = NULL,
      pii_redacted_at = NOW()
    FROM expired_visitors ev
    WHERE v.id = ev.id
    RETURNING v.id
  )
  SELECT COUNT(*)
  INTO v_redacted_count
  FROM redacted_visitors;

  RETURN COALESCE(v_redacted_count, 0);
END;
$$;


ALTER FUNCTION "public"."purge_expired_visitor_personal_data"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."recalculate_indent_totals"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public'
    AS $$
DECLARE
    v_indent_id UUID;
BEGIN
    v_indent_id := COALESCE(NEW.indent_id, OLD.indent_id);
    UPDATE indents
    SET 
        total_items = (SELECT COUNT(*) FROM indent_items WHERE indent_id = v_indent_id),
        total_estimated_value = (SELECT COALESCE(SUM(estimated_total), 0) FROM indent_items WHERE indent_id = v_indent_id),
        updated_at = CURRENT_TIMESTAMP
    WHERE id = v_indent_id;
    RETURN COALESCE(NEW, OLD);
END;
$$;


ALTER FUNCTION "public"."recalculate_indent_totals"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."recalculate_po_totals"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public'
    AS $$
DECLARE
    v_po_id UUID;
BEGIN
    v_po_id := COALESCE(NEW.purchase_order_id, OLD.purchase_order_id);
    UPDATE purchase_orders
    SET 
        subtotal = (SELECT COALESCE(SUM(line_total - tax_amount), 0) FROM purchase_order_items WHERE purchase_order_id = v_po_id),
        tax_amount = (SELECT COALESCE(SUM(tax_amount), 0) FROM purchase_order_items WHERE purchase_order_id = v_po_id),
        grand_total = (SELECT COALESCE(SUM(line_total), 0) FROM purchase_order_items WHERE purchase_order_id = v_po_id) + shipping_cost - discount_amount,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = v_po_id;
    RETURN COALESCE(NEW, OLD);
END;
$$;


ALTER FUNCTION "public"."recalculate_po_totals"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."record_guard_gps_tracking"("p_guard_id" "uuid", "p_latitude" numeric, "p_longitude" numeric, "p_accuracy_meters" integer DEFAULT NULL::integer, "p_is_within_fence" boolean DEFAULT true, "p_shift_id" "uuid" DEFAULT NULL::"uuid") RETURNS "uuid"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
  v_tracking_id UUID;
BEGIN
  INSERT INTO guard_gps_tracking (
    guard_id,
    latitude,
    longitude,
    accuracy_meters,
    is_within_fence,
    shift_id
  ) VALUES (
    p_guard_id,
    p_latitude,
    p_longitude,
    p_accuracy_meters,
    p_is_within_fence,
    p_shift_id
  )
  RETURNING id INTO v_tracking_id;
  
  RETURN v_tracking_id;
END;
$$;


ALTER FUNCTION "public"."record_guard_gps_tracking"("p_guard_id" "uuid", "p_latitude" numeric, "p_longitude" numeric, "p_accuracy_meters" integer, "p_is_within_fence" boolean, "p_shift_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."reject_leave_request"("p_leave_id" "uuid", "p_approver_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE v_emp UUID;
BEGIN
  SELECT employee_id INTO v_emp FROM users WHERE id = p_approver_id;
  UPDATE leave_applications
  SET status = 'rejected', approved_by = v_emp, approved_at = NOW(), updated_at = NOW()
  WHERE id = p_leave_id AND status = 'pending';
END;
$$;


ALTER FUNCTION "public"."reject_leave_request"("p_leave_id" "uuid", "p_approver_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."reject_md_item"("p_item_id" "uuid", "p_approver_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
  UPDATE purchase_orders
  SET md_action = 'rejected', md_approved_at = NOW(), md_approved_by = p_approver_id, updated_at = NOW()
  WHERE id = p_item_id AND status = 'acknowledged' AND md_action IS NULL;
END;
$$;


ALTER FUNCTION "public"."reject_md_item"("p_item_id" "uuid", "p_approver_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."reopen_guard_checklist"("p_guard_id" "uuid", "p_reason" "text", "p_checklist_id" "uuid" DEFAULT NULL::"uuid") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_response RECORD;
  v_reopened_count INTEGER := 0;
BEGIN
  IF auth.uid() IS NULL OR NOT (
    has_role('security_supervisor')
    OR has_role('society_manager')
    OR has_role('admin')
    OR has_role('super_admin')
  ) THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Only oversight users can reopen submitted checklists');
  END IF;

  IF p_guard_id IS NULL THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Guard ID is required');
  END IF;

  IF COALESCE(BTRIM(p_reason), '') = '' THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Override reason is required');
  END IF;

  FOR v_response IN
    UPDATE public.checklist_responses cr
    SET
      override_status = 'approved',
      override_reason = BTRIM(p_reason),
      overridden_by = auth.uid(),
      overridden_at = NOW()
    FROM public.security_guards sg
    WHERE sg.id = p_guard_id
      AND cr.employee_id = sg.employee_id
      AND cr.response_date = CURRENT_DATE
      AND (p_checklist_id IS NULL OR cr.checklist_id = p_checklist_id)
    RETURNING cr.id, cr.checklist_id, cr.employee_id
  LOOP
    INSERT INTO public.checklist_response_override_audit (
      response_id,
      checklist_id,
      employee_id,
      guard_id,
      status,
      reason,
      acted_by
    )
    VALUES (
      v_response.id,
      v_response.checklist_id,
      v_response.employee_id,
      p_guard_id,
      'approved',
      BTRIM(p_reason),
      auth.uid()
    );

    v_reopened_count := v_reopened_count + 1;
  END LOOP;

  IF v_reopened_count = 0 THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'No submitted checklist was found for this guard today');
  END IF;

  RETURN JSONB_BUILD_OBJECT(
    'success', TRUE,
    'guard_id', p_guard_id,
    'reopened_count', v_reopened_count
  );
END;
$$;


ALTER FUNCTION "public"."reopen_guard_checklist"("p_guard_id" "uuid", "p_reason" "text", "p_checklist_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."resolve_mobile_panic_alert"("p_alert_id" "uuid", "p_notes" "text" DEFAULT NULL::"text") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_guard_user_id UUID;
  v_resolver_employee_id UUID;
BEGIN
  IF auth.uid() IS NULL OR NOT (
    has_role('security_supervisor')
    OR has_role('society_manager')
    OR has_role('admin')
    OR has_role('super_admin')
  ) THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Only oversight users can resolve alerts');
  END IF;

  v_resolver_employee_id := get_employee_id();

  IF v_resolver_employee_id IS NULL THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Resolver employee profile is missing');
  END IF;

  UPDATE public.panic_alerts
  SET
    is_resolved = TRUE,
    resolved_at = NOW(),
    resolved_by = v_resolver_employee_id,
    resolution_notes = NULLIF(p_notes, ''),
    streaming_active = FALSE
  WHERE id = p_alert_id
    AND is_resolved = FALSE;

  IF NOT FOUND THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Alert not found or already resolved');
  END IF;

  SELECT e.auth_user_id
  INTO v_guard_user_id
  FROM public.panic_alerts pa
  JOIN public.security_guards sg ON sg.id = pa.guard_id
  JOIN public.employees e ON e.id = sg.employee_id
  WHERE pa.id = p_alert_id
  LIMIT 1;

  IF v_guard_user_id IS NOT NULL THEN
    PERFORM public.mobile_insert_notification(
      v_guard_user_id,
      'SOS resolved',
      'Your panic alert has been resolved by the control room.',
      'panic_resolved',
      'high',
      '/guard/home',
      JSONB_BUILD_OBJECT('alert_id', p_alert_id),
      'push_queued',
      'queued',
      NOW() + INTERVAL '60 seconds'
    );
  END IF;

  RETURN JSONB_BUILD_OBJECT('success', TRUE, 'alert_id', p_alert_id);
END;
$$;


ALTER FUNCTION "public"."resolve_mobile_panic_alert"("p_alert_id" "uuid", "p_notes" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."resolve_panic_alert"("p_alert_id" "uuid", "p_resolved_by" "uuid", "p_resolution_notes" "text" DEFAULT NULL::"text") RETURNS boolean
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
  UPDATE guard_panic_alerts
  SET
    status = 'resolved',
    resolved_at = NOW(),
    resolved_by = p_resolved_by,
    resolution_notes = p_resolution_notes
  WHERE id = p_alert_id;
  
  RETURN true;
END;
$$;


ALTER FUNCTION "public"."resolve_panic_alert"("p_alert_id" "uuid", "p_resolved_by" "uuid", "p_resolution_notes" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."search_resident_destinations"("p_search" "text" DEFAULT ''::"text") RETURNS TABLE("flat_id" "uuid", "flat_label" "text", "resident_id" "uuid", "resident_name" "text", "resident_phone" "text")
    LANGUAGE "sql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
  WITH matched AS (
    SELECT
      f.id AS flat_id,
      TRIM(
        COALESCE(b.building_name || ' - ', '')
        || f.flat_number
      ) AS flat_label,
      r.id AS resident_id,
      r.full_name AS resident_name,
      COALESCE(r.phone, r.alternate_phone) AS resident_phone,
      ROW_NUMBER() OVER (
        PARTITION BY f.id
        ORDER BY r.is_primary_contact DESC, r.created_at
      ) AS resident_rank
    FROM public.flats f
    LEFT JOIN public.buildings b ON b.id = f.building_id
    LEFT JOIN public.residents r
      ON r.flat_id = f.id
     AND r.is_active = TRUE
    WHERE
      p_search = ''
      OR f.flat_number ILIKE '%' || p_search || '%'
      OR COALESCE(b.building_name, '') ILIKE '%' || p_search || '%'
      OR COALESCE(r.full_name, '') ILIKE '%' || p_search || '%'
      OR COALESCE(r.phone, '') ILIKE '%' || p_search || '%'
  )
  SELECT
    matched.flat_id,
    matched.flat_label,
    matched.resident_id,
    matched.resident_name,
    matched.resident_phone
  FROM matched
  WHERE matched.resident_rank = 1
  ORDER BY matched.flat_label
  LIMIT 25;
$$;


ALTER FUNCTION "public"."search_resident_destinations"("p_search" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."search_residents"("p_query" "text", "p_society_id" "uuid" DEFAULT NULL::"uuid") RETURNS TABLE("id" "uuid", "full_name" "text", "flat_number" "text", "profile_photo_url" "text", "masked_phone" "text", "is_owner" boolean, "move_in_date" timestamp with time zone)
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    r.id,
    (r.first_name || ' ' || r.last_name) as full_name,
    f.flat_number,
    r.profile_photo_url,
    -- Mask phone: *****6789
    CASE 
      WHEN length(r.phone_number) >= 10 THEN
        repeat('*', 6) || substring(r.phone_number from length(r.phone_number)-3)
      ELSE
        '*****'
    END as masked_phone,
    r.is_owner,
    r.move_in_date
  FROM residents r
  JOIN flats f ON r.flat_id = f.id
  WHERE 
    (p_society_id IS NULL OR f.society_id = p_society_id)
    AND (
      r.first_name ILIKE '%' || p_query || '%' OR
      r.last_name ILIKE '%' || p_query || '%' OR
      f.flat_number ILIKE '%' || p_query || '%'
    )
    AND r.status = 'active'
  LIMIT 50;
END;
$$;


ALTER FUNCTION "public"."search_residents"("p_query" "text", "p_society_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."send_custom_sms"("p_phone_number" "text", "p_message" "text") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_service_key TEXT;
BEGIN
  v_service_key := current_setting('app.settings.service_role_key', true);

  IF v_service_key IS NULL OR v_service_key = '' THEN
    RETURN jsonb_build_object('success', false, 'error', 'app.settings.service_role_key not configured');
  END IF;

  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'Authentication required';
  END IF;

  IF COALESCE(btrim(p_phone_number), '') = '' THEN
    RAISE EXCEPTION 'Phone number is required';
  END IF;

  IF COALESCE(btrim(p_message), '') = '' THEN
    RAISE EXCEPTION 'Message is required';
  END IF;

  PERFORM net.http_post(
    url     := 'https://wwhbdgwfodumognpkgrf.supabase.co/functions/v1/send-notification',
    headers := jsonb_build_object(
      'Content-Type',  'application/json',
      'Authorization', 'Bearer ' || v_service_key
    ),
    body    := jsonb_build_object(
      'mobile',  p_phone_number,
      'title',   'FacilityPro Alert',
      'body',    p_message,
      'channel', 'sms'
    )::TEXT
  );

  RETURN jsonb_build_object('success', true);
EXCEPTION WHEN OTHERS THEN
  RETURN jsonb_build_object('success', false, 'error', SQLERRM);
END;
$$;


ALTER FUNCTION "public"."send_custom_sms"("p_phone_number" "text", "p_message" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."send_panic_alert_sms"("p_alert_type" "text", "p_guard_name" "text", "p_guard_phone" "text" DEFAULT NULL::"text", "p_latitude" numeric DEFAULT NULL::numeric, "p_longitude" numeric DEFAULT NULL::numeric, "p_manager_phone" "text" DEFAULT NULL::"text") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_location_msg TEXT;
  v_title        TEXT;
  v_body_text    TEXT;
  v_manager      RECORD;
  v_service_key  TEXT;
BEGIN
  v_service_key := current_setting('app.settings.service_role_key', true);

  IF v_service_key IS NULL OR v_service_key = '' THEN
    RETURN jsonb_build_object('success', false, 'error', 'app.settings.service_role_key not configured');
  END IF;

  IF p_latitude IS NOT NULL AND p_longitude IS NOT NULL THEN
    v_location_msg := format('Location: %s, %s', round(p_latitude::NUMERIC, 5), round(p_longitude::NUMERIC, 5));
  ELSE
    v_location_msg := 'Location unavailable';
  END IF;

  v_title     := format('PANIC ALERT: %s', upper(p_alert_type));
  v_body_text := format('Guard %s triggered a %s alert. %s', p_guard_name, p_alert_type, v_location_msg);

  IF p_manager_phone IS NOT NULL AND p_manager_phone <> '' THEN
    PERFORM net.http_post(
      url     := 'https://wwhbdgwfodumognpkgrf.supabase.co/functions/v1/send-notification',
      headers := jsonb_build_object(
        'Content-Type',  'application/json',
        'Authorization', 'Bearer ' || v_service_key
      ),
      body    := jsonb_build_object(
        'mobile',  p_manager_phone,
        'title',   v_title,
        'body',    v_body_text,
        'channel', 'sms'
      )::TEXT
    );
  END IF;

  FOR v_manager IN
    SELECT u.id
    FROM   users u
    JOIN   roles r ON u.role_id = r.id
    WHERE  r.role_name IN ('admin', 'company_md', 'company_hod')
  LOOP
    PERFORM net.http_post(
      url     := 'https://wwhbdgwfodumognpkgrf.supabase.co/functions/v1/send-notification',
      headers := jsonb_build_object(
        'Content-Type',  'application/json',
        'Authorization', 'Bearer ' || v_service_key
      ),
      body    := jsonb_build_object(
        'user_id', v_manager.id::TEXT,
        'title',   v_title,
        'body',    v_body_text,
        'channel', 'fcm',
        'data',    jsonb_build_object(
          'alert_type',  p_alert_type,
          'guard_name',  p_guard_name,
          'latitude',    COALESCE(p_latitude::TEXT, ''),
          'longitude',   COALESCE(p_longitude::TEXT, '')
        )
      )::TEXT
    );
  END LOOP;

  RETURN jsonb_build_object('success', true);
EXCEPTION WHEN OTHERS THEN
  RETURN jsonb_build_object('success', false, 'error', SQLERRM);
END;
$$;


ALTER FUNCTION "public"."send_panic_alert_sms"("p_alert_type" "text", "p_guard_name" "text", "p_guard_phone" "text", "p_latitude" numeric, "p_longitude" numeric, "p_manager_phone" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."send_push_notification_to_manager"("p_alert_type" "text", "p_guard_name" "text", "p_latitude" numeric DEFAULT NULL::numeric, "p_longitude" numeric DEFAULT NULL::numeric) RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_location_msg TEXT;
  v_title        TEXT;
  v_body_text    TEXT;
  v_manager      RECORD;
  v_service_key  TEXT;
BEGIN
  v_service_key := current_setting('app.settings.service_role_key', true);

  IF v_service_key IS NULL OR v_service_key = '' THEN
    RETURN jsonb_build_object('success', false, 'error', 'app.settings.service_role_key not configured');
  END IF;

  IF p_latitude IS NOT NULL AND p_longitude IS NOT NULL THEN
    v_location_msg := format('Location: %s, %s', round(p_latitude::NUMERIC, 5), round(p_longitude::NUMERIC, 5));
  ELSE
    v_location_msg := 'Location unavailable';
  END IF;

  v_title     := format('ALERT: %s', upper(p_alert_type));
  v_body_text := format('Guard %s — %s. %s', p_guard_name, p_alert_type, v_location_msg);

  FOR v_manager IN
    SELECT u.id
    FROM   users u
    JOIN   roles r ON u.role_id = r.id
    WHERE  r.role_name IN ('admin', 'company_md', 'company_hod')
  LOOP
    PERFORM net.http_post(
      url     := 'https://wwhbdgwfodumognpkgrf.supabase.co/functions/v1/send-notification',
      headers := jsonb_build_object(
        'Content-Type',  'application/json',
        'Authorization', 'Bearer ' || v_service_key
      ),
      body    := jsonb_build_object(
        'user_id', v_manager.id::TEXT,
        'title',   v_title,
        'body',    v_body_text,
        'channel', 'fcm',
        'data',    jsonb_build_object(
          'alert_type', p_alert_type,
          'guard_name', p_guard_name,
          'latitude',   COALESCE(p_latitude::TEXT, ''),
          'longitude',  COALESCE(p_longitude::TEXT, '')
        )
      )::TEXT
    );
  END LOOP;

  RETURN jsonb_build_object('success', true);
EXCEPTION WHEN OTHERS THEN
  RETURN jsonb_build_object('success', false, 'error', SQLERRM);
END;
$$;


ALTER FUNCTION "public"."send_push_notification_to_manager"("p_alert_type" "text", "p_guard_name" "text", "p_latitude" numeric, "p_longitude" numeric) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."service_request_can_bridge_to_bill_generated"("p_request_id" "uuid") RETURNS boolean
    LANGUAGE "sql" STABLE
    SET "search_path" TO 'public'
    AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.service_purchase_orders spo
    JOIN public.service_acknowledgments ack
      ON ack.spo_id = spo.id
     AND ack.status = 'acknowledged'
    WHERE spo.request_id = p_request_id
      AND spo.status IN ('deployment_confirmed', 'completed')
      AND EXISTS (
        SELECT 1
        FROM public.service_delivery_notes note
        WHERE note.po_id = spo.id
          AND note.status IN ('pending', 'verified')
      )
  );
$$;


ALTER FUNCTION "public"."service_request_can_bridge_to_bill_generated"("p_request_id" "uuid") OWNER TO "postgres";


COMMENT ON FUNCTION "public"."service_request_can_bridge_to_bill_generated"("p_request_id" "uuid") IS 'Allows service requests to bridge from po_issued to bill_generated once deployment evidence lives in the service tables.';



CREATE OR REPLACE FUNCTION "public"."set_resident_frequent_visitor"("p_visitor_id" "uuid", "p_is_frequent" boolean) RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_flat_id UUID;
BEGIN
  IF auth.uid() IS NULL OR NOT is_resident() THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Only residents can manage frequent visitors');
  END IF;

  SELECT flat_id
  INTO v_flat_id
  FROM public.residents
  WHERE auth_user_id = auth.uid()
  LIMIT 1;

  UPDATE public.visitors
  SET is_frequent_visitor = p_is_frequent
  WHERE id = p_visitor_id
    AND flat_id = v_flat_id;

  IF NOT FOUND THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Visitor not found for this resident');
  END IF;

  RETURN JSONB_BUILD_OBJECT('success', TRUE, 'visitor_id', p_visitor_id, 'is_frequent', p_is_frequent);
END;
$$;


ALTER FUNCTION "public"."set_resident_frequent_visitor"("p_visitor_id" "uuid", "p_is_frequent" boolean) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."stamp_server_time"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public'
    AS $$
BEGIN
    NEW.created_at = now();
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."stamp_server_time"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."start_mobile_panic_alert"("p_alert_type" "text" DEFAULT 'panic'::"text", "p_latitude" numeric DEFAULT NULL::numeric, "p_longitude" numeric DEFAULT NULL::numeric, "p_photo_url" "text" DEFAULT NULL::"text", "p_description" "text" DEFAULT NULL::"text", "p_metadata" "jsonb" DEFAULT '{}'::"jsonb") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_guard_id UUID;
  v_location_id UUID;
  v_alert_id UUID;
  v_alert_type alert_type;
  v_recipient RECORD;
  v_guard_name TEXT;
  v_notified_count INTEGER := 0;
  v_alert_label TEXT;
BEGIN
  IF auth.uid() IS NULL OR NOT is_guard() THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Only authenticated guards can raise alerts');
  END IF;

  SELECT
    sg.id,
    sg.assigned_location_id,
    TRIM(COALESCE(e.first_name, '') || ' ' || COALESCE(e.last_name, ''))
  INTO
    v_guard_id,
    v_location_id,
    v_guard_name
  FROM public.security_guards sg
  JOIN public.employees e ON e.id = sg.employee_id
  WHERE e.auth_user_id = auth.uid()
  LIMIT 1;

  IF v_guard_id IS NULL THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Guard profile not found');
  END IF;

  v_alert_type := CASE
    WHEN COALESCE(LOWER(p_alert_type), 'panic') = 'inactivity' THEN 'inactivity'
    WHEN COALESCE(LOWER(p_alert_type), 'panic') = 'geo_fence_breach' THEN 'geo_fence_breach'
    ELSE 'panic'
  END;

  v_alert_label := CASE v_alert_type
    WHEN 'geo_fence_breach' THEN 'Geo-fence Breach'
    WHEN 'inactivity' THEN 'Inactivity Alert'
    ELSE 'SOS / Panic Alert'
  END;

  INSERT INTO public.panic_alerts (
    guard_id,
    alert_type,
    location_id,
    latitude,
    longitude,
    description,
    photo_url,
    streaming_active,
    metadata
  )
  VALUES (
    v_guard_id,
    v_alert_type,
    v_location_id,
    p_latitude,
    p_longitude,
    NULLIF(p_description, ''),
    NULLIF(p_photo_url, ''),
    TRUE,
    COALESCE(p_metadata, '{}'::JSONB)
  )
  RETURNING id INTO v_alert_id;

  FOR v_recipient IN
    SELECT u.id
    FROM public.users u
    JOIN public.roles r ON r.id = u.role_id
    WHERE
      u.is_active = TRUE
      AND r.role_name::TEXT IN ('security_supervisor', 'society_manager', 'admin', 'super_admin')
  LOOP
    PERFORM public.mobile_insert_notification(
      v_recipient.id,
      v_alert_label,
      COALESCE(NULLIF(v_guard_name, ''), 'A guard') || ' triggered a ' || REPLACE(v_alert_type::TEXT, '_', ' ') || ' alert with live location.',
      'panic',
      'critical',
      '/society/panic-alerts',
      JSONB_BUILD_OBJECT(
        'alert_id', v_alert_id,
        'guard_id', v_guard_id,
        'alert_type', v_alert_type::TEXT
      ),
      'push_queued',
      'queued',
      CASE
        WHEN v_alert_type::TEXT = 'panic' THEN NOW()
        ELSE NOW() + INTERVAL '60 seconds'
      END
    );
    v_notified_count := v_notified_count + 1;
  END LOOP;

  RETURN JSONB_BUILD_OBJECT(
    'success', TRUE,
    'alert_id', v_alert_id,
    'guard_id', v_guard_id,
    'notified_count', v_notified_count
  );
END;
$$;


ALTER FUNCTION "public"."start_mobile_panic_alert"("p_alert_type" "text", "p_latitude" numeric, "p_longitude" numeric, "p_photo_url" "text", "p_description" "text", "p_metadata" "jsonb") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."start_service_task"("p_request_id" "uuid", "p_before_photo_url" "text" DEFAULT NULL::"text") RETURNS boolean
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_request public.service_requests%ROWTYPE;
  v_session_id UUID;
  v_before_photo_url TEXT := NULLIF(p_before_photo_url, '');
BEGIN
  SELECT *
  INTO v_request
  FROM public.service_requests
  WHERE id = p_request_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Service request % not found', p_request_id;
  END IF;

  IF v_request.assigned_to IS NULL THEN
    RAISE EXCEPTION 'Service request must be assigned before it can be started';
  END IF;

  UPDATE public.service_requests
  SET
    status = 'in_progress',
    started_at = COALESCE(started_at, NOW()),
    before_photo_url = COALESCE(v_before_photo_url, before_photo_url),
    updated_at = NOW()
  WHERE id = p_request_id;

  SELECT js.id
  INTO v_session_id
  FROM public.job_sessions js
  WHERE js.service_request_id = p_request_id
    AND js.status IN ('started', 'paused')
  ORDER BY js.created_at DESC
  LIMIT 1;

  IF v_session_id IS NULL THEN
    INSERT INTO public.job_sessions (
      service_request_id,
      technician_id,
      start_time,
      status
    )
    VALUES (
      p_request_id,
      v_request.assigned_to,
      COALESCE(v_request.started_at, NOW()),
      'started'
    )
    RETURNING id INTO v_session_id;
  ELSE
    UPDATE public.job_sessions
    SET
      status = 'started',
      start_time = COALESCE(start_time, COALESCE(v_request.started_at, NOW())),
      updated_at = NOW()
    WHERE id = v_session_id;
  END IF;

  IF v_before_photo_url IS NOT NULL THEN
    INSERT INTO public.job_photos (
      job_session_id,
      photo_type,
      photo_url,
      captured_at
    )
    SELECT
      v_session_id,
      'before',
      v_before_photo_url,
      NOW()
    WHERE NOT EXISTS (
      SELECT 1
      FROM public.job_photos jp
      WHERE jp.job_session_id = v_session_id
        AND jp.photo_type = 'before'
        AND jp.photo_url = v_before_photo_url
    );
  END IF;

  RETURN TRUE;
END;
$$;


ALTER FUNCTION "public"."start_service_task"("p_request_id" "uuid", "p_before_photo_url" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."submit_mobile_guard_checklist"("p_checklist_id" "uuid", "p_responses" "jsonb", "p_is_complete" boolean DEFAULT true) RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_employee_id UUID;
  v_guard_id UUID;
  v_response_id UUID;
  v_existing_response public.checklist_responses%ROWTYPE;
  v_now TIMESTAMPTZ := NOW();
BEGIN
  IF auth.uid() IS NULL OR NOT is_guard() THEN
    RETURN JSONB_BUILD_OBJECT(
      'success', FALSE,
      'error', 'Only authenticated guards can submit checklists'
    );
  END IF;

  IF p_checklist_id IS NULL THEN
    RETURN JSONB_BUILD_OBJECT(
      'success', FALSE,
      'error', 'Checklist ID is required'
    );
  END IF;

  IF JSONB_TYPEOF(COALESCE(p_responses, '[]'::JSONB)) IS DISTINCT FROM 'array' THEN
    RETURN JSONB_BUILD_OBJECT(
      'success', FALSE,
      'error', 'Checklist responses must be a JSON array'
    );
  END IF;

  v_employee_id := get_employee_id();
  v_guard_id := get_guard_id();

  IF v_employee_id IS NULL THEN
    RETURN JSONB_BUILD_OBJECT(
      'success', FALSE,
      'error', 'Guard profile is not fully configured'
    );
  END IF;

  SELECT *
  INTO v_existing_response
  FROM public.checklist_responses cr
  WHERE cr.employee_id = v_employee_id
    AND cr.checklist_id = p_checklist_id
    AND cr.response_date = CURRENT_DATE
  LIMIT 1;

  IF FOUND AND COALESCE(v_existing_response.override_status, 'none') NOT IN ('approved', 'none') THEN
    RETURN JSONB_BUILD_OBJECT(
      'success', FALSE,
      'error', 'Checklist is locked and requires a fresh supervisor override before resubmission'
    );
  END IF;

  IF FOUND AND COALESCE(v_existing_response.override_status, 'none') = 'none' THEN
    RETURN JSONB_BUILD_OBJECT(
      'success', FALSE,
      'error', 'Checklist is already locked for today. Ask a supervisor to reopen it first.'
    );
  END IF;

  INSERT INTO public.checklist_responses (
    employee_id,
    checklist_id,
    response_date,
    submitted_at,
    responses,
    is_complete,
    override_status
  )
  VALUES (
    v_employee_id,
    p_checklist_id,
    CURRENT_DATE,
    v_now,
    COALESCE(p_responses, '[]'::JSONB),
    COALESCE(p_is_complete, TRUE),
    'none'
  )
  ON CONFLICT (checklist_id, employee_id, response_date)
  DO UPDATE SET
    submitted_at = EXCLUDED.submitted_at,
    responses = EXCLUDED.responses,
    is_complete = EXCLUDED.is_complete,
    override_status = CASE
      WHEN public.checklist_responses.override_status = 'approved' THEN 'resubmitted'
      ELSE public.checklist_responses.override_status
    END
  RETURNING id INTO v_response_id;

  IF FOUND AND COALESCE(v_existing_response.override_status, 'none') = 'approved' THEN
    INSERT INTO public.checklist_response_override_audit (
      response_id,
      checklist_id,
      employee_id,
      guard_id,
      status,
      reason,
      acted_by
    )
    VALUES (
      v_response_id,
      p_checklist_id,
      v_employee_id,
      v_guard_id,
      'resubmitted',
      v_existing_response.override_reason,
      auth.uid()
    );
  END IF;

  RETURN JSONB_BUILD_OBJECT(
    'success', TRUE,
    'response_id', v_response_id,
    'submitted_at', v_now
  );
END;
$$;


ALTER FUNCTION "public"."submit_mobile_guard_checklist"("p_checklist_id" "uuid", "p_responses" "jsonb", "p_is_complete" boolean) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."supplier_transition_service_po_status"("p_spo_id" "uuid", "p_new_status" "text", "p_headcount_expected" integer DEFAULT NULL::integer, "p_grade_verified" boolean DEFAULT NULL::boolean, "p_notes" "text" DEFAULT NULL::"text") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_spo public.service_purchase_orders%ROWTYPE;
  v_supplier_id UUID;
  v_total_headcount INTEGER := 0;
  v_notes TEXT := NULLIF(BTRIM(p_notes), '');
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'Authentication required';
  END IF;

  SELECT supplier_id
  INTO v_supplier_id
  FROM public.users
  WHERE id = auth.uid();

  IF v_supplier_id IS NULL THEN
    RAISE EXCEPTION 'Authenticated user is not linked to a supplier';
  END IF;

  SELECT *
  INTO v_spo
  FROM public.service_purchase_orders
  WHERE id = p_spo_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Service purchase order not found';
  END IF;

  IF v_spo.vendor_id IS DISTINCT FROM v_supplier_id THEN
    RAISE EXCEPTION 'Only the assigned supplier can transition this service purchase order';
  END IF;

  IF p_new_status NOT IN ('acknowledged', 'delivery_note_uploaded', 'completed', 'cancelled') THEN
    RAISE EXCEPTION 'Unsupported service purchase order transition: %', p_new_status;
  END IF;

  IF p_new_status = 'acknowledged' AND v_spo.status <> 'sent_to_vendor' THEN
    RAISE EXCEPTION 'Only sent service purchase orders can be acknowledged';
  END IF;

  IF p_new_status = 'delivery_note_uploaded'
     AND v_spo.status NOT IN ('acknowledged', 'in_progress', 'delivery_note_uploaded') THEN
    RAISE EXCEPTION 'Delivery note upload requires an acknowledged service purchase order';
  END IF;

  IF v_spo.status = p_new_status THEN
    RETURN jsonb_build_object(
      'success', true,
      'changed', false,
      'service_purchase_order_id', v_spo.id,
      'status', v_spo.status
    );
  END IF;

  UPDATE public.service_purchase_orders
  SET
    status = p_new_status,
    updated_at = NOW()
  WHERE id = p_spo_id;

  IF p_new_status = 'acknowledged' THEN
    IF p_headcount_expected IS NULL THEN
      SELECT COALESCE(SUM(quantity), 0)
      INTO v_total_headcount
      FROM public.service_purchase_order_items
      WHERE spo_id = p_spo_id;
    ELSE
      v_total_headcount := p_headcount_expected;
    END IF;

    UPDATE public.service_acknowledgments
    SET
      acknowledged_by = auth.uid(),
      headcount_expected = v_total_headcount,
      grade_verified = COALESCE(p_grade_verified, grade_verified),
      notes = COALESCE(v_notes, notes),
      status = 'acknowledged',
      acknowledged_at = COALESCE(acknowledged_at, NOW()),
      updated_at = NOW()
    WHERE spo_id = p_spo_id;

    IF NOT FOUND THEN
      INSERT INTO public.service_acknowledgments (
        spo_id,
        acknowledged_by,
        headcount_expected,
        headcount_received,
        grade_verified,
        notes,
        status,
        acknowledged_at,
        created_at,
        updated_at
      )
      VALUES (
        p_spo_id,
        auth.uid(),
        v_total_headcount,
        0,
        p_grade_verified,
        v_notes,
        'acknowledged',
        NOW(),
        NOW(),
        NOW()
      );
    END IF;
  END IF;

  RETURN jsonb_build_object(
    'success', true,
    'changed', true,
    'service_purchase_order_id', p_spo_id,
    'status', p_new_status
  );
END;
$$;


ALTER FUNCTION "public"."supplier_transition_service_po_status"("p_spo_id" "uuid", "p_new_status" "text", "p_headcount_expected" integer, "p_grade_verified" boolean, "p_notes" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."sync_leave_application_attendance"("p_leave_application_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_leave RECORD;
  v_log_date DATE;
  v_note_marker TEXT;
  v_attendance_status TEXT;
BEGIN
  SELECT
    la.id,
    la.employee_id,
    la.from_date,
    la.to_date,
    la.status,
    lt.leave_type::TEXT AS leave_type
  INTO v_leave
  FROM public.leave_applications la
  LEFT JOIN public.leave_types lt
    ON lt.id = la.leave_type_id
  WHERE la.id = p_leave_application_id;

  v_note_marker := format('Synced from leave application %s', p_leave_application_id);

  DELETE FROM public.attendance_logs
  WHERE notes = v_note_marker;

  IF v_leave.id IS NULL THEN
    RETURN;
  END IF;

  IF v_leave.status <> 'approved' THEN
    RETURN;
  END IF;

  v_attendance_status := public.map_leave_type_to_attendance_status(v_leave.leave_type);

  FOR v_log_date IN
    SELECT generate_series(v_leave.from_date, v_leave.to_date, INTERVAL '1 day')::DATE
  LOOP
    UPDATE public.attendance_logs
    SET
      check_in_time = NULL,
      check_out_time = NULL,
      check_in_location_id = NULL,
      check_out_location_id = NULL,
      check_in_latitude = NULL,
      check_in_longitude = NULL,
      check_out_latitude = NULL,
      check_out_longitude = NULL,
      check_in_selfie_url = NULL,
      total_hours = 0,
      overtime_hours = 0,
      is_auto_punch_out = FALSE,
      status = v_attendance_status,
      notes = v_note_marker,
      updated_at = NOW()
    WHERE employee_id = v_leave.employee_id
      AND log_date = v_log_date
      AND check_in_time IS NULL
      AND check_out_time IS NULL;

    IF NOT FOUND THEN
      IF NOT EXISTS (
        SELECT 1
        FROM public.attendance_logs al
        WHERE al.employee_id = v_leave.employee_id
          AND al.log_date = v_log_date
          AND (al.check_in_time IS NOT NULL OR al.check_out_time IS NOT NULL)
      ) THEN
        INSERT INTO public.attendance_logs (
          id,
          employee_id,
          log_date,
          total_hours,
          overtime_hours,
          status,
          is_auto_punch_out,
          notes
        )
        VALUES (
          gen_random_uuid(),
          v_leave.employee_id,
          v_log_date,
          0,
          0,
          v_attendance_status,
          FALSE,
          v_note_marker
        );
      END IF;
    END IF;
  END LOOP;
END;
$$;


ALTER FUNCTION "public"."sync_leave_application_attendance"("p_leave_application_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."sync_purchase_bill_match_status_from_reconciliation"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_match_status TEXT;
  v_reconciled_at TIMESTAMPTZ;
  v_reconciled_by UUID;
BEGIN
  IF NEW.purchase_bill_id IS NULL THEN
    RETURN NEW;
  END IF;

  IF NEW.status = 'matched' THEN
    v_match_status := 'matched';
    v_reconciled_at := COALESCE(NEW.updated_at, NEW.created_at, NOW());
    v_reconciled_by := COALESCE(NEW.updated_by, NEW.created_by);
  ELSIF NEW.status = 'resolved' THEN
    v_match_status := 'force_matched';
    v_reconciled_at := COALESCE(NEW.resolved_at, NEW.updated_at, NEW.created_at, NOW());
    v_reconciled_by := COALESCE(NEW.resolved_by, NEW.updated_by, NEW.created_by);
  ELSE
    RETURN NEW;
  END IF;

  UPDATE public.purchase_bills
  SET
    is_reconciled = TRUE,
    reconciled_at = COALESCE(v_reconciled_at, reconciled_at, NOW()),
    reconciled_by = COALESCE(v_reconciled_by, reconciled_by),
    match_status = v_match_status
  WHERE id = NEW.purchase_bill_id;

  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."sync_purchase_bill_match_status_from_reconciliation"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."sync_request_status_from_purchase_bill"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_request_id UUID;
  v_current_status TEXT;
  v_target_status public.request_status;
BEGIN
  IF NEW.purchase_order_id IS NOT NULL THEN
    SELECT r.id, r.status::TEXT
    INTO v_request_id, v_current_status
    FROM public.requests r
    JOIN public.indents i ON i.id = r.indent_id
    JOIN public.purchase_orders po ON po.indent_id = i.id
    WHERE po.id = NEW.purchase_order_id
    LIMIT 1;
  ELSIF NEW.service_purchase_order_id IS NOT NULL THEN
    SELECT r.id, r.status::TEXT
    INTO v_request_id, v_current_status
    FROM public.service_purchase_orders spo
    JOIN public.requests r ON r.id = spo.request_id
    WHERE spo.id = NEW.service_purchase_order_id
    LIMIT 1;
  END IF;

  IF v_request_id IS NULL THEN
    RETURN NEW;
  END IF;

  IF NEW.payment_status = 'paid' THEN
    v_target_status := 'paid';
  ELSIF COALESCE(NEW.status, '') NOT IN ('draft', 'cancelled', 'rejected') THEN
    v_target_status := 'bill_generated';
  ELSE
    RETURN NEW;
  END IF;

  IF v_target_status = 'bill_generated'
     AND v_current_status IN ('bill_generated', 'paid', 'feedback_pending', 'completed') THEN
    RETURN NEW;
  END IF;

  IF v_target_status = 'paid'
     AND v_current_status IN ('paid', 'feedback_pending', 'completed') THEN
    RETURN NEW;
  END IF;

  UPDATE public.requests
  SET
    status = v_target_status,
    updated_at = NOW()
  WHERE id = v_request_id;

  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."sync_request_status_from_purchase_bill"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."transition_po_status"("p_po_id" "uuid", "p_new_status" "text", "p_user_id" "uuid" DEFAULT NULL::"uuid", "p_vehicle_details" "text" DEFAULT NULL::"text", "p_dispatch_notes" "text" DEFAULT NULL::"text", "p_dispatched_at" timestamp with time zone DEFAULT NULL::timestamp with time zone) RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_current_status TEXT;
  v_valid_transitions JSONB := '{
    "draft": ["sent_to_vendor", "cancelled"],
    "sent_to_vendor": ["acknowledged", "cancelled"],
    "acknowledged": ["dispatched", "partial_received", "received"],
    "dispatched": ["partial_received", "received"],
    "partial_received": ["received"],
    "received": [],
    "cancelled": []
  }'::JSONB;
  v_allowed JSONB;
  v_item_count INT;
BEGIN
  SELECT status::TEXT INTO v_current_status
  FROM purchase_orders
  WHERE id = p_po_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RETURN jsonb_build_object('success', false, 'error', 'Purchase order not found');
  END IF;

  v_allowed := v_valid_transitions -> v_current_status;

  IF v_allowed IS NULL OR NOT v_allowed ? p_new_status THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', format('Invalid status transition from "%s" to "%s"', v_current_status, p_new_status)
    );
  END IF;

  IF p_new_status = 'sent_to_vendor' THEN
    SELECT COUNT(*) INTO v_item_count
    FROM purchase_order_items
    WHERE purchase_order_id = p_po_id;

    IF v_item_count = 0 THEN
      RETURN jsonb_build_object('success', false, 'error', 'Cannot send PO to vendor without line items');
    END IF;
  END IF;

  UPDATE purchase_orders
  SET
    status = p_new_status::po_status,
    updated_at = NOW(),
    updated_by = p_user_id,
    sent_to_vendor_at = CASE WHEN p_new_status = 'sent_to_vendor' THEN NOW() ELSE sent_to_vendor_at END,
    vendor_acknowledged_at = CASE WHEN p_new_status = 'acknowledged' THEN NOW() ELSE vendor_acknowledged_at END,
    dispatched_at = CASE WHEN p_new_status = 'dispatched' THEN COALESCE(p_dispatched_at, NOW()) ELSE dispatched_at END,
    vehicle_details = CASE WHEN p_new_status = 'dispatched' THEN p_vehicle_details ELSE vehicle_details END,
    dispatch_notes = CASE WHEN p_new_status = 'dispatched' THEN p_dispatch_notes ELSE dispatch_notes END
  WHERE id = p_po_id;

  RETURN jsonb_build_object(
    'success', true,
    'previous_status', v_current_status,
    'new_status', p_new_status
  );
END;
$$;


ALTER FUNCTION "public"."transition_po_status"("p_po_id" "uuid", "p_new_status" "text", "p_user_id" "uuid", "p_vehicle_details" "text", "p_dispatch_notes" "text", "p_dispatched_at" timestamp with time zone) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."trg_cleanup_leave_application_attendance"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
  DELETE FROM public.attendance_logs
  WHERE employee_id = OLD.employee_id
    AND notes = format('Synced from leave application %s', OLD.id);

  RETURN OLD;
END;
$$;


ALTER FUNCTION "public"."trg_cleanup_leave_application_attendance"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."trg_sync_leave_application_attendance"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
  PERFORM public.sync_leave_application_attendance(NEW.id);
  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."trg_sync_leave_application_attendance"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."trigger_checklist_check"() RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE 
    v_response RECORD;
    v_anon_key TEXT;
BEGIN
    v_anon_key := current_setting('app.settings.jwt_anon_key', true);
    
    SELECT http.status, http.content::jsonb INTO v_response
    FROM http(('POST',
        'https://wwhbdgwfodumognpkgrf.supabase.co/functions/v1/check-incomplete-checklists',
        ARRAY[
            http_header('Authorization', 'Bearer ' || v_anon_key),
            http_header('Content-Type','application/json'),
            http_header('x-internal-api-key','CRON_SECURE_KEY_8823')
        ], 'application/json', '{"threshold":50,"only_past_midpoint":true}'
    )) AS http;
    RAISE NOTICE 'Checklist check: %', v_response;
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Failed: %', SQLERRM;
END;
$$;


ALTER FUNCTION "public"."trigger_checklist_check"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."trigger_daily_mobile_checklist_reminders"() RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_response RECORD;
  v_service_role_key TEXT;
BEGIN
  v_service_role_key := current_setting('app.settings.service_role_key', true);

  IF COALESCE(v_service_role_key, '') = '' THEN
    RAISE NOTICE 'checklist-reminders skipped because app.settings.service_role_key is not configured';
    RETURN;
  END IF;

  SELECT http.status, http.content::jsonb
  INTO v_response
  FROM http((
    'POST',
    'https://wwhbdgwfodumognpkgrf.supabase.co/functions/v1/checklist-reminders',
    ARRAY[
      http_header('Authorization', 'Bearer ' || v_service_role_key),
      http_header('Content-Type', 'application/json')
    ],
    'application/json',
    '{}'
  )) AS http;

  RAISE NOTICE 'checklist-reminders: %', v_response;
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'checklist-reminders failed: %', SQLERRM;
END;
$$;


ALTER FUNCTION "public"."trigger_daily_mobile_checklist_reminders"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."trigger_inactivity_check"() RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE 
    v_response RECORD;
    v_anon_key TEXT;
BEGIN
    v_anon_key := current_setting('app.settings.jwt_anon_key', true);
    
    SELECT http.status, http.content::jsonb INTO v_response
    FROM http(('POST',
        'https://wwhbdgwfodumognpkgrf.supabase.co/functions/v1/check-guard-inactivity',
        ARRAY[
            http_header('Authorization', 'Bearer ' || v_anon_key),
            http_header('Content-Type','application/json'),
            http_header('x-internal-api-key','CRON_SECURE_KEY_8823')
        ], 'application/json', '{}'
    )) AS http;
    RAISE NOTICE 'Inactivity check: %', v_response;
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Failed: %', SQLERRM;
END;
$$;


ALTER FUNCTION "public"."trigger_inactivity_check"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."trigger_mobile_notification_queue"() RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_response RECORD;
  v_service_role_key TEXT;
BEGIN
  v_service_role_key := current_setting('app.settings.service_role_key', true);

  IF COALESCE(v_service_role_key, '') = '' THEN
    RAISE NOTICE 'dispatch-notification-queue skipped because app.settings.service_role_key is not configured';
    RETURN;
  END IF;

  SELECT http.status, http.content::jsonb
  INTO v_response
  FROM http((
    'POST',
    'https://wwhbdgwfodumognpkgrf.supabase.co/functions/v1/dispatch-notification-queue',
    ARRAY[
      http_header('Authorization', 'Bearer ' || v_service_role_key),
      http_header('Content-Type', 'application/json')
    ],
    'application/json',
    '{}'
  )) AS http;

  RAISE NOTICE 'dispatch-notification-queue: %', v_response;
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'dispatch-notification-queue failed: %', SQLERRM;
END;
$$;


ALTER FUNCTION "public"."trigger_mobile_notification_queue"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."trigger_panic_alert"("p_guard_id" "uuid", "p_latitude" numeric, "p_longitude" numeric, "p_shift_id" "uuid" DEFAULT NULL::"uuid") RETURNS "uuid"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
  v_alert_id UUID;
BEGIN
  INSERT INTO guard_panic_alerts (
    guard_id,
    latitude,
    longitude,
    shift_id,
    status
  ) VALUES (
    p_guard_id,
    p_latitude,
    p_longitude,
    p_shift_id,
    'active'
  )
  RETURNING id INTO v_alert_id;
  
  -- Trigger notification via Edge Function (implemented in production)
  -- This RPC just records the alert; actual SMS/push notifications
  -- are handled by backend services
  
  RETURN v_alert_id;
END;
$$;


ALTER FUNCTION "public"."trigger_panic_alert"("p_guard_id" "uuid", "p_latitude" numeric, "p_longitude" numeric, "p_shift_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."trigger_shift_end_checklist_reminder"() RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
    v_response RECORD;
    v_service_role_key TEXT;
BEGIN
    v_service_role_key := current_setting('app.settings.service_role_key', true);

    SELECT http.status, http.content::jsonb INTO v_response
    FROM http(('POST',
        'https://wwhbdgwfodumognpkgrf.supabase.co/functions/v1/check-checklist',
        ARRAY[
            http_header('Authorization', 'Bearer ' || v_service_role_key),
            http_header('Content-Type', 'application/json')
        ], 'application/json', '{}'
    )) AS http;

    RAISE NOTICE 'check-checklist: %', v_response;
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'check-checklist failed: %', SQLERRM;
END;
$$;


ALTER FUNCTION "public"."trigger_shift_end_checklist_reminder"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_ad_booking_updated_at"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public', 'extensions'
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."update_ad_booking_updated_at"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_bgv_updated_at"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public', 'extensions'
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."update_bgv_updated_at"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_bill_due_amount"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public'
    AS $$
BEGIN
    NEW.due_amount := NEW.total_amount - NEW.paid_amount;
    IF NEW.paid_amount >= NEW.total_amount THEN
        NEW.payment_status := 'paid';
    ELSIF NEW.paid_amount > 0 THEN
        NEW.payment_status := 'partial';
    ELSE
        NEW.payment_status := 'unpaid';
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."update_bill_due_amount"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_budget_usage"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public'
    AS $$
DECLARE
    v_budget RECORD;
BEGIN
    IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') AND NEW.budget_id IS NOT NULL THEN
        -- Force recalculation of used_amount for this budget
        UPDATE budgets b
        SET used_amount = (SELECT COALESCE(SUM(total_amount), 0) FROM purchase_bills WHERE budget_id = b.id),
            updated_at = NOW()
        WHERE id = NEW.budget_id;
        
        -- Check and Notify
        SELECT * INTO v_budget FROM budgets WHERE id = NEW.budget_id;
        IF v_budget.allocated_amount > 0 AND (v_budget.used_amount / v_budget.allocated_amount * 100) >= v_budget.alert_threshold_percent THEN
            IF v_budget.alert_notified_at IS NULL THEN
                INSERT INTO notifications (user_id, notification_type, title, message)
                VALUES ('ba8661e4-e7d2-4dc7-adda-f05623b6b700', 'budget_threshold_alert', 'Budget Alert', 'Budget ' || v_budget.name || ' threshold hit (' || ROUND((v_budget.used_amount / v_budget.allocated_amount * 100)::numeric, 2) || '%).');
                
                UPDATE budgets SET alert_notified_at = NOW() WHERE id = v_budget.id;
            END IF;
        END IF;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."update_budget_usage"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_delivery_note_updated_at"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public', 'extensions'
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."update_delivery_note_updated_at"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_dispatch_updated_at"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public', 'extensions'
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."update_dispatch_updated_at"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_oversight_ticket_status"("p_ticket_id" "uuid", "p_status" "text", "p_resolution_notes" "text" DEFAULT NULL::"text") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_status TEXT := LOWER(COALESCE(NULLIF(BTRIM(p_status), ''), ''));
  v_ticket public.oversight_tickets%ROWTYPE;
BEGIN
  IF auth.uid() IS NULL OR get_my_app_role() NOT IN ('admin', 'super_admin', 'security_supervisor', 'society_manager') THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Only oversight users can update tickets');
  END IF;

  IF p_ticket_id IS NULL THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Ticket id is required');
  END IF;

  IF v_status NOT IN ('open', 'acknowledged', 'closed') THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Ticket status must be open, acknowledged, or closed');
  END IF;

  UPDATE public.oversight_tickets
  SET
    status = v_status,
    acknowledged_at = CASE
      WHEN v_status IN ('acknowledged', 'closed') THEN COALESCE(acknowledged_at, NOW())
      ELSE NULL
    END,
    acknowledged_by = CASE
      WHEN v_status IN ('acknowledged', 'closed') THEN COALESCE(acknowledged_by, auth.uid())
      ELSE NULL
    END,
    resolved_at = CASE
      WHEN v_status = 'closed' THEN COALESCE(resolved_at, NOW())
      ELSE NULL
    END,
    resolved_by = CASE
      WHEN v_status = 'closed' THEN COALESCE(resolved_by, auth.uid())
      ELSE NULL
    END,
    resolution_notes = CASE
      WHEN v_status = 'closed' THEN NULLIF(BTRIM(p_resolution_notes), '')
      ELSE NULL
    END,
    updated_at = NOW()
  WHERE id = p_ticket_id
  RETURNING * INTO v_ticket;

  IF v_ticket.id IS NULL THEN
    RETURN JSONB_BUILD_OBJECT('success', FALSE, 'error', 'Ticket not found');
  END IF;

  RETURN JSONB_BUILD_OBJECT(
    'success', TRUE,
    'ticket_id', v_ticket.id,
    'ticket_number', v_ticket.ticket_number,
    'status', v_ticket.status
  );
END;
$$;


ALTER FUNCTION "public"."update_oversight_ticket_status"("p_ticket_id" "uuid", "p_status" "text", "p_resolution_notes" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_panic_alert_location"("p_alert_id" "uuid", "p_latitude" numeric, "p_longitude" numeric, "p_captured_at" timestamp with time zone DEFAULT "now"()) RETURNS boolean
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
  IF auth.uid() IS NULL OR NOT is_guard() THEN
    RETURN FALSE;
  END IF;

  UPDATE public.panic_alerts
  SET
    latitude = p_latitude,
    longitude = p_longitude,
    streaming_active = TRUE,
    metadata = jsonb_set(
      jsonb_set(COALESCE(metadata, '{}'::JSONB), '{last_streamed_at}', to_jsonb(COALESCE(p_captured_at, NOW())), TRUE),
      '{stream_source}',
      to_jsonb('mobile_guard'::TEXT),
      TRUE
    )
  WHERE id = p_alert_id
    AND guard_id = get_guard_id()
    AND is_resolved = FALSE;

  RETURN FOUND;
END;
$$;


ALTER FUNCTION "public"."update_panic_alert_location"("p_alert_id" "uuid", "p_latitude" numeric, "p_longitude" numeric, "p_captured_at" timestamp with time zone) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_phase_b_updated_at"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."update_phase_b_updated_at"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_po_receipt_status"("p_po_id" "uuid", "p_user_id" "uuid") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_current_status TEXT;
  v_total_ordered NUMERIC;
  v_total_received NUMERIC;
  v_new_status TEXT;
BEGIN
  SELECT status INTO v_current_status
  FROM purchase_orders
  WHERE id = p_po_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RETURN jsonb_build_object('success', false, 'error', 'Purchase order not found');
  END IF;

  IF v_current_status NOT IN ('acknowledged', 'dispatched', 'partial_received') THEN
    RETURN jsonb_build_object('success', false, 'error', format('Cannot auto-update receipt status from "%s"', v_current_status));
  END IF;

  SELECT
    COALESCE(SUM(ordered_quantity), 0),
    COALESCE(SUM(received_quantity), 0)
  INTO v_total_ordered, v_total_received
  FROM purchase_order_items
  WHERE purchase_order_id = p_po_id;

  IF v_total_received >= v_total_ordered THEN
    v_new_status := 'received';
  ELSIF v_total_received > 0 AND v_current_status IN ('acknowledged', 'dispatched') THEN
    v_new_status := 'partial_received';
  ELSE
    RETURN jsonb_build_object('success', true, 'status', v_current_status, 'changed', false);
  END IF;

  UPDATE purchase_orders
  SET status = v_new_status, updated_at = NOW(), updated_by = p_user_id
  WHERE id = p_po_id;

  RETURN jsonb_build_object(
    'success', true,
    'previous_status', v_current_status,
    'new_status', v_new_status,
    'changed', true
  );
END;
$$;


ALTER FUNCTION "public"."update_po_receipt_status"("p_po_id" "uuid", "p_user_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_ppe_all_items_checked"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    -- If using discrete columns, check them
    IF NEW.gloves_worn IS NOT NULL THEN
        NEW.all_items_checked := 
            NEW.gloves_worn AND 
            NEW.mask_worn AND 
            NEW.goggles_worn AND 
            NEW.full_suit_worn AND 
            NEW.chemical_dilution_verified AND 
            NEW.resident_area_cleared;
    -- Fallback to JSONB if discrete columns are not all set (just in case)
    ELSIF NEW.checklist IS NOT NULL THEN
        NEW.all_items_checked := check_all_ppe_items(NEW.checklist);
    END IF;
    
    -- Also update status to 'verified' if all items are checked
    IF NEW.all_items_checked THEN
        NEW.status := 'verified';
    END IF;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."update_ppe_all_items_checked"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_qr_link_status"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public'
    AS $$
BEGIN
    -- When asset_id is set, mark as linked
    IF NEW.asset_id IS NOT NULL AND (OLD.asset_id IS NULL OR OLD.asset_id != NEW.asset_id) THEN
        NEW.is_linked = true;
    
    -- When asset_id is removed, mark as unlinked
    ELSIF NEW.asset_id IS NULL AND OLD.asset_id IS NOT NULL THEN
        NEW.is_linked = false;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."update_qr_link_status"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_shortage_note_updated_at"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public', 'extensions'
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."update_shortage_note_updated_at"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_spill_kit_updated_at"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public', 'extensions'
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."update_spill_kit_updated_at"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_updated_at_column"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public', 'extensions'
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."update_updated_at_column"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."upsert_employee_salary_component"("p_employee_id" "uuid", "p_component_id" "uuid", "p_amount" bigint, "p_effective_from" "date", "p_notes" "text" DEFAULT NULL::"text") RETURNS "uuid"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_actor_role TEXT;
  v_current public.employee_salary_structure%ROWTYPE;
  v_component_exists BOOLEAN;
  v_employee_exists BOOLEAN;
  v_salary_id UUID;
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'Salary structure update requires an authenticated session';
  END IF;

  v_actor_role := COALESCE(public.get_my_app_role(), public.get_user_role()::TEXT);

  IF v_actor_role NOT IN ('admin', 'super_admin', 'account') THEN
    RAISE EXCEPTION 'Only payroll admins can maintain employee salary structure';
  END IF;

  IF p_amount IS NULL OR p_amount <= 0 THEN
    RAISE EXCEPTION 'Salary amount must be greater than zero';
  END IF;

  IF p_effective_from IS NULL THEN
    RAISE EXCEPTION 'Effective from date is required';
  END IF;

  SELECT EXISTS (
    SELECT 1
    FROM public.employees e
    WHERE e.id = p_employee_id
      AND e.is_active = TRUE
  )
  INTO v_employee_exists;

  IF NOT v_employee_exists THEN
    RAISE EXCEPTION 'Employee not found or inactive';
  END IF;

  SELECT EXISTS (
    SELECT 1
    FROM public.salary_components sc
    WHERE sc.id = p_component_id
      AND sc.is_active = TRUE
  )
  INTO v_component_exists;

  IF NOT v_component_exists THEN
    RAISE EXCEPTION 'Salary component not found or inactive';
  END IF;

  SELECT *
  INTO v_current
  FROM public.employee_salary_structure ess
  WHERE ess.employee_id = p_employee_id
    AND ess.component_id = p_component_id
    AND ess.effective_to IS NULL
  ORDER BY ess.effective_from DESC, ess.created_at DESC NULLS LAST, ess.id DESC
  LIMIT 1
  FOR UPDATE;

  IF FOUND THEN
    IF v_current.effective_from = p_effective_from THEN
      UPDATE public.employee_salary_structure
      SET
        amount = p_amount,
        notes = p_notes,
        updated_at = NOW(),
        updated_by = auth.uid(),
        effective_to = NULL
      WHERE id = v_current.id
      RETURNING id INTO v_salary_id;

      RETURN v_salary_id;
    END IF;

    IF p_effective_from < v_current.effective_from THEN
      RAISE EXCEPTION 'Cannot backdate before the current active component start date (%).', v_current.effective_from;
    END IF;

    UPDATE public.employee_salary_structure
    SET
      effective_to = p_effective_from - 1,
      updated_at = NOW(),
      updated_by = auth.uid()
    WHERE id = v_current.id;
  END IF;

  INSERT INTO public.employee_salary_structure (
    employee_id,
    component_id,
    amount,
    effective_from,
    effective_to,
    notes,
    created_by,
    updated_by
  )
  VALUES (
    p_employee_id,
    p_component_id,
    p_amount,
    p_effective_from,
    NULL,
    p_notes,
    auth.uid(),
    auth.uid()
  )
  RETURNING id INTO v_salary_id;

  RETURN v_salary_id;
END;
$$;


ALTER FUNCTION "public"."upsert_employee_salary_component"("p_employee_id" "uuid", "p_component_id" "uuid", "p_amount" bigint, "p_effective_from" "date", "p_notes" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."upsert_push_token"("p_token" "text", "p_device_type" "text" DEFAULT 'unknown'::"text", "p_token_type" "text" DEFAULT 'fcm'::"text") RETURNS "uuid"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_id UUID;
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'Authentication required';
  END IF;

  IF COALESCE(btrim(p_token), '') = '' THEN
    RAISE EXCEPTION 'Push token is required';
  END IF;

  INSERT INTO public.push_tokens (
    user_id,
    token,
    token_type,
    device_type,
    last_used,
    is_active
  )
  VALUES (
    auth.uid(),
    p_token,
    COALESCE(NULLIF(btrim(p_token_type), ''), 'fcm'),
    COALESCE(NULLIF(btrim(p_device_type), ''), 'unknown'),
    NOW(),
    TRUE
  )
  ON CONFLICT (user_id, token)
  DO UPDATE SET
    token_type = EXCLUDED.token_type,
    device_type = EXCLUDED.device_type,
    last_used = NOW(),
    is_active = TRUE
  RETURNING id INTO v_id;

  RETURN v_id;
END;
$$;


ALTER FUNCTION "public"."upsert_push_token"("p_token" "text", "p_device_type" "text", "p_token_type" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."validate_bill_for_payout"("p_bill_id" "uuid") RETURNS TABLE("is_valid" boolean, "message" "text", "match_status" "text", "po_total" numeric, "grn_total" numeric, "bill_total" numeric)
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_po_id UUID;
  v_spo_id UUID;
  v_grn_id UUID;
  v_payment_status TEXT;
BEGIN
  SELECT
    pb.total_amount,
    COALESCE(pb.match_status, 'pending'),
    pb.payment_status,
    pb.purchase_order_id,
    pb.service_purchase_order_id,
    pb.material_receipt_id
  INTO bill_total, match_status, v_payment_status, v_po_id, v_spo_id, v_grn_id
  FROM public.purchase_bills pb
  WHERE pb.id = p_bill_id;

  IF NOT FOUND THEN
    RETURN QUERY
    SELECT
      FALSE,
      'Bill not found.'::TEXT,
      'pending'::TEXT,
      0::NUMERIC,
      0::NUMERIC,
      0::NUMERIC;
    RETURN;
  END IF;

  -- 1. Get PO/SPO Total
  IF v_po_id IS NOT NULL THEN
    SELECT COALESCE(po.grand_total, 0)
    INTO po_total
    FROM public.purchase_orders po
    WHERE po.id = v_po_id;
  ELSIF v_spo_id IS NOT NULL THEN
    SELECT COALESCE(spo.total_amount, 0)
    INTO po_total
    FROM public.service_purchase_orders spo
    WHERE spo.id = v_spo_id;
  ELSE
    po_total := 0;
  END IF;
  po_total := COALESCE(po_total, 0);

  -- 2. Get GRN/Acknowledgment Total
  IF v_grn_id IS NOT NULL THEN
    SELECT COALESCE(grn.total_received_value, 0)
    INTO grn_total
    FROM public.material_receipts grn
    WHERE grn.id = v_grn_id;
  ELSIF v_spo_id IS NOT NULL THEN
    -- For services, we check if there is an acknowledgment. 
    -- If acknowledged, we treat the 'receipt value' as matching the bill for now,
    -- as service acknowledgments are headcount-based rather than value-based.
    IF EXISTS (
      SELECT 1 FROM public.service_acknowledgments 
      WHERE spo_id = v_spo_id AND status = 'acknowledged'
    ) THEN
      grn_total := bill_total;
    ELSE
      grn_total := 0;
    END IF;
  ELSE
    grn_total := 0;
  END IF;
  grn_total := COALESCE(grn_total, 0);

  -- 3. Validation Logic
  IF v_payment_status = 'paid' THEN
    RETURN QUERY
    SELECT
      FALSE,
      'Bill is already fully paid.'::TEXT,
      match_status,
      po_total,
      grn_total,
      bill_total;
  ELSIF match_status IN ('matched', 'force_matched') THEN
    RETURN QUERY
    SELECT
      TRUE,
      'Bill is valid for payout.'::TEXT,
      match_status,
      po_total,
      grn_total,
      bill_total;
  ELSIF v_spo_id IS NOT NULL AND grn_total > 0 AND bill_total <= po_total THEN
    -- Special Case: Service POs can be paid if acknowledged and bill <= SPO total
    RETURN QUERY
    SELECT
      TRUE,
      'Service deployment verified. Valid for payout.'::TEXT,
      'matched'::TEXT,
      po_total,
      grn_total,
      bill_total;
  ELSE
    RETURN QUERY
    SELECT
      FALSE,
      'Reconciliation mismatch detected. Requires manual Force Match by Finance Admin.'::TEXT,
      match_status,
      po_total,
      grn_total,
      bill_total;
  END IF;
END;
$$;


ALTER FUNCTION "public"."validate_bill_for_payout"("p_bill_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."validate_clock_in_geofence"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
  IF NEW.check_in_time IS NULL THEN
    RETURN NEW;
  END IF;

  IF NEW.check_in_latitude IS NULL OR NEW.check_in_longitude IS NULL THEN
    IF has_role('admin')
      OR has_role('super_admin')
      OR has_role('security_supervisor')
      OR has_role('society_manager')
      OR has_role('site_supervisor') THEN
      RETURN NEW;
    END IF;

    RAISE EXCEPTION
      'Clock-in rejected: GPS coordinates are required to validate the geo-fence boundary.';
  END IF;

  IF NEW.check_in_location_id IS NULL THEN
    IF has_role('admin')
      OR has_role('super_admin')
      OR has_role('security_supervisor')
      OR has_role('society_manager')
      OR has_role('site_supervisor') THEN
      RETURN NEW;
    END IF;

    RAISE EXCEPTION
      'Clock-in rejected: A check-in location is required for geo-fence validation.';
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM public.company_locations cl
    WHERE cl.id = NEW.check_in_location_id
      AND cl.latitude IS NOT NULL
      AND cl.longitude IS NOT NULL
  ) THEN
    RETURN NEW;
  END IF;

  IF NOT check_geofence(
    NEW.check_in_latitude::double precision,
    NEW.check_in_longitude::double precision,
    (
      SELECT cl.latitude::double precision
      FROM public.company_locations cl
      WHERE cl.id = NEW.check_in_location_id
    ),
    (
      SELECT cl.longitude::double precision
      FROM public.company_locations cl
      WHERE cl.id = NEW.check_in_location_id
    ),
    COALESCE(
      (
        SELECT cl.geo_fence_radius::double precision
        FROM public.company_locations cl
        WHERE cl.id = NEW.check_in_location_id
      ),
      100.0
    )
  ) THEN
    RAISE EXCEPTION
      'Clock-in rejected: You are outside the geo-fence boundary for this location. Please move closer to your assigned location.';
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."validate_clock_in_geofence"() OWNER TO "postgres";


COMMENT ON FUNCTION "public"."validate_clock_in_geofence"() IS 'Server-side geo-fence enforcement for attendance clock-in. Prevents bypassing client-side geo-fence checks via DevTools or direct API calls.';



CREATE OR REPLACE FUNCTION "public"."validate_indent_rate"("p_indent_id" "uuid") RETURNS boolean
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
    v_supplier_id UUID;
    v_service_type TEXT;
    v_is_service_request BOOLEAN;
    v_has_rate BOOLEAN;
BEGIN
    -- Get request and supplier info
    SELECT r.is_service_request, r.service_type, i.supplier_id
    INTO v_is_service_request, v_service_type, v_supplier_id
    FROM public.indents i
    LEFT JOIN public.requests r ON i.service_request_id = r.id
    WHERE i.id = p_indent_id;

    -- Fallback for indents without a service_request_id
    IF v_is_service_request IS NULL THEN
        -- Check if it looks like a service request via other fields if needed, 
        -- but as per migration 20260401000001, we should use the flag.
        v_is_service_request := FALSE;
    END IF;

    -- Case 1: Service Request
    IF v_is_service_request = TRUE THEN
        IF v_service_type IS NULL OR v_supplier_id IS NULL THEN
            RETURN FALSE;
        END IF;

        SELECT EXISTS (
            SELECT 1 FROM public.service_rates
            WHERE supplier_id = v_supplier_id
              AND service_type = v_service_type
              AND is_active = TRUE
              AND CURRENT_DATE >= effective_from
              AND (effective_to IS NULL OR CURRENT_DATE <= effective_to)
        ) INTO v_has_rate;

        RETURN v_has_rate;

    -- Case 2: Material Request
    ELSE
        -- For material requests, every item in the indent must have an active rate contract
        -- with the selected supplier.
        SELECT NOT EXISTS (
            SELECT 1 
            FROM public.indent_items ii
            WHERE ii.indent_id = p_indent_id
              AND ii.product_id IS NOT NULL
              AND NOT EXISTS (
                SELECT 1 
                FROM public.supplier_products sp
                JOIN public.supplier_rates sr ON sp.id = sr.supplier_product_id
                WHERE sp.supplier_id = v_supplier_id
                  AND sp.product_id = ii.product_id
                  AND sr.is_active = TRUE
                  AND CURRENT_DATE >= sr.effective_from
              )
        ) INTO v_has_rate;
        
        RETURN v_has_rate;
    END IF;

    RETURN FALSE;
END;
$$;


ALTER FUNCTION "public"."validate_indent_rate"("p_indent_id" "uuid") OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."ad_booking_number_seq"
    START WITH 1001
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."ad_booking_number_seq" OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."asset_categories" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "category_code" character varying(20) NOT NULL,
    "category_name" character varying(100) NOT NULL,
    "description" "text",
    "parent_category_id" "uuid",
    "maintenance_frequency_days" integer,
    "icon" character varying(50),
    "color" character varying(7),
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid",
    "updated_by" "uuid"
);


ALTER TABLE "public"."asset_categories" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."assets" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "asset_code" character varying(50) NOT NULL,
    "name" character varying(200) NOT NULL,
    "description" "text",
    "category_id" "uuid" NOT NULL,
    "location_id" "uuid" NOT NULL,
    "society_id" "uuid",
    "serial_number" character varying(100),
    "model_number" character varying(100),
    "manufacturer" character varying(100),
    "purchase_date" "date",
    "purchase_cost" numeric(12,2),
    "warranty_expiry" "date",
    "expected_life_years" integer,
    "status" "public"."asset_status" DEFAULT 'functional'::"public"."asset_status",
    "vendor_id" "uuid",
    "specifications" "jsonb" DEFAULT '{}'::"jsonb",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid",
    "updated_by" "uuid"
);


ALTER TABLE "public"."assets" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."company_locations" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "location_code" character varying(20) NOT NULL,
    "location_name" character varying(200) NOT NULL,
    "location_type" character varying(50),
    "latitude" numeric(10,8),
    "longitude" numeric(11,8),
    "geo_fence_radius" numeric(6,2),
    "address" "text",
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid",
    "society_id" "uuid"
);


ALTER TABLE "public"."company_locations" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."qr_codes" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "asset_id" "uuid",
    "society_id" "uuid",
    "claimed_by" "uuid",
    "claimed_at" timestamp with time zone,
    "version" integer DEFAULT 0,
    "print_batch_id" "uuid",
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid",
    "batch_id" "text",
    "sequence_number" integer,
    "is_linked" boolean DEFAULT false,
    "warehouse_id" "uuid"
);


ALTER TABLE "public"."qr_codes" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."suppliers" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "supplier_name" character varying(255) NOT NULL,
    "contact_person" character varying(255),
    "phone" character varying(20),
    "email" character varying(255),
    "address" "text",
    "gst_number" character varying(20),
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "supplier_code" character varying(50),
    "supplier_type" character varying(50),
    "alternate_phone" character varying(20),
    "pan_number" character varying(20),
    "city" character varying(100),
    "state" character varying(100),
    "pincode" character varying(10),
    "country" character varying(100) DEFAULT 'India'::character varying,
    "bank_name" character varying(100),
    "bank_account_number" character varying(50),
    "ifsc_code" character varying(20),
    "payment_terms" integer DEFAULT 30,
    "credit_limit" numeric(12,2) DEFAULT 0,
    "rating" numeric(3,2),
    "status" character varying(50) DEFAULT 'active'::character varying,
    "is_verified" boolean DEFAULT false,
    "tier" integer DEFAULT 3,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid",
    "updated_by" "uuid",
    "rates" "text",
    "availability" "text"
);


ALTER TABLE "public"."suppliers" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."assets_with_details" WITH ("security_invoker"='on') AS
 SELECT "a"."id",
    "a"."asset_code",
    "a"."name",
    "a"."description",
    "a"."category_id",
    "a"."location_id",
    "a"."society_id",
    "a"."serial_number",
    "a"."model_number",
    "a"."manufacturer",
    "a"."purchase_date",
    "a"."purchase_cost",
    "a"."warranty_expiry",
    "a"."expected_life_years",
    "a"."status",
    "a"."vendor_id",
    "a"."specifications",
    "a"."created_at",
    "a"."updated_at",
    "a"."created_by",
    "a"."updated_by",
    "ac"."category_name",
    "ac"."category_code",
    "cl"."location_name",
    "cl"."location_code",
    "s"."supplier_name" AS "vendor_name",
    ( SELECT "qr_codes"."id"
           FROM "public"."qr_codes"
          WHERE ("qr_codes"."asset_id" = "a"."id")
         LIMIT 1) AS "qr_id"
   FROM ((("public"."assets" "a"
     LEFT JOIN "public"."asset_categories" "ac" ON (("a"."category_id" = "ac"."id")))
     LEFT JOIN "public"."company_locations" "cl" ON (("a"."location_id" = "cl"."id")))
     LEFT JOIN "public"."suppliers" "s" ON (("a"."vendor_id" = "s"."id")));


ALTER VIEW "public"."assets_with_details" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."attendance_logs" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "employee_id" "uuid" NOT NULL,
    "log_date" "date" NOT NULL,
    "check_in_time" timestamp with time zone,
    "check_out_time" timestamp with time zone,
    "check_in_location_id" "uuid",
    "check_out_location_id" "uuid",
    "total_hours" numeric(5,2),
    "status" character varying(20),
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "check_in_latitude" numeric,
    "check_in_longitude" numeric,
    "check_out_latitude" numeric,
    "check_out_longitude" numeric,
    "check_in_selfie_url" "text",
    "is_auto_punch_out" boolean DEFAULT false,
    "notes" "text",
    "overtime_hours" numeric(5,2)
);


ALTER TABLE "public"."attendance_logs" OWNER TO "postgres";


COMMENT ON COLUMN "public"."attendance_logs"."check_in_selfie_url" IS 'Signed URL reference for guard selfie at check-in.';



CREATE TABLE IF NOT EXISTS "public"."audit_logs" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "entity_type" "text" NOT NULL,
    "entity_id" "uuid",
    "actor_id" "uuid",
    "action" "text" NOT NULL,
    "old_data" "jsonb",
    "new_data" "jsonb",
    "evidence_url" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "actor_role" character varying(50),
    "metadata" "jsonb"
);


ALTER TABLE "public"."audit_logs" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."background_verifications" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "candidate_id" "uuid",
    "employee_id" "uuid",
    "verification_type" character varying(50) NOT NULL,
    "verification_agency" character varying(200),
    "initiated_date" "date" DEFAULT CURRENT_DATE NOT NULL,
    "completed_date" "date",
    "status" character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    "verification_document_url" "text",
    "remarks" "text",
    "verified_by" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."background_verifications" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."behavior_ticket_seq"
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."behavior_ticket_seq" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."behaviour_tickets" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "employee_id" "uuid" NOT NULL,
    "raised_by" "uuid" NOT NULL,
    "category" character varying NOT NULL,
    "severity" character varying NOT NULL,
    "description" "text" NOT NULL,
    "evidence_photo_url" "text",
    "incident_date" "date" DEFAULT CURRENT_DATE NOT NULL,
    "incident_time" time without time zone,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "behaviour_tickets_category_check" CHECK ((("category")::"text" = ANY ((ARRAY['sleeping_on_duty'::character varying, 'rudeness'::character varying, 'absence_from_post'::character varying, 'grooming_uniform'::character varying, 'unauthorized_entry'::character varying])::"text"[]))),
    CONSTRAINT "behaviour_tickets_severity_check" CHECK ((("severity")::"text" = ANY ((ARRAY['low'::character varying, 'medium'::character varying, 'high'::character varying])::"text"[])))
);


ALTER TABLE "public"."behaviour_tickets" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."bill_number_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."bill_number_seq" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."budget_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."budget_seq" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."budgets" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "budget_code" character varying(20),
    "name" character varying(100) NOT NULL,
    "department" character varying(100),
    "category" character varying(100),
    "financial_period_id" "uuid" NOT NULL,
    "allocated_amount" numeric(15,2) NOT NULL,
    "used_amount" numeric(15,2) DEFAULT 0,
    "remaining_amount" numeric(15,2) GENERATED ALWAYS AS (("allocated_amount" - "used_amount")) STORED,
    "alert_threshold_percent" integer DEFAULT 90,
    "alert_notified_at" timestamp with time zone,
    "status" "public"."budget_status" DEFAULT 'draft'::"public"."budget_status" NOT NULL,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid"
);


ALTER TABLE "public"."budgets" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."buildings" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "building_code" character varying(20) NOT NULL,
    "building_name" character varying(100) NOT NULL,
    "society_id" "uuid" NOT NULL,
    "total_floors" integer,
    "total_flats" integer,
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."buildings" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."buyer_accounts" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "account_type" "text" NOT NULL,
    "display_name" "text" NOT NULL,
    "gstin" "text",
    "society_id" "uuid",
    "auth_user_id" "uuid",
    "is_active" boolean DEFAULT true NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "buyer_accounts_account_type_check" CHECK (("account_type" = ANY (ARRAY['society'::"text", 'corporate'::"text", 'individual_resident'::"text"])))
);


ALTER TABLE "public"."buyer_accounts" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."buyer_feedback" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "request_id" "uuid" NOT NULL,
    "overall_rating" smallint NOT NULL,
    "quality_rating" smallint,
    "delivery_rating" smallint,
    "professionalism_rating" smallint,
    "would_recommend" boolean DEFAULT true,
    "comments" "text",
    "submitted_by" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "service_request_id" "uuid",
    CONSTRAINT "buyer_feedback_delivery_rating_check" CHECK ((("delivery_rating" >= 1) AND ("delivery_rating" <= 5))),
    CONSTRAINT "buyer_feedback_overall_rating_check" CHECK ((("overall_rating" >= 1) AND ("overall_rating" <= 5))),
    CONSTRAINT "buyer_feedback_professionalism_rating_check" CHECK ((("professionalism_rating" >= 1) AND ("professionalism_rating" <= 5))),
    CONSTRAINT "buyer_feedback_quality_rating_check" CHECK ((("quality_rating" >= 1) AND ("quality_rating" <= 5)))
);


ALTER TABLE "public"."buyer_feedback" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."candidate_interviews" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "candidate_id" "uuid" NOT NULL,
    "round_number" integer NOT NULL,
    "interview_type" "text" NOT NULL,
    "scheduled_at" timestamp with time zone NOT NULL,
    "duration_minutes" integer DEFAULT 60,
    "location" "text",
    "meeting_link" "text",
    "interviewer_id" "uuid",
    "panel_members" "jsonb",
    "completed_at" timestamp with time zone,
    "rating" integer,
    "feedback" "text",
    "recommendation" "text",
    "status" "text" DEFAULT 'scheduled'::"text",
    "cancellation_reason" "text",
    "notes" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid",
    "updated_by" "uuid",
    CONSTRAINT "candidate_interviews_interview_type_check" CHECK (("interview_type" = ANY (ARRAY['phone'::"text", 'technical'::"text", 'hr'::"text", 'final'::"text", 'panel'::"text", 'other'::"text"]))),
    CONSTRAINT "candidate_interviews_rating_check" CHECK ((("rating" >= 1) AND ("rating" <= 5))),
    CONSTRAINT "candidate_interviews_recommendation_check" CHECK (("recommendation" = ANY (ARRAY['strong_yes'::"text", 'yes'::"text", 'maybe'::"text", 'no'::"text", 'strong_no'::"text"]))),
    CONSTRAINT "candidate_interviews_round_number_check" CHECK (("round_number" >= 1)),
    CONSTRAINT "candidate_interviews_status_check" CHECK (("status" = ANY (ARRAY['scheduled'::"text", 'in_progress'::"text", 'completed'::"text", 'cancelled'::"text", 'rescheduled'::"text", 'no_show'::"text"])))
);


ALTER TABLE "public"."candidate_interviews" OWNER TO "postgres";


COMMENT ON TABLE "public"."candidate_interviews" IS 'Multi-round interview tracking for recruitment pipeline';



CREATE TABLE IF NOT EXISTS "public"."candidates" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "candidate_code" character varying(20),
    "first_name" character varying(100) NOT NULL,
    "last_name" character varying(100) NOT NULL,
    "email" character varying(255) NOT NULL,
    "phone" character varying(20) NOT NULL,
    "date_of_birth" "date",
    "address" "text",
    "city" character varying(100),
    "state" character varying(100),
    "pincode" character varying(10),
    "applied_position" character varying(200) NOT NULL,
    "designation_id" "uuid",
    "department" character varying(100),
    "expected_salary" numeric(12,2),
    "notice_period_days" integer,
    "resume_url" "text",
    "status" "public"."candidate_status" DEFAULT 'screening'::"public"."candidate_status" NOT NULL,
    "status_changed_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "status_changed_by" "uuid",
    "interview_date" timestamp with time zone,
    "interview_notes" "text",
    "interview_rating" integer,
    "interviewer_id" "uuid",
    "bgv_initiated_at" timestamp with time zone,
    "bgv_completed_at" timestamp with time zone,
    "bgv_status" character varying(50),
    "bgv_notes" "text",
    "offered_salary" numeric(12,2),
    "offer_date" "date",
    "offer_accepted_at" timestamp with time zone,
    "joining_date" "date",
    "rejection_reason" "text",
    "converted_employee_id" "uuid",
    "converted_at" timestamp with time zone,
    "source" character varying(100),
    "referred_by" "uuid",
    "notes" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid",
    "updated_by" "uuid",
    CONSTRAINT "candidates_interview_rating_check" CHECK ((("interview_rating" >= 1) AND ("interview_rating" <= 5)))
);


ALTER TABLE "public"."candidates" OWNER TO "postgres";


COMMENT ON TABLE "public"."candidates" IS 'Recruitment applicant tracking - admin entry only';



CREATE TABLE IF NOT EXISTS "public"."employees" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "employee_code" character varying(50) NOT NULL,
    "first_name" character varying(100) NOT NULL,
    "last_name" character varying(100) NOT NULL,
    "email" character varying(255),
    "phone" character varying(20),
    "date_of_birth" "date",
    "date_of_joining" "date" NOT NULL,
    "designation_id" "uuid",
    "department" character varying(100),
    "reporting_to" "uuid",
    "is_active" boolean DEFAULT true,
    "address" "text",
    "city" character varying(100),
    "state" character varying(100),
    "pincode" character varying(10),
    "emergency_contact_name" character varying(100),
    "emergency_contact_phone" character varying(20),
    "photo_url" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid",
    "updated_by" "uuid",
    "auth_user_id" "uuid"
);


ALTER TABLE "public"."employees" OWNER TO "postgres";


COMMENT ON COLUMN "public"."employees"."auth_user_id" IS 'Links employee to Supabase auth.users for authentication';



CREATE OR REPLACE VIEW "public"."candidate_interviews_with_details" WITH ("security_invoker"='on') AS
 SELECT "ci"."id",
    "ci"."candidate_id",
    "ci"."round_number",
    "ci"."interview_type",
    "ci"."scheduled_at",
    "ci"."duration_minutes",
    "ci"."location",
    "ci"."meeting_link",
    "ci"."interviewer_id",
    "ci"."panel_members",
    "ci"."completed_at",
    "ci"."rating",
    "ci"."feedback",
    "ci"."recommendation",
    "ci"."status",
    "ci"."cancellation_reason",
    "ci"."notes",
    "ci"."created_at",
    "ci"."updated_at",
    "ci"."created_by",
    "ci"."updated_by",
    "c"."candidate_code",
    ((("c"."first_name")::"text" || ' '::"text") || ("c"."last_name")::"text") AS "candidate_name",
    "c"."applied_position",
    "c"."status" AS "candidate_status",
    ((("i"."first_name")::"text" || ' '::"text") || ("i"."last_name")::"text") AS "interviewer_name",
    "i"."email" AS "interviewer_email"
   FROM (("public"."candidate_interviews" "ci"
     JOIN "public"."candidates" "c" ON (("ci"."candidate_id" = "c"."id")))
     LEFT JOIN "public"."employees" "i" ON (("ci"."interviewer_id" = "i"."id")));


ALTER VIEW "public"."candidate_interviews_with_details" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."candidate_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."candidate_seq" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."designations" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "designation_code" character varying(20) NOT NULL,
    "designation_name" character varying(100) NOT NULL,
    "department" character varying(100),
    "description" "text",
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid",
    "updated_by" "uuid",
    "level" character varying(50),
    CONSTRAINT "designations_level_check" CHECK ((("level")::"text" = ANY ((ARRAY['junior'::character varying, 'senior'::character varying, 'lead'::character varying, 'head'::character varying])::"text"[])))
);


ALTER TABLE "public"."designations" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."candidates_with_details" WITH ("security_invoker"='on') AS
 SELECT "c"."id",
    "c"."candidate_code",
    "c"."first_name",
    "c"."last_name",
    "c"."email",
    "c"."phone",
    "c"."date_of_birth",
    "c"."address",
    "c"."city",
    "c"."state",
    "c"."pincode",
    "c"."applied_position",
    "c"."designation_id",
    "c"."department",
    "c"."expected_salary",
    "c"."notice_period_days",
    "c"."resume_url",
    "c"."status",
    "c"."status_changed_at",
    "c"."status_changed_by",
    "c"."interview_date",
    "c"."interview_notes",
    "c"."interview_rating",
    "c"."interviewer_id",
    "c"."bgv_initiated_at",
    "c"."bgv_completed_at",
    "c"."bgv_status",
    "c"."bgv_notes",
    "c"."offered_salary",
    "c"."offer_date",
    "c"."offer_accepted_at",
    "c"."joining_date",
    "c"."rejection_reason",
    "c"."converted_employee_id",
    "c"."converted_at",
    "c"."source",
    "c"."referred_by",
    "c"."notes",
    "c"."created_at",
    "c"."updated_at",
    "c"."created_by",
    "c"."updated_by",
    "d"."designation_name",
    ((("i"."first_name")::"text" || ' '::"text") || ("i"."last_name")::"text") AS "interviewer_name",
    ((("r"."first_name")::"text" || ' '::"text") || ("r"."last_name")::"text") AS "referred_by_name",
    "ce"."employee_code" AS "converted_employee_code"
   FROM (((("public"."candidates" "c"
     LEFT JOIN "public"."designations" "d" ON (("c"."designation_id" = "d"."id")))
     LEFT JOIN "public"."employees" "i" ON (("c"."interviewer_id" = "i"."id")))
     LEFT JOIN "public"."employees" "r" ON (("c"."referred_by" = "r"."id")))
     LEFT JOIN "public"."employees" "ce" ON (("c"."converted_employee_id" = "ce"."id")));


ALTER VIEW "public"."candidates_with_details" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."checklist_assignments" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "checklist_id" "uuid" NOT NULL,
    "employee_id" "uuid" NOT NULL,
    "assigned_by" "uuid",
    "assigned_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "is_active" boolean DEFAULT true NOT NULL
);


ALTER TABLE "public"."checklist_assignments" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."checklist_response_override_audit" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "response_id" "uuid" NOT NULL,
    "checklist_id" "uuid" NOT NULL,
    "employee_id" "uuid" NOT NULL,
    "guard_id" "uuid",
    "status" "text" NOT NULL,
    "reason" "text",
    "acted_by" "uuid" NOT NULL,
    "acted_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."checklist_response_override_audit" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."checklist_responses" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "checklist_id" "uuid" NOT NULL,
    "employee_id" "uuid" NOT NULL,
    "response_date" "date" NOT NULL,
    "responses" "jsonb" NOT NULL,
    "location_id" "uuid",
    "latitude" numeric(10,8),
    "longitude" numeric(11,8),
    "submitted_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "is_complete" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "evidence_photos" "jsonb" DEFAULT '[]'::"jsonb",
    "override_status" "text" DEFAULT 'none'::"text" NOT NULL,
    "override_reason" "text",
    "overridden_by" "uuid",
    "overridden_at" timestamp with time zone,
    CONSTRAINT "checklist_responses_override_status_check" CHECK (("override_status" = ANY (ARRAY['none'::"text", 'approved'::"text", 'resubmitted'::"text"])))
);


ALTER TABLE "public"."checklist_responses" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."company_events" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "event_date" "date" NOT NULL,
    "event_name" character varying(255),
    "location_id" "uuid",
    "description" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "event_code" character varying(50),
    "category" character varying(50),
    "event_time" time without time zone,
    "venue" character varying(200),
    "attendees" "text",
    "status" character varying(20) DEFAULT 'Scheduled'::character varying,
    "title" character varying(200),
    "is_active" boolean DEFAULT true,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid"
);


ALTER TABLE "public"."company_events" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."compliance_snapshots" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "period_id" "uuid",
    "snapshot_name" "text" NOT NULL,
    "snapshot_date" timestamp with time zone DEFAULT "now"(),
    "total_invoices_amount" bigint DEFAULT 0 NOT NULL,
    "total_collections_amount" bigint DEFAULT 0 NOT NULL,
    "total_bills_amount" bigint DEFAULT 0 NOT NULL,
    "total_payouts_amount" bigint DEFAULT 0 NOT NULL,
    "unresolved_reconciliations_count" integer DEFAULT 0 NOT NULL,
    "data_payload" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    "is_locked" boolean DEFAULT true,
    "created_by" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."compliance_snapshots" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."contracts" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "contract_number" character varying(50) NOT NULL,
    "society_id" "uuid" NOT NULL,
    "start_date" "date" NOT NULL,
    "end_date" "date" NOT NULL,
    "status" character varying(20) DEFAULT 'draft'::character varying,
    "contract_value" bigint DEFAULT 0,
    "payment_terms" "text",
    "document_url" "text",
    "description" "text",
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid",
    "updated_by" "uuid",
    CONSTRAINT "contracts_status_check" CHECK ((("status")::"text" = ANY ((ARRAY['draft'::character varying, 'active'::character varying, 'expired'::character varying, 'terminated'::character varying, 'renewed'::character varying])::"text"[])))
);


ALTER TABLE "public"."contracts" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."credit_notes" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "sale_bill_id" "uuid" NOT NULL,
    "credit_note_number" "text" NOT NULL,
    "reason" "text" NOT NULL,
    "amount" bigint NOT NULL,
    "tax_amount" bigint DEFAULT 0,
    "issued_by" "uuid",
    "issued_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."credit_notes" OWNER TO "postgres";


COMMENT ON TABLE "public"."credit_notes" IS 'Invoice adjustments reducing amount due (SLA breaches, returns, corrections)';



COMMENT ON COLUMN "public"."credit_notes"."tax_amount" IS 'Undifferentiated tax (v1). Will split to CGST/SGST when GST engine lands (12-1)';



CREATE TABLE IF NOT EXISTS "public"."daily_checklist_items" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "checklist_id" "uuid",
    "shift_id" "uuid",
    "task_name" character varying NOT NULL,
    "category" character varying DEFAULT 'general'::character varying NOT NULL,
    "priority" integer DEFAULT 1 NOT NULL,
    "requires_photo" boolean DEFAULT false NOT NULL,
    "requires_signature" boolean DEFAULT false NOT NULL,
    "description" "text",
    "is_active" boolean DEFAULT true NOT NULL,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "input_type" "text" DEFAULT 'yes_no'::"text" NOT NULL,
    "numeric_unit_label" "text",
    "numeric_min_value" numeric,
    "numeric_max_value" numeric,
    "requires_supervisor_override" boolean DEFAULT false NOT NULL
);


ALTER TABLE "public"."daily_checklist_items" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."daily_checklists" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "checklist_code" character varying(20) NOT NULL,
    "checklist_name" character varying(200) NOT NULL,
    "department" character varying(100) NOT NULL,
    "description" "text",
    "questions" "jsonb" NOT NULL,
    "frequency" character varying(20) DEFAULT 'daily'::character varying,
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid"
);


ALTER TABLE "public"."daily_checklists" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."debit_notes" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "sale_bill_id" "uuid" NOT NULL,
    "debit_note_number" "text" NOT NULL,
    "reason" "text" NOT NULL,
    "amount" bigint NOT NULL,
    "tax_amount" bigint DEFAULT 0,
    "issued_by" "uuid",
    "issued_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."debit_notes" OWNER TO "postgres";


COMMENT ON TABLE "public"."debit_notes" IS 'Invoice adjustments increasing amount due (rare, usually missed charges)';



COMMENT ON COLUMN "public"."debit_notes"."tax_amount" IS 'Undifferentiated tax (v1). Will split to CGST/SGST when GST engine lands (12-1)';



CREATE SEQUENCE IF NOT EXISTS "public"."delivery_note_number_seq"
    START WITH 1001
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."delivery_note_number_seq" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."maintenance_schedules" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "asset_id" "uuid" NOT NULL,
    "task_name" character varying(200) NOT NULL,
    "task_description" "text",
    "frequency" "public"."maintenance_frequency" NOT NULL,
    "custom_interval_days" integer,
    "last_performed_date" "date",
    "next_due_date" "date" NOT NULL,
    "assigned_to_role" "uuid",
    "assigned_to_employee" "uuid",
    "reminder_days_before" integer DEFAULT 3,
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid"
);


ALTER TABLE "public"."maintenance_schedules" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."due_maintenance_schedules" WITH ("security_invoker"='on') AS
 SELECT "ms"."id",
    "ms"."asset_id",
    "ms"."task_name",
    "ms"."task_description",
    "ms"."frequency",
    "ms"."custom_interval_days",
    "ms"."last_performed_date",
    "ms"."next_due_date",
    "ms"."assigned_to_role",
    "ms"."assigned_to_employee",
    "ms"."reminder_days_before",
    "ms"."is_active",
    "ms"."created_at",
    "ms"."updated_at",
    "ms"."created_by",
    "a"."name" AS "asset_name",
    "a"."asset_code",
    "a"."location_id",
    "cl"."location_name"
   FROM (("public"."maintenance_schedules" "ms"
     JOIN "public"."assets" "a" ON (("ms"."asset_id" = "a"."id")))
     LEFT JOIN "public"."company_locations" "cl" ON (("a"."location_id" = "cl"."id")))
  WHERE (("ms"."is_active" = true) AND ("ms"."next_due_date" <= (CURRENT_DATE + '7 days'::interval)))
  ORDER BY "ms"."next_due_date";


ALTER VIEW "public"."due_maintenance_schedules" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."emergency_contacts" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "contact_name" character varying(100) NOT NULL,
    "contact_type" character varying(50) NOT NULL,
    "phone_number" character varying(20) NOT NULL,
    "priority" integer DEFAULT 1,
    "is_active" boolean DEFAULT true,
    "society_id" "uuid",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "description" "text"
);


ALTER TABLE "public"."emergency_contacts" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."employee_behavior_tickets" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "ticket_number" character varying(50),
    "employee_id" "uuid" NOT NULL,
    "category" "public"."behavior_category" NOT NULL,
    "severity" character varying(20) NOT NULL,
    "reported_by" "uuid",
    "description" "text",
    "evidence_urls" "jsonb",
    "status" character varying(20) DEFAULT 'open'::character varying,
    "resolution" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."employee_behavior_tickets" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."employee_documents" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "document_code" character varying(50),
    "employee_id" "uuid" NOT NULL,
    "document_type" "public"."document_type" NOT NULL,
    "document_number" character varying(100),
    "document_name" character varying(200) NOT NULL,
    "file_path" "text" NOT NULL,
    "file_name" character varying(255) NOT NULL,
    "file_size" integer,
    "mime_type" character varying(100),
    "issue_date" "date",
    "expiry_date" "date",
    "status" "public"."document_status" DEFAULT 'pending_review'::"public"."document_status" NOT NULL,
    "verified_at" timestamp with time zone,
    "verified_by" "uuid",
    "rejection_reason" "text",
    "expiry_notified_at" timestamp with time zone,
    "notes" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid",
    "updated_by" "uuid"
);


ALTER TABLE "public"."employee_documents" OWNER TO "postgres";


COMMENT ON TABLE "public"."employee_documents" IS 'Compliance document storage with internal verification';



CREATE TABLE IF NOT EXISTS "public"."users" (
    "id" "uuid" NOT NULL,
    "employee_id" "uuid",
    "role_id" "uuid" NOT NULL,
    "username" character varying(100) NOT NULL,
    "full_name" character varying(200) NOT NULL,
    "email" character varying(255) NOT NULL,
    "phone" character varying(20),
    "is_active" boolean DEFAULT true,
    "last_login" timestamp with time zone,
    "preferences" "jsonb" DEFAULT '{}'::"jsonb",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "supplier_id" "uuid",
    "must_change_password" boolean DEFAULT false NOT NULL
);


ALTER TABLE "public"."users" OWNER TO "postgres";


COMMENT ON COLUMN "public"."users"."must_change_password" IS 'When true, user must change their password before accessing any app route. Set to true when admin provisions a new account with a temporary password.';



CREATE OR REPLACE VIEW "public"."employee_documents_with_details" WITH ("security_invoker"='on') AS
 SELECT "ed"."id",
    "ed"."document_code",
    "ed"."employee_id",
    "ed"."document_type",
    "ed"."document_number",
    "ed"."document_name",
    "ed"."file_path",
    "ed"."file_name",
    "ed"."file_size",
    "ed"."mime_type",
    "ed"."issue_date",
    "ed"."expiry_date",
    "ed"."status",
    "ed"."verified_at",
    "ed"."verified_by",
    "ed"."rejection_reason",
    "ed"."expiry_notified_at",
    "ed"."notes",
    "ed"."created_at",
    "ed"."updated_at",
    "ed"."created_by",
    "ed"."updated_by",
    "e"."employee_code",
    ((("e"."first_name")::"text" || ' '::"text") || ("e"."last_name")::"text") AS "employee_name",
    "e"."department",
    "v"."full_name" AS "verified_by_name"
   FROM (("public"."employee_documents" "ed"
     JOIN "public"."employees" "e" ON (("ed"."employee_id" = "e"."id")))
     LEFT JOIN "public"."users" "v" ON (("ed"."verified_by" = "v"."id")));


ALTER VIEW "public"."employee_documents_with_details" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."employee_salary_structure" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "employee_id" "uuid" NOT NULL,
    "component_id" "uuid" NOT NULL,
    "amount" bigint NOT NULL,
    "effective_from" "date" NOT NULL,
    "effective_to" "date",
    "notes" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid",
    "updated_by" "uuid"
);


ALTER TABLE "public"."employee_salary_structure" OWNER TO "postgres";


COMMENT ON TABLE "public"."employee_salary_structure" IS 'Employee-specific salary component assignments with effective dates';



COMMENT ON COLUMN "public"."employee_salary_structure"."amount" IS 'Amount in paise (1 INR = 100 paise)';



COMMENT ON COLUMN "public"."employee_salary_structure"."effective_to" IS 'NULL means currently active';



CREATE TABLE IF NOT EXISTS "public"."salary_components" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "name" "text" NOT NULL,
    "abbr" character varying(20) NOT NULL,
    "type" "text" NOT NULL,
    "formula" "text",
    "default_amount" bigint,
    "depends_on_payment_days" boolean DEFAULT true,
    "is_tax_applicable" boolean DEFAULT true,
    "sort_order" integer DEFAULT 0,
    "is_active" boolean DEFAULT true,
    "description" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid",
    "updated_by" "uuid",
    CONSTRAINT "salary_components_type_check" CHECK (("type" = ANY (ARRAY['earning'::"text", 'deduction'::"text"])))
);


ALTER TABLE "public"."salary_components" OWNER TO "postgres";


COMMENT ON TABLE "public"."salary_components" IS 'Reusable salary component definitions with formulas - from Horilla HRMS pattern';



COMMENT ON COLUMN "public"."salary_components"."formula" IS 'Formula using variables: B (Basic), gross_pay, etc. Example: B * 0.12';



COMMENT ON COLUMN "public"."salary_components"."default_amount" IS 'Default amount in paise (smallest currency unit) if no formula';



CREATE OR REPLACE VIEW "public"."employee_salary_structure_with_details" WITH ("security_invoker"='on') AS
 SELECT "ess"."id",
    "ess"."employee_id",
    "ess"."component_id",
    "ess"."amount",
    "ess"."effective_from",
    "ess"."effective_to",
    "ess"."notes",
    "ess"."created_at",
    "ess"."updated_at",
    "ess"."created_by",
    "ess"."updated_by",
    "e"."employee_code",
    ((("e"."first_name")::"text" || ' '::"text") || ("e"."last_name")::"text") AS "employee_name",
    "e"."department",
    "sc"."name" AS "component_name",
    "sc"."abbr" AS "component_abbr",
    "sc"."type" AS "component_type",
    "sc"."formula" AS "component_formula",
    "sc"."depends_on_payment_days"
   FROM (("public"."employee_salary_structure" "ess"
     JOIN "public"."employees" "e" ON (("ess"."employee_id" = "e"."id")))
     JOIN "public"."salary_components" "sc" ON (("ess"."component_id" = "sc"."id")))
  WHERE ("ess"."effective_to" IS NULL);


ALTER VIEW "public"."employee_salary_structure_with_details" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."employee_shift_assignments" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "employee_id" "uuid" NOT NULL,
    "shift_id" "uuid" NOT NULL,
    "assigned_from" "date" NOT NULL,
    "assigned_to" "date",
    "is_active" boolean DEFAULT true,
    "assigned_by" "uuid",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."employee_shift_assignments" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."products" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "subcategory_id" "uuid",
    "product_name" character varying(255) NOT NULL,
    "product_code" character varying(50),
    "unit_of_measurement" character varying(20),
    "description" "text",
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "category_id" "uuid",
    "base_rate" numeric(10,2),
    "min_stock_level" integer DEFAULT 10,
    "current_stock" integer DEFAULT 0,
    "hsn_code" character varying(20),
    "specifications" "jsonb",
    "status" character varying(20) DEFAULT 'active'::character varying,
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "created_by" "uuid",
    "updated_by" "uuid"
);


ALTER TABLE "public"."products" OWNER TO "postgres";


COMMENT ON COLUMN "public"."products"."min_stock_level" IS 'Minimum stock level before reorder alert is triggered.';



COMMENT ON COLUMN "public"."products"."current_stock" IS 'Simple stock count for quick reference. For detailed tracking, use inventory table.';



COMMENT ON COLUMN "public"."products"."status" IS 'Product status: active, inactive, discontinued';



CREATE TABLE IF NOT EXISTS "public"."safety_equipment" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "equipment_name" "text" NOT NULL,
    "type" "text",
    "expiry_date" "date",
    "location" "text",
    "status" "text" DEFAULT 'active'::"text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."safety_equipment" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."stock_batches" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "batch_number" character varying(50) NOT NULL,
    "product_id" "uuid" NOT NULL,
    "warehouse_id" "uuid" NOT NULL,
    "initial_quantity" numeric(10,2) NOT NULL,
    "current_quantity" numeric(10,2) NOT NULL,
    "manufacturing_date" "date",
    "expiry_date" "date",
    "unit_cost" numeric(10,2),
    "status" character varying(20) DEFAULT 'active'::character varying,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "chk_current_quantity_non_negative" CHECK (("current_quantity" >= (0)::numeric))
);


ALTER TABLE "public"."stock_batches" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."expiry_tracking" WITH ("security_invoker"='true') AS
 SELECT "sb"."id" AS "item_id",
    (((("p"."product_name")::"text" || ' ('::"text") || ("sb"."batch_number")::"text") || ')'::"text") AS "item_name",
    'chemical'::"text" AS "item_type",
    "sb"."expiry_date",
    'pest_control'::"text" AS "category"
   FROM ("public"."stock_batches" "sb"
     JOIN "public"."products" "p" ON (("sb"."product_id" = "p"."id")))
  WHERE (("sb"."expiry_date" IS NOT NULL) AND ("sb"."current_quantity" > (0)::numeric))
UNION ALL
 SELECT "safety_equipment"."id" AS "item_id",
    "safety_equipment"."equipment_name" AS "item_name",
    'safety_equipment'::"text" AS "item_type",
    "safety_equipment"."expiry_date",
    'safety'::"text" AS "category"
   FROM "public"."safety_equipment"
  WHERE (("safety_equipment"."expiry_date" IS NOT NULL) AND ("safety_equipment"."status" = 'active'::"text"))
UNION ALL
 SELECT "ed"."id" AS "item_id",
    "ed"."document_name" AS "item_name",
    'document'::"text" AS "item_type",
    "ed"."expiry_date",
    'compliance'::"text" AS "category"
   FROM "public"."employee_documents" "ed"
  WHERE ("ed"."expiry_date" IS NOT NULL);


ALTER VIEW "public"."expiry_tracking" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."financial_periods" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "period_name" character varying(50) NOT NULL,
    "period_type" "public"."financial_period_type" NOT NULL,
    "start_date" "date" NOT NULL,
    "end_date" "date" NOT NULL,
    "status" "public"."financial_period_status" DEFAULT 'open'::"public"."financial_period_status" NOT NULL,
    "closed_at" timestamp with time zone,
    "closed_by" "uuid",
    "closing_notes" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid",
    CONSTRAINT "date_range_check" CHECK (("end_date" >= "start_date"))
);


ALTER TABLE "public"."financial_periods" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."flats" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "flat_number" character varying(20) NOT NULL,
    "building_id" "uuid" NOT NULL,
    "floor_number" integer,
    "flat_type" character varying(50),
    "area_sqft" numeric(8,2),
    "ownership_type" character varying(20),
    "is_occupied" boolean DEFAULT false,
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."flats" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."gps_tracking" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "employee_id" "uuid" NOT NULL,
    "latitude" numeric(10,8) NOT NULL,
    "longitude" numeric(11,8) NOT NULL,
    "tracked_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "battery_level" integer,
    "is_mock_location" boolean DEFAULT false,
    "accuracy_meters" numeric,
    "speed_kmh" numeric,
    "heading_degrees" numeric
)
PARTITION BY RANGE ("tracked_at");


ALTER TABLE "public"."gps_tracking" OWNER TO "postgres";


COMMENT ON TABLE "public"."gps_tracking" IS 'Time-partitioned GPS tracking data. Partitions exist through Dec 2026. Add more partitions before they are needed.';



COMMENT ON COLUMN "public"."gps_tracking"."employee_id" IS 'Stores security_guards.id values for guard GPS telemetry.';



CREATE TABLE IF NOT EXISTS "public"."gps_tracking_2026_02" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "employee_id" "uuid" NOT NULL,
    "latitude" numeric(10,8) NOT NULL,
    "longitude" numeric(11,8) NOT NULL,
    "tracked_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "battery_level" integer,
    "is_mock_location" boolean DEFAULT false,
    "accuracy_meters" numeric,
    "speed_kmh" numeric,
    "heading_degrees" numeric
);


ALTER TABLE "public"."gps_tracking_2026_02" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."gps_tracking_2026_03" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "employee_id" "uuid" NOT NULL,
    "latitude" numeric(10,8) NOT NULL,
    "longitude" numeric(11,8) NOT NULL,
    "tracked_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "battery_level" integer,
    "is_mock_location" boolean DEFAULT false,
    "accuracy_meters" numeric,
    "speed_kmh" numeric,
    "heading_degrees" numeric
);


ALTER TABLE "public"."gps_tracking_2026_03" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."gps_tracking_2026_04" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "employee_id" "uuid" NOT NULL,
    "latitude" numeric(10,8) NOT NULL,
    "longitude" numeric(11,8) NOT NULL,
    "tracked_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "battery_level" integer,
    "is_mock_location" boolean DEFAULT false,
    "accuracy_meters" numeric,
    "speed_kmh" numeric,
    "heading_degrees" numeric
);


ALTER TABLE "public"."gps_tracking_2026_04" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."gps_tracking_2026_05" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "employee_id" "uuid" NOT NULL,
    "latitude" numeric(10,8) NOT NULL,
    "longitude" numeric(11,8) NOT NULL,
    "tracked_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "battery_level" integer,
    "is_mock_location" boolean DEFAULT false,
    "accuracy_meters" numeric,
    "speed_kmh" numeric,
    "heading_degrees" numeric
);


ALTER TABLE "public"."gps_tracking_2026_05" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."gps_tracking_2026_06" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "employee_id" "uuid" NOT NULL,
    "latitude" numeric(10,8) NOT NULL,
    "longitude" numeric(11,8) NOT NULL,
    "tracked_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "battery_level" integer,
    "is_mock_location" boolean DEFAULT false,
    "accuracy_meters" numeric,
    "speed_kmh" numeric,
    "heading_degrees" numeric
);


ALTER TABLE "public"."gps_tracking_2026_06" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."gps_tracking_2026_07" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "employee_id" "uuid" NOT NULL,
    "latitude" numeric(10,8) NOT NULL,
    "longitude" numeric(11,8) NOT NULL,
    "tracked_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "battery_level" integer,
    "is_mock_location" boolean DEFAULT false,
    "accuracy_meters" numeric,
    "speed_kmh" numeric,
    "heading_degrees" numeric
);


ALTER TABLE "public"."gps_tracking_2026_07" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."gps_tracking_2026_08" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "employee_id" "uuid" NOT NULL,
    "latitude" numeric(10,8) NOT NULL,
    "longitude" numeric(11,8) NOT NULL,
    "tracked_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "battery_level" integer,
    "is_mock_location" boolean DEFAULT false,
    "accuracy_meters" numeric,
    "speed_kmh" numeric,
    "heading_degrees" numeric
);


ALTER TABLE "public"."gps_tracking_2026_08" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."gps_tracking_2026_09" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "employee_id" "uuid" NOT NULL,
    "latitude" numeric(10,8) NOT NULL,
    "longitude" numeric(11,8) NOT NULL,
    "tracked_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "battery_level" integer,
    "is_mock_location" boolean DEFAULT false,
    "accuracy_meters" numeric,
    "speed_kmh" numeric,
    "heading_degrees" numeric
);


ALTER TABLE "public"."gps_tracking_2026_09" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."gps_tracking_2026_10" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "employee_id" "uuid" NOT NULL,
    "latitude" numeric(10,8) NOT NULL,
    "longitude" numeric(11,8) NOT NULL,
    "tracked_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "battery_level" integer,
    "is_mock_location" boolean DEFAULT false,
    "accuracy_meters" numeric,
    "speed_kmh" numeric,
    "heading_degrees" numeric
);


ALTER TABLE "public"."gps_tracking_2026_10" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."gps_tracking_2026_11" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "employee_id" "uuid" NOT NULL,
    "latitude" numeric(10,8) NOT NULL,
    "longitude" numeric(11,8) NOT NULL,
    "tracked_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "battery_level" integer,
    "is_mock_location" boolean DEFAULT false,
    "accuracy_meters" numeric,
    "speed_kmh" numeric,
    "heading_degrees" numeric
);


ALTER TABLE "public"."gps_tracking_2026_11" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."gps_tracking_2026_12" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "employee_id" "uuid" NOT NULL,
    "latitude" numeric(10,8) NOT NULL,
    "longitude" numeric(11,8) NOT NULL,
    "tracked_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "battery_level" integer,
    "is_mock_location" boolean DEFAULT false,
    "accuracy_meters" numeric,
    "speed_kmh" numeric,
    "heading_degrees" numeric
);


ALTER TABLE "public"."gps_tracking_2026_12" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."gps_tracking_default" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "employee_id" "uuid" NOT NULL,
    "latitude" numeric(10,8) NOT NULL,
    "longitude" numeric(11,8) NOT NULL,
    "tracked_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "battery_level" integer,
    "is_mock_location" boolean DEFAULT false,
    "accuracy_meters" numeric,
    "speed_kmh" numeric,
    "heading_degrees" numeric
);


ALTER TABLE "public"."gps_tracking_default" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."grn_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."grn_seq" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."guard_gps_tracking" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "guard_id" "uuid" NOT NULL,
    "latitude" numeric(10,8) NOT NULL,
    "longitude" numeric(11,8) NOT NULL,
    "accuracy_meters" integer,
    "is_within_fence" boolean DEFAULT true,
    "shift_id" "uuid",
    "recorded_at" timestamp with time zone DEFAULT "now"(),
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."guard_gps_tracking" OWNER TO "postgres";


COMMENT ON TABLE "public"."guard_gps_tracking" IS 'Real-time GPS location tracking for on-duty guards during shifts. Used for geofence monitoring, inactivity detection, and manager dashboard location tracking.';



COMMENT ON COLUMN "public"."guard_gps_tracking"."guard_id" IS 'Foreign key to employees table (guard)';



COMMENT ON COLUMN "public"."guard_gps_tracking"."latitude" IS 'Guard latitude (8 decimal places = ~1.1mm accuracy)';



COMMENT ON COLUMN "public"."guard_gps_tracking"."longitude" IS 'Guard longitude (8 decimal places = ~1.1mm accuracy)';



COMMENT ON COLUMN "public"."guard_gps_tracking"."accuracy_meters" IS 'GPS accuracy in meters (from device)';



COMMENT ON COLUMN "public"."guard_gps_tracking"."is_within_fence" IS 'Boolean flag indicating if guard is within assigned geofence';



COMMENT ON COLUMN "public"."guard_gps_tracking"."recorded_at" IS 'Timestamp when GPS reading was captured';



CREATE TABLE IF NOT EXISTS "public"."guard_panic_alerts" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "guard_id" "uuid" NOT NULL,
    "shift_id" "uuid",
    "latitude" numeric(10,8) NOT NULL,
    "longitude" numeric(11,8) NOT NULL,
    "status" "text" DEFAULT 'active'::"text",
    "triggered_at" timestamp with time zone DEFAULT "now"(),
    "acknowledged_at" timestamp with time zone,
    "acknowledged_by" "uuid",
    "resolved_at" timestamp with time zone,
    "resolved_by" "uuid",
    "resolution_notes" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "guard_panic_alerts_status_check" CHECK (("status" = ANY (ARRAY['active'::"text", 'acknowledged'::"text", 'resolved'::"text"])))
);


ALTER TABLE "public"."guard_panic_alerts" OWNER TO "postgres";


COMMENT ON TABLE "public"."guard_panic_alerts" IS 'SOS/Panic button activations from guards. Tracks GPS location, recipients (manager + residents via SMS/push), and resolution status.';



COMMENT ON COLUMN "public"."guard_panic_alerts"."status" IS 'Alert lifecycle: active (just triggered) -> acknowledged (manager confirmed) -> resolved (handled)';



COMMENT ON COLUMN "public"."guard_panic_alerts"."acknowledged_by" IS 'Manager/supervisor who acknowledged the alert';



COMMENT ON COLUMN "public"."guard_panic_alerts"."resolved_by" IS 'Manager/supervisor who marked alert as resolved';



CREATE TABLE IF NOT EXISTS "public"."guard_patrol_logs" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "guard_id" "uuid" NOT NULL,
    "patrol_start_time" timestamp with time zone NOT NULL,
    "patrol_end_time" timestamp with time zone,
    "patrol_route" "jsonb",
    "checkpoints_verified" integer,
    "total_checkpoints" integer,
    "anomalies_found" "text",
    "photos" "jsonb",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."guard_patrol_logs" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."holiday_master" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "holiday_date" "date" NOT NULL,
    "holiday_name" character varying(255) NOT NULL,
    "description" "text",
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."holiday_master" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."holidays" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "holiday_name" character varying(200) NOT NULL,
    "holiday_date" "date" NOT NULL,
    "holiday_type" character varying(50) DEFAULT 'national'::character varying,
    "payroll_impact" character varying(50) DEFAULT 'standard_off'::character varying,
    "description" "text",
    "is_active" boolean DEFAULT true,
    "year" integer NOT NULL,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid"
);


ALTER TABLE "public"."holidays" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."horticulture_seasonal_plans" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "plan_description" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "zone_id" "uuid",
    "season" "text",
    "start_date" "date",
    "end_date" "date",
    "status" "text" DEFAULT 'planned'::"text",
    "created_by" "uuid",
    CONSTRAINT "horticulture_seasonal_plans_status_check" CHECK (("status" = ANY (ARRAY['planned'::"text", 'in_progress'::"text", 'completed'::"text", 'cancelled'::"text"])))
);


ALTER TABLE "public"."horticulture_seasonal_plans" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."horticulture_tasks" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "zone_id" "uuid",
    "task_type" character varying(100) NOT NULL,
    "assigned_to" "uuid",
    "status" character varying(50) DEFAULT 'Scheduled'::character varying,
    "scheduled_date" "date",
    "completed_date" timestamp with time zone,
    "notes" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "plan_id" "uuid",
    "task_name" "text",
    "photo_evidence" "text"[] DEFAULT '{}'::"text"[],
    CONSTRAINT "horticulture_tasks_status_check" CHECK ((("status")::"text" = ANY ((ARRAY['pending'::character varying, 'in_progress'::character varying, 'completed'::character varying])::"text"[])))
);


ALTER TABLE "public"."horticulture_tasks" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."horticulture_zones" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "name" character varying(100) NOT NULL,
    "area_sqft" numeric(10,2),
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "location_id" "uuid",
    "plant_types" "text"[] DEFAULT '{}'::"text"[]
);


ALTER TABLE "public"."horticulture_zones" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."indent_items" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "indent_id" "uuid" NOT NULL,
    "product_id" "uuid",
    "item_description" "text",
    "specifications" "text",
    "requested_quantity" numeric(10,2) NOT NULL,
    "unit_of_measure" character varying(20) DEFAULT 'pcs'::character varying,
    "estimated_unit_price" bigint,
    "estimated_total" bigint,
    "approved_quantity" numeric(10,2),
    "notes" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "override_approved_by" "uuid",
    "override_reason" "text",
    "override_approved_at" timestamp with time zone
);


ALTER TABLE "public"."indent_items" OWNER TO "postgres";


COMMENT ON TABLE "public"."indent_items" IS 'Line items for indent requests';



CREATE SEQUENCE IF NOT EXISTS "public"."indent_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."indent_seq" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."indents" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "indent_number" character varying(20),
    "requester_id" "uuid" NOT NULL,
    "department" character varying(100),
    "location_id" "uuid",
    "society_id" "uuid",
    "title" character varying(200),
    "purpose" "text",
    "required_date" "date",
    "priority" character varying(20) DEFAULT 'normal'::character varying,
    "status" "public"."indent_status" DEFAULT 'draft'::"public"."indent_status" NOT NULL,
    "total_items" integer DEFAULT 0,
    "total_estimated_value" bigint DEFAULT 0,
    "submitted_at" timestamp with time zone,
    "submitted_by" "uuid",
    "approved_at" timestamp with time zone,
    "approved_by" "uuid",
    "approver_notes" "text",
    "rejected_at" timestamp with time zone,
    "rejected_by" "uuid",
    "rejection_reason" "text",
    "po_created_at" timestamp with time zone,
    "linked_po_id" "uuid",
    "notes" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid",
    "updated_by" "uuid",
    "service_request_id" "uuid",
    "supplier_id" "uuid",
    CONSTRAINT "indents_priority_check" CHECK ((("priority")::"text" = ANY ((ARRAY['low'::character varying, 'normal'::character varying, 'high'::character varying, 'urgent'::character varying])::"text"[])))
);


ALTER TABLE "public"."indents" OWNER TO "postgres";


COMMENT ON TABLE "public"."indents" IS 'Internal material requests before conversion to PO';



COMMENT ON COLUMN "public"."indents"."total_estimated_value" IS 'Sum of estimated_total from indent_items in paise';



CREATE TABLE IF NOT EXISTS "public"."societies" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "society_code" character varying(20) NOT NULL,
    "society_name" character varying(200) NOT NULL,
    "address" "text",
    "city" character varying(100),
    "state" character varying(100),
    "pincode" character varying(10),
    "total_buildings" integer,
    "total_flats" integer,
    "contact_person" character varying(100),
    "contact_phone" character varying(20),
    "contact_email" character varying(255),
    "society_manager_id" "uuid",
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."societies" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."indents_with_details" WITH ("security_invoker"='on') AS
 SELECT "i"."id",
    "i"."indent_number",
    "i"."requester_id",
    "i"."department",
    "i"."location_id",
    "i"."society_id",
    "i"."title",
    "i"."purpose",
    "i"."required_date",
    "i"."priority",
    "i"."status",
    "i"."total_items",
    "i"."total_estimated_value",
    "i"."submitted_at",
    "i"."submitted_by",
    "i"."approved_at",
    "i"."approved_by",
    "i"."approver_notes",
    "i"."rejected_at",
    "i"."rejected_by",
    "i"."rejection_reason",
    "i"."po_created_at",
    "i"."linked_po_id",
    "i"."notes",
    "i"."created_at",
    "i"."updated_at",
    "i"."created_by",
    "i"."updated_by",
    "e"."employee_code" AS "requester_code",
    ((("e"."first_name")::"text" || ' '::"text") || (COALESCE("e"."last_name", ''::character varying))::"text") AS "requester_name",
    "cl"."location_name",
    "s"."society_name",
    ( SELECT "count"(*) AS "count"
           FROM "public"."indent_items"
          WHERE ("indent_items"."indent_id" = "i"."id")) AS "item_count"
   FROM ((("public"."indents" "i"
     LEFT JOIN "public"."employees" "e" ON (("i"."requester_id" = "e"."id")))
     LEFT JOIN "public"."company_locations" "cl" ON (("i"."location_id" = "cl"."id")))
     LEFT JOIN "public"."societies" "s" ON (("i"."society_id" = "s"."id")));


ALTER VIEW "public"."indents_with_details" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."inventory" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "product_id" "uuid" NOT NULL,
    "location_id" "uuid",
    "quantity_on_hand" numeric(10,2) DEFAULT 0 NOT NULL,
    "reserved_quantity" numeric(10,2) DEFAULT 0,
    "reorder_level" numeric(10,2),
    "max_stock_level" numeric(10,2),
    "last_stock_date" "date",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."inventory" OWNER TO "postgres";


COMMENT ON TABLE "public"."inventory" IS 'Detailed inventory tracking by product and location';



CREATE TABLE IF NOT EXISTS "public"."job_materials_used" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "job_session_id" "uuid" NOT NULL,
    "product_id" "uuid" NOT NULL,
    "stock_batch_id" "uuid",
    "quantity" numeric(10,2) NOT NULL,
    "unit_cost" numeric(10,2),
    "notes" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid"
);


ALTER TABLE "public"."job_materials_used" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."job_photos" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "job_session_id" "uuid" NOT NULL,
    "photo_type" character varying(20) NOT NULL,
    "photo_url" "text" NOT NULL,
    "caption" "text",
    "latitude" numeric(10,8),
    "longitude" numeric(11,8),
    "captured_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "is_important" boolean DEFAULT false
);


ALTER TABLE "public"."job_photos" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."job_sessions" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "service_request_id" "uuid" NOT NULL,
    "technician_id" "uuid" NOT NULL,
    "start_time" timestamp with time zone,
    "end_time" timestamp with time zone,
    "start_latitude" numeric(10,8),
    "start_longitude" numeric(11,8),
    "end_latitude" numeric(10,8),
    "end_longitude" numeric(11,8),
    "status" "public"."job_session_status" DEFAULT 'started'::"public"."job_session_status",
    "work_performed" "text",
    "remarks" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."job_sessions" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."leave_applications" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "employee_id" "uuid" NOT NULL,
    "leave_type_id" "uuid" NOT NULL,
    "from_date" "date" NOT NULL,
    "to_date" "date" NOT NULL,
    "number_of_days" numeric(3,1) NOT NULL,
    "reason" "text" NOT NULL,
    "status" character varying(20) DEFAULT 'pending'::character varying,
    "approved_by" "uuid",
    "approved_at" timestamp with time zone,
    "rejection_reason" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."leave_applications" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."leave_types" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "leave_type" "public"."leave_type_enum" NOT NULL,
    "leave_name" character varying(100) NOT NULL,
    "yearly_quota" integer NOT NULL,
    "can_carry_forward" boolean DEFAULT false,
    "max_carry_forward" integer DEFAULT 0,
    "requires_approval" boolean DEFAULT true,
    "description" "text",
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."leave_types" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."login_rate_limits" (
    "ip_address" "inet" NOT NULL,
    "attempt_count" integer DEFAULT 1,
    "first_attempt_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "blocked_until" timestamp with time zone,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."login_rate_limits" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."material_arrival_evidence" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "po_id" "uuid",
    "photo_url" "text" NOT NULL,
    "signature_url" "text",
    "vehicle_number" "text",
    "driver_name" "text",
    "arrival_status" "text" DEFAULT 'arrived'::"text",
    "logged_by" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "gate_location" "text",
    "notes" "text",
    CONSTRAINT "arrival_requires_photo" CHECK (("photo_url" IS NOT NULL)),
    CONSTRAINT "material_arrival_evidence_arrival_status_check" CHECK (("arrival_status" = ANY (ARRAY['arrived'::"text", 'completed'::"text"])))
);


ALTER TABLE "public"."material_arrival_evidence" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."material_arrival_logs" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "po_id" "uuid" NOT NULL,
    "vehicle_number" "text" NOT NULL,
    "arrival_photo_url" "text" NOT NULL,
    "arrival_signature_url" "text",
    "logged_by" "uuid" NOT NULL,
    "logged_at" timestamp with time zone DEFAULT "now"(),
    "gate_location" "text",
    "notes" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "material_arrival_logs_vehicle_number_check" CHECK (("length"("vehicle_number") >= 4))
);


ALTER TABLE "public"."material_arrival_logs" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."material_receipt_items" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "material_receipt_id" "uuid" NOT NULL,
    "po_item_id" "uuid",
    "product_id" "uuid",
    "item_description" "text",
    "ordered_quantity" numeric(10,2),
    "received_quantity" numeric(10,2) NOT NULL,
    "accepted_quantity" numeric(10,2),
    "rejected_quantity" numeric(10,2) DEFAULT 0,
    "quality_status" "public"."grn_item_quality_status" DEFAULT 'accepted'::"public"."grn_item_quality_status",
    "rejection_reason" "text",
    "unit_price" bigint,
    "line_total" bigint,
    "unmatched_qty" numeric(10,2),
    "unmatched_amount" bigint,
    "batch_number" character varying(50),
    "expiry_date" "date",
    "notes" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "material_receipt_items_quantity_coherence" CHECK (((("accepted_quantity" IS NULL) OR ("accepted_quantity" >= (0)::numeric)) AND (("rejected_quantity" IS NULL) OR ("rejected_quantity" >= (0)::numeric)) AND ("received_quantity" >= (0)::numeric) AND ((COALESCE("accepted_quantity", (0)::numeric) + COALESCE("rejected_quantity", (0)::numeric)) <= "received_quantity")))
);


ALTER TABLE "public"."material_receipt_items" OWNER TO "postgres";


COMMENT ON TABLE "public"."material_receipt_items" IS 'Line items for material receipts';



CREATE TABLE IF NOT EXISTS "public"."material_receipts" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "grn_number" character varying(20),
    "purchase_order_id" "uuid",
    "supplier_id" "uuid",
    "received_date" "date" DEFAULT CURRENT_DATE NOT NULL,
    "received_by" "uuid",
    "warehouse_id" "uuid",
    "status" "public"."grn_status" DEFAULT 'draft'::"public"."grn_status" NOT NULL,
    "quality_checked_by" "uuid",
    "quality_checked_at" timestamp with time zone,
    "total_received_value" bigint DEFAULT 0,
    "delivery_challan_number" character varying(100),
    "vehicle_number" character varying(50),
    "notes" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid",
    "updated_by" "uuid"
);


ALTER TABLE "public"."material_receipts" OWNER TO "postgres";


COMMENT ON TABLE "public"."material_receipts" IS 'Goods Received Notes (GRN) for received materials';



CREATE TABLE IF NOT EXISTS "public"."purchase_orders" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "po_number" character varying(20),
    "indent_id" "uuid",
    "supplier_id" "uuid",
    "po_date" "date" DEFAULT CURRENT_DATE NOT NULL,
    "expected_delivery_date" "date",
    "status" "public"."po_status" DEFAULT 'draft'::"public"."po_status" NOT NULL,
    "shipping_address" "text",
    "billing_address" "text",
    "subtotal" bigint DEFAULT 0,
    "tax_amount" bigint DEFAULT 0,
    "discount_amount" bigint DEFAULT 0,
    "shipping_cost" bigint DEFAULT 0,
    "grand_total" bigint DEFAULT 0,
    "payment_terms" "text",
    "sent_to_vendor_at" timestamp with time zone,
    "vendor_acknowledged_at" timestamp with time zone,
    "notes" "text",
    "terms_and_conditions" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid",
    "updated_by" "uuid",
    "dispatched_at" timestamp with time zone,
    "vehicle_details" "text",
    "dispatch_notes" "text",
    "md_action" "text",
    "md_approved_at" timestamp with time zone,
    "md_approved_by" "uuid",
    CONSTRAINT "purchase_orders_md_action_check" CHECK (("md_action" = ANY (ARRAY['approved'::"text", 'rejected'::"text"])))
);


ALTER TABLE "public"."purchase_orders" OWNER TO "postgres";


COMMENT ON TABLE "public"."purchase_orders" IS 'Purchase orders sent to suppliers';



COMMENT ON COLUMN "public"."purchase_orders"."grand_total" IS 'Total PO value including tax, minus discounts, plus shipping in paise';



CREATE TABLE IF NOT EXISTS "public"."warehouses" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "warehouse_code" character varying(20) NOT NULL,
    "warehouse_name" character varying(200) NOT NULL,
    "location_id" "uuid",
    "society_id" "uuid",
    "manager_id" "uuid",
    "phone" character varying(20),
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid"
);


ALTER TABLE "public"."warehouses" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."material_receipts_with_details" WITH ("security_invoker"='on') AS
 SELECT "mr"."id",
    "mr"."grn_number",
    "mr"."purchase_order_id",
    "mr"."supplier_id",
    "mr"."received_date",
    "mr"."received_by",
    "mr"."warehouse_id",
    "mr"."status",
    "mr"."quality_checked_by",
    "mr"."quality_checked_at",
    "mr"."total_received_value",
    "mr"."delivery_challan_number",
    "mr"."vehicle_number",
    "mr"."notes",
    "mr"."created_at",
    "mr"."updated_at",
    "mr"."created_by",
    "mr"."updated_by",
    "po"."po_number",
    "sup"."supplier_name",
    "w"."warehouse_name",
    ((("e"."first_name")::"text" || ' '::"text") || (COALESCE("e"."last_name", ''::character varying))::"text") AS "received_by_name",
    ( SELECT "count"(*) AS "count"
           FROM "public"."material_receipt_items"
          WHERE ("material_receipt_items"."material_receipt_id" = "mr"."id")) AS "item_count"
   FROM (((("public"."material_receipts" "mr"
     LEFT JOIN "public"."purchase_orders" "po" ON (("mr"."purchase_order_id" = "po"."id")))
     LEFT JOIN "public"."suppliers" "sup" ON (("mr"."supplier_id" = "sup"."id")))
     LEFT JOIN "public"."warehouses" "w" ON (("mr"."warehouse_id" = "w"."id")))
     LEFT JOIN "public"."employees" "e" ON (("mr"."received_by" = "e"."id")));


ALTER VIEW "public"."material_receipts_with_details" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."notification_logs" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "user_id" "uuid",
    "channel" character varying(20) NOT NULL,
    "recipient_phone" character varying(20),
    "status" character varying(20) NOT NULL,
    "error_message" "text",
    "sent_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "notification_id" "uuid"
);


ALTER TABLE "public"."notification_logs" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."notifications" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "notification_type" character varying(50) NOT NULL,
    "title" character varying(200) NOT NULL,
    "message" "text" NOT NULL,
    "reference_type" character varying(50),
    "reference_id" "uuid",
    "is_read" boolean DEFAULT false,
    "read_at" timestamp with time zone,
    "priority" character varying(20) DEFAULT 'normal'::character varying,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "data" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    "delivery_state" "text" DEFAULT 'created'::"text" NOT NULL,
    "fallback_state" "text" DEFAULT 'not_applicable'::"text" NOT NULL,
    "delivered_at" timestamp with time zone,
    "sms_fallback_at" timestamp with time zone,
    "action_url" "text"
);


ALTER TABLE "public"."notifications" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."oversight_ticket_seq"
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."oversight_ticket_seq" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."oversight_tickets" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "ticket_number" "text",
    "ticket_type" "text" NOT NULL,
    "material_issue_type" "text",
    "source_visitor_id" "uuid",
    "parent_ticket_id" "uuid",
    "linked_employee_id" "uuid",
    "subject_name" "text" NOT NULL,
    "category" "text" NOT NULL,
    "severity" "text" DEFAULT 'medium'::"text" NOT NULL,
    "status" "text" DEFAULT 'open'::"text" NOT NULL,
    "note" "text" NOT NULL,
    "evidence_urls" "jsonb" DEFAULT '[]'::"jsonb" NOT NULL,
    "batch_number" "text",
    "ordered_quantity" numeric,
    "received_quantity" numeric,
    "shortage_quantity" numeric,
    "return_quantity" numeric,
    "inspection_outcome" "text",
    "location_name" "text",
    "acknowledged_at" timestamp with time zone,
    "acknowledged_by" "uuid",
    "resolved_at" timestamp with time zone,
    "resolved_by" "uuid",
    "resolution_notes" "text",
    "created_by" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "oversight_tickets_inspection_outcome_check" CHECK ((("inspection_outcome" IS NULL) OR ("inspection_outcome" = ANY (ARRAY['approved'::"text", 'rejected'::"text"])))),
    CONSTRAINT "oversight_tickets_material_issue_type_check" CHECK ((("material_issue_type" IS NULL) OR ("material_issue_type" = ANY (ARRAY['quality'::"text", 'quantity'::"text"])))),
    CONSTRAINT "oversight_tickets_severity_check" CHECK (("severity" = ANY (ARRAY['low'::"text", 'medium'::"text", 'high'::"text", 'critical'::"text"]))),
    CONSTRAINT "oversight_tickets_status_check" CHECK (("status" = ANY (ARRAY['open'::"text", 'acknowledged'::"text", 'closed'::"text"]))),
    CONSTRAINT "oversight_tickets_ticket_type_check" CHECK (("ticket_type" = ANY (ARRAY['behavior'::"text", 'material'::"text", 'return'::"text"])))
);


ALTER TABLE "public"."oversight_tickets" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."panic_alerts" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "guard_id" "uuid" NOT NULL,
    "alert_type" "public"."alert_type" NOT NULL,
    "location_id" "uuid",
    "latitude" numeric(10,8),
    "longitude" numeric(11,8),
    "alert_time" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "description" "text",
    "is_resolved" boolean DEFAULT false,
    "resolved_at" timestamp with time zone,
    "resolved_by" "uuid",
    "resolution_notes" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "photo_url" "text",
    "acknowledged_at" timestamp with time zone,
    "acknowledged_by" "uuid",
    "acknowledged_notes" "text",
    "streaming_active" boolean DEFAULT false NOT NULL,
    "metadata" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL
);


ALTER TABLE "public"."panic_alerts" OWNER TO "postgres";


COMMENT ON COLUMN "public"."panic_alerts"."resolved_by" IS 'Employee ID who resolved this alert';



CREATE TABLE IF NOT EXISTS "public"."payment_methods" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "method_name" character varying(50) NOT NULL,
    "gateway" "public"."payment_gateway" DEFAULT 'manual'::"public"."payment_gateway",
    "is_active" boolean DEFAULT true,
    "config" "jsonb" DEFAULT '{}'::"jsonb",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."payment_methods" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."payment_num_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."payment_num_seq" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."payments" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "payment_number" character varying(50),
    "payment_type" character varying(20) NOT NULL,
    "reference_type" character varying(50) NOT NULL,
    "reference_id" "uuid",
    "payer_type" character varying(50),
    "payer_id" "uuid",
    "payee_type" character varying(50),
    "payee_id" "uuid",
    "payment_date" "date" DEFAULT CURRENT_DATE NOT NULL,
    "payment_method_id" "uuid",
    "amount" numeric(15,2) NOT NULL,
    "currency" character varying(3) DEFAULT 'INR'::character varying,
    "external_id" character varying(100),
    "gateway_log" "jsonb" DEFAULT '{}'::"jsonb",
    "failure_reason" "text",
    "status" character varying(20) DEFAULT 'pending'::character varying,
    "processed_by" "uuid",
    "notes" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "evidence_url" "text"
);


ALTER TABLE "public"."payments" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."payroll_cycles" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "cycle_code" character varying(20) NOT NULL,
    "period_month" integer NOT NULL,
    "period_year" integer NOT NULL,
    "period_start" "date" NOT NULL,
    "period_end" "date" NOT NULL,
    "total_working_days" integer NOT NULL,
    "status" "public"."payroll_cycle_status" DEFAULT 'draft'::"public"."payroll_cycle_status" NOT NULL,
    "computed_at" timestamp with time zone,
    "computed_by" "uuid",
    "approved_at" timestamp with time zone,
    "approved_by" "uuid",
    "disbursed_at" timestamp with time zone,
    "disbursed_by" "uuid",
    "total_employees" integer DEFAULT 0,
    "total_gross" numeric(14,2) DEFAULT 0,
    "total_deductions" numeric(14,2) DEFAULT 0,
    "total_net" numeric(14,2) DEFAULT 0,
    "notes" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid",
    "updated_by" "uuid",
    CONSTRAINT "payroll_cycles_period_month_check" CHECK ((("period_month" >= 1) AND ("period_month" <= 12))),
    CONSTRAINT "payroll_cycles_period_year_check" CHECK (("period_year" >= 2020))
);


ALTER TABLE "public"."payroll_cycles" OWNER TO "postgres";


COMMENT ON TABLE "public"."payroll_cycles" IS 'Monthly payroll run management';



CREATE SEQUENCE IF NOT EXISTS "public"."payslip_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."payslip_seq" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."payslips" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "payslip_number" character varying(30),
    "payroll_cycle_id" "uuid" NOT NULL,
    "employee_id" "uuid" NOT NULL,
    "present_days" numeric(6,2) DEFAULT 0 NOT NULL,
    "absent_days" numeric(6,2) DEFAULT 0 NOT NULL,
    "leave_days" numeric(6,2) DEFAULT 0 NOT NULL,
    "overtime_hours" numeric(6,2) DEFAULT 0 NOT NULL,
    "basic_salary" numeric(12,2) DEFAULT 0 NOT NULL,
    "pro_rated_basic" numeric(12,2) DEFAULT 0 NOT NULL,
    "hra" numeric(12,2) DEFAULT 0 NOT NULL,
    "special_allowance" numeric(12,2) DEFAULT 0 NOT NULL,
    "travel_allowance" numeric(12,2) DEFAULT 0 NOT NULL,
    "medical_allowance" numeric(12,2) DEFAULT 0 NOT NULL,
    "overtime_amount" numeric(12,2) DEFAULT 0 NOT NULL,
    "bonus" numeric(12,2) DEFAULT 0 NOT NULL,
    "other_earnings" numeric(12,2) DEFAULT 0 NOT NULL,
    "gross_salary" numeric(12,2) DEFAULT 0 NOT NULL,
    "pf_deduction" numeric(12,2) DEFAULT 0 NOT NULL,
    "esic_deduction" numeric(12,2) DEFAULT 0 NOT NULL,
    "professional_tax" numeric(12,2) DEFAULT 0 NOT NULL,
    "tds" numeric(12,2) DEFAULT 0 NOT NULL,
    "loan_recovery" numeric(12,2) DEFAULT 0 NOT NULL,
    "advance_recovery" numeric(12,2) DEFAULT 0 NOT NULL,
    "other_deductions" numeric(12,2) DEFAULT 0 NOT NULL,
    "total_deductions" numeric(12,2) DEFAULT 0 NOT NULL,
    "net_payable" numeric(12,2) DEFAULT 0 NOT NULL,
    "employer_pf" numeric(12,2) DEFAULT 0 NOT NULL,
    "employer_esic" numeric(12,2) DEFAULT 0 NOT NULL,
    "bank_account_number" character varying(30),
    "bank_ifsc" character varying(20),
    "payment_mode" character varying(20),
    "payment_reference" character varying(100),
    "paid_at" timestamp with time zone,
    "status" "public"."payslip_status" DEFAULT 'draft'::"public"."payslip_status" NOT NULL,
    "notes" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid",
    "updated_by" "uuid"
);


ALTER TABLE "public"."payslips" OWNER TO "postgres";


COMMENT ON TABLE "public"."payslips" IS 'Individual employee salary records with attendance-based calculation';



COMMENT ON COLUMN "public"."payslips"."pro_rated_basic" IS 'Basic salary adjusted for attendance: (basic × present_days / total_working_days)';



COMMENT ON COLUMN "public"."payslips"."gross_salary" IS 'pro_rated_basic + hra + allowances + overtime + bonus';



COMMENT ON COLUMN "public"."payslips"."net_payable" IS 'gross_salary - total_deductions';



CREATE OR REPLACE VIEW "public"."payslips_with_details" WITH ("security_invoker"='on') AS
 SELECT "ps"."id",
    "ps"."payslip_number",
    "ps"."payroll_cycle_id",
    "ps"."employee_id",
    "ps"."present_days",
    "ps"."absent_days",
    "ps"."leave_days",
    "ps"."overtime_hours",
    "ps"."basic_salary",
    "ps"."pro_rated_basic",
    "ps"."hra",
    "ps"."special_allowance",
    "ps"."travel_allowance",
    "ps"."medical_allowance",
    "ps"."overtime_amount",
    "ps"."bonus",
    "ps"."other_earnings",
    "ps"."gross_salary",
    "ps"."pf_deduction",
    "ps"."esic_deduction",
    "ps"."professional_tax",
    "ps"."tds",
    "ps"."loan_recovery",
    "ps"."advance_recovery",
    "ps"."other_deductions",
    "ps"."total_deductions",
    "ps"."net_payable",
    "ps"."employer_pf",
    "ps"."employer_esic",
    "ps"."bank_account_number",
    "ps"."bank_ifsc",
    "ps"."payment_mode",
    "ps"."payment_reference",
    "ps"."paid_at",
    "ps"."status",
    "ps"."notes",
    "ps"."created_at",
    "ps"."updated_at",
    "ps"."created_by",
    "ps"."updated_by",
    "e"."employee_code",
    ((("e"."first_name")::"text" || ' '::"text") || ("e"."last_name")::"text") AS "employee_name",
    "e"."department",
    "pc"."cycle_code",
    "pc"."period_month",
    "pc"."period_year",
    "pc"."total_working_days"
   FROM (("public"."payslips" "ps"
     JOIN "public"."employees" "e" ON (("ps"."employee_id" = "e"."id")))
     JOIN "public"."payroll_cycles" "pc" ON (("ps"."payroll_cycle_id" = "pc"."id")));


ALTER VIEW "public"."payslips_with_details" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."personnel_dispatch_seq"
    START WITH 1001
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."personnel_dispatch_seq" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."personnel_dispatches" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "dispatch_number" character varying(50) NOT NULL,
    "service_po_id" "uuid" NOT NULL,
    "supplier_id" "uuid" NOT NULL,
    "personnel_json" "jsonb" DEFAULT '[]'::"jsonb" NOT NULL,
    "dispatch_date" "date" DEFAULT CURRENT_DATE NOT NULL,
    "deployment_site_id" "uuid",
    "status" character varying(20) DEFAULT 'dispatched'::character varying NOT NULL,
    "confirmed_by" "uuid",
    "confirmed_at" timestamp with time zone,
    "notes" "text",
    "created_by" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "employee_id" "uuid",
    "start_date" "date" DEFAULT CURRENT_DATE NOT NULL,
    "end_date" "date"
);


ALTER TABLE "public"."personnel_dispatches" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."pest_control_chemicals" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "product_id" "uuid" NOT NULL,
    "current_stock" numeric(15,2) DEFAULT 0 NOT NULL,
    "unit" character varying(20) DEFAULT 'liters'::character varying NOT NULL,
    "reorder_level" numeric(15,2) DEFAULT 5 NOT NULL,
    "last_restocked_at" timestamp with time zone,
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid",
    "updated_by" "uuid",
    "expiry_date" "date",
    "batch_number" character varying(50)
);


ALTER TABLE "public"."pest_control_chemicals" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."pest_control_ppe_verifications" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "technician_id" "uuid" NOT NULL,
    "service_request_id" "uuid",
    "items_json" "jsonb" NOT NULL,
    "status" character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    "site_readiness_report" "text",
    "verified_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid",
    "job_session_id" "uuid",
    "checklist" "jsonb",
    "all_items_checked" boolean DEFAULT false,
    "gloves_worn" boolean DEFAULT false,
    "mask_worn" boolean DEFAULT false,
    "goggles_worn" boolean DEFAULT false,
    "full_suit_worn" boolean DEFAULT false,
    "chemical_dilution_verified" boolean DEFAULT false,
    "resident_area_cleared" boolean DEFAULT false
);


ALTER TABLE "public"."pest_control_ppe_verifications" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."pest_control_spill_kits" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "kit_code" character varying(50) NOT NULL,
    "location_id" "uuid",
    "items_json" "jsonb" DEFAULT '[]'::"jsonb" NOT NULL,
    "last_inspected_at" timestamp with time zone,
    "inspected_by" "uuid",
    "status" character varying(20) DEFAULT 'ok'::character varying NOT NULL,
    "notes" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."pest_control_spill_kits" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."po_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."po_seq" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."printing_ad_bookings" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "booking_number" character varying(50) NOT NULL,
    "ad_space_id" "uuid" NOT NULL,
    "advertiser_name" character varying(200) NOT NULL,
    "start_date" "date" NOT NULL,
    "end_date" "date" NOT NULL,
    "agreed_rate_paise" bigint DEFAULT 0 NOT NULL,
    "creative_url" "text",
    "status" character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    "approved_by" "uuid",
    "approved_at" timestamp with time zone,
    "notes" "text",
    "created_by" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."printing_ad_bookings" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."printing_ad_spaces" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "space_name" character varying(100) NOT NULL,
    "location_description" "text",
    "asset_id" "uuid",
    "dimensions" character varying(50),
    "base_rate_paise" integer DEFAULT 0 NOT NULL,
    "status" character varying(20) DEFAULT 'available'::character varying NOT NULL,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid",
    "updated_by" "uuid"
);


ALTER TABLE "public"."printing_ad_spaces" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."product_categories" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "category_name" character varying(255) NOT NULL,
    "description" "text",
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "category_code" character varying(20),
    "parent_category_id" "uuid",
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "created_by" "uuid",
    "updated_by" "uuid"
);


ALTER TABLE "public"."product_categories" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."product_subcategories" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "category_id" "uuid",
    "subcategory_name" character varying(255) NOT NULL,
    "description" "text",
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "subcategory_code" character varying(20),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "created_by" "uuid",
    "updated_by" "uuid"
);


ALTER TABLE "public"."product_subcategories" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."purchase_bill_items" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "purchase_bill_id" "uuid" NOT NULL,
    "po_item_id" "uuid",
    "grn_item_id" "uuid",
    "product_id" "uuid",
    "item_description" "text",
    "billed_quantity" numeric(10,2) NOT NULL,
    "unit_of_measure" character varying(20) DEFAULT 'pcs'::character varying,
    "unit_price" bigint NOT NULL,
    "tax_rate" numeric(5,2) DEFAULT 0,
    "tax_amount" bigint DEFAULT 0,
    "discount_amount" bigint DEFAULT 0,
    "line_total" bigint NOT NULL,
    "unmatched_qty" numeric(10,2),
    "unmatched_amount" bigint,
    "notes" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."purchase_bill_items" OWNER TO "postgres";


COMMENT ON TABLE "public"."purchase_bill_items" IS 'Line items for supplier bills';



CREATE SEQUENCE IF NOT EXISTS "public"."purchase_bill_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."purchase_bill_seq" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."purchase_bills" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "bill_number" character varying(30),
    "supplier_invoice_number" character varying(100),
    "purchase_order_id" "uuid",
    "material_receipt_id" "uuid",
    "supplier_id" "uuid",
    "bill_date" "date" DEFAULT CURRENT_DATE NOT NULL,
    "due_date" "date",
    "status" "text" DEFAULT 'draft'::"text",
    "payment_status" "text" DEFAULT 'unpaid'::"text",
    "subtotal" bigint DEFAULT 0,
    "tax_amount" bigint DEFAULT 0,
    "discount_amount" bigint DEFAULT 0,
    "total_amount" bigint DEFAULT 0 NOT NULL,
    "paid_amount" bigint DEFAULT 0,
    "due_amount" bigint DEFAULT 0,
    "last_payment_date" "date",
    "notes" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid",
    "updated_by" "uuid",
    "budget_id" "uuid",
    "external_id" character varying(100),
    "gateway_log" "jsonb" DEFAULT '{}'::"jsonb",
    "failure_reason" "text",
    "is_reconciled" boolean DEFAULT false,
    "reconciled_at" timestamp with time zone,
    "reconciled_by" "uuid",
    "match_status" "text" DEFAULT 'pending'::"text",
    "service_purchase_order_id" "uuid",
    CONSTRAINT "purchase_bills_payment_status_check" CHECK (("payment_status" = ANY (ARRAY['unpaid'::"text", 'partial'::"text", 'paid'::"text"]))),
    CONSTRAINT "purchase_bills_status_check" CHECK (("status" = ANY (ARRAY['draft'::"text", 'submitted'::"text", 'approved'::"text", 'disputed'::"text"])))
);


ALTER TABLE "public"."purchase_bills" OWNER TO "postgres";


COMMENT ON TABLE "public"."purchase_bills" IS 'Supplier bills/invoices for payment';



COMMENT ON COLUMN "public"."purchase_bills"."due_amount" IS 'total_amount - paid_amount, auto-calculated';



CREATE OR REPLACE VIEW "public"."purchase_bills_with_details" WITH ("security_invoker"='on') AS
 SELECT "pb"."id",
    "pb"."bill_number",
    "pb"."supplier_invoice_number",
    "pb"."purchase_order_id",
    "pb"."material_receipt_id",
    "pb"."supplier_id",
    "pb"."bill_date",
    "pb"."due_date",
    "pb"."status",
    "pb"."payment_status",
    "pb"."subtotal",
    "pb"."tax_amount",
    "pb"."discount_amount",
    "pb"."total_amount",
    "pb"."paid_amount",
    "pb"."due_amount",
    "pb"."last_payment_date",
    "pb"."notes",
    "pb"."created_at",
    "pb"."updated_at",
    "pb"."created_by",
    "pb"."updated_by",
    "sup"."supplier_name",
    "po"."po_number",
    "mr"."grn_number"
   FROM ((("public"."purchase_bills" "pb"
     LEFT JOIN "public"."suppliers" "sup" ON (("pb"."supplier_id" = "sup"."id")))
     LEFT JOIN "public"."purchase_orders" "po" ON (("pb"."purchase_order_id" = "po"."id")))
     LEFT JOIN "public"."material_receipts" "mr" ON (("pb"."material_receipt_id" = "mr"."id")));


ALTER VIEW "public"."purchase_bills_with_details" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."purchase_order_items" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "purchase_order_id" "uuid" NOT NULL,
    "indent_item_id" "uuid",
    "product_id" "uuid",
    "item_description" "text",
    "specifications" "text",
    "ordered_quantity" numeric(10,2) NOT NULL,
    "unit_of_measure" character varying(20) DEFAULT 'pcs'::character varying,
    "received_quantity" numeric(10,2) DEFAULT 0,
    "unit_price" bigint NOT NULL,
    "tax_rate" numeric(5,2) DEFAULT 0,
    "tax_amount" bigint DEFAULT 0,
    "discount_percent" numeric(5,2) DEFAULT 0,
    "discount_amount" bigint DEFAULT 0,
    "line_total" bigint NOT NULL,
    "unmatched_qty" numeric(10,2),
    "unmatched_amount" bigint,
    "notes" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."purchase_order_items" OWNER TO "postgres";


COMMENT ON TABLE "public"."purchase_order_items" IS 'Line items for purchase orders';



CREATE OR REPLACE VIEW "public"."purchase_orders_with_details" WITH ("security_invoker"='on') AS
 SELECT "po"."id",
    "po"."po_number",
    "po"."indent_id",
    "po"."supplier_id",
    "po"."po_date",
    "po"."expected_delivery_date",
    "po"."status",
    "po"."shipping_address",
    "po"."billing_address",
    "po"."subtotal",
    "po"."tax_amount",
    "po"."discount_amount",
    "po"."shipping_cost",
    "po"."grand_total",
    "po"."payment_terms",
    "po"."sent_to_vendor_at",
    "po"."vendor_acknowledged_at",
    "po"."notes",
    "po"."terms_and_conditions",
    "po"."created_at",
    "po"."updated_at",
    "po"."created_by",
    "po"."updated_by",
    "sup"."supplier_name",
    "i"."indent_number",
    ( SELECT "count"(*) AS "count"
           FROM "public"."purchase_order_items"
          WHERE ("purchase_order_items"."purchase_order_id" = "po"."id")) AS "item_count"
   FROM (("public"."purchase_orders" "po"
     LEFT JOIN "public"."suppliers" "sup" ON (("po"."supplier_id" = "sup"."id")))
     LEFT JOIN "public"."indents" "i" ON (("po"."indent_id" = "i"."id")));


ALTER VIEW "public"."purchase_orders_with_details" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."push_tokens" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "token" "text" NOT NULL,
    "token_type" character varying(20) DEFAULT 'fcm'::character varying,
    "device_type" character varying(50),
    "last_used" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."push_tokens" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."qr_batch_logs" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "batch_id" "text" NOT NULL,
    "society_id" "uuid" NOT NULL,
    "warehouse_id" "uuid",
    "count" integer NOT NULL,
    "generated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "generated_by" "uuid",
    "notes" "text",
    "downloaded_at" timestamp with time zone,
    "download_count" integer DEFAULT 0
);


ALTER TABLE "public"."qr_batch_logs" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."qr_codes_with_batch_info" WITH ("security_invoker"='on') AS
 SELECT "qc"."id",
    "qc"."asset_id",
    "qc"."society_id",
    "qc"."claimed_by",
    "qc"."claimed_at",
    "qc"."version",
    "qc"."print_batch_id",
    "qc"."is_active",
    "qc"."created_at",
    "qc"."created_by",
    "qc"."batch_id",
    "qc"."sequence_number",
    "qc"."is_linked",
    "qc"."warehouse_id",
    "qb"."generated_at" AS "batch_generated_at",
    "qb"."generated_by" AS "batch_generated_by",
    COALESCE(("u"."full_name")::"text", 'Unknown'::"text") AS "generated_by_name",
    "qb"."count" AS "batch_count",
    "a"."name" AS "linked_asset_name",
    "a"."asset_code" AS "linked_asset_tag",
    "w"."warehouse_name"
   FROM (((("public"."qr_codes" "qc"
     LEFT JOIN "public"."qr_batch_logs" "qb" ON (("qc"."batch_id" = "qb"."batch_id")))
     LEFT JOIN "public"."users" "u" ON (("qb"."generated_by" = "u"."id")))
     LEFT JOIN "public"."assets" "a" ON (("qc"."asset_id" = "a"."id")))
     LEFT JOIN "public"."warehouses" "w" ON (("qc"."warehouse_id" = "w"."id")));


ALTER VIEW "public"."qr_codes_with_batch_info" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."qr_scans" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "qr_id" "uuid" NOT NULL,
    "scanned_by" "uuid",
    "latitude" numeric(10,8),
    "longitude" numeric(11,8),
    "user_agent" "text",
    "ip_address" "inet",
    "scanned_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."qr_scans" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."reconciliation_lines" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "reconciliation_id" "uuid" NOT NULL,
    "po_item_id" "uuid",
    "grn_item_id" "uuid",
    "bill_item_id" "uuid",
    "product_id" "uuid",
    "matched_qty" numeric(10,2) DEFAULT 0 NOT NULL,
    "matched_amount" bigint DEFAULT 0 NOT NULL,
    "po_unit_price" bigint,
    "grn_unit_price" bigint,
    "bill_unit_price" bigint,
    "unit_price_variance" bigint DEFAULT 0,
    "qty_ordered" numeric(10,2),
    "qty_received" numeric(10,2),
    "qty_billed" numeric(10,2),
    "qty_variance" numeric(10,2) DEFAULT 0,
    "match_type" "text" NOT NULL,
    "status" "text" DEFAULT 'pending'::"text",
    "resolution_notes" "text",
    "resolved_at" timestamp with time zone,
    "resolved_by" "uuid",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "reconciliation_lines_match_type_check" CHECK (("match_type" = ANY (ARRAY['PO_GRN'::"text", 'GRN_BILL'::"text", 'PO_BILL'::"text", 'THREE_WAY'::"text"]))),
    CONSTRAINT "reconciliation_lines_status_check" CHECK (("status" = ANY (ARRAY['pending'::"text", 'matched'::"text", 'variance'::"text", 'resolved'::"text"])))
);


ALTER TABLE "public"."reconciliation_lines" OWNER TO "postgres";


COMMENT ON TABLE "public"."reconciliation_lines" IS 'Line-item level three-way matching for PO/GRN/Bill reconciliation - from bs_reconcile pattern';



COMMENT ON COLUMN "public"."reconciliation_lines"."matched_amount" IS 'Matched amount in paise';



COMMENT ON COLUMN "public"."reconciliation_lines"."unit_price_variance" IS 'bill_price - po_price in paise';



COMMENT ON COLUMN "public"."reconciliation_lines"."match_type" IS 'Type of match: PO_GRN, GRN_BILL, PO_BILL, or THREE_WAY';



CREATE TABLE IF NOT EXISTS "public"."reconciliations" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "reconciliation_number" character varying(20),
    "purchase_bill_id" "uuid",
    "purchase_order_id" "uuid",
    "material_receipt_id" "uuid",
    "bill_amount" numeric(14,2),
    "po_amount" numeric(14,2),
    "grn_amount" numeric(14,2),
    "bill_po_variance" numeric(14,2),
    "bill_grn_variance" numeric(14,2),
    "po_grn_variance" numeric(14,2),
    "status" "public"."reconciliation_status" DEFAULT 'pending'::"public"."reconciliation_status" NOT NULL,
    "discrepancy_type" character varying(100),
    "discrepancy_notes" "text",
    "resolution_action" character varying(100),
    "resolution_notes" "text",
    "resolved_at" timestamp with time zone,
    "resolved_by" "uuid",
    "adjusted_amount" numeric(14,2),
    "adjustment_reason" "text",
    "notes" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid",
    "updated_by" "uuid"
);


ALTER TABLE "public"."reconciliations" OWNER TO "postgres";


COMMENT ON TABLE "public"."reconciliations" IS 'Three-way Bill/PO/GRN matching records';



COMMENT ON COLUMN "public"."reconciliations"."bill_po_variance" IS 'Difference between bill amount and PO amount';



COMMENT ON COLUMN "public"."reconciliations"."bill_grn_variance" IS 'Difference between bill amount and GRN received value';



COMMENT ON COLUMN "public"."reconciliations"."po_grn_variance" IS 'Difference between PO amount and GRN received value';



CREATE OR REPLACE VIEW "public"."reconciliation_lines_with_details" WITH ("security_invoker"='on') AS
 SELECT "rl"."id",
    "rl"."reconciliation_id",
    "rl"."po_item_id",
    "rl"."grn_item_id",
    "rl"."bill_item_id",
    "rl"."product_id",
    "rl"."matched_qty",
    "rl"."matched_amount",
    "rl"."po_unit_price",
    "rl"."grn_unit_price",
    "rl"."bill_unit_price",
    "rl"."unit_price_variance",
    "rl"."qty_ordered",
    "rl"."qty_received",
    "rl"."qty_billed",
    "rl"."qty_variance",
    "rl"."match_type",
    "rl"."status",
    "rl"."resolution_notes",
    "rl"."resolved_at",
    "rl"."resolved_by",
    "rl"."created_at",
    "rl"."updated_at",
    "r"."reconciliation_number",
    "r"."status" AS "reconciliation_status",
    "p"."product_code",
    "p"."product_name"
   FROM (("public"."reconciliation_lines" "rl"
     JOIN "public"."reconciliations" "r" ON (("rl"."reconciliation_id" = "r"."id")))
     LEFT JOIN "public"."products" "p" ON (("rl"."product_id" = "p"."id")));


ALTER VIEW "public"."reconciliation_lines_with_details" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."reconciliation_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."reconciliation_seq" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."reconciliations_with_details" WITH ("security_invoker"='on') AS
 SELECT "r"."id",
    "r"."reconciliation_number",
    "r"."purchase_bill_id",
    "r"."purchase_order_id",
    "r"."material_receipt_id",
    "r"."bill_amount",
    "r"."po_amount",
    "r"."grn_amount",
    "r"."bill_po_variance",
    "r"."bill_grn_variance",
    "r"."po_grn_variance",
    "r"."status",
    "r"."discrepancy_type",
    "r"."discrepancy_notes",
    "r"."resolution_action",
    "r"."resolution_notes",
    "r"."resolved_at",
    "r"."resolved_by",
    "r"."adjusted_amount",
    "r"."adjustment_reason",
    "r"."notes",
    "r"."created_at",
    "r"."updated_at",
    "r"."created_by",
    "r"."updated_by",
    "pb"."bill_number",
    "pb"."bill_date",
    "po"."po_number",
    "po"."po_date",
    "mr"."grn_number",
    "mr"."received_date",
    "s"."supplier_name"
   FROM (((("public"."reconciliations" "r"
     LEFT JOIN "public"."purchase_bills" "pb" ON (("r"."purchase_bill_id" = "pb"."id")))
     LEFT JOIN "public"."purchase_orders" "po" ON (("r"."purchase_order_id" = "po"."id")))
     LEFT JOIN "public"."material_receipts" "mr" ON (("r"."material_receipt_id" = "mr"."id")))
     LEFT JOIN "public"."suppliers" "s" ON ((("pb"."supplier_id" = "s"."id") OR ("po"."supplier_id" = "s"."id"))));


ALTER VIEW "public"."reconciliations_with_details" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."reorder_rules" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "product_id" "uuid" NOT NULL,
    "warehouse_id" "uuid",
    "reorder_level" numeric(10,2) NOT NULL,
    "reorder_quantity" numeric(10,2) NOT NULL,
    "max_stock_level" numeric(10,2),
    "lead_time_days" integer DEFAULT 7,
    "auto_reorder" boolean DEFAULT false,
    "preferred_supplier_id" "uuid",
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."reorder_rules" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."request_items" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "request_id" "uuid" NOT NULL,
    "product_id" "uuid",
    "quantity" numeric(14,2) NOT NULL,
    "unit" character varying(20),
    "notes" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."request_items" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."request_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."request_seq" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."requests" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "request_number" character varying(50),
    "buyer_id" "uuid" NOT NULL,
    "title" character varying(200) NOT NULL,
    "description" "text",
    "category_id" "uuid",
    "location_id" "uuid",
    "preferred_delivery_date" "date",
    "status" "public"."request_status" DEFAULT 'pending'::"public"."request_status" NOT NULL,
    "rejection_reason" "text",
    "rejected_at" timestamp with time zone,
    "rejected_by" "uuid",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid",
    "updated_by" "uuid",
    "supplier_id" "uuid",
    "indent_id" "uuid",
    "headcount" integer DEFAULT 0,
    "shift" character varying(50),
    "duration_months" integer DEFAULT 1,
    "service_type" "text",
    "service_grade" "text",
    "start_date" "date",
    "site_location_id" "uuid",
    "is_service_request" boolean DEFAULT false NOT NULL
);


ALTER TABLE "public"."requests" OWNER TO "postgres";


COMMENT ON COLUMN "public"."requests"."is_service_request" IS 'Explicit discriminator written at creation time. TRUE = service deployment request (routes through service_purchase_orders). FALSE = material/goods request (routes through purchase_orders via create_po_from_supplier_request). Do NOT infer request type from optional service fields after this migration.';



CREATE TABLE IF NOT EXISTS "public"."residents" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "resident_code" character varying(50) NOT NULL,
    "flat_id" "uuid" NOT NULL,
    "full_name" character varying(200) NOT NULL,
    "relation" character varying(50),
    "phone" character varying(20),
    "alternate_phone" character varying(20),
    "email" character varying(255),
    "is_primary_contact" boolean DEFAULT false,
    "move_in_date" "date",
    "move_out_date" "date",
    "emergency_contact_name" character varying(100),
    "emergency_contact_phone" character varying(20),
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "auth_user_id" "uuid"
);


ALTER TABLE "public"."residents" OWNER TO "postgres";


COMMENT ON COLUMN "public"."residents"."auth_user_id" IS 'Links resident to Supabase auth.users for authentication';



CREATE OR REPLACE VIEW "public"."resident_directory" WITH ("security_invoker"='true') AS
 SELECT "r"."id",
    "r"."full_name",
    "f"."flat_number",
    "b"."building_name",
    "r"."is_primary_contact",
    "r"."is_active",
        CASE
            WHEN ("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_md'::"public"."user_role", 'society_manager'::"public"."user_role"])) THEN ("r"."phone")::"text"
            ELSE
            CASE
                WHEN ("r"."phone" IS NULL) THEN NULL::"text"
                ELSE ('XXXXXX'::"text" || "right"(("r"."phone")::"text", 4))
            END
        END AS "masked_phone",
        CASE
            WHEN ("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_md'::"public"."user_role", 'society_manager'::"public"."user_role"])) THEN ("r"."email")::"text"
            ELSE
            CASE
                WHEN ("r"."email" IS NULL) THEN NULL::"text"
                ELSE '***@***.com'::"text"
            END
        END AS "masked_email"
   FROM (("public"."residents" "r"
     LEFT JOIN "public"."flats" "f" ON (("r"."flat_id" = "f"."id")))
     LEFT JOIN "public"."buildings" "b" ON (("f"."building_id" = "b"."id")));


ALTER VIEW "public"."resident_directory" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."roles" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "role_name" "public"."user_role" NOT NULL,
    "role_display_name" character varying(100) NOT NULL,
    "description" "text",
    "permissions" "jsonb" DEFAULT '{}'::"jsonb",
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid",
    "updated_by" "uuid"
);


ALTER TABLE "public"."roles" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."rtv_ticket_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."rtv_ticket_seq" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."rtv_tickets" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "rtv_number" character varying(50) DEFAULT "public"."get_next_rtv_number"() NOT NULL,
    "po_id" "uuid",
    "supplier_id" "uuid" NOT NULL,
    "product_id" "uuid" NOT NULL,
    "receipt_id" "uuid",
    "return_reason" character varying(100) NOT NULL,
    "quantity" numeric(10,2) NOT NULL,
    "unit_of_measurement" character varying(20),
    "estimated_value" numeric(12,2),
    "status" character varying(50) DEFAULT 'pending_dispatch'::character varying,
    "credit_note_number" character varying(50),
    "credit_note_amount" numeric(12,2),
    "photo_urls" "jsonb" DEFAULT '[]'::"jsonb",
    "notes" "text",
    "dispatched_at" timestamp with time zone,
    "accepted_at" timestamp with time zone,
    "credit_issued_at" timestamp with time zone,
    "raised_by" "uuid",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."rtv_tickets" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."sale_bill_items" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "sale_bill_id" "uuid" NOT NULL,
    "service_id" "uuid",
    "product_id" "uuid",
    "item_description" "text",
    "quantity" numeric(10,2) DEFAULT 1,
    "unit_of_measure" character varying(20) DEFAULT 'units'::character varying,
    "unit_price" bigint DEFAULT 0,
    "tax_rate" numeric(5,2) DEFAULT 0,
    "tax_amount" bigint DEFAULT 0,
    "discount_amount" bigint DEFAULT 0,
    "line_total" bigint DEFAULT 0,
    "notes" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."sale_bill_items" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."sale_bills" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "invoice_number" character varying(50),
    "client_id" "uuid" NOT NULL,
    "contract_id" "uuid",
    "invoice_date" "date" NOT NULL,
    "due_date" "date",
    "billing_period_start" "date",
    "billing_period_end" "date",
    "status" character varying(20) DEFAULT 'draft'::character varying NOT NULL,
    "payment_status" character varying(20) DEFAULT 'unpaid'::character varying NOT NULL,
    "subtotal" bigint DEFAULT 0,
    "tax_amount" bigint DEFAULT 0,
    "discount_amount" bigint DEFAULT 0,
    "total_amount" bigint DEFAULT 0,
    "paid_amount" bigint DEFAULT 0,
    "due_amount" bigint DEFAULT 0,
    "last_payment_date" "date",
    "notes" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid",
    "updated_by" "uuid",
    "external_id" character varying(100),
    "gateway_log" "jsonb" DEFAULT '{}'::"jsonb",
    "failure_reason" "text",
    "request_id" "uuid",
    "paid_at" timestamp with time zone,
    "buyer_account_id" "uuid",
    "payment_method" "text",
    "payment_reference" "text",
    CONSTRAINT "sale_bills_payment_method_check" CHECK ((("payment_method" IS NULL) OR ("payment_method" = ANY (ARRAY['upi'::"text", 'neft'::"text", 'rtgs'::"text", 'cheque'::"text", 'cash'::"text"])))),
    CONSTRAINT "sale_bills_payment_status_check" CHECK ((("payment_status")::"text" = ANY ((ARRAY['unpaid'::character varying, 'partial'::character varying, 'paid'::character varying, 'overdue'::character varying, 'written_off'::character varying])::"text"[]))),
    CONSTRAINT "sale_bills_status_check" CHECK ((("status")::"text" = ANY ((ARRAY['draft'::character varying, 'sent'::character varying, 'acknowledged'::character varying, 'disputed'::character varying, 'cancelled'::character varying])::"text"[])))
);


ALTER TABLE "public"."sale_bills" OWNER TO "postgres";


COMMENT ON TABLE "public"."sale_bills" IS 'Bills for services provided, used in financial reporting.';



CREATE SEQUENCE IF NOT EXISTS "public"."sale_invoice_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."sale_invoice_seq" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."sale_product_rates" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "product_id" "uuid",
    "rate" numeric(15,2) NOT NULL,
    "effective_from" "date" NOT NULL,
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."sale_product_rates" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."security_guards" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "employee_id" "uuid" NOT NULL,
    "guard_code" character varying(50) NOT NULL,
    "grade" "public"."guard_grade" NOT NULL,
    "is_armed" boolean DEFAULT false,
    "license_number" character varying(100),
    "license_expiry" "date",
    "assigned_location_id" "uuid",
    "shift_timing" character varying(20),
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."security_guards" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."service_acknowledgments" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "spo_id" "uuid",
    "acknowledged_by" "uuid",
    "headcount_expected" integer,
    "headcount_received" integer,
    "grade_verified" boolean DEFAULT false,
    "notes" "text",
    "acknowledged_at" timestamp with time zone DEFAULT "now"(),
    "created_at" timestamp with time zone DEFAULT "now"(),
    "status" "text" DEFAULT 'acknowledged'::"text",
    "updated_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."service_acknowledgments" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."service_delivery_notes" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "delivery_note_number" character varying(50) NOT NULL,
    "po_id" "uuid" NOT NULL,
    "delivery_date" "date" NOT NULL,
    "personnel_details" "jsonb" DEFAULT '[]'::"jsonb" NOT NULL,
    "verified_by" "uuid",
    "verified_at" timestamp with time zone,
    "status" character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    "remarks" "text",
    "created_by" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."service_delivery_notes" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."service_feedback" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "service_request_id" "uuid",
    "society_id" "uuid",
    "resident_id" "uuid",
    "score" integer,
    "comments" "text",
    "photo_url" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "service_feedback_score_check" CHECK ((("score" >= 1) AND ("score" <= 5)))
);


ALTER TABLE "public"."service_feedback" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."service_purchase_order_items" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "spo_id" "uuid" NOT NULL,
    "service_description" "text" NOT NULL,
    "quantity" numeric DEFAULT 1 NOT NULL,
    "unit" character varying(50),
    "unit_price" bigint DEFAULT 0 NOT NULL,
    "line_total" bigint DEFAULT 0 NOT NULL,
    "notes" "text",
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."service_purchase_order_items" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."service_purchase_order_number_seq"
    START WITH 1001
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."service_purchase_order_number_seq" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."service_purchase_orders" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "spo_number" character varying(50) NOT NULL,
    "vendor_id" "uuid",
    "service_type" character varying(100) NOT NULL,
    "description" "text",
    "start_date" "date" NOT NULL,
    "end_date" "date",
    "total_amount" bigint DEFAULT 0 NOT NULL,
    "status" character varying(50) DEFAULT 'draft'::character varying NOT NULL,
    "terms_conditions" "text",
    "created_by" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "request_id" "uuid",
    "indent_id" "uuid",
    CONSTRAINT "service_purchase_orders_status_check" CHECK ((("status")::"text" = ANY ((ARRAY['draft'::character varying, 'sent_to_vendor'::character varying, 'acknowledged'::character varying, 'in_progress'::character varying, 'delivery_note_uploaded'::character varying, 'deployment_confirmed'::character varying, 'completed'::character varying, 'cancelled'::character varying])::"text"[])))
);


ALTER TABLE "public"."service_purchase_orders" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."service_rates" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "supplier_id" "uuid" NOT NULL,
    "service_type" "text" NOT NULL,
    "rate" numeric(15,2) NOT NULL,
    "effective_from" "date" NOT NULL,
    "effective_to" "date",
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."service_rates" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."service_requests" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "request_number" character varying(50) NOT NULL,
    "service_id" "uuid",
    "asset_id" "uuid",
    "location_id" "uuid",
    "society_id" "uuid",
    "title" character varying(200),
    "description" "text" NOT NULL,
    "priority" "public"."service_priority" DEFAULT 'normal'::"public"."service_priority",
    "requester_id" "uuid",
    "requester_phone" character varying(20),
    "assigned_to" "uuid",
    "assigned_at" timestamp with time zone,
    "scheduled_date" "date",
    "scheduled_time" time without time zone,
    "estimated_duration_minutes" integer,
    "status" "public"."service_request_status" DEFAULT 'open'::"public"."service_request_status",
    "completed_at" timestamp with time zone,
    "resolution_notes" "text",
    "maintenance_schedule_id" "uuid",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid",
    "before_photo_url" "text",
    "after_photo_url" "text",
    "completion_signature_url" "text",
    "started_at" timestamp with time zone,
    "completion_notes" "text",
    "type" "text" DEFAULT 'service_request'::"text" NOT NULL,
    "monthly_amount" bigint,
    "start_date" "date",
    "end_date" "date",
    "notice_days" integer DEFAULT 30,
    "auto_renew_terms" "jsonb",
    "frozen_rates" "jsonb",
    CONSTRAINT "service_completion_requires_photo" CHECK (((("status")::"text" <> 'completed'::"text") OR ("after_photo_url" IS NOT NULL))),
    CONSTRAINT "service_requests_type_check" CHECK (("type" = ANY (ARRAY['service_request'::"text", 'ticket'::"text"])))
);


ALTER TABLE "public"."service_requests" OWNER TO "postgres";


COMMENT ON COLUMN "public"."service_requests"."monthly_amount" IS 'Fixed monthly billing amount (in paise) for type=deployment requests';



COMMENT ON COLUMN "public"."service_requests"."start_date" IS 'Contract start date for type=deployment';



COMMENT ON COLUMN "public"."service_requests"."end_date" IS 'Contract end date for type=deployment';



COMMENT ON COLUMN "public"."service_requests"."notice_days" IS 'Termination notice period (default 30) for type=deployment';



COMMENT ON COLUMN "public"."service_requests"."auto_renew_terms" IS 'JSON configuration for auto-renewal (opt-in, default off)';



COMMENT ON COLUMN "public"."service_requests"."frozen_rates" IS 'JSON map of rate overrides frozen at contract creation time';



CREATE TABLE IF NOT EXISTS "public"."services" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "service_code" character varying(20) NOT NULL,
    "service_name" character varying(200) NOT NULL,
    "service_category" character varying(50),
    "description" "text",
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid",
    "is_v1" boolean DEFAULT true NOT NULL
);


ALTER TABLE "public"."services" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."service_requests_with_details" WITH ("security_invoker"='on') AS
 SELECT "sr"."id",
    "sr"."request_number",
    "sr"."service_id",
    "sr"."asset_id",
    "sr"."location_id",
    "sr"."society_id",
    "sr"."title",
    "sr"."description",
    "sr"."priority",
    "sr"."requester_id",
    "sr"."requester_phone",
    "sr"."assigned_to",
    "sr"."assigned_at",
    "sr"."scheduled_date",
    "sr"."scheduled_time",
    "sr"."estimated_duration_minutes",
    "sr"."status",
    "sr"."completed_at",
    "sr"."resolution_notes",
    "sr"."maintenance_schedule_id",
    "sr"."created_at",
    "sr"."updated_at",
    "sr"."created_by",
    "sr"."before_photo_url",
    "sr"."after_photo_url",
    "sr"."completion_signature_url",
    "sr"."started_at",
    "sr"."completion_notes",
    "a"."name" AS "asset_name",
    "a"."asset_code",
    ((("e"."first_name")::"text" || ' '::"text") || ("e"."last_name")::"text") AS "technician_name",
    "cl"."location_name",
    "sv"."service_name",
    "sv"."service_code",
    ( SELECT "pest_control_ppe_verifications"."all_items_checked"
           FROM "public"."pest_control_ppe_verifications"
          WHERE ("pest_control_ppe_verifications"."service_request_id" = "sr"."id")
          ORDER BY "pest_control_ppe_verifications"."verified_at" DESC
         LIMIT 1) AS "ppe_verified"
   FROM (((("public"."service_requests" "sr"
     LEFT JOIN "public"."assets" "a" ON (("sr"."asset_id" = "a"."id")))
     LEFT JOIN "public"."employees" "e" ON (("sr"."assigned_to" = "e"."id")))
     LEFT JOIN "public"."company_locations" "cl" ON (("sr"."location_id" = "cl"."id")))
     LEFT JOIN "public"."services" "sv" ON (("sr"."service_id" = "sv"."id")));


ALTER VIEW "public"."service_requests_with_details" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."service_tasks" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "task_name" character varying(255) NOT NULL,
    "service_type" character varying(100) NOT NULL,
    "description" "text",
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."service_tasks" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."services_wise_work" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "service_type" character varying(100) NOT NULL,
    "work_id" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."services_wise_work" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."shifts" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "shift_code" character varying(20) NOT NULL,
    "shift_name" character varying(100) NOT NULL,
    "start_time" time without time zone NOT NULL,
    "end_time" time without time zone NOT NULL,
    "duration_hours" numeric(4,2),
    "is_night_shift" boolean DEFAULT false,
    "break_duration_minutes" integer DEFAULT 60,
    "grace_time_minutes" integer DEFAULT 15,
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "standard_hours" numeric(4,2),
    "description" "text"
);


ALTER TABLE "public"."shifts" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."shortage_note_items" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "shortage_note_id" "uuid" NOT NULL,
    "product_id" "uuid",
    "product_name" character varying(200),
    "ordered_quantity" numeric(10,2) NOT NULL,
    "received_quantity" numeric(10,2) NOT NULL,
    "shortage_quantity" numeric(10,2) GENERATED ALWAYS AS (("ordered_quantity" - "received_quantity")) STORED,
    "unit" character varying(20),
    "rate" numeric(10,2),
    "shortage_value" numeric(12,2) GENERATED ALWAYS AS ((("ordered_quantity" - "received_quantity") * COALESCE("rate", (0)::numeric))) STORED,
    "notes" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."shortage_note_items" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."shortage_note_seq"
    START WITH 1001
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."shortage_note_seq" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."shortage_notes" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "note_number" character varying(50) NOT NULL,
    "grn_id" "uuid",
    "po_id" "uuid" NOT NULL,
    "supplier_id" "uuid" NOT NULL,
    "status" character varying(20) DEFAULT 'open'::character varying NOT NULL,
    "total_shortage_value" numeric(12,2) DEFAULT 0,
    "resolution" "text",
    "created_by" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."shortage_notes" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."stock_levels" WITH ("security_invoker"='on') AS
 SELECT "p"."id" AS "product_id",
    "p"."product_name",
    "p"."product_code",
    "w"."id" AS "warehouse_id",
    "w"."warehouse_name",
    COALESCE("sum"("sb"."current_quantity"), (0)::numeric) AS "total_quantity",
    "rr"."reorder_level",
        CASE
            WHEN (COALESCE("sum"("sb"."current_quantity"), (0)::numeric) <= COALESCE("rr"."reorder_level", (0)::numeric)) THEN true
            ELSE false
        END AS "needs_reorder"
   FROM ((("public"."products" "p"
     CROSS JOIN "public"."warehouses" "w")
     LEFT JOIN "public"."stock_batches" "sb" ON ((("p"."id" = "sb"."product_id") AND ("w"."id" = "sb"."warehouse_id") AND (("sb"."status")::"text" = 'active'::"text"))))
     LEFT JOIN "public"."reorder_rules" "rr" ON ((("p"."id" = "rr"."product_id") AND ("w"."id" = "rr"."warehouse_id"))))
  GROUP BY "p"."id", "p"."product_name", "p"."product_code", "w"."id", "w"."warehouse_name", "rr"."reorder_level";


ALTER VIEW "public"."stock_levels" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."stock_transactions" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "transaction_number" character varying(50) NOT NULL,
    "product_id" "uuid" NOT NULL,
    "location_id" "uuid",
    "transaction_type" character varying(20) NOT NULL,
    "quantity" numeric(10,2) NOT NULL,
    "unit_of_measurement" character varying(20) NOT NULL,
    "reference_type" character varying(50),
    "reference_id" "uuid",
    "transaction_date" "date" NOT NULL,
    "batch_number" character varying(50),
    "notes" "text",
    "created_by" "uuid",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."stock_transactions" OWNER TO "postgres";


COMMENT ON TABLE "public"."stock_transactions" IS 'All inventory movements for audit trail';



CREATE TABLE IF NOT EXISTS "public"."storage_deletion_queue" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "bucket_id" "text" NOT NULL,
    "file_path" "text" NOT NULL,
    "metadata" "jsonb",
    "scheduled_at" timestamp with time zone DEFAULT "now"(),
    "processed_at" timestamp with time zone
);


ALTER TABLE "public"."storage_deletion_queue" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."supplier_products" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "supplier_id" "uuid",
    "product_id" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."supplier_products" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."supplier_rates" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "supplier_product_id" "uuid",
    "rate" numeric(15,2) NOT NULL,
    "effective_from" "date" NOT NULL,
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."supplier_rates" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."system_config" (
    "key" character varying(100) NOT NULL,
    "value" "text" NOT NULL,
    "description" "text",
    "updated_by" "uuid",
    "updated_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."system_config" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."technician_profiles" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "employee_id" "uuid" NOT NULL,
    "skills" "text"[] DEFAULT '{}'::"text"[],
    "certifications" "text"[] DEFAULT '{}'::"text"[],
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" "uuid",
    "specialization" character varying,
    CONSTRAINT "technician_profiles_specialization_check" CHECK ((("specialization")::"text" = ANY ((ARRAY['ac'::character varying, 'pest_control'::character varying, 'plumbing'::character varying, 'electrical'::character varying, 'general'::character varying])::"text"[])))
);


ALTER TABLE "public"."technician_profiles" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."vendor_wise_services" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "supplier_id" "uuid",
    "service_type" character varying(100) NOT NULL,
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."vendor_wise_services" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."vendor_scorecards" WITH ("security_invoker"='on') AS
 SELECT "s"."id" AS "supplier_id",
    "s"."supplier_name",
    "vws"."service_type",
    "count"("sf"."id") AS "total_feedbacks",
    (COALESCE("avg"("sf"."score"), (0)::numeric))::numeric(3,2) AS "average_rating",
    "count"(
        CASE
            WHEN ("sf"."score" <= 2) THEN 1
            ELSE NULL::integer
        END) AS "critical_feedbacks",
        CASE
            WHEN ("avg"("sf"."score") >= 4.5) THEN 'Incentivize'::"text"
            WHEN ("avg"("sf"."score") <= 2.5) THEN 'Warning'::"text"
            ELSE 'Standard'::"text"
        END AS "performance_status"
   FROM (((("public"."suppliers" "s"
     LEFT JOIN "public"."vendor_wise_services" "vws" ON (("s"."id" = "vws"."supplier_id")))
     LEFT JOIN "public"."services" "sv" ON ((("sv"."service_name")::"text" = ("vws"."service_type")::"text")))
     LEFT JOIN "public"."service_requests" "sr" ON (("sr"."service_id" = "sv"."id")))
     LEFT JOIN "public"."service_feedback" "sf" ON (("sf"."service_request_id" = "sr"."id")))
  GROUP BY "s"."id", "s"."supplier_name", "vws"."service_type";


ALTER VIEW "public"."vendor_scorecards" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."view_attendance_by_dept" WITH ("security_invoker"='on') AS
 SELECT "e"."department",
    "count"("a"."id") FILTER (WHERE (("a"."status")::"text" = 'present'::"text")) AS "total_present",
    "count"("a"."id") FILTER (WHERE (("a"."status")::"text" = 'absent'::"text")) AS "total_absent",
    "round"(((("count"("a"."id") FILTER (WHERE (("a"."status")::"text" = 'present'::"text")))::numeric / (NULLIF("count"("a"."id"), 0))::numeric) * (100)::numeric), 2) AS "attendance_rate",
    "round"("avg"((EXTRACT(epoch FROM (("a"."check_in_time")::time without time zone - "s"."start_time")) / (60)::numeric)) FILTER (WHERE (("a"."check_in_time")::time without time zone > "s"."start_time")), 2) AS "avg_late_minutes"
   FROM ((("public"."employees" "e"
     LEFT JOIN "public"."attendance_logs" "a" ON (("e"."id" = "a"."employee_id")))
     LEFT JOIN "public"."employee_shift_assignments" "esa" ON ((("e"."id" = "esa"."employee_id") AND ("esa"."is_active" = true))))
     LEFT JOIN "public"."shifts" "s" ON (("esa"."shift_id" = "s"."id")))
  GROUP BY "e"."department";


ALTER VIEW "public"."view_attendance_by_dept" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."view_financial_kpis" WITH ("security_invoker"='true') AS
 SELECT COALESCE("sum"("due_amount"), (0)::numeric) AS "total_outstanding",
    COALESCE("sum"("paid_amount"), (0)::numeric) AS "total_collected_ytd",
    COALESCE("sum"("total_amount"), (0)::numeric) AS "total_billing_ytd"
   FROM "public"."sale_bills";


ALTER VIEW "public"."view_financial_kpis" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."view_financial_monthly_trends" WITH ("security_invoker"='on') AS
 WITH "monthly_sales" AS (
         SELECT ("date_trunc"('month'::"text", ("sale_bills"."invoice_date")::timestamp with time zone))::"date" AS "report_month",
            "sum"("sale_bills"."total_amount") AS "revenue"
           FROM "public"."sale_bills"
          WHERE (("sale_bills"."status")::"text" <> 'cancelled'::"text")
          GROUP BY (("date_trunc"('month'::"text", ("sale_bills"."invoice_date")::timestamp with time zone))::"date")
        ), "monthly_purchases" AS (
         SELECT ("date_trunc"('month'::"text", ("purchase_bills"."bill_date")::timestamp with time zone))::"date" AS "report_month",
            "sum"("purchase_bills"."total_amount") AS "expense"
           FROM "public"."purchase_bills"
          WHERE ("purchase_bills"."status" <> 'cancelled'::"text")
          GROUP BY (("date_trunc"('month'::"text", ("purchase_bills"."bill_date")::timestamp with time zone))::"date")
        )
 SELECT COALESCE("s"."report_month", "p"."report_month") AS "month",
    COALESCE(("s"."revenue" / (100)::numeric), (0)::numeric) AS "revenue",
    COALESCE(("p"."expense" / (100)::numeric), (0)::numeric) AS "expense",
    ((COALESCE("s"."revenue", (0)::numeric) - COALESCE("p"."expense", (0)::numeric)) / (100)::numeric) AS "net_margin"
   FROM ("monthly_sales" "s"
     FULL JOIN "monthly_purchases" "p" ON (("s"."report_month" = "p"."report_month")))
  ORDER BY COALESCE("s"."report_month", "p"."report_month") DESC;


ALTER VIEW "public"."view_financial_monthly_trends" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."view_financial_revenue_by_category" WITH ("security_invoker"='on') AS
 SELECT COALESCE("s"."service_category", 'Uncategorized'::character varying) AS "category",
    ("sum"("bi"."line_total") / (100)::numeric) AS "revenue"
   FROM ("public"."sale_bill_items" "bi"
     JOIN "public"."services" "s" ON (("bi"."service_id" = "s"."id")))
  GROUP BY COALESCE("s"."service_category", 'Uncategorized'::character varying);


ALTER VIEW "public"."view_financial_revenue_by_category" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."view_inventory_velocity" WITH ("security_invoker"='on') AS
 SELECT "p"."id" AS "product_id",
    "p"."product_name" AS "item_name",
    "pc"."category_name" AS "category",
    COALESCE("i"."quantity_on_hand", (0)::numeric) AS "stock_level",
    COALESCE("sum"("abs"("st"."quantity")) FILTER (WHERE (("st"."transaction_type")::"text" = ANY ((ARRAY['OUT'::character varying, 'ISSUE'::character varying])::"text"[]))), (0)::numeric) AS "consumption_rate",
        CASE
            WHEN (COALESCE("sum"("abs"("st"."quantity")) FILTER (WHERE (("st"."transaction_type")::"text" = ANY ((ARRAY['OUT'::character varying, 'ISSUE'::character varying])::"text"[]))), (0)::numeric) > (0)::numeric) THEN "round"((COALESCE("i"."quantity_on_hand", (0)::numeric) / (NULLIF("sum"("abs"("st"."quantity")) FILTER (WHERE (("st"."transaction_type")::"text" = ANY ((ARRAY['OUT'::character varying, 'ISSUE'::character varying])::"text"[]))), (0)::numeric) / (30)::numeric)), 0)
            ELSE (999)::numeric
        END AS "days_to_stockout"
   FROM ((("public"."products" "p"
     JOIN "public"."product_categories" "pc" ON (("p"."category_id" = "pc"."id")))
     LEFT JOIN "public"."inventory" "i" ON (("p"."id" = "i"."product_id")))
     LEFT JOIN "public"."stock_transactions" "st" ON ((("p"."id" = "st"."product_id") AND ("st"."transaction_date" > (CURRENT_DATE - '30 days'::interval)))))
  GROUP BY "p"."id", "p"."product_name", "pc"."category_name", "i"."quantity_on_hand";


ALTER VIEW "public"."view_inventory_velocity" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."view_inventory_summary" WITH ("security_invoker"='on') AS
 SELECT "product_id",
    "item_name",
    "category",
    "stock_level",
        CASE
            WHEN ("stock_level" < (10)::numeric) THEN 'Low Stock'::"text"
            ELSE 'In Stock'::"text"
        END AS "stock_status"
   FROM "public"."view_inventory_velocity";


ALTER VIEW "public"."view_inventory_summary" OWNER TO "postgres";


COMMENT ON VIEW "public"."view_inventory_summary" IS 'Summary of inventory levels and stock status for analytics reporting.';



CREATE OR REPLACE VIEW "public"."view_service_performance" WITH ("security_invoker"='true') AS
 SELECT "s"."service_category",
    "count"("sr"."id") AS "total_jobs",
    "round"("avg"((EXTRACT(epoch FROM ("sr"."completed_at" - "sr"."created_at")) / (3600)::numeric)), 1) AS "avg_response",
    "round"("avg"("sf"."score"), 1) AS "avg_rating",
    "round"(((("count"("sr"."id") FILTER (WHERE ("sr"."status" = 'completed'::"public"."service_request_status")))::numeric / (NULLIF("count"("sr"."id"), 0))::numeric) * (100)::numeric), 1) AS "resolution_rate",
    "count"("sr"."id") FILTER (WHERE ((("sr"."completed_at" - "sr"."created_at") > '24:00:00'::interval) OR (("sr"."status" <> 'completed'::"public"."service_request_status") AND (("now"() - "sr"."created_at") > '24:00:00'::interval)))) AS "total_breaches"
   FROM (("public"."services" "s"
     JOIN "public"."service_requests" "sr" ON (("s"."id" = "sr"."service_id")))
     LEFT JOIN "public"."service_feedback" "sf" ON (("sr"."id" = "sf"."service_request_id")))
  GROUP BY "s"."service_category";


ALTER VIEW "public"."view_service_performance" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."visitor_bypass_audit" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "visitor_id" "uuid" NOT NULL,
    "bypass_reason" "text" NOT NULL,
    "bypassed_by_auth_user_id" "uuid",
    "entry_guard_id" "uuid",
    "resident_id" "uuid",
    "flat_id" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."visitor_bypass_audit" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."visitor_photo_metadata" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "visitor_id" "uuid" NOT NULL,
    "guard_id" "uuid" NOT NULL,
    "storage_path" "text" NOT NULL,
    "storage_bucket" "text" DEFAULT 'visitor-photos'::"text",
    "file_size_bytes" integer,
    "mime_type" "text" DEFAULT 'image/jpeg'::"text",
    "photo_captured_at" timestamp with time zone NOT NULL,
    "uploaded_at" timestamp with time zone DEFAULT "now"(),
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."visitor_photo_metadata" OWNER TO "postgres";


COMMENT ON TABLE "public"."visitor_photo_metadata" IS 'Metadata for visitor photos captured by guards at gate. Photos stored in Supabase object storage bucket ''visitor-photos''.';



CREATE TABLE IF NOT EXISTS "public"."visitors" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "visitor_name" character varying(200) NOT NULL,
    "visitor_type" character varying(50),
    "phone" character varying(20),
    "vehicle_number" character varying(20),
    "photo_url" "text",
    "flat_id" "uuid",
    "resident_id" "uuid",
    "purpose" character varying(200),
    "entry_time" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "exit_time" timestamp with time zone,
    "entry_guard_id" "uuid",
    "exit_guard_id" "uuid",
    "entry_location_id" "uuid",
    "approved_by_resident" boolean,
    "visitor_pass_number" character varying(50),
    "is_frequent_visitor" boolean DEFAULT false,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "rejection_reason" "text",
    "bypass_reason" "text",
    "approval_status" "text" DEFAULT 'pending'::"text" NOT NULL,
    "approval_deadline_at" timestamp with time zone,
    "decision_at" timestamp with time zone,
    "notification_sent_at" timestamp with time zone,
    "pii_redacted_at" timestamp with time zone
);


ALTER TABLE "public"."visitors" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."waitlist" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "email" "text" NOT NULL,
    "name" "text",
    "company" "text",
    "source" "text" DEFAULT 'landing_page'::"text",
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."waitlist" OWNER TO "postgres";


COMMENT ON TABLE "public"."waitlist" IS 'Early access sign-ups from the FacilityPro landing page.';



CREATE TABLE IF NOT EXISTS "public"."work_master" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "work_name" character varying(255) NOT NULL,
    "description" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "is_active" boolean DEFAULT true
);


ALTER TABLE "public"."work_master" OWNER TO "postgres";


COMMENT ON COLUMN "public"."work_master"."is_active" IS 'Soft-delete flag for work master items';



ALTER TABLE ONLY "public"."gps_tracking" ATTACH PARTITION "public"."gps_tracking_2026_02" FOR VALUES FROM ('2026-02-01 00:00:00+00') TO ('2026-03-01 00:00:00+00');



ALTER TABLE ONLY "public"."gps_tracking" ATTACH PARTITION "public"."gps_tracking_2026_03" FOR VALUES FROM ('2026-03-01 00:00:00+00') TO ('2026-04-01 00:00:00+00');



ALTER TABLE ONLY "public"."gps_tracking" ATTACH PARTITION "public"."gps_tracking_2026_04" FOR VALUES FROM ('2026-04-01 00:00:00+00') TO ('2026-05-01 00:00:00+00');



ALTER TABLE ONLY "public"."gps_tracking" ATTACH PARTITION "public"."gps_tracking_2026_05" FOR VALUES FROM ('2026-05-01 00:00:00+00') TO ('2026-06-01 00:00:00+00');



ALTER TABLE ONLY "public"."gps_tracking" ATTACH PARTITION "public"."gps_tracking_2026_06" FOR VALUES FROM ('2026-06-01 00:00:00+00') TO ('2026-07-01 00:00:00+00');



ALTER TABLE ONLY "public"."gps_tracking" ATTACH PARTITION "public"."gps_tracking_2026_07" FOR VALUES FROM ('2026-07-01 00:00:00+00') TO ('2026-08-01 00:00:00+00');



ALTER TABLE ONLY "public"."gps_tracking" ATTACH PARTITION "public"."gps_tracking_2026_08" FOR VALUES FROM ('2026-08-01 00:00:00+00') TO ('2026-09-01 00:00:00+00');



ALTER TABLE ONLY "public"."gps_tracking" ATTACH PARTITION "public"."gps_tracking_2026_09" FOR VALUES FROM ('2026-09-01 00:00:00+00') TO ('2026-10-01 00:00:00+00');



ALTER TABLE ONLY "public"."gps_tracking" ATTACH PARTITION "public"."gps_tracking_2026_10" FOR VALUES FROM ('2026-10-01 00:00:00+00') TO ('2026-11-01 00:00:00+00');



ALTER TABLE ONLY "public"."gps_tracking" ATTACH PARTITION "public"."gps_tracking_2026_11" FOR VALUES FROM ('2026-11-01 00:00:00+00') TO ('2026-12-01 00:00:00+00');



ALTER TABLE ONLY "public"."gps_tracking" ATTACH PARTITION "public"."gps_tracking_2026_12" FOR VALUES FROM ('2026-12-01 00:00:00+00') TO ('2027-01-01 00:00:00+00');



ALTER TABLE ONLY "public"."gps_tracking" ATTACH PARTITION "public"."gps_tracking_default" DEFAULT;



ALTER TABLE ONLY "public"."asset_categories"
    ADD CONSTRAINT "asset_categories_category_code_key" UNIQUE ("category_code");



ALTER TABLE ONLY "public"."asset_categories"
    ADD CONSTRAINT "asset_categories_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."assets"
    ADD CONSTRAINT "assets_asset_code_key" UNIQUE ("asset_code");



ALTER TABLE ONLY "public"."assets"
    ADD CONSTRAINT "assets_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."attendance_logs"
    ADD CONSTRAINT "attendance_logs_employee_id_log_date_key" UNIQUE ("employee_id", "log_date");



ALTER TABLE ONLY "public"."attendance_logs"
    ADD CONSTRAINT "attendance_logs_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."audit_logs"
    ADD CONSTRAINT "audit_logs_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."background_verifications"
    ADD CONSTRAINT "background_verifications_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."behaviour_tickets"
    ADD CONSTRAINT "behaviour_tickets_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."budgets"
    ADD CONSTRAINT "budgets_budget_code_key" UNIQUE ("budget_code");



ALTER TABLE ONLY "public"."budgets"
    ADD CONSTRAINT "budgets_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."buildings"
    ADD CONSTRAINT "buildings_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."buildings"
    ADD CONSTRAINT "buildings_society_id_building_code_key" UNIQUE ("society_id", "building_code");



ALTER TABLE ONLY "public"."buyer_accounts"
    ADD CONSTRAINT "buyer_accounts_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."buyer_feedback"
    ADD CONSTRAINT "buyer_feedback_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."candidate_interviews"
    ADD CONSTRAINT "candidate_interviews_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."candidates"
    ADD CONSTRAINT "candidates_candidate_code_key" UNIQUE ("candidate_code");



ALTER TABLE ONLY "public"."candidates"
    ADD CONSTRAINT "candidates_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."checklist_assignments"
    ADD CONSTRAINT "checklist_assignments_checklist_id_employee_id_key" UNIQUE ("checklist_id", "employee_id");



ALTER TABLE ONLY "public"."checklist_assignments"
    ADD CONSTRAINT "checklist_assignments_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."checklist_response_override_audit"
    ADD CONSTRAINT "checklist_response_override_audit_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."checklist_responses"
    ADD CONSTRAINT "checklist_responses_checklist_id_employee_id_response_date_key" UNIQUE ("checklist_id", "employee_id", "response_date");



ALTER TABLE ONLY "public"."checklist_responses"
    ADD CONSTRAINT "checklist_responses_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."company_events"
    ADD CONSTRAINT "company_events_event_code_key" UNIQUE ("event_code");



ALTER TABLE ONLY "public"."company_events"
    ADD CONSTRAINT "company_events_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."company_locations"
    ADD CONSTRAINT "company_locations_location_code_key" UNIQUE ("location_code");



ALTER TABLE ONLY "public"."company_locations"
    ADD CONSTRAINT "company_locations_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."compliance_snapshots"
    ADD CONSTRAINT "compliance_snapshots_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."contracts"
    ADD CONSTRAINT "contracts_contract_number_key" UNIQUE ("contract_number");



ALTER TABLE ONLY "public"."contracts"
    ADD CONSTRAINT "contracts_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."credit_notes"
    ADD CONSTRAINT "credit_notes_credit_note_number_key" UNIQUE ("credit_note_number");



ALTER TABLE ONLY "public"."credit_notes"
    ADD CONSTRAINT "credit_notes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."daily_checklist_items"
    ADD CONSTRAINT "daily_checklist_items_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."daily_checklists"
    ADD CONSTRAINT "daily_checklists_checklist_code_key" UNIQUE ("checklist_code");



ALTER TABLE ONLY "public"."daily_checklists"
    ADD CONSTRAINT "daily_checklists_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."debit_notes"
    ADD CONSTRAINT "debit_notes_debit_note_number_key" UNIQUE ("debit_note_number");



ALTER TABLE ONLY "public"."debit_notes"
    ADD CONSTRAINT "debit_notes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."designations"
    ADD CONSTRAINT "designations_designation_code_key" UNIQUE ("designation_code");



ALTER TABLE ONLY "public"."designations"
    ADD CONSTRAINT "designations_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."emergency_contacts"
    ADD CONSTRAINT "emergency_contacts_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."employee_behavior_tickets"
    ADD CONSTRAINT "employee_behavior_tickets_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."employee_behavior_tickets"
    ADD CONSTRAINT "employee_behavior_tickets_ticket_number_key" UNIQUE ("ticket_number");



ALTER TABLE ONLY "public"."employee_documents"
    ADD CONSTRAINT "employee_documents_document_code_key" UNIQUE ("document_code");



ALTER TABLE ONLY "public"."employee_documents"
    ADD CONSTRAINT "employee_documents_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."employee_salary_structure"
    ADD CONSTRAINT "employee_salary_structure_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."employee_shift_assignments"
    ADD CONSTRAINT "employee_shift_assignments_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."employees"
    ADD CONSTRAINT "employees_auth_user_id_key" UNIQUE ("auth_user_id");



ALTER TABLE ONLY "public"."employees"
    ADD CONSTRAINT "employees_email_key" UNIQUE ("email");



ALTER TABLE ONLY "public"."employees"
    ADD CONSTRAINT "employees_employee_code_key" UNIQUE ("employee_code");



ALTER TABLE ONLY "public"."employees"
    ADD CONSTRAINT "employees_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."financial_periods"
    ADD CONSTRAINT "financial_periods_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."flats"
    ADD CONSTRAINT "flats_building_id_flat_number_key" UNIQUE ("building_id", "flat_number");



ALTER TABLE ONLY "public"."flats"
    ADD CONSTRAINT "flats_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."gps_tracking"
    ADD CONSTRAINT "gps_tracking_pkey" PRIMARY KEY ("id", "tracked_at");



ALTER TABLE ONLY "public"."gps_tracking_2026_02"
    ADD CONSTRAINT "gps_tracking_2026_02_pkey" PRIMARY KEY ("id", "tracked_at");



ALTER TABLE ONLY "public"."gps_tracking_2026_03"
    ADD CONSTRAINT "gps_tracking_2026_03_pkey" PRIMARY KEY ("id", "tracked_at");



ALTER TABLE ONLY "public"."gps_tracking_2026_04"
    ADD CONSTRAINT "gps_tracking_2026_04_pkey" PRIMARY KEY ("id", "tracked_at");



ALTER TABLE ONLY "public"."gps_tracking_2026_05"
    ADD CONSTRAINT "gps_tracking_2026_05_pkey" PRIMARY KEY ("id", "tracked_at");



ALTER TABLE ONLY "public"."gps_tracking_2026_06"
    ADD CONSTRAINT "gps_tracking_2026_06_pkey" PRIMARY KEY ("id", "tracked_at");



ALTER TABLE ONLY "public"."gps_tracking_2026_07"
    ADD CONSTRAINT "gps_tracking_2026_07_pkey" PRIMARY KEY ("id", "tracked_at");



ALTER TABLE ONLY "public"."gps_tracking_2026_08"
    ADD CONSTRAINT "gps_tracking_2026_08_pkey" PRIMARY KEY ("id", "tracked_at");



ALTER TABLE ONLY "public"."gps_tracking_2026_09"
    ADD CONSTRAINT "gps_tracking_2026_09_pkey" PRIMARY KEY ("id", "tracked_at");



ALTER TABLE ONLY "public"."gps_tracking_2026_10"
    ADD CONSTRAINT "gps_tracking_2026_10_pkey" PRIMARY KEY ("id", "tracked_at");



ALTER TABLE ONLY "public"."gps_tracking_2026_11"
    ADD CONSTRAINT "gps_tracking_2026_11_pkey" PRIMARY KEY ("id", "tracked_at");



ALTER TABLE ONLY "public"."gps_tracking_2026_12"
    ADD CONSTRAINT "gps_tracking_2026_12_pkey" PRIMARY KEY ("id", "tracked_at");



ALTER TABLE ONLY "public"."gps_tracking_default"
    ADD CONSTRAINT "gps_tracking_default_pkey" PRIMARY KEY ("id", "tracked_at");



ALTER TABLE ONLY "public"."guard_gps_tracking"
    ADD CONSTRAINT "guard_gps_tracking_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."guard_panic_alerts"
    ADD CONSTRAINT "guard_panic_alerts_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."guard_patrol_logs"
    ADD CONSTRAINT "guard_patrol_logs_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."holiday_master"
    ADD CONSTRAINT "holiday_master_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."holidays"
    ADD CONSTRAINT "holidays_holiday_date_year_key" UNIQUE ("holiday_date", "year");



ALTER TABLE ONLY "public"."holidays"
    ADD CONSTRAINT "holidays_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."horticulture_seasonal_plans"
    ADD CONSTRAINT "horticulture_seasonal_plans_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."horticulture_tasks"
    ADD CONSTRAINT "horticulture_tasks_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."horticulture_zones"
    ADD CONSTRAINT "horticulture_zones_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."indent_items"
    ADD CONSTRAINT "indent_items_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."indents"
    ADD CONSTRAINT "indents_indent_number_key" UNIQUE ("indent_number");



ALTER TABLE ONLY "public"."indents"
    ADD CONSTRAINT "indents_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."inventory"
    ADD CONSTRAINT "inventory_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."inventory"
    ADD CONSTRAINT "inventory_product_id_location_id_key" UNIQUE ("product_id", "location_id");



ALTER TABLE ONLY "public"."job_materials_used"
    ADD CONSTRAINT "job_materials_used_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."job_photos"
    ADD CONSTRAINT "job_photos_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."job_sessions"
    ADD CONSTRAINT "job_sessions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."leave_applications"
    ADD CONSTRAINT "leave_applications_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."leave_types"
    ADD CONSTRAINT "leave_types_leave_type_key" UNIQUE ("leave_type");



ALTER TABLE ONLY "public"."leave_types"
    ADD CONSTRAINT "leave_types_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."login_rate_limits"
    ADD CONSTRAINT "login_rate_limits_pkey" PRIMARY KEY ("ip_address");



ALTER TABLE ONLY "public"."maintenance_schedules"
    ADD CONSTRAINT "maintenance_schedules_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."material_arrival_evidence"
    ADD CONSTRAINT "material_arrival_evidence_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."material_arrival_logs"
    ADD CONSTRAINT "material_arrival_logs_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."material_receipt_items"
    ADD CONSTRAINT "material_receipt_items_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."material_receipts"
    ADD CONSTRAINT "material_receipts_grn_number_key" UNIQUE ("grn_number");



ALTER TABLE ONLY "public"."material_receipts"
    ADD CONSTRAINT "material_receipts_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."notification_logs"
    ADD CONSTRAINT "notification_logs_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."notifications"
    ADD CONSTRAINT "notifications_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."oversight_tickets"
    ADD CONSTRAINT "oversight_tickets_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."oversight_tickets"
    ADD CONSTRAINT "oversight_tickets_ticket_number_key" UNIQUE ("ticket_number");



ALTER TABLE ONLY "public"."panic_alerts"
    ADD CONSTRAINT "panic_alerts_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."payment_methods"
    ADD CONSTRAINT "payment_methods_method_name_key" UNIQUE ("method_name");



ALTER TABLE ONLY "public"."payment_methods"
    ADD CONSTRAINT "payment_methods_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."payments"
    ADD CONSTRAINT "payments_payment_number_key" UNIQUE ("payment_number");



ALTER TABLE ONLY "public"."payments"
    ADD CONSTRAINT "payments_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."payroll_cycles"
    ADD CONSTRAINT "payroll_cycles_cycle_code_key" UNIQUE ("cycle_code");



ALTER TABLE ONLY "public"."payroll_cycles"
    ADD CONSTRAINT "payroll_cycles_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."payslips"
    ADD CONSTRAINT "payslips_payslip_number_key" UNIQUE ("payslip_number");



ALTER TABLE ONLY "public"."payslips"
    ADD CONSTRAINT "payslips_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."personnel_dispatches"
    ADD CONSTRAINT "personnel_dispatches_dispatch_number_key" UNIQUE ("dispatch_number");



ALTER TABLE ONLY "public"."personnel_dispatches"
    ADD CONSTRAINT "personnel_dispatches_overlap_excl" EXCLUDE USING "gist" ("employee_id" WITH =, "daterange"("start_date", COALESCE("end_date", 'infinity'::"date"), '[)'::"text") WITH &&) WHERE ((("status")::"text" <> ALL ((ARRAY['cancelled'::character varying, 'completed'::character varying, 'withdrawn'::character varying])::"text"[])));



ALTER TABLE ONLY "public"."personnel_dispatches"
    ADD CONSTRAINT "personnel_dispatches_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."pest_control_chemicals"
    ADD CONSTRAINT "pest_control_chemicals_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."pest_control_ppe_verifications"
    ADD CONSTRAINT "pest_control_ppe_verifications_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."pest_control_spill_kits"
    ADD CONSTRAINT "pest_control_spill_kits_kit_code_key" UNIQUE ("kit_code");



ALTER TABLE ONLY "public"."pest_control_spill_kits"
    ADD CONSTRAINT "pest_control_spill_kits_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."printing_ad_bookings"
    ADD CONSTRAINT "printing_ad_bookings_booking_number_key" UNIQUE ("booking_number");



ALTER TABLE ONLY "public"."printing_ad_bookings"
    ADD CONSTRAINT "printing_ad_bookings_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."printing_ad_spaces"
    ADD CONSTRAINT "printing_ad_spaces_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."product_categories"
    ADD CONSTRAINT "product_categories_category_code_key" UNIQUE ("category_code");



ALTER TABLE ONLY "public"."product_categories"
    ADD CONSTRAINT "product_categories_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."product_subcategories"
    ADD CONSTRAINT "product_subcategories_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."product_subcategories"
    ADD CONSTRAINT "product_subcategories_subcategory_code_key" UNIQUE ("subcategory_code");



ALTER TABLE ONLY "public"."products"
    ADD CONSTRAINT "products_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."products"
    ADD CONSTRAINT "products_product_code_key" UNIQUE ("product_code");



ALTER TABLE ONLY "public"."purchase_bill_items"
    ADD CONSTRAINT "purchase_bill_items_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."purchase_bills"
    ADD CONSTRAINT "purchase_bills_bill_number_key" UNIQUE ("bill_number");



ALTER TABLE ONLY "public"."purchase_bills"
    ADD CONSTRAINT "purchase_bills_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."purchase_order_items"
    ADD CONSTRAINT "purchase_order_items_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."purchase_orders"
    ADD CONSTRAINT "purchase_orders_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."purchase_orders"
    ADD CONSTRAINT "purchase_orders_po_number_key" UNIQUE ("po_number");



ALTER TABLE ONLY "public"."push_tokens"
    ADD CONSTRAINT "push_tokens_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."push_tokens"
    ADD CONSTRAINT "push_tokens_user_id_token_key" UNIQUE ("user_id", "token");



ALTER TABLE ONLY "public"."qr_batch_logs"
    ADD CONSTRAINT "qr_batch_logs_batch_id_key" UNIQUE ("batch_id");



ALTER TABLE ONLY "public"."qr_batch_logs"
    ADD CONSTRAINT "qr_batch_logs_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."qr_codes"
    ADD CONSTRAINT "qr_codes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."qr_scans"
    ADD CONSTRAINT "qr_scans_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."reconciliation_lines"
    ADD CONSTRAINT "reconciliation_lines_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."reconciliations"
    ADD CONSTRAINT "reconciliations_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."reconciliations"
    ADD CONSTRAINT "reconciliations_reconciliation_number_key" UNIQUE ("reconciliation_number");



ALTER TABLE ONLY "public"."reorder_rules"
    ADD CONSTRAINT "reorder_rules_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."reorder_rules"
    ADD CONSTRAINT "reorder_rules_product_id_warehouse_id_key" UNIQUE ("product_id", "warehouse_id");



ALTER TABLE ONLY "public"."request_items"
    ADD CONSTRAINT "request_items_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."requests"
    ADD CONSTRAINT "requests_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."requests"
    ADD CONSTRAINT "requests_request_number_key" UNIQUE ("request_number");



ALTER TABLE ONLY "public"."residents"
    ADD CONSTRAINT "residents_auth_user_id_key" UNIQUE ("auth_user_id");



ALTER TABLE ONLY "public"."residents"
    ADD CONSTRAINT "residents_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."residents"
    ADD CONSTRAINT "residents_resident_code_key" UNIQUE ("resident_code");



ALTER TABLE ONLY "public"."roles"
    ADD CONSTRAINT "roles_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."roles"
    ADD CONSTRAINT "roles_role_name_key" UNIQUE ("role_name");



ALTER TABLE ONLY "public"."rtv_tickets"
    ADD CONSTRAINT "rtv_tickets_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."rtv_tickets"
    ADD CONSTRAINT "rtv_tickets_rtv_number_key" UNIQUE ("rtv_number");



ALTER TABLE ONLY "public"."safety_equipment"
    ADD CONSTRAINT "safety_equipment_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."salary_components"
    ADD CONSTRAINT "salary_components_abbr_key" UNIQUE ("abbr");



ALTER TABLE ONLY "public"."salary_components"
    ADD CONSTRAINT "salary_components_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."sale_bill_items"
    ADD CONSTRAINT "sale_bill_items_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."sale_bills"
    ADD CONSTRAINT "sale_bills_invoice_number_key" UNIQUE ("invoice_number");



ALTER TABLE ONLY "public"."sale_bills"
    ADD CONSTRAINT "sale_bills_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."sale_product_rates"
    ADD CONSTRAINT "sale_product_rates_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."security_guards"
    ADD CONSTRAINT "security_guards_guard_code_key" UNIQUE ("guard_code");



ALTER TABLE ONLY "public"."security_guards"
    ADD CONSTRAINT "security_guards_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."service_acknowledgments"
    ADD CONSTRAINT "service_acknowledgments_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."service_acknowledgments"
    ADD CONSTRAINT "service_acknowledgments_spo_id_key" UNIQUE ("spo_id");



ALTER TABLE ONLY "public"."service_delivery_notes"
    ADD CONSTRAINT "service_delivery_notes_delivery_note_number_key" UNIQUE ("delivery_note_number");



ALTER TABLE ONLY "public"."service_delivery_notes"
    ADD CONSTRAINT "service_delivery_notes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."service_feedback"
    ADD CONSTRAINT "service_feedback_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."service_purchase_order_items"
    ADD CONSTRAINT "service_purchase_order_items_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."service_purchase_orders"
    ADD CONSTRAINT "service_purchase_orders_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."service_purchase_orders"
    ADD CONSTRAINT "service_purchase_orders_spo_number_key" UNIQUE ("spo_number");



ALTER TABLE ONLY "public"."service_rates"
    ADD CONSTRAINT "service_rates_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."service_rates"
    ADD CONSTRAINT "service_rates_supplier_id_service_type_effective_from_key" UNIQUE ("supplier_id", "service_type", "effective_from");



ALTER TABLE ONLY "public"."service_requests"
    ADD CONSTRAINT "service_requests_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."service_requests"
    ADD CONSTRAINT "service_requests_request_number_key" UNIQUE ("request_number");



ALTER TABLE ONLY "public"."service_tasks"
    ADD CONSTRAINT "service_tasks_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."services"
    ADD CONSTRAINT "services_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."services"
    ADD CONSTRAINT "services_service_code_key" UNIQUE ("service_code");



ALTER TABLE ONLY "public"."services_wise_work"
    ADD CONSTRAINT "services_wise_work_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."shifts"
    ADD CONSTRAINT "shifts_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."shifts"
    ADD CONSTRAINT "shifts_shift_code_key" UNIQUE ("shift_code");



ALTER TABLE ONLY "public"."shortage_note_items"
    ADD CONSTRAINT "shortage_note_items_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."shortage_notes"
    ADD CONSTRAINT "shortage_notes_note_number_key" UNIQUE ("note_number");



ALTER TABLE ONLY "public"."shortage_notes"
    ADD CONSTRAINT "shortage_notes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."societies"
    ADD CONSTRAINT "societies_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."societies"
    ADD CONSTRAINT "societies_society_code_key" UNIQUE ("society_code");



ALTER TABLE ONLY "public"."stock_batches"
    ADD CONSTRAINT "stock_batches_batch_number_product_id_warehouse_id_key" UNIQUE ("batch_number", "product_id", "warehouse_id");



ALTER TABLE ONLY "public"."stock_batches"
    ADD CONSTRAINT "stock_batches_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."stock_transactions"
    ADD CONSTRAINT "stock_transactions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."stock_transactions"
    ADD CONSTRAINT "stock_transactions_transaction_number_key" UNIQUE ("transaction_number");



ALTER TABLE ONLY "public"."storage_deletion_queue"
    ADD CONSTRAINT "storage_deletion_queue_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."supplier_products"
    ADD CONSTRAINT "supplier_products_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."supplier_products"
    ADD CONSTRAINT "supplier_products_supplier_id_product_id_key" UNIQUE ("supplier_id", "product_id");



ALTER TABLE ONLY "public"."supplier_rates"
    ADD CONSTRAINT "supplier_rates_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."suppliers"
    ADD CONSTRAINT "suppliers_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."system_config"
    ADD CONSTRAINT "system_config_pkey" PRIMARY KEY ("key");



ALTER TABLE ONLY "public"."technician_profiles"
    ADD CONSTRAINT "technician_profiles_employee_id_key" UNIQUE ("employee_id");



ALTER TABLE ONLY "public"."technician_profiles"
    ADD CONSTRAINT "technician_profiles_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."candidate_interviews"
    ADD CONSTRAINT "unique_candidate_round" UNIQUE ("candidate_id", "round_number");



ALTER TABLE ONLY "public"."employee_salary_structure"
    ADD CONSTRAINT "unique_employee_component_period" UNIQUE ("employee_id", "component_id", "effective_from");



ALTER TABLE ONLY "public"."payslips"
    ADD CONSTRAINT "unique_employee_cycle" UNIQUE ("payroll_cycle_id", "employee_id");



ALTER TABLE ONLY "public"."payroll_cycles"
    ADD CONSTRAINT "unique_payroll_period" UNIQUE ("period_month", "period_year");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_username_key" UNIQUE ("username");



ALTER TABLE ONLY "public"."vendor_wise_services"
    ADD CONSTRAINT "vendor_wise_services_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."visitor_bypass_audit"
    ADD CONSTRAINT "visitor_bypass_audit_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."visitor_photo_metadata"
    ADD CONSTRAINT "visitor_photo_metadata_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."visitor_photo_metadata"
    ADD CONSTRAINT "visitor_photo_metadata_visitor_id_photo_captured_at_key" UNIQUE ("visitor_id", "photo_captured_at");



ALTER TABLE ONLY "public"."visitors"
    ADD CONSTRAINT "visitors_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."waitlist"
    ADD CONSTRAINT "waitlist_email_key" UNIQUE ("email");



ALTER TABLE ONLY "public"."waitlist"
    ADD CONSTRAINT "waitlist_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."warehouses"
    ADD CONSTRAINT "warehouses_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."warehouses"
    ADD CONSTRAINT "warehouses_warehouse_code_key" UNIQUE ("warehouse_code");



ALTER TABLE ONLY "public"."work_master"
    ADD CONSTRAINT "work_master_pkey" PRIMARY KEY ("id");



CREATE INDEX "idx_gps_employee_time" ON ONLY "public"."gps_tracking" USING "btree" ("employee_id", "tracked_at" DESC);



CREATE INDEX "gps_tracking_2026_02_employee_id_tracked_at_idx" ON "public"."gps_tracking_2026_02" USING "btree" ("employee_id", "tracked_at" DESC);



CREATE INDEX "idx_gps_time_brin" ON ONLY "public"."gps_tracking" USING "brin" ("tracked_at");



CREATE INDEX "gps_tracking_2026_02_tracked_at_idx" ON "public"."gps_tracking_2026_02" USING "brin" ("tracked_at");



CREATE INDEX "gps_tracking_2026_03_employee_id_tracked_at_idx" ON "public"."gps_tracking_2026_03" USING "btree" ("employee_id", "tracked_at" DESC);



CREATE INDEX "gps_tracking_2026_03_tracked_at_idx" ON "public"."gps_tracking_2026_03" USING "brin" ("tracked_at");



CREATE INDEX "gps_tracking_2026_04_employee_id_tracked_at_idx" ON "public"."gps_tracking_2026_04" USING "btree" ("employee_id", "tracked_at" DESC);



CREATE INDEX "gps_tracking_2026_04_tracked_at_idx" ON "public"."gps_tracking_2026_04" USING "brin" ("tracked_at");



CREATE INDEX "gps_tracking_2026_05_employee_id_tracked_at_idx" ON "public"."gps_tracking_2026_05" USING "btree" ("employee_id", "tracked_at" DESC);



CREATE INDEX "gps_tracking_2026_05_tracked_at_idx" ON "public"."gps_tracking_2026_05" USING "brin" ("tracked_at");



CREATE INDEX "gps_tracking_2026_06_employee_id_tracked_at_idx" ON "public"."gps_tracking_2026_06" USING "btree" ("employee_id", "tracked_at" DESC);



CREATE INDEX "gps_tracking_2026_06_tracked_at_idx" ON "public"."gps_tracking_2026_06" USING "brin" ("tracked_at");



CREATE INDEX "gps_tracking_2026_07_employee_id_tracked_at_idx" ON "public"."gps_tracking_2026_07" USING "btree" ("employee_id", "tracked_at" DESC);



CREATE INDEX "gps_tracking_2026_07_tracked_at_idx" ON "public"."gps_tracking_2026_07" USING "brin" ("tracked_at");



CREATE INDEX "gps_tracking_2026_08_employee_id_tracked_at_idx" ON "public"."gps_tracking_2026_08" USING "btree" ("employee_id", "tracked_at" DESC);



CREATE INDEX "gps_tracking_2026_08_tracked_at_idx" ON "public"."gps_tracking_2026_08" USING "brin" ("tracked_at");



CREATE INDEX "gps_tracking_2026_09_employee_id_tracked_at_idx" ON "public"."gps_tracking_2026_09" USING "btree" ("employee_id", "tracked_at" DESC);



CREATE INDEX "gps_tracking_2026_09_tracked_at_idx" ON "public"."gps_tracking_2026_09" USING "brin" ("tracked_at");



CREATE INDEX "gps_tracking_2026_10_employee_id_tracked_at_idx" ON "public"."gps_tracking_2026_10" USING "btree" ("employee_id", "tracked_at" DESC);



CREATE INDEX "gps_tracking_2026_10_tracked_at_idx" ON "public"."gps_tracking_2026_10" USING "brin" ("tracked_at");



CREATE INDEX "gps_tracking_2026_11_employee_id_tracked_at_idx" ON "public"."gps_tracking_2026_11" USING "btree" ("employee_id", "tracked_at" DESC);



CREATE INDEX "gps_tracking_2026_11_tracked_at_idx" ON "public"."gps_tracking_2026_11" USING "brin" ("tracked_at");



CREATE INDEX "gps_tracking_2026_12_employee_id_tracked_at_idx" ON "public"."gps_tracking_2026_12" USING "btree" ("employee_id", "tracked_at" DESC);



CREATE INDEX "gps_tracking_2026_12_tracked_at_idx" ON "public"."gps_tracking_2026_12" USING "brin" ("tracked_at");



CREATE INDEX "gps_tracking_default_employee_id_tracked_at_idx" ON "public"."gps_tracking_default" USING "btree" ("employee_id", "tracked_at" DESC);



CREATE INDEX "gps_tracking_default_tracked_at_idx" ON "public"."gps_tracking_default" USING "brin" ("tracked_at");



CREATE INDEX "idx_ad_bookings_ad_space_id" ON "public"."printing_ad_bookings" USING "btree" ("ad_space_id");



CREATE INDEX "idx_ad_bookings_status" ON "public"."printing_ad_bookings" USING "btree" ("status");



CREATE INDEX "idx_asset_categories_created_by" ON "public"."asset_categories" USING "btree" ("created_by");



CREATE INDEX "idx_asset_categories_parent" ON "public"."asset_categories" USING "btree" ("parent_category_id");



CREATE INDEX "idx_asset_categories_updated_by" ON "public"."asset_categories" USING "btree" ("updated_by");



CREATE INDEX "idx_assets_asset_code" ON "public"."assets" USING "btree" ("asset_code");



CREATE INDEX "idx_assets_category_id" ON "public"."assets" USING "btree" ("category_id");



CREATE INDEX "idx_assets_created_by" ON "public"."assets" USING "btree" ("created_by");



CREATE INDEX "idx_assets_location_id" ON "public"."assets" USING "btree" ("location_id");



CREATE INDEX "idx_assets_society_id" ON "public"."assets" USING "btree" ("society_id");



CREATE INDEX "idx_assets_status" ON "public"."assets" USING "btree" ("status");



CREATE INDEX "idx_assets_updated_by" ON "public"."assets" USING "btree" ("updated_by");



CREATE INDEX "idx_assets_vendor_id" ON "public"."assets" USING "btree" ("vendor_id");



CREATE INDEX "idx_attendance_logs_check_in_location_id" ON "public"."attendance_logs" USING "btree" ("check_in_location_id");



CREATE INDEX "idx_attendance_logs_check_out_location_id" ON "public"."attendance_logs" USING "btree" ("check_out_location_id");



CREATE INDEX "idx_attendance_logs_employee_date" ON "public"."attendance_logs" USING "btree" ("employee_id", "log_date");



CREATE INDEX "idx_attendance_logs_employee_id" ON "public"."attendance_logs" USING "btree" ("employee_id");



CREATE INDEX "idx_attendance_logs_log_date" ON "public"."attendance_logs" USING "btree" ("log_date");



CREATE INDEX "idx_audit_logs_actor_id" ON "public"."audit_logs" USING "btree" ("actor_id");



CREATE INDEX "idx_audit_logs_created_at" ON "public"."audit_logs" USING "btree" ("created_at");



CREATE INDEX "idx_audit_logs_entity_id" ON "public"."audit_logs" USING "btree" ("entity_id");



CREATE INDEX "idx_audit_logs_entity_type" ON "public"."audit_logs" USING "btree" ("entity_type");



CREATE INDEX "idx_audit_logs_table_name" ON "public"."audit_logs" USING "btree" ("entity_type");



CREATE INDEX "idx_background_verifications_candidate_id" ON "public"."background_verifications" USING "btree" ("candidate_id");



CREATE INDEX "idx_background_verifications_employee_id" ON "public"."background_verifications" USING "btree" ("employee_id");



CREATE INDEX "idx_background_verifications_status" ON "public"."background_verifications" USING "btree" ("status");



CREATE INDEX "idx_background_verifications_verified_by" ON "public"."background_verifications" USING "btree" ("verified_by");



CREATE INDEX "idx_behavior_tickets_employee_id" ON "public"."employee_behavior_tickets" USING "btree" ("employee_id");



CREATE INDEX "idx_behavior_tickets_status" ON "public"."employee_behavior_tickets" USING "btree" ("status");



CREATE INDEX "idx_behaviour_tickets_employee_id" ON "public"."behaviour_tickets" USING "btree" ("employee_id");



CREATE INDEX "idx_behaviour_tickets_raised_by" ON "public"."behaviour_tickets" USING "btree" ("raised_by");



CREATE INDEX "idx_budgets_created_by" ON "public"."budgets" USING "btree" ("created_by");



CREATE INDEX "idx_budgets_dept_cat" ON "public"."budgets" USING "btree" ("department", "category");



CREATE INDEX "idx_budgets_period" ON "public"."budgets" USING "btree" ("financial_period_id");



CREATE INDEX "idx_budgets_status" ON "public"."budgets" USING "btree" ("status");



CREATE INDEX "idx_buyer_accounts_account_type" ON "public"."buyer_accounts" USING "btree" ("account_type");



CREATE INDEX "idx_buyer_accounts_auth_user_id" ON "public"."buyer_accounts" USING "btree" ("auth_user_id");



CREATE INDEX "idx_buyer_accounts_society_id" ON "public"."buyer_accounts" USING "btree" ("society_id");



CREATE INDEX "idx_buyer_feedback_request_id" ON "public"."buyer_feedback" USING "btree" ("request_id");



CREATE INDEX "idx_buyer_feedback_service_request_id" ON "public"."buyer_feedback" USING "btree" ("service_request_id");



CREATE INDEX "idx_buyer_feedback_submitted_by" ON "public"."buyer_feedback" USING "btree" ("submitted_by");



CREATE INDEX "idx_candidate_interviews_candidate" ON "public"."candidate_interviews" USING "btree" ("candidate_id");



CREATE INDEX "idx_candidate_interviews_created_by" ON "public"."candidate_interviews" USING "btree" ("created_by");



CREATE INDEX "idx_candidate_interviews_interviewer" ON "public"."candidate_interviews" USING "btree" ("interviewer_id");



CREATE INDEX "idx_candidate_interviews_scheduled" ON "public"."candidate_interviews" USING "btree" ("scheduled_at");



CREATE INDEX "idx_candidate_interviews_status" ON "public"."candidate_interviews" USING "btree" ("status");



CREATE INDEX "idx_candidate_interviews_updated_by" ON "public"."candidate_interviews" USING "btree" ("updated_by");



CREATE INDEX "idx_candidates_applied_position" ON "public"."candidates" USING "btree" ("applied_position");



CREATE INDEX "idx_candidates_converted_employee_id" ON "public"."candidates" USING "btree" ("converted_employee_id");



CREATE INDEX "idx_candidates_created_at" ON "public"."candidates" USING "btree" ("created_at" DESC);



CREATE INDEX "idx_candidates_created_by" ON "public"."candidates" USING "btree" ("created_by");



CREATE INDEX "idx_candidates_department" ON "public"."candidates" USING "btree" ("department");



CREATE INDEX "idx_candidates_designation_id" ON "public"."candidates" USING "btree" ("designation_id");



CREATE INDEX "idx_candidates_email" ON "public"."candidates" USING "btree" ("email");



CREATE INDEX "idx_candidates_interviewer_id" ON "public"."candidates" USING "btree" ("interviewer_id");



CREATE INDEX "idx_candidates_referred_by" ON "public"."candidates" USING "btree" ("referred_by");



CREATE INDEX "idx_candidates_status" ON "public"."candidates" USING "btree" ("status");



CREATE INDEX "idx_candidates_status_changed_by" ON "public"."candidates" USING "btree" ("status_changed_by");



CREATE INDEX "idx_candidates_updated_by" ON "public"."candidates" USING "btree" ("updated_by");



CREATE INDEX "idx_checklist_response_override_audit_response" ON "public"."checklist_response_override_audit" USING "btree" ("response_id", "acted_at" DESC);



CREATE INDEX "idx_checklist_responses_employee_id" ON "public"."checklist_responses" USING "btree" ("employee_id");



CREATE INDEX "idx_checklist_responses_location_id" ON "public"."checklist_responses" USING "btree" ("location_id");



CREATE INDEX "idx_checklist_responses_override_status" ON "public"."checklist_responses" USING "btree" ("employee_id", "response_date", "override_status");



CREATE INDEX "idx_company_events_created_by" ON "public"."company_events" USING "btree" ("created_by");



CREATE INDEX "idx_company_events_location_id" ON "public"."company_events" USING "btree" ("location_id");



CREATE INDEX "idx_company_locations_created_by" ON "public"."company_locations" USING "btree" ("created_by");



CREATE INDEX "idx_company_locations_society_id" ON "public"."company_locations" USING "btree" ("society_id");



CREATE INDEX "idx_compliance_snapshots_created_by" ON "public"."compliance_snapshots" USING "btree" ("created_by");



CREATE INDEX "idx_compliance_snapshots_period_id" ON "public"."compliance_snapshots" USING "btree" ("period_id");



CREATE INDEX "idx_contracts_created_by" ON "public"."contracts" USING "btree" ("created_by");



CREATE INDEX "idx_contracts_dates" ON "public"."contracts" USING "btree" ("start_date", "end_date");



CREATE INDEX "idx_contracts_society" ON "public"."contracts" USING "btree" ("society_id");



CREATE INDEX "idx_contracts_status" ON "public"."contracts" USING "btree" ("status");



CREATE INDEX "idx_contracts_updated_by" ON "public"."contracts" USING "btree" ("updated_by");



CREATE INDEX "idx_credit_notes_issued_at" ON "public"."credit_notes" USING "btree" ("issued_at");



CREATE INDEX "idx_credit_notes_sale_bill_id" ON "public"."credit_notes" USING "btree" ("sale_bill_id");



CREATE INDEX "idx_daily_checklist_items_checklist_id" ON "public"."daily_checklist_items" USING "btree" ("checklist_id");



CREATE INDEX "idx_daily_checklist_items_shift_id" ON "public"."daily_checklist_items" USING "btree" ("shift_id");



CREATE INDEX "idx_daily_checklists_created_by" ON "public"."daily_checklists" USING "btree" ("created_by");



CREATE INDEX "idx_debit_notes_issued_at" ON "public"."debit_notes" USING "btree" ("issued_at");



CREATE INDEX "idx_debit_notes_sale_bill_id" ON "public"."debit_notes" USING "btree" ("sale_bill_id");



CREATE INDEX "idx_designations_created_by" ON "public"."designations" USING "btree" ("created_by");



CREATE INDEX "idx_designations_updated_by" ON "public"."designations" USING "btree" ("updated_by");



CREATE INDEX "idx_emergency_contacts_society_id" ON "public"."emergency_contacts" USING "btree" ("society_id");



CREATE INDEX "idx_employee_behavior_tickets_reported_by" ON "public"."employee_behavior_tickets" USING "btree" ("reported_by");



CREATE INDEX "idx_employee_documents_created_by" ON "public"."employee_documents" USING "btree" ("created_by");



CREATE INDEX "idx_employee_documents_employee" ON "public"."employee_documents" USING "btree" ("employee_id");



CREATE INDEX "idx_employee_documents_expiry" ON "public"."employee_documents" USING "btree" ("expiry_date") WHERE ("expiry_date" IS NOT NULL);



CREATE INDEX "idx_employee_documents_status" ON "public"."employee_documents" USING "btree" ("status");



CREATE INDEX "idx_employee_documents_type" ON "public"."employee_documents" USING "btree" ("document_type");



CREATE INDEX "idx_employee_documents_updated_by" ON "public"."employee_documents" USING "btree" ("updated_by");



CREATE INDEX "idx_employee_documents_verified_by" ON "public"."employee_documents" USING "btree" ("verified_by");



CREATE INDEX "idx_employee_salary_structure_active" ON "public"."employee_salary_structure" USING "btree" ("effective_to") WHERE ("effective_to" IS NULL);



CREATE INDEX "idx_employee_salary_structure_component" ON "public"."employee_salary_structure" USING "btree" ("component_id");



CREATE INDEX "idx_employee_salary_structure_created_by" ON "public"."employee_salary_structure" USING "btree" ("created_by");



CREATE INDEX "idx_employee_salary_structure_employee" ON "public"."employee_salary_structure" USING "btree" ("employee_id");



CREATE INDEX "idx_employee_salary_structure_updated_by" ON "public"."employee_salary_structure" USING "btree" ("updated_by");



CREATE INDEX "idx_employee_shift_assignments_assigned_by" ON "public"."employee_shift_assignments" USING "btree" ("assigned_by");



CREATE INDEX "idx_employee_shift_assignments_employee_id" ON "public"."employee_shift_assignments" USING "btree" ("employee_id");



CREATE INDEX "idx_employee_shift_assignments_shift_id" ON "public"."employee_shift_assignments" USING "btree" ("shift_id");



CREATE INDEX "idx_employees_auth_user_id" ON "public"."employees" USING "btree" ("auth_user_id");



CREATE INDEX "idx_employees_created_by" ON "public"."employees" USING "btree" ("created_by");



CREATE INDEX "idx_employees_designation_id" ON "public"."employees" USING "btree" ("designation_id");



CREATE INDEX "idx_employees_reporting_to" ON "public"."employees" USING "btree" ("reporting_to");



CREATE INDEX "idx_employees_updated_by" ON "public"."employees" USING "btree" ("updated_by");



CREATE INDEX "idx_financial_periods_closed_by" ON "public"."financial_periods" USING "btree" ("closed_by");



CREATE INDEX "idx_financial_periods_created_by" ON "public"."financial_periods" USING "btree" ("created_by");



CREATE INDEX "idx_financial_periods_dates" ON "public"."financial_periods" USING "btree" ("start_date", "end_date");



CREATE INDEX "idx_financial_periods_status" ON "public"."financial_periods" USING "btree" ("status");



CREATE INDEX "idx_guard_gps_tracking_guard_id" ON "public"."guard_gps_tracking" USING "btree" ("guard_id");



CREATE INDEX "idx_guard_gps_tracking_recorded_at" ON "public"."guard_gps_tracking" USING "btree" ("recorded_at" DESC);



CREATE INDEX "idx_guard_gps_tracking_shift_id" ON "public"."guard_gps_tracking" USING "btree" ("shift_id");



CREATE INDEX "idx_guard_gps_tracking_within_fence" ON "public"."guard_gps_tracking" USING "btree" ("is_within_fence");



CREATE INDEX "idx_guard_panic_alerts_guard_id" ON "public"."guard_panic_alerts" USING "btree" ("guard_id");



CREATE INDEX "idx_guard_panic_alerts_shift_id" ON "public"."guard_panic_alerts" USING "btree" ("shift_id");



CREATE INDEX "idx_guard_panic_alerts_status" ON "public"."guard_panic_alerts" USING "btree" ("status");



CREATE INDEX "idx_guard_panic_alerts_triggered_at" ON "public"."guard_panic_alerts" USING "btree" ("triggered_at" DESC);



CREATE INDEX "idx_guard_patrol_logs_guard_id" ON "public"."guard_patrol_logs" USING "btree" ("guard_id");



CREATE INDEX "idx_holidays_created_by" ON "public"."holidays" USING "btree" ("created_by");



CREATE INDEX "idx_holidays_date" ON "public"."holidays" USING "btree" ("holiday_date");



CREATE INDEX "idx_holidays_year" ON "public"."holidays" USING "btree" ("year");



CREATE INDEX "idx_horticulture_seasonal_plans_status" ON "public"."horticulture_seasonal_plans" USING "btree" ("status");



CREATE INDEX "idx_horticulture_seasonal_plans_zone_id" ON "public"."horticulture_seasonal_plans" USING "btree" ("zone_id");



CREATE INDEX "idx_horticulture_tasks_assigned_to" ON "public"."horticulture_tasks" USING "btree" ("assigned_to");



CREATE INDEX "idx_horticulture_tasks_plan_id" ON "public"."horticulture_tasks" USING "btree" ("plan_id");



CREATE INDEX "idx_horticulture_tasks_scheduled_date" ON "public"."horticulture_tasks" USING "btree" ("scheduled_date");



CREATE INDEX "idx_horticulture_tasks_status" ON "public"."horticulture_tasks" USING "btree" ("status");



CREATE INDEX "idx_horticulture_tasks_zone_id" ON "public"."horticulture_tasks" USING "btree" ("zone_id");



CREATE INDEX "idx_horticulture_zones_location_id" ON "public"."horticulture_zones" USING "btree" ("location_id");



CREATE INDEX "idx_indent_items_indent" ON "public"."indent_items" USING "btree" ("indent_id");



CREATE INDEX "idx_indent_items_override_approved_by" ON "public"."indent_items" USING "btree" ("override_approved_by");



CREATE INDEX "idx_indent_items_product" ON "public"."indent_items" USING "btree" ("product_id");



CREATE INDEX "idx_indents_approved_by" ON "public"."indents" USING "btree" ("approved_by");



CREATE INDEX "idx_indents_created_at" ON "public"."indents" USING "btree" ("created_at" DESC);



CREATE INDEX "idx_indents_created_by" ON "public"."indents" USING "btree" ("created_by");



CREATE INDEX "idx_indents_department" ON "public"."indents" USING "btree" ("department");



CREATE INDEX "idx_indents_linked_po_id" ON "public"."indents" USING "btree" ("linked_po_id");



CREATE INDEX "idx_indents_location" ON "public"."indents" USING "btree" ("location_id");



CREATE INDEX "idx_indents_rejected_by" ON "public"."indents" USING "btree" ("rejected_by");



CREATE INDEX "idx_indents_requester" ON "public"."indents" USING "btree" ("requester_id");



CREATE INDEX "idx_indents_service_request_id" ON "public"."indents" USING "btree" ("service_request_id");



CREATE INDEX "idx_indents_society" ON "public"."indents" USING "btree" ("society_id");



CREATE INDEX "idx_indents_status" ON "public"."indents" USING "btree" ("status");



CREATE INDEX "idx_indents_submitted_by" ON "public"."indents" USING "btree" ("submitted_by");



CREATE INDEX "idx_indents_supplier_id" ON "public"."indents" USING "btree" ("supplier_id");



CREATE INDEX "idx_indents_updated_by" ON "public"."indents" USING "btree" ("updated_by");



CREATE INDEX "idx_inventory_location_id" ON "public"."inventory" USING "btree" ("location_id");



CREATE INDEX "idx_inventory_product_id" ON "public"."inventory" USING "btree" ("product_id");



CREATE INDEX "idx_job_materials_used_created_by" ON "public"."job_materials_used" USING "btree" ("created_by");



CREATE INDEX "idx_job_materials_used_job_session_id" ON "public"."job_materials_used" USING "btree" ("job_session_id");



CREATE INDEX "idx_job_materials_used_product_id" ON "public"."job_materials_used" USING "btree" ("product_id");



CREATE INDEX "idx_job_materials_used_stock_batch_id" ON "public"."job_materials_used" USING "btree" ("stock_batch_id");



CREATE INDEX "idx_job_photos_job_session_id" ON "public"."job_photos" USING "btree" ("job_session_id");



CREATE INDEX "idx_job_sessions_service_request_id" ON "public"."job_sessions" USING "btree" ("service_request_id");



CREATE INDEX "idx_job_sessions_status" ON "public"."job_sessions" USING "btree" ("status");



CREATE INDEX "idx_job_sessions_technician_id" ON "public"."job_sessions" USING "btree" ("technician_id");



CREATE INDEX "idx_leave_applications_leave_type_id" ON "public"."leave_applications" USING "btree" ("leave_type_id");



CREATE INDEX "idx_leave_apps_approved_by" ON "public"."leave_applications" USING "btree" ("approved_by");



CREATE INDEX "idx_leave_apps_employee_status" ON "public"."leave_applications" USING "btree" ("employee_id", "status");



CREATE INDEX "idx_login_rate_limits_ip" ON "public"."login_rate_limits" USING "btree" ("ip_address");



CREATE INDEX "idx_maintenance_schedules_asset_id" ON "public"."maintenance_schedules" USING "btree" ("asset_id");



CREATE INDEX "idx_maintenance_schedules_assigned_to_employee" ON "public"."maintenance_schedules" USING "btree" ("assigned_to_employee");



CREATE INDEX "idx_maintenance_schedules_assigned_to_role" ON "public"."maintenance_schedules" USING "btree" ("assigned_to_role");



CREATE INDEX "idx_maintenance_schedules_created_by" ON "public"."maintenance_schedules" USING "btree" ("created_by");



CREATE INDEX "idx_maintenance_schedules_next_due_date" ON "public"."maintenance_schedules" USING "btree" ("next_due_date");



CREATE INDEX "idx_material_arrival_evidence_logged_by" ON "public"."material_arrival_evidence" USING "btree" ("logged_by");



CREATE INDEX "idx_material_arrival_evidence_po_id" ON "public"."material_arrival_evidence" USING "btree" ("po_id");



CREATE INDEX "idx_material_arrival_logged_at" ON "public"."material_arrival_logs" USING "btree" ("logged_at" DESC);



CREATE INDEX "idx_material_arrival_logged_by" ON "public"."material_arrival_logs" USING "btree" ("logged_by");



CREATE INDEX "idx_material_arrival_po" ON "public"."material_arrival_logs" USING "btree" ("po_id");



CREATE INDEX "idx_material_receipt_items_grn" ON "public"."material_receipt_items" USING "btree" ("material_receipt_id");



CREATE INDEX "idx_material_receipt_items_po_item" ON "public"."material_receipt_items" USING "btree" ("po_item_id");



CREATE INDEX "idx_material_receipt_items_product" ON "public"."material_receipt_items" USING "btree" ("product_id");



CREATE INDEX "idx_material_receipts_created_at" ON "public"."material_receipts" USING "btree" ("created_at" DESC);



CREATE INDEX "idx_material_receipts_created_by" ON "public"."material_receipts" USING "btree" ("created_by");



CREATE INDEX "idx_material_receipts_po" ON "public"."material_receipts" USING "btree" ("purchase_order_id");



CREATE INDEX "idx_material_receipts_quality_checked_by" ON "public"."material_receipts" USING "btree" ("quality_checked_by");



CREATE INDEX "idx_material_receipts_received_by" ON "public"."material_receipts" USING "btree" ("received_by");



CREATE INDEX "idx_material_receipts_status" ON "public"."material_receipts" USING "btree" ("status");



CREATE INDEX "idx_material_receipts_supplier" ON "public"."material_receipts" USING "btree" ("supplier_id");



CREATE INDEX "idx_material_receipts_updated_by" ON "public"."material_receipts" USING "btree" ("updated_by");



CREATE INDEX "idx_material_receipts_warehouse_id" ON "public"."material_receipts" USING "btree" ("warehouse_id");



CREATE INDEX "idx_notification_logs_notification_id" ON "public"."notification_logs" USING "btree" ("notification_id", "sent_at" DESC);



CREATE INDEX "idx_notification_logs_user_id" ON "public"."notification_logs" USING "btree" ("user_id");



CREATE INDEX "idx_notifications_created_at" ON "public"."notifications" USING "btree" ("created_at");



CREATE INDEX "idx_notifications_delivery_state" ON "public"."notifications" USING "btree" ("user_id", "delivery_state", "created_at" DESC);



CREATE INDEX "idx_notifications_is_read" ON "public"."notifications" USING "btree" ("user_id", "is_read");



CREATE INDEX "idx_notifications_user_id" ON "public"."notifications" USING "btree" ("user_id");



CREATE INDEX "idx_notifications_user_unread" ON "public"."notifications" USING "btree" ("user_id") WHERE ("is_read" = false);



CREATE INDEX "idx_oversight_tickets_parent" ON "public"."oversight_tickets" USING "btree" ("parent_ticket_id");



CREATE INDEX "idx_oversight_tickets_source_visitor" ON "public"."oversight_tickets" USING "btree" ("source_visitor_id");



CREATE INDEX "idx_oversight_tickets_status_created" ON "public"."oversight_tickets" USING "btree" ("status", "created_at" DESC);



CREATE INDEX "idx_panic_alerts_ack_state" ON "public"."panic_alerts" USING "btree" ("is_resolved", "acknowledged_at", "alert_time" DESC);



CREATE INDEX "idx_panic_alerts_guard_resolved" ON "public"."panic_alerts" USING "btree" ("guard_id", "resolved_at");



CREATE INDEX "idx_panic_alerts_location_id" ON "public"."panic_alerts" USING "btree" ("location_id");



CREATE INDEX "idx_panic_alerts_resolved_by" ON "public"."panic_alerts" USING "btree" ("resolved_by");



CREATE INDEX "idx_payments_external_id" ON "public"."payments" USING "btree" ("external_id");



CREATE UNIQUE INDEX "idx_payments_idempotency" ON "public"."payments" USING "btree" ("reference_id", "payment_type") WHERE ((("status")::"text" <> 'failed'::"text") AND (("status")::"text" <> 'refunded'::"text"));



CREATE INDEX "idx_payments_payment_method_id" ON "public"."payments" USING "btree" ("payment_method_id");



CREATE INDEX "idx_payments_processed_by" ON "public"."payments" USING "btree" ("processed_by");



CREATE INDEX "idx_payments_reference" ON "public"."payments" USING "btree" ("reference_type", "reference_id");



CREATE INDEX "idx_payroll_cycles_approved_by" ON "public"."payroll_cycles" USING "btree" ("approved_by");



CREATE INDEX "idx_payroll_cycles_computed_by" ON "public"."payroll_cycles" USING "btree" ("computed_by");



CREATE INDEX "idx_payroll_cycles_created_by" ON "public"."payroll_cycles" USING "btree" ("created_by");



CREATE INDEX "idx_payroll_cycles_disbursed_by" ON "public"."payroll_cycles" USING "btree" ("disbursed_by");



CREATE INDEX "idx_payroll_cycles_period" ON "public"."payroll_cycles" USING "btree" ("period_year", "period_month");



CREATE INDEX "idx_payroll_cycles_status" ON "public"."payroll_cycles" USING "btree" ("status");



CREATE INDEX "idx_payroll_cycles_updated_by" ON "public"."payroll_cycles" USING "btree" ("updated_by");



CREATE INDEX "idx_payslips_created_by" ON "public"."payslips" USING "btree" ("created_by");



CREATE INDEX "idx_payslips_cycle" ON "public"."payslips" USING "btree" ("payroll_cycle_id");



CREATE INDEX "idx_payslips_employee" ON "public"."payslips" USING "btree" ("employee_id");



CREATE INDEX "idx_payslips_status" ON "public"."payslips" USING "btree" ("status");



CREATE INDEX "idx_payslips_updated_by" ON "public"."payslips" USING "btree" ("updated_by");



CREATE INDEX "idx_pc_chemicals_product" ON "public"."pest_control_chemicals" USING "btree" ("product_id");



CREATE INDEX "idx_pc_ppe_request" ON "public"."pest_control_ppe_verifications" USING "btree" ("service_request_id");



CREATE INDEX "idx_pc_ppe_technician" ON "public"."pest_control_ppe_verifications" USING "btree" ("technician_id");



CREATE INDEX "idx_personnel_dispatches_confirmed_by" ON "public"."personnel_dispatches" USING "btree" ("confirmed_by");



CREATE INDEX "idx_personnel_dispatches_created_by" ON "public"."personnel_dispatches" USING "btree" ("created_by");



CREATE INDEX "idx_personnel_dispatches_deployment_site_id" ON "public"."personnel_dispatches" USING "btree" ("deployment_site_id");



CREATE INDEX "idx_personnel_dispatches_employee_id" ON "public"."personnel_dispatches" USING "btree" ("employee_id");



CREATE INDEX "idx_personnel_dispatches_po_id" ON "public"."personnel_dispatches" USING "btree" ("service_po_id");



CREATE INDEX "idx_personnel_dispatches_status" ON "public"."personnel_dispatches" USING "btree" ("status");



CREATE INDEX "idx_personnel_dispatches_supplier_id" ON "public"."personnel_dispatches" USING "btree" ("supplier_id");



CREATE INDEX "idx_pest_control_chemicals_created_by" ON "public"."pest_control_chemicals" USING "btree" ("created_by");



CREATE INDEX "idx_pest_control_chemicals_expiry" ON "public"."pest_control_chemicals" USING "btree" ("expiry_date");



CREATE INDEX "idx_pest_control_chemicals_updated_by" ON "public"."pest_control_chemicals" USING "btree" ("updated_by");



CREATE INDEX "idx_pest_control_ppe_verifications_created_by" ON "public"."pest_control_ppe_verifications" USING "btree" ("created_by");



CREATE INDEX "idx_pest_control_spill_kits_inspected_by" ON "public"."pest_control_spill_kits" USING "btree" ("inspected_by");



CREATE INDEX "idx_pest_control_spill_kits_location_id" ON "public"."pest_control_spill_kits" USING "btree" ("location_id");



CREATE INDEX "idx_pest_control_spill_kits_status" ON "public"."pest_control_spill_kits" USING "btree" ("status");



CREATE INDEX "idx_printing_ad_bookings_approved_by" ON "public"."printing_ad_bookings" USING "btree" ("approved_by");



CREATE INDEX "idx_printing_ad_bookings_created_by" ON "public"."printing_ad_bookings" USING "btree" ("created_by");



CREATE INDEX "idx_printing_ad_spaces_asset_id" ON "public"."printing_ad_spaces" USING "btree" ("asset_id");



CREATE INDEX "idx_printing_ad_spaces_created_by" ON "public"."printing_ad_spaces" USING "btree" ("created_by");



CREATE INDEX "idx_printing_ad_spaces_updated_by" ON "public"."printing_ad_spaces" USING "btree" ("updated_by");



CREATE INDEX "idx_printing_ad_status" ON "public"."printing_ad_spaces" USING "btree" ("status");



CREATE INDEX "idx_product_categories_created_by" ON "public"."product_categories" USING "btree" ("created_by");



CREATE INDEX "idx_product_categories_parent_category_id" ON "public"."product_categories" USING "btree" ("parent_category_id");



CREATE INDEX "idx_product_categories_updated_by" ON "public"."product_categories" USING "btree" ("updated_by");



CREATE INDEX "idx_product_subcategories_category_id" ON "public"."product_subcategories" USING "btree" ("category_id");



CREATE INDEX "idx_product_subcategories_created_by" ON "public"."product_subcategories" USING "btree" ("created_by");



CREATE INDEX "idx_product_subcategories_updated_by" ON "public"."product_subcategories" USING "btree" ("updated_by");



CREATE INDEX "idx_products_category_id" ON "public"."products" USING "btree" ("category_id");



CREATE INDEX "idx_products_created_by" ON "public"."products" USING "btree" ("created_by");



CREATE INDEX "idx_products_current_stock" ON "public"."products" USING "btree" ("current_stock");



CREATE INDEX "idx_products_product_code" ON "public"."products" USING "btree" ("product_code");



CREATE INDEX "idx_products_status" ON "public"."products" USING "btree" ("status");



CREATE INDEX "idx_products_subcategory_id" ON "public"."products" USING "btree" ("subcategory_id");



CREATE INDEX "idx_products_updated_by" ON "public"."products" USING "btree" ("updated_by");



CREATE INDEX "idx_purchase_bill_items_bill" ON "public"."purchase_bill_items" USING "btree" ("purchase_bill_id");



CREATE INDEX "idx_purchase_bill_items_grn_item_id" ON "public"."purchase_bill_items" USING "btree" ("grn_item_id");



CREATE INDEX "idx_purchase_bill_items_po_item_id" ON "public"."purchase_bill_items" USING "btree" ("po_item_id");



CREATE INDEX "idx_purchase_bill_items_product" ON "public"."purchase_bill_items" USING "btree" ("product_id");



CREATE INDEX "idx_purchase_bills_budget_id" ON "public"."purchase_bills" USING "btree" ("budget_id");



CREATE INDEX "idx_purchase_bills_created_at" ON "public"."purchase_bills" USING "btree" ("created_at" DESC);



CREATE INDEX "idx_purchase_bills_created_by" ON "public"."purchase_bills" USING "btree" ("created_by");



CREATE INDEX "idx_purchase_bills_grn" ON "public"."purchase_bills" USING "btree" ("material_receipt_id");



CREATE INDEX "idx_purchase_bills_payment_status" ON "public"."purchase_bills" USING "btree" ("payment_status");



CREATE INDEX "idx_purchase_bills_po" ON "public"."purchase_bills" USING "btree" ("purchase_order_id");



CREATE INDEX "idx_purchase_bills_reconciled_by" ON "public"."purchase_bills" USING "btree" ("reconciled_by");



CREATE INDEX "idx_purchase_bills_service_purchase_order_id" ON "public"."purchase_bills" USING "btree" ("service_purchase_order_id");



CREATE INDEX "idx_purchase_bills_status" ON "public"."purchase_bills" USING "btree" ("status");



CREATE INDEX "idx_purchase_bills_supplier" ON "public"."purchase_bills" USING "btree" ("supplier_id");



CREATE INDEX "idx_purchase_bills_updated_by" ON "public"."purchase_bills" USING "btree" ("updated_by");



CREATE INDEX "idx_purchase_order_items_indent_item" ON "public"."purchase_order_items" USING "btree" ("indent_item_id");



CREATE INDEX "idx_purchase_order_items_po" ON "public"."purchase_order_items" USING "btree" ("purchase_order_id");



CREATE INDEX "idx_purchase_order_items_product" ON "public"."purchase_order_items" USING "btree" ("product_id");



CREATE INDEX "idx_purchase_orders_created_at" ON "public"."purchase_orders" USING "btree" ("created_at" DESC);



CREATE INDEX "idx_purchase_orders_created_by" ON "public"."purchase_orders" USING "btree" ("created_by");



CREATE INDEX "idx_purchase_orders_indent" ON "public"."purchase_orders" USING "btree" ("indent_id");



CREATE INDEX "idx_purchase_orders_status" ON "public"."purchase_orders" USING "btree" ("status");



CREATE INDEX "idx_purchase_orders_supplier" ON "public"."purchase_orders" USING "btree" ("supplier_id");



CREATE INDEX "idx_purchase_orders_updated_by" ON "public"."purchase_orders" USING "btree" ("updated_by");



CREATE INDEX "idx_push_tokens_user_id" ON "public"."push_tokens" USING "btree" ("user_id");



CREATE INDEX "idx_qr_batch_logs_batch_id" ON "public"."qr_batch_logs" USING "btree" ("batch_id");



CREATE INDEX "idx_qr_batch_logs_generated_at" ON "public"."qr_batch_logs" USING "btree" ("generated_at");



CREATE INDEX "idx_qr_batch_logs_generated_by" ON "public"."qr_batch_logs" USING "btree" ("generated_by");



CREATE INDEX "idx_qr_batch_logs_society" ON "public"."qr_batch_logs" USING "btree" ("society_id");



CREATE INDEX "idx_qr_batch_logs_warehouse_id" ON "public"."qr_batch_logs" USING "btree" ("warehouse_id");



CREATE INDEX "idx_qr_codes_asset_id" ON "public"."qr_codes" USING "btree" ("asset_id");



CREATE INDEX "idx_qr_codes_batch_id" ON "public"."qr_codes" USING "btree" ("batch_id");



CREATE INDEX "idx_qr_codes_claimed_by" ON "public"."qr_codes" USING "btree" ("claimed_by");



CREATE INDEX "idx_qr_codes_created_by" ON "public"."qr_codes" USING "btree" ("created_by");



CREATE INDEX "idx_qr_codes_is_linked" ON "public"."qr_codes" USING "btree" ("is_linked");



CREATE INDEX "idx_qr_codes_sequence" ON "public"."qr_codes" USING "btree" ("sequence_number");



CREATE INDEX "idx_qr_codes_society_id" ON "public"."qr_codes" USING "btree" ("society_id");



CREATE INDEX "idx_qr_codes_warehouse_id" ON "public"."qr_codes" USING "btree" ("warehouse_id");



CREATE INDEX "idx_qr_scans_qr_id" ON "public"."qr_scans" USING "btree" ("qr_id");



CREATE INDEX "idx_qr_scans_scanned_at" ON "public"."qr_scans" USING "btree" ("scanned_at");



CREATE INDEX "idx_qr_scans_scanned_by" ON "public"."qr_scans" USING "btree" ("scanned_by");



CREATE INDEX "idx_reconciliation_lines_bill_item" ON "public"."reconciliation_lines" USING "btree" ("bill_item_id") WHERE ("bill_item_id" IS NOT NULL);



CREATE INDEX "idx_reconciliation_lines_grn_item" ON "public"."reconciliation_lines" USING "btree" ("grn_item_id") WHERE ("grn_item_id" IS NOT NULL);



CREATE INDEX "idx_reconciliation_lines_po_item" ON "public"."reconciliation_lines" USING "btree" ("po_item_id") WHERE ("po_item_id" IS NOT NULL);



CREATE INDEX "idx_reconciliation_lines_product" ON "public"."reconciliation_lines" USING "btree" ("product_id");



CREATE INDEX "idx_reconciliation_lines_reconciliation" ON "public"."reconciliation_lines" USING "btree" ("reconciliation_id");



CREATE INDEX "idx_reconciliation_lines_resolved_by" ON "public"."reconciliation_lines" USING "btree" ("resolved_by");



CREATE INDEX "idx_reconciliation_lines_status" ON "public"."reconciliation_lines" USING "btree" ("status");



CREATE INDEX "idx_reconciliations_bill" ON "public"."reconciliations" USING "btree" ("purchase_bill_id");



CREATE INDEX "idx_reconciliations_created" ON "public"."reconciliations" USING "btree" ("created_at" DESC);



CREATE INDEX "idx_reconciliations_created_by" ON "public"."reconciliations" USING "btree" ("created_by");



CREATE INDEX "idx_reconciliations_grn" ON "public"."reconciliations" USING "btree" ("material_receipt_id");



CREATE INDEX "idx_reconciliations_po" ON "public"."reconciliations" USING "btree" ("purchase_order_id");



CREATE INDEX "idx_reconciliations_resolved_by" ON "public"."reconciliations" USING "btree" ("resolved_by");



CREATE INDEX "idx_reconciliations_status" ON "public"."reconciliations" USING "btree" ("status");



CREATE INDEX "idx_reconciliations_updated_by" ON "public"."reconciliations" USING "btree" ("updated_by");



CREATE INDEX "idx_reorder_rules_preferred_supplier_id" ON "public"."reorder_rules" USING "btree" ("preferred_supplier_id");



CREATE INDEX "idx_reorder_rules_warehouse_id" ON "public"."reorder_rules" USING "btree" ("warehouse_id");



CREATE INDEX "idx_request_items_product_id" ON "public"."request_items" USING "btree" ("product_id");



CREATE INDEX "idx_request_items_request" ON "public"."request_items" USING "btree" ("request_id");



CREATE INDEX "idx_requests_buyer" ON "public"."requests" USING "btree" ("buyer_id");



CREATE INDEX "idx_requests_category" ON "public"."requests" USING "btree" ("category_id");



CREATE INDEX "idx_requests_created_by" ON "public"."requests" USING "btree" ("created_by");



CREATE INDEX "idx_requests_indent_id" ON "public"."requests" USING "btree" ("indent_id");



CREATE INDEX "idx_requests_is_service_request" ON "public"."requests" USING "btree" ("is_service_request");



CREATE INDEX "idx_requests_location_id" ON "public"."requests" USING "btree" ("location_id");



CREATE INDEX "idx_requests_rejected_by" ON "public"."requests" USING "btree" ("rejected_by");



CREATE INDEX "idx_requests_service_type" ON "public"."requests" USING "btree" ("service_type");



CREATE INDEX "idx_requests_site_location_id" ON "public"."requests" USING "btree" ("site_location_id");



CREATE INDEX "idx_requests_status" ON "public"."requests" USING "btree" ("status");



CREATE INDEX "idx_requests_supplier_id" ON "public"."requests" USING "btree" ("supplier_id");



CREATE INDEX "idx_requests_updated_by" ON "public"."requests" USING "btree" ("updated_by");



CREATE INDEX "idx_residents_auth_user_id" ON "public"."residents" USING "btree" ("auth_user_id");



CREATE INDEX "idx_residents_flat_id" ON "public"."residents" USING "btree" ("flat_id");



CREATE INDEX "idx_roles_created_by" ON "public"."roles" USING "btree" ("created_by");



CREATE INDEX "idx_roles_updated_by" ON "public"."roles" USING "btree" ("updated_by");



CREATE INDEX "idx_rtv_tickets_po_id" ON "public"."rtv_tickets" USING "btree" ("po_id");



CREATE INDEX "idx_rtv_tickets_product_id" ON "public"."rtv_tickets" USING "btree" ("product_id");



CREATE INDEX "idx_rtv_tickets_raised_by" ON "public"."rtv_tickets" USING "btree" ("raised_by");



CREATE INDEX "idx_rtv_tickets_receipt_id" ON "public"."rtv_tickets" USING "btree" ("receipt_id");



CREATE INDEX "idx_rtv_tickets_supplier_id" ON "public"."rtv_tickets" USING "btree" ("supplier_id");



CREATE INDEX "idx_salary_components_active" ON "public"."salary_components" USING "btree" ("is_active") WHERE ("is_active" = true);



CREATE INDEX "idx_salary_components_created_by" ON "public"."salary_components" USING "btree" ("created_by");



CREATE INDEX "idx_salary_components_type" ON "public"."salary_components" USING "btree" ("type");



CREATE INDEX "idx_salary_components_updated_by" ON "public"."salary_components" USING "btree" ("updated_by");



CREATE INDEX "idx_sale_bill_items_bill" ON "public"."sale_bill_items" USING "btree" ("sale_bill_id");



CREATE INDEX "idx_sale_bill_items_product_id" ON "public"."sale_bill_items" USING "btree" ("product_id");



CREATE INDEX "idx_sale_bill_items_service_id" ON "public"."sale_bill_items" USING "btree" ("service_id");



CREATE INDEX "idx_sale_bills_buyer_account_id" ON "public"."sale_bills" USING "btree" ("buyer_account_id");



CREATE INDEX "idx_sale_bills_client" ON "public"."sale_bills" USING "btree" ("client_id");



CREATE INDEX "idx_sale_bills_contract" ON "public"."sale_bills" USING "btree" ("contract_id");



CREATE INDEX "idx_sale_bills_created_by" ON "public"."sale_bills" USING "btree" ("created_by");



CREATE INDEX "idx_sale_bills_date" ON "public"."sale_bills" USING "btree" ("invoice_date");



CREATE INDEX "idx_sale_bills_payment_status" ON "public"."sale_bills" USING "btree" ("payment_status");



CREATE INDEX "idx_sale_bills_status" ON "public"."sale_bills" USING "btree" ("status");



CREATE INDEX "idx_sale_bills_updated_by" ON "public"."sale_bills" USING "btree" ("updated_by");



CREATE INDEX "idx_sale_product_rates_product_id" ON "public"."sale_product_rates" USING "btree" ("product_id");



CREATE INDEX "idx_security_guards_assigned_location_id" ON "public"."security_guards" USING "btree" ("assigned_location_id");



CREATE INDEX "idx_security_guards_emp_id" ON "public"."security_guards" USING "btree" ("employee_id");



CREATE INDEX "idx_service_acknowledgments_acknowledged_by" ON "public"."service_acknowledgments" USING "btree" ("acknowledged_by");



CREATE INDEX "idx_service_acknowledgments_spo_id" ON "public"."service_acknowledgments" USING "btree" ("spo_id");



CREATE INDEX "idx_service_delivery_notes_created_by" ON "public"."service_delivery_notes" USING "btree" ("created_by");



CREATE INDEX "idx_service_delivery_notes_po_id" ON "public"."service_delivery_notes" USING "btree" ("po_id");



CREATE INDEX "idx_service_delivery_notes_status" ON "public"."service_delivery_notes" USING "btree" ("status");



CREATE INDEX "idx_service_delivery_notes_verified_by" ON "public"."service_delivery_notes" USING "btree" ("verified_by");



CREATE INDEX "idx_service_feedback_resident_id" ON "public"."service_feedback" USING "btree" ("resident_id");



CREATE INDEX "idx_service_feedback_service_request_id" ON "public"."service_feedback" USING "btree" ("service_request_id");



CREATE INDEX "idx_service_feedback_society_id" ON "public"."service_feedback" USING "btree" ("society_id");



CREATE INDEX "idx_service_purchase_order_items_spo_id" ON "public"."service_purchase_order_items" USING "btree" ("spo_id");



CREATE INDEX "idx_service_purchase_orders_created_by" ON "public"."service_purchase_orders" USING "btree" ("created_by");



CREATE INDEX "idx_service_purchase_orders_indent_id" ON "public"."service_purchase_orders" USING "btree" ("indent_id");



CREATE INDEX "idx_service_purchase_orders_request_id" ON "public"."service_purchase_orders" USING "btree" ("request_id");



CREATE INDEX "idx_service_purchase_orders_vendor_id" ON "public"."service_purchase_orders" USING "btree" ("vendor_id");



CREATE INDEX "idx_service_rates_lookup" ON "public"."service_rates" USING "btree" ("supplier_id", "service_type", "is_active", "effective_from");



CREATE INDEX "idx_service_requests_asset_id" ON "public"."service_requests" USING "btree" ("asset_id");



CREATE INDEX "idx_service_requests_assigned_to" ON "public"."service_requests" USING "btree" ("assigned_to");



CREATE INDEX "idx_service_requests_created_by" ON "public"."service_requests" USING "btree" ("created_by");



CREATE INDEX "idx_service_requests_end_date" ON "public"."service_requests" USING "btree" ("end_date") WHERE ("type" = 'deployment'::"text");



CREATE INDEX "idx_service_requests_location_id" ON "public"."service_requests" USING "btree" ("location_id");



CREATE INDEX "idx_service_requests_maintenance_schedule_id" ON "public"."service_requests" USING "btree" ("maintenance_schedule_id");



CREATE INDEX "idx_service_requests_requester_id" ON "public"."service_requests" USING "btree" ("requester_id");



CREATE INDEX "idx_service_requests_scheduled_date" ON "public"."service_requests" USING "btree" ("scheduled_date");



CREATE INDEX "idx_service_requests_service_id" ON "public"."service_requests" USING "btree" ("service_id");



CREATE INDEX "idx_service_requests_society_id" ON "public"."service_requests" USING "btree" ("society_id");



CREATE INDEX "idx_service_requests_start_date" ON "public"."service_requests" USING "btree" ("start_date") WHERE ("type" = 'deployment'::"text");



CREATE INDEX "idx_service_requests_status" ON "public"."service_requests" USING "btree" ("status");



CREATE INDEX "idx_service_requests_type" ON "public"."service_requests" USING "btree" ("type");



CREATE INDEX "idx_services_created_by" ON "public"."services" USING "btree" ("created_by");



CREATE INDEX "idx_services_is_v1" ON "public"."services" USING "btree" ("is_v1");



CREATE INDEX "idx_services_wise_work_work_id" ON "public"."services_wise_work" USING "btree" ("work_id");



CREATE INDEX "idx_shortage_note_items_note_id" ON "public"."shortage_note_items" USING "btree" ("shortage_note_id");



CREATE INDEX "idx_shortage_note_items_product_id" ON "public"."shortage_note_items" USING "btree" ("product_id");



CREATE INDEX "idx_shortage_notes_created_by" ON "public"."shortage_notes" USING "btree" ("created_by");



CREATE INDEX "idx_shortage_notes_po_id" ON "public"."shortage_notes" USING "btree" ("po_id");



CREATE INDEX "idx_shortage_notes_status" ON "public"."shortage_notes" USING "btree" ("status");



CREATE INDEX "idx_shortage_notes_supplier_id" ON "public"."shortage_notes" USING "btree" ("supplier_id");



CREATE INDEX "idx_societies_society_manager_id" ON "public"."societies" USING "btree" ("society_manager_id");



CREATE INDEX "idx_stock_batches_expiry_date" ON "public"."stock_batches" USING "btree" ("expiry_date");



CREATE INDEX "idx_stock_batches_product_id" ON "public"."stock_batches" USING "btree" ("product_id");



CREATE INDEX "idx_stock_batches_warehouse_id" ON "public"."stock_batches" USING "btree" ("warehouse_id");



CREATE INDEX "idx_stock_transactions_created_by" ON "public"."stock_transactions" USING "btree" ("created_by");



CREATE INDEX "idx_stock_transactions_location_id" ON "public"."stock_transactions" USING "btree" ("location_id");



CREATE INDEX "idx_stock_transactions_product_id" ON "public"."stock_transactions" USING "btree" ("product_id");



CREATE INDEX "idx_stock_transactions_transaction_date" ON "public"."stock_transactions" USING "btree" ("transaction_date");



CREATE INDEX "idx_supplier_products_product_id" ON "public"."supplier_products" USING "btree" ("product_id");



CREATE INDEX "idx_supplier_rates_supplier_product_id" ON "public"."supplier_rates" USING "btree" ("supplier_product_id");



CREATE INDEX "idx_suppliers_active" ON "public"."suppliers" USING "btree" ("is_active") WHERE ("is_active" = true);



CREATE INDEX "idx_suppliers_created_by" ON "public"."suppliers" USING "btree" ("created_by");



CREATE UNIQUE INDEX "idx_suppliers_supplier_code" ON "public"."suppliers" USING "btree" ("supplier_code") WHERE ("supplier_code" IS NOT NULL);



CREATE INDEX "idx_suppliers_updated_by" ON "public"."suppliers" USING "btree" ("updated_by");



CREATE INDEX "idx_system_config_updated_by" ON "public"."system_config" USING "btree" ("updated_by");



CREATE INDEX "idx_technician_profiles_created_by" ON "public"."technician_profiles" USING "btree" ("created_by");



CREATE INDEX "idx_users_employee_id" ON "public"."users" USING "btree" ("employee_id");



CREATE INDEX "idx_users_role_id" ON "public"."users" USING "btree" ("role_id");



CREATE INDEX "idx_users_supplier_id" ON "public"."users" USING "btree" ("supplier_id");



CREATE INDEX "idx_vendor_wise_services_supplier_id" ON "public"."vendor_wise_services" USING "btree" ("supplier_id");



CREATE INDEX "idx_visitor_bypass_audit_created_at" ON "public"."visitor_bypass_audit" USING "btree" ("created_at" DESC);



CREATE INDEX "idx_visitor_bypass_audit_visitor_id" ON "public"."visitor_bypass_audit" USING "btree" ("visitor_id");



CREATE INDEX "idx_visitor_photo_metadata_guard_id" ON "public"."visitor_photo_metadata" USING "btree" ("guard_id");



CREATE INDEX "idx_visitor_photo_metadata_uploaded_at" ON "public"."visitor_photo_metadata" USING "btree" ("uploaded_at" DESC);



CREATE INDEX "idx_visitor_photo_metadata_visitor_id" ON "public"."visitor_photo_metadata" USING "btree" ("visitor_id");



CREATE INDEX "idx_visitors_approval_status" ON "public"."visitors" USING "btree" ("approval_status", "approval_deadline_at");



CREATE INDEX "idx_visitors_entry_guard" ON "public"."visitors" USING "btree" ("entry_guard_id");



CREATE INDEX "idx_visitors_entry_location_id" ON "public"."visitors" USING "btree" ("entry_location_id");



CREATE INDEX "idx_visitors_exit_guard" ON "public"."visitors" USING "btree" ("exit_guard_id");



CREATE INDEX "idx_visitors_flat_entry" ON "public"."visitors" USING "btree" ("flat_id", "entry_time" DESC);



CREATE INDEX "idx_visitors_resident_id" ON "public"."visitors" USING "btree" ("resident_id");



CREATE INDEX "idx_warehouses_created_by" ON "public"."warehouses" USING "btree" ("created_by");



CREATE INDEX "idx_warehouses_location_id" ON "public"."warehouses" USING "btree" ("location_id");



CREATE INDEX "idx_warehouses_manager_id" ON "public"."warehouses" USING "btree" ("manager_id");



CREATE INDEX "idx_warehouses_society_id" ON "public"."warehouses" USING "btree" ("society_id");



CREATE INDEX "waitlist_email_idx" ON "public"."waitlist" USING "btree" ("email");



ALTER INDEX "public"."idx_gps_employee_time" ATTACH PARTITION "public"."gps_tracking_2026_02_employee_id_tracked_at_idx";



ALTER INDEX "public"."gps_tracking_pkey" ATTACH PARTITION "public"."gps_tracking_2026_02_pkey";



ALTER INDEX "public"."idx_gps_time_brin" ATTACH PARTITION "public"."gps_tracking_2026_02_tracked_at_idx";



ALTER INDEX "public"."idx_gps_employee_time" ATTACH PARTITION "public"."gps_tracking_2026_03_employee_id_tracked_at_idx";



ALTER INDEX "public"."gps_tracking_pkey" ATTACH PARTITION "public"."gps_tracking_2026_03_pkey";



ALTER INDEX "public"."idx_gps_time_brin" ATTACH PARTITION "public"."gps_tracking_2026_03_tracked_at_idx";



ALTER INDEX "public"."idx_gps_employee_time" ATTACH PARTITION "public"."gps_tracking_2026_04_employee_id_tracked_at_idx";



ALTER INDEX "public"."gps_tracking_pkey" ATTACH PARTITION "public"."gps_tracking_2026_04_pkey";



ALTER INDEX "public"."idx_gps_time_brin" ATTACH PARTITION "public"."gps_tracking_2026_04_tracked_at_idx";



ALTER INDEX "public"."idx_gps_employee_time" ATTACH PARTITION "public"."gps_tracking_2026_05_employee_id_tracked_at_idx";



ALTER INDEX "public"."gps_tracking_pkey" ATTACH PARTITION "public"."gps_tracking_2026_05_pkey";



ALTER INDEX "public"."idx_gps_time_brin" ATTACH PARTITION "public"."gps_tracking_2026_05_tracked_at_idx";



ALTER INDEX "public"."idx_gps_employee_time" ATTACH PARTITION "public"."gps_tracking_2026_06_employee_id_tracked_at_idx";



ALTER INDEX "public"."gps_tracking_pkey" ATTACH PARTITION "public"."gps_tracking_2026_06_pkey";



ALTER INDEX "public"."idx_gps_time_brin" ATTACH PARTITION "public"."gps_tracking_2026_06_tracked_at_idx";



ALTER INDEX "public"."idx_gps_employee_time" ATTACH PARTITION "public"."gps_tracking_2026_07_employee_id_tracked_at_idx";



ALTER INDEX "public"."gps_tracking_pkey" ATTACH PARTITION "public"."gps_tracking_2026_07_pkey";



ALTER INDEX "public"."idx_gps_time_brin" ATTACH PARTITION "public"."gps_tracking_2026_07_tracked_at_idx";



ALTER INDEX "public"."idx_gps_employee_time" ATTACH PARTITION "public"."gps_tracking_2026_08_employee_id_tracked_at_idx";



ALTER INDEX "public"."gps_tracking_pkey" ATTACH PARTITION "public"."gps_tracking_2026_08_pkey";



ALTER INDEX "public"."idx_gps_time_brin" ATTACH PARTITION "public"."gps_tracking_2026_08_tracked_at_idx";



ALTER INDEX "public"."idx_gps_employee_time" ATTACH PARTITION "public"."gps_tracking_2026_09_employee_id_tracked_at_idx";



ALTER INDEX "public"."gps_tracking_pkey" ATTACH PARTITION "public"."gps_tracking_2026_09_pkey";



ALTER INDEX "public"."idx_gps_time_brin" ATTACH PARTITION "public"."gps_tracking_2026_09_tracked_at_idx";



ALTER INDEX "public"."idx_gps_employee_time" ATTACH PARTITION "public"."gps_tracking_2026_10_employee_id_tracked_at_idx";



ALTER INDEX "public"."gps_tracking_pkey" ATTACH PARTITION "public"."gps_tracking_2026_10_pkey";



ALTER INDEX "public"."idx_gps_time_brin" ATTACH PARTITION "public"."gps_tracking_2026_10_tracked_at_idx";



ALTER INDEX "public"."idx_gps_employee_time" ATTACH PARTITION "public"."gps_tracking_2026_11_employee_id_tracked_at_idx";



ALTER INDEX "public"."gps_tracking_pkey" ATTACH PARTITION "public"."gps_tracking_2026_11_pkey";



ALTER INDEX "public"."idx_gps_time_brin" ATTACH PARTITION "public"."gps_tracking_2026_11_tracked_at_idx";



ALTER INDEX "public"."idx_gps_employee_time" ATTACH PARTITION "public"."gps_tracking_2026_12_employee_id_tracked_at_idx";



ALTER INDEX "public"."gps_tracking_pkey" ATTACH PARTITION "public"."gps_tracking_2026_12_pkey";



ALTER INDEX "public"."idx_gps_time_brin" ATTACH PARTITION "public"."gps_tracking_2026_12_tracked_at_idx";



ALTER INDEX "public"."idx_gps_employee_time" ATTACH PARTITION "public"."gps_tracking_default_employee_id_tracked_at_idx";



ALTER INDEX "public"."gps_tracking_pkey" ATTACH PARTITION "public"."gps_tracking_default_pkey";



ALTER INDEX "public"."idx_gps_time_brin" ATTACH PARTITION "public"."gps_tracking_default_tracked_at_idx";



CREATE OR REPLACE TRIGGER "set_ad_booking_number" BEFORE INSERT ON "public"."printing_ad_bookings" FOR EACH ROW EXECUTE FUNCTION "public"."generate_ad_booking_number"();



CREATE OR REPLACE TRIGGER "set_ad_booking_updated_at" BEFORE UPDATE ON "public"."printing_ad_bookings" FOR EACH ROW EXECUTE FUNCTION "public"."update_ad_booking_updated_at"();



CREATE OR REPLACE TRIGGER "set_bgv_updated_at" BEFORE UPDATE ON "public"."background_verifications" FOR EACH ROW EXECUTE FUNCTION "public"."update_bgv_updated_at"();



CREATE OR REPLACE TRIGGER "set_bill_number" BEFORE INSERT ON "public"."purchase_bills" FOR EACH ROW EXECUTE FUNCTION "public"."generate_bill_number_trigger"();



CREATE OR REPLACE TRIGGER "set_budget_code" BEFORE INSERT ON "public"."budgets" FOR EACH ROW WHEN (("new"."budget_code" IS NULL)) EXECUTE FUNCTION "public"."generate_budget_code"();



CREATE OR REPLACE TRIGGER "set_candidate_code" BEFORE INSERT ON "public"."candidates" FOR EACH ROW WHEN (("new"."candidate_code" IS NULL)) EXECUTE FUNCTION "public"."generate_candidate_code"();



CREATE OR REPLACE TRIGGER "set_delivery_note_number" BEFORE INSERT ON "public"."service_delivery_notes" FOR EACH ROW EXECUTE FUNCTION "public"."generate_delivery_note_number"();



CREATE OR REPLACE TRIGGER "set_dispatch_number" BEFORE INSERT ON "public"."personnel_dispatches" FOR EACH ROW EXECUTE FUNCTION "public"."generate_dispatch_number"();



CREATE OR REPLACE TRIGGER "set_dispatch_updated_at" BEFORE UPDATE ON "public"."personnel_dispatches" FOR EACH ROW EXECUTE FUNCTION "public"."update_dispatch_updated_at"();



CREATE OR REPLACE TRIGGER "set_document_code" BEFORE INSERT ON "public"."employee_documents" FOR EACH ROW WHEN (("new"."document_code" IS NULL)) EXECUTE FUNCTION "public"."generate_document_code"();



CREATE OR REPLACE TRIGGER "set_grn_number" BEFORE INSERT ON "public"."material_receipts" FOR EACH ROW WHEN (("new"."grn_number" IS NULL)) EXECUTE FUNCTION "public"."generate_grn_number"();



CREATE OR REPLACE TRIGGER "set_indent_number" BEFORE INSERT ON "public"."indents" FOR EACH ROW WHEN (("new"."indent_number" IS NULL)) EXECUTE FUNCTION "public"."generate_indent_number"();



CREATE OR REPLACE TRIGGER "set_payslip_number" BEFORE INSERT ON "public"."payslips" FOR EACH ROW WHEN (("new"."payslip_number" IS NULL)) EXECUTE FUNCTION "public"."generate_payslip_number"();



CREATE OR REPLACE TRIGGER "set_po_number" BEFORE INSERT ON "public"."purchase_orders" FOR EACH ROW WHEN (("new"."po_number" IS NULL)) EXECUTE FUNCTION "public"."generate_po_number"();



CREATE OR REPLACE TRIGGER "set_reconciliation_number" BEFORE INSERT ON "public"."reconciliations" FOR EACH ROW WHEN (("new"."reconciliation_number" IS NULL)) EXECUTE FUNCTION "public"."generate_reconciliation_number"();



CREATE OR REPLACE TRIGGER "set_request_number" BEFORE INSERT ON "public"."requests" FOR EACH ROW WHEN (("new"."request_number" IS NULL)) EXECUTE FUNCTION "public"."generate_request_number"();



CREATE OR REPLACE TRIGGER "set_sale_invoice_number" BEFORE INSERT ON "public"."sale_bills" FOR EACH ROW EXECUTE FUNCTION "public"."generate_sale_invoice_number"();



CREATE OR REPLACE TRIGGER "set_service_purchase_order_number" BEFORE INSERT ON "public"."service_purchase_orders" FOR EACH ROW EXECUTE FUNCTION "public"."generate_service_purchase_order_number"();



CREATE OR REPLACE TRIGGER "set_shortage_note_number" BEFORE INSERT ON "public"."shortage_notes" FOR EACH ROW EXECUTE FUNCTION "public"."generate_shortage_note_number"();



CREATE OR REPLACE TRIGGER "set_shortage_note_updated_at" BEFORE UPDATE ON "public"."shortage_notes" FOR EACH ROW EXECUTE FUNCTION "public"."update_shortage_note_updated_at"();



CREATE OR REPLACE TRIGGER "set_spill_kit_updated_at" BEFORE UPDATE ON "public"."pest_control_spill_kits" FOR EACH ROW EXECUTE FUNCTION "public"."update_spill_kit_updated_at"();



CREATE OR REPLACE TRIGGER "tr_audit_attendance_logs" AFTER INSERT OR DELETE OR UPDATE ON "public"."attendance_logs" FOR EACH ROW EXECUTE FUNCTION "public"."log_financial_audit"();



CREATE OR REPLACE TRIGGER "tr_audit_indents" AFTER INSERT OR DELETE OR UPDATE ON "public"."indents" FOR EACH ROW EXECUTE FUNCTION "public"."log_financial_audit"();



CREATE OR REPLACE TRIGGER "tr_audit_material_receipts" AFTER INSERT OR DELETE OR UPDATE ON "public"."material_receipts" FOR EACH ROW EXECUTE FUNCTION "public"."log_financial_audit"();



CREATE OR REPLACE TRIGGER "tr_audit_payments" AFTER INSERT OR DELETE OR UPDATE ON "public"."payments" FOR EACH ROW EXECUTE FUNCTION "public"."log_financial_audit"();



CREATE OR REPLACE TRIGGER "tr_audit_purchase_bills" AFTER INSERT OR DELETE OR UPDATE ON "public"."purchase_bills" FOR EACH ROW EXECUTE FUNCTION "public"."log_financial_audit"();



CREATE OR REPLACE TRIGGER "tr_audit_purchase_orders" AFTER INSERT OR DELETE OR UPDATE ON "public"."purchase_orders" FOR EACH ROW EXECUTE FUNCTION "public"."log_financial_audit"();



CREATE OR REPLACE TRIGGER "tr_audit_reconciliations" AFTER INSERT OR DELETE OR UPDATE ON "public"."reconciliations" FOR EACH ROW EXECUTE FUNCTION "public"."log_financial_audit"();



CREATE OR REPLACE TRIGGER "tr_audit_requests" AFTER INSERT OR DELETE OR UPDATE ON "public"."requests" FOR EACH ROW EXECUTE FUNCTION "public"."log_financial_audit"();



CREATE OR REPLACE TRIGGER "tr_audit_sale_bills" AFTER INSERT OR DELETE OR UPDATE ON "public"."sale_bills" FOR EACH ROW EXECUTE FUNCTION "public"."log_financial_audit"();



CREATE OR REPLACE TRIGGER "tr_audit_service_requests" AFTER INSERT OR DELETE OR UPDATE ON "public"."service_requests" FOR EACH ROW EXECUTE FUNCTION "public"."log_financial_audit"();



CREATE OR REPLACE TRIGGER "tr_audit_visitors" AFTER INSERT OR DELETE OR UPDATE ON "public"."visitors" FOR EACH ROW EXECUTE FUNCTION "public"."log_financial_audit"();



CREATE OR REPLACE TRIGGER "tr_generate_behavior_ticket_number" BEFORE INSERT ON "public"."employee_behavior_tickets" FOR EACH ROW EXECUTE FUNCTION "public"."generate_behavior_ticket_number"();



CREATE OR REPLACE TRIGGER "tr_generate_oversight_ticket_number" BEFORE INSERT ON "public"."oversight_tickets" FOR EACH ROW EXECUTE FUNCTION "public"."generate_oversight_ticket_number"();



CREATE OR REPLACE TRIGGER "tr_guard_request_status" BEFORE UPDATE OF "status" ON "public"."requests" FOR EACH ROW EXECUTE FUNCTION "public"."enforce_request_status_transition"();



CREATE OR REPLACE TRIGGER "tr_mobile_refresh_visitor_decision_state" BEFORE INSERT OR UPDATE OF "approved_by_resident", "rejection_reason", "exit_time", "approval_status" ON "public"."visitors" FOR EACH ROW EXECUTE FUNCTION "public"."mobile_refresh_visitor_decision_state"();



CREATE OR REPLACE TRIGGER "tr_purchase_bills_request_status_sync" AFTER INSERT OR UPDATE OF "status", "payment_status", "purchase_order_id", "service_purchase_order_id" ON "public"."purchase_bills" FOR EACH ROW EXECUTE FUNCTION "public"."sync_request_status_from_purchase_bill"();



COMMENT ON TRIGGER "tr_purchase_bills_request_status_sync" ON "public"."purchase_bills" IS 'Propagates bill_generated and paid back to requests for both material and service flows.';



CREATE OR REPLACE TRIGGER "tr_purchase_bills_service_ack_gate" BEFORE INSERT OR UPDATE OF "service_purchase_order_id" ON "public"."purchase_bills" FOR EACH ROW EXECUTE FUNCTION "public"."check_service_acknowledgment_gate"();



COMMENT ON TRIGGER "tr_purchase_bills_service_ack_gate" ON "public"."purchase_bills" IS 'Enforces SPO-linked bills require an acknowledged service acknowledgment record on both insert and reference update.';



CREATE OR REPLACE TRIGGER "tr_stamp_attendance" BEFORE INSERT ON "public"."attendance_logs" FOR EACH ROW EXECUTE FUNCTION "public"."stamp_server_time"();



CREATE OR REPLACE TRIGGER "tr_update_oversight_tickets_updated_at" BEFORE UPDATE ON "public"."oversight_tickets" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "tr_visitor_bypass_audit" AFTER INSERT OR UPDATE OF "bypass_reason" ON "public"."visitors" FOR EACH ROW EXECUTE FUNCTION "public"."log_visitor_bypass_audit"();



CREATE OR REPLACE TRIGGER "tr_visitor_immutability" BEFORE UPDATE ON "public"."visitors" FOR EACH ROW EXECUTE FUNCTION "public"."check_visitor_immutability"();



CREATE OR REPLACE TRIGGER "trg_block_expired_chemical_issuance" BEFORE INSERT ON "public"."stock_transactions" FOR EACH ROW EXECUTE FUNCTION "public"."block_expired_chemical_issuance"();



CREATE OR REPLACE TRIGGER "trg_check_grn_item_quality" BEFORE INSERT ON "public"."stock_transactions" FOR EACH ROW EXECUTE FUNCTION "public"."check_grn_item_quality"();



CREATE OR REPLACE TRIGGER "trg_check_rate_before_forward" BEFORE UPDATE ON "public"."requests" FOR EACH ROW EXECUTE FUNCTION "public"."check_rate_before_forward"();



CREATE OR REPLACE TRIGGER "trg_cleanup_leave_application_attendance" AFTER DELETE ON "public"."leave_applications" FOR EACH ROW EXECUTE FUNCTION "public"."trg_cleanup_leave_application_attendance"();



CREATE OR REPLACE TRIGGER "trg_enforce_feedback_before_close" BEFORE UPDATE ON "public"."service_requests" FOR EACH ROW WHEN ((("new"."status")::"text" = 'closed'::"text")) EXECUTE FUNCTION "public"."enforce_feedback_before_close"();



CREATE OR REPLACE TRIGGER "trg_enforce_pest_control_ppe" BEFORE UPDATE ON "public"."job_sessions" FOR EACH ROW EXECUTE FUNCTION "public"."enforce_pest_control_ppe"();



CREATE OR REPLACE TRIGGER "trg_enforce_service_evidence" BEFORE UPDATE ON "public"."service_requests" FOR EACH ROW EXECUTE FUNCTION "public"."enforce_service_completion_evidence"();



CREATE OR REPLACE TRIGGER "trg_link_pest_control_ppe_on_session_start" AFTER INSERT OR UPDATE ON "public"."job_sessions" FOR EACH ROW EXECUTE FUNCTION "public"."link_pest_control_ppe_on_session_start"();



CREATE OR REPLACE TRIGGER "trg_sync_leave_application_attendance" AFTER INSERT OR UPDATE OF "employee_id", "leave_type_id", "from_date", "to_date", "status" ON "public"."leave_applications" FOR EACH ROW EXECUTE FUNCTION "public"."trg_sync_leave_application_attendance"();



CREATE OR REPLACE TRIGGER "trg_update_ppe_all_items_checked" BEFORE INSERT OR UPDATE ON "public"."pest_control_ppe_verifications" FOR EACH ROW EXECUTE FUNCTION "public"."update_ppe_all_items_checked"();



CREATE OR REPLACE TRIGGER "trg_update_qr_link_status" BEFORE INSERT OR UPDATE ON "public"."qr_codes" FOR EACH ROW EXECUTE FUNCTION "public"."update_qr_link_status"();



CREATE OR REPLACE TRIGGER "trg_validate_clock_in_geofence" BEFORE INSERT ON "public"."attendance_logs" FOR EACH ROW EXECUTE FUNCTION "public"."validate_clock_in_geofence"();



CREATE OR REPLACE TRIGGER "trigger_asset_categories_updated_at" BEFORE UPDATE ON "public"."asset_categories" FOR EACH ROW EXECUTE FUNCTION "public"."update_phase_b_updated_at"();



CREATE OR REPLACE TRIGGER "trigger_assets_updated_at" BEFORE UPDATE ON "public"."assets" FOR EACH ROW EXECUTE FUNCTION "public"."update_phase_b_updated_at"();



CREATE OR REPLACE TRIGGER "trigger_check_payments_closure" BEFORE INSERT OR DELETE OR UPDATE ON "public"."payments" FOR EACH ROW EXECUTE FUNCTION "public"."check_finance_closure"();



CREATE OR REPLACE TRIGGER "trigger_check_purchase_bills_closure" BEFORE INSERT OR DELETE OR UPDATE ON "public"."purchase_bills" FOR EACH ROW EXECUTE FUNCTION "public"."check_finance_closure"();



CREATE OR REPLACE TRIGGER "trigger_check_sale_bills_closure" BEFORE INSERT OR DELETE OR UPDATE ON "public"."sale_bills" FOR EACH ROW EXECUTE FUNCTION "public"."check_finance_closure"();



CREATE OR REPLACE TRIGGER "trigger_create_qr_for_asset" AFTER INSERT ON "public"."assets" FOR EACH ROW EXECUTE FUNCTION "public"."create_qr_for_asset"();



CREATE OR REPLACE TRIGGER "trigger_deduct_stock" AFTER INSERT ON "public"."job_materials_used" FOR EACH ROW EXECUTE FUNCTION "public"."deduct_stock_on_material_use"();



CREATE OR REPLACE TRIGGER "trigger_generate_asset_code" BEFORE INSERT ON "public"."assets" FOR EACH ROW WHEN (("new"."asset_code" IS NULL)) EXECUTE FUNCTION "public"."generate_asset_code"();



CREATE OR REPLACE TRIGGER "trigger_generate_payment_number" BEFORE INSERT ON "public"."payments" FOR EACH ROW EXECUTE FUNCTION "public"."generate_payment_number"();



CREATE OR REPLACE TRIGGER "trigger_generate_service_request_number" BEFORE INSERT ON "public"."service_requests" FOR EACH ROW WHEN ((("new"."request_number" IS NULL) OR (("new"."request_number")::"text" = 'PENDING'::"text"))) EXECUTE FUNCTION "public"."generate_service_request_number"();



CREATE OR REPLACE TRIGGER "trigger_job_sessions_updated_at" BEFORE UPDATE ON "public"."job_sessions" FOR EACH ROW EXECUTE FUNCTION "public"."update_phase_b_updated_at"();



CREATE OR REPLACE TRIGGER "trigger_maintenance_schedules_updated_at" BEFORE UPDATE ON "public"."maintenance_schedules" FOR EACH ROW EXECUTE FUNCTION "public"."update_phase_b_updated_at"();



CREATE OR REPLACE TRIGGER "trigger_notify_payment_failure" AFTER UPDATE OF "status" ON "public"."payments" FOR EACH ROW EXECUTE FUNCTION "public"."notify_payment_failure"();



CREATE OR REPLACE TRIGGER "trigger_recalculate_indent_totals" AFTER INSERT OR DELETE OR UPDATE ON "public"."indent_items" FOR EACH ROW EXECUTE FUNCTION "public"."recalculate_indent_totals"();



CREATE OR REPLACE TRIGGER "trigger_recalculate_po_totals" AFTER INSERT OR DELETE OR UPDATE ON "public"."purchase_order_items" FOR EACH ROW EXECUTE FUNCTION "public"."recalculate_po_totals"();



CREATE OR REPLACE TRIGGER "trigger_service_requests_updated_at" BEFORE UPDATE ON "public"."service_requests" FOR EACH ROW EXECUTE FUNCTION "public"."update_phase_b_updated_at"();



CREATE OR REPLACE TRIGGER "trigger_services_updated_at" BEFORE UPDATE ON "public"."services" FOR EACH ROW EXECUTE FUNCTION "public"."update_phase_b_updated_at"();



CREATE OR REPLACE TRIGGER "trigger_stock_batches_updated_at" BEFORE UPDATE ON "public"."stock_batches" FOR EACH ROW EXECUTE FUNCTION "public"."update_phase_b_updated_at"();



CREATE OR REPLACE TRIGGER "trigger_sync_purchase_bill_match_status" AFTER INSERT OR UPDATE OF "status", "resolved_at", "resolved_by", "updated_at", "updated_by" ON "public"."reconciliations" FOR EACH ROW EXECUTE FUNCTION "public"."sync_purchase_bill_match_status_from_reconciliation"();



CREATE OR REPLACE TRIGGER "trigger_technician_profiles_updated_at" BEFORE UPDATE ON "public"."technician_profiles" FOR EACH ROW EXECUTE FUNCTION "public"."update_phase_b_updated_at"();



CREATE OR REPLACE TRIGGER "trigger_update_bill_due_amount" BEFORE INSERT OR UPDATE OF "total_amount", "paid_amount" ON "public"."purchase_bills" FOR EACH ROW EXECUTE FUNCTION "public"."update_bill_due_amount"();



CREATE OR REPLACE TRIGGER "trigger_update_budget_usage" AFTER INSERT OR DELETE OR UPDATE OF "budget_id", "total_amount" ON "public"."purchase_bills" FOR EACH ROW EXECUTE FUNCTION "public"."update_budget_usage"();



CREATE OR REPLACE TRIGGER "trigger_warehouses_updated_at" BEFORE UPDATE ON "public"."warehouses" FOR EACH ROW EXECUTE FUNCTION "public"."update_phase_b_updated_at"();



CREATE OR REPLACE TRIGGER "update_candidate_interviews_updated_at" BEFORE UPDATE ON "public"."candidate_interviews" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_candidates_updated_at" BEFORE UPDATE ON "public"."candidates" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_contracts_updated_at" BEFORE UPDATE ON "public"."contracts" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_delivery_notes_updated_at" BEFORE UPDATE ON "public"."service_delivery_notes" FOR EACH ROW EXECUTE FUNCTION "public"."update_delivery_note_updated_at"();



CREATE OR REPLACE TRIGGER "update_employee_documents_updated_at" BEFORE UPDATE ON "public"."employee_documents" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_employee_salary_structure_updated_at" BEFORE UPDATE ON "public"."employee_salary_structure" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_indent_items_updated_at" BEFORE UPDATE ON "public"."indent_items" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_indents_updated_at" BEFORE UPDATE ON "public"."indents" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_inventory_updated_at" BEFORE UPDATE ON "public"."inventory" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_material_receipt_items_updated_at" BEFORE UPDATE ON "public"."material_receipt_items" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_material_receipts_updated_at" BEFORE UPDATE ON "public"."material_receipts" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_payroll_cycles_updated_at" BEFORE UPDATE ON "public"."payroll_cycles" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_payslips_updated_at" BEFORE UPDATE ON "public"."payslips" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_pc_chemicals_modtime" BEFORE UPDATE ON "public"."pest_control_chemicals" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_printing_ad_spaces_modtime" BEFORE UPDATE ON "public"."printing_ad_spaces" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_product_categories_updated_at" BEFORE UPDATE ON "public"."product_categories" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_product_subcategories_updated_at" BEFORE UPDATE ON "public"."product_subcategories" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_products_updated_at" BEFORE UPDATE ON "public"."products" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_purchase_bill_items_updated_at" BEFORE UPDATE ON "public"."purchase_bill_items" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_purchase_bills_updated_at" BEFORE UPDATE ON "public"."purchase_bills" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_purchase_order_items_updated_at" BEFORE UPDATE ON "public"."purchase_order_items" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_purchase_orders_updated_at" BEFORE UPDATE ON "public"."purchase_orders" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_reconciliation_lines_updated_at" BEFORE UPDATE ON "public"."reconciliation_lines" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_reconciliations_updated_at" BEFORE UPDATE ON "public"."reconciliations" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_requests_updated_at" BEFORE UPDATE ON "public"."requests" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_rtv_tickets_updated_at" BEFORE UPDATE ON "public"."rtv_tickets" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_salary_components_updated_at" BEFORE UPDATE ON "public"."salary_components" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_sale_bill_items_updated_at" BEFORE UPDATE ON "public"."sale_bill_items" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_sale_bills_updated_at" BEFORE UPDATE ON "public"."sale_bills" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



ALTER TABLE ONLY "public"."asset_categories"
    ADD CONSTRAINT "asset_categories_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."asset_categories"
    ADD CONSTRAINT "asset_categories_parent_category_id_fkey" FOREIGN KEY ("parent_category_id") REFERENCES "public"."asset_categories"("id");



ALTER TABLE ONLY "public"."asset_categories"
    ADD CONSTRAINT "asset_categories_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."assets"
    ADD CONSTRAINT "assets_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "public"."asset_categories"("id");



ALTER TABLE ONLY "public"."assets"
    ADD CONSTRAINT "assets_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."assets"
    ADD CONSTRAINT "assets_location_id_fkey" FOREIGN KEY ("location_id") REFERENCES "public"."company_locations"("id");



ALTER TABLE ONLY "public"."assets"
    ADD CONSTRAINT "assets_society_id_fkey" FOREIGN KEY ("society_id") REFERENCES "public"."societies"("id");



ALTER TABLE ONLY "public"."assets"
    ADD CONSTRAINT "assets_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."assets"
    ADD CONSTRAINT "assets_vendor_id_fkey" FOREIGN KEY ("vendor_id") REFERENCES "public"."suppliers"("id");



ALTER TABLE ONLY "public"."attendance_logs"
    ADD CONSTRAINT "attendance_logs_check_in_location_id_fkey" FOREIGN KEY ("check_in_location_id") REFERENCES "public"."company_locations"("id");



ALTER TABLE ONLY "public"."attendance_logs"
    ADD CONSTRAINT "attendance_logs_check_out_location_id_fkey" FOREIGN KEY ("check_out_location_id") REFERENCES "public"."company_locations"("id");



ALTER TABLE ONLY "public"."attendance_logs"
    ADD CONSTRAINT "attendance_logs_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."audit_logs"
    ADD CONSTRAINT "audit_logs_actor_id_fkey" FOREIGN KEY ("actor_id") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."background_verifications"
    ADD CONSTRAINT "background_verifications_candidate_id_fkey" FOREIGN KEY ("candidate_id") REFERENCES "public"."candidates"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."background_verifications"
    ADD CONSTRAINT "background_verifications_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."background_verifications"
    ADD CONSTRAINT "background_verifications_verified_by_fkey" FOREIGN KEY ("verified_by") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."behaviour_tickets"
    ADD CONSTRAINT "behaviour_tickets_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."behaviour_tickets"
    ADD CONSTRAINT "behaviour_tickets_raised_by_fkey" FOREIGN KEY ("raised_by") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."budgets"
    ADD CONSTRAINT "budgets_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."budgets"
    ADD CONSTRAINT "budgets_financial_period_id_fkey" FOREIGN KEY ("financial_period_id") REFERENCES "public"."financial_periods"("id");



ALTER TABLE ONLY "public"."buildings"
    ADD CONSTRAINT "buildings_society_id_fkey" FOREIGN KEY ("society_id") REFERENCES "public"."societies"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."buyer_accounts"
    ADD CONSTRAINT "buyer_accounts_auth_user_id_fkey" FOREIGN KEY ("auth_user_id") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."buyer_accounts"
    ADD CONSTRAINT "buyer_accounts_society_id_fkey" FOREIGN KEY ("society_id") REFERENCES "public"."societies"("id");



ALTER TABLE ONLY "public"."buyer_feedback"
    ADD CONSTRAINT "buyer_feedback_request_id_fkey" FOREIGN KEY ("request_id") REFERENCES "public"."requests"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."buyer_feedback"
    ADD CONSTRAINT "buyer_feedback_service_request_id_fkey" FOREIGN KEY ("service_request_id") REFERENCES "public"."service_requests"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."buyer_feedback"
    ADD CONSTRAINT "buyer_feedback_submitted_by_fkey" FOREIGN KEY ("submitted_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."candidate_interviews"
    ADD CONSTRAINT "candidate_interviews_candidate_id_fkey" FOREIGN KEY ("candidate_id") REFERENCES "public"."candidates"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."candidate_interviews"
    ADD CONSTRAINT "candidate_interviews_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."candidate_interviews"
    ADD CONSTRAINT "candidate_interviews_interviewer_id_fkey" FOREIGN KEY ("interviewer_id") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."candidate_interviews"
    ADD CONSTRAINT "candidate_interviews_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."candidates"
    ADD CONSTRAINT "candidates_converted_employee_id_fkey" FOREIGN KEY ("converted_employee_id") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."candidates"
    ADD CONSTRAINT "candidates_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."candidates"
    ADD CONSTRAINT "candidates_designation_id_fkey" FOREIGN KEY ("designation_id") REFERENCES "public"."designations"("id");



ALTER TABLE ONLY "public"."candidates"
    ADD CONSTRAINT "candidates_interviewer_id_fkey" FOREIGN KEY ("interviewer_id") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."candidates"
    ADD CONSTRAINT "candidates_referred_by_fkey" FOREIGN KEY ("referred_by") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."candidates"
    ADD CONSTRAINT "candidates_status_changed_by_fkey" FOREIGN KEY ("status_changed_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."candidates"
    ADD CONSTRAINT "candidates_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."checklist_assignments"
    ADD CONSTRAINT "checklist_assignments_assigned_by_fkey" FOREIGN KEY ("assigned_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."checklist_assignments"
    ADD CONSTRAINT "checklist_assignments_checklist_id_fkey" FOREIGN KEY ("checklist_id") REFERENCES "public"."daily_checklists"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."checklist_assignments"
    ADD CONSTRAINT "checklist_assignments_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "public"."employees"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."checklist_response_override_audit"
    ADD CONSTRAINT "checklist_response_override_audit_acted_by_fkey" FOREIGN KEY ("acted_by") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."checklist_response_override_audit"
    ADD CONSTRAINT "checklist_response_override_audit_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "public"."employees"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."checklist_response_override_audit"
    ADD CONSTRAINT "checklist_response_override_audit_guard_id_fkey" FOREIGN KEY ("guard_id") REFERENCES "public"."security_guards"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."checklist_response_override_audit"
    ADD CONSTRAINT "checklist_response_override_audit_response_id_fkey" FOREIGN KEY ("response_id") REFERENCES "public"."checklist_responses"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."checklist_responses"
    ADD CONSTRAINT "checklist_responses_checklist_id_fkey" FOREIGN KEY ("checklist_id") REFERENCES "public"."daily_checklists"("id");



ALTER TABLE ONLY "public"."checklist_responses"
    ADD CONSTRAINT "checklist_responses_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."checklist_responses"
    ADD CONSTRAINT "checklist_responses_location_id_fkey" FOREIGN KEY ("location_id") REFERENCES "public"."company_locations"("id");



ALTER TABLE ONLY "public"."checklist_responses"
    ADD CONSTRAINT "checklist_responses_overridden_by_fkey" FOREIGN KEY ("overridden_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."company_events"
    ADD CONSTRAINT "company_events_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."company_events"
    ADD CONSTRAINT "company_events_location_id_fkey" FOREIGN KEY ("location_id") REFERENCES "public"."company_locations"("id");



ALTER TABLE ONLY "public"."company_locations"
    ADD CONSTRAINT "company_locations_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."company_locations"
    ADD CONSTRAINT "company_locations_society_id_fkey" FOREIGN KEY ("society_id") REFERENCES "public"."societies"("id");



ALTER TABLE ONLY "public"."compliance_snapshots"
    ADD CONSTRAINT "compliance_snapshots_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."compliance_snapshots"
    ADD CONSTRAINT "compliance_snapshots_period_id_fkey" FOREIGN KEY ("period_id") REFERENCES "public"."financial_periods"("id");



ALTER TABLE ONLY "public"."contracts"
    ADD CONSTRAINT "contracts_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."contracts"
    ADD CONSTRAINT "contracts_society_id_fkey" FOREIGN KEY ("society_id") REFERENCES "public"."societies"("id");



ALTER TABLE ONLY "public"."contracts"
    ADD CONSTRAINT "contracts_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."credit_notes"
    ADD CONSTRAINT "credit_notes_issued_by_fkey" FOREIGN KEY ("issued_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."credit_notes"
    ADD CONSTRAINT "credit_notes_sale_bill_id_fkey" FOREIGN KEY ("sale_bill_id") REFERENCES "public"."sale_bills"("id");



ALTER TABLE ONLY "public"."daily_checklist_items"
    ADD CONSTRAINT "daily_checklist_items_checklist_id_fkey" FOREIGN KEY ("checklist_id") REFERENCES "public"."daily_checklists"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."daily_checklist_items"
    ADD CONSTRAINT "daily_checklist_items_shift_id_fkey" FOREIGN KEY ("shift_id") REFERENCES "public"."shifts"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."daily_checklists"
    ADD CONSTRAINT "daily_checklists_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."debit_notes"
    ADD CONSTRAINT "debit_notes_issued_by_fkey" FOREIGN KEY ("issued_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."debit_notes"
    ADD CONSTRAINT "debit_notes_sale_bill_id_fkey" FOREIGN KEY ("sale_bill_id") REFERENCES "public"."sale_bills"("id");



ALTER TABLE ONLY "public"."designations"
    ADD CONSTRAINT "designations_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."designations"
    ADD CONSTRAINT "designations_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."emergency_contacts"
    ADD CONSTRAINT "emergency_contacts_society_id_fkey" FOREIGN KEY ("society_id") REFERENCES "public"."societies"("id");



ALTER TABLE ONLY "public"."employee_behavior_tickets"
    ADD CONSTRAINT "employee_behavior_tickets_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."employee_behavior_tickets"
    ADD CONSTRAINT "employee_behavior_tickets_reported_by_fkey" FOREIGN KEY ("reported_by") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."employee_documents"
    ADD CONSTRAINT "employee_documents_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."employee_documents"
    ADD CONSTRAINT "employee_documents_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "public"."employees"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."employee_documents"
    ADD CONSTRAINT "employee_documents_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."employee_documents"
    ADD CONSTRAINT "employee_documents_verified_by_fkey" FOREIGN KEY ("verified_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."employee_salary_structure"
    ADD CONSTRAINT "employee_salary_structure_component_id_fkey" FOREIGN KEY ("component_id") REFERENCES "public"."salary_components"("id");



ALTER TABLE ONLY "public"."employee_salary_structure"
    ADD CONSTRAINT "employee_salary_structure_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."employee_salary_structure"
    ADD CONSTRAINT "employee_salary_structure_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "public"."employees"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."employee_salary_structure"
    ADD CONSTRAINT "employee_salary_structure_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."employee_shift_assignments"
    ADD CONSTRAINT "employee_shift_assignments_assigned_by_fkey" FOREIGN KEY ("assigned_by") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."employee_shift_assignments"
    ADD CONSTRAINT "employee_shift_assignments_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "public"."employees"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."employee_shift_assignments"
    ADD CONSTRAINT "employee_shift_assignments_shift_id_fkey" FOREIGN KEY ("shift_id") REFERENCES "public"."shifts"("id");



ALTER TABLE ONLY "public"."employees"
    ADD CONSTRAINT "employees_auth_user_id_fkey" FOREIGN KEY ("auth_user_id") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."employees"
    ADD CONSTRAINT "employees_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."employees"
    ADD CONSTRAINT "employees_designation_id_fkey" FOREIGN KEY ("designation_id") REFERENCES "public"."designations"("id");



ALTER TABLE ONLY "public"."employees"
    ADD CONSTRAINT "employees_reporting_to_fkey" FOREIGN KEY ("reporting_to") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."employees"
    ADD CONSTRAINT "employees_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."financial_periods"
    ADD CONSTRAINT "financial_periods_closed_by_fkey" FOREIGN KEY ("closed_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."financial_periods"
    ADD CONSTRAINT "financial_periods_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."societies"
    ADD CONSTRAINT "fk_societies_manager" FOREIGN KEY ("society_manager_id") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."flats"
    ADD CONSTRAINT "flats_building_id_fkey" FOREIGN KEY ("building_id") REFERENCES "public"."buildings"("id") ON DELETE CASCADE;



ALTER TABLE "public"."gps_tracking"
    ADD CONSTRAINT "gps_tracking_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "public"."security_guards"("id");



ALTER TABLE ONLY "public"."guard_gps_tracking"
    ADD CONSTRAINT "guard_gps_tracking_guard_id_fkey" FOREIGN KEY ("guard_id") REFERENCES "public"."employees"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."guard_gps_tracking"
    ADD CONSTRAINT "guard_gps_tracking_shift_id_fkey" FOREIGN KEY ("shift_id") REFERENCES "public"."shifts"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."guard_panic_alerts"
    ADD CONSTRAINT "guard_panic_alerts_acknowledged_by_fkey" FOREIGN KEY ("acknowledged_by") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."guard_panic_alerts"
    ADD CONSTRAINT "guard_panic_alerts_guard_id_fkey" FOREIGN KEY ("guard_id") REFERENCES "public"."employees"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."guard_panic_alerts"
    ADD CONSTRAINT "guard_panic_alerts_resolved_by_fkey" FOREIGN KEY ("resolved_by") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."guard_panic_alerts"
    ADD CONSTRAINT "guard_panic_alerts_shift_id_fkey" FOREIGN KEY ("shift_id") REFERENCES "public"."shifts"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."guard_patrol_logs"
    ADD CONSTRAINT "guard_patrol_logs_guard_id_fkey" FOREIGN KEY ("guard_id") REFERENCES "public"."security_guards"("id");



ALTER TABLE ONLY "public"."holidays"
    ADD CONSTRAINT "holidays_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."horticulture_seasonal_plans"
    ADD CONSTRAINT "horticulture_seasonal_plans_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."horticulture_seasonal_plans"
    ADD CONSTRAINT "horticulture_seasonal_plans_zone_id_fkey" FOREIGN KEY ("zone_id") REFERENCES "public"."horticulture_zones"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."horticulture_tasks"
    ADD CONSTRAINT "horticulture_tasks_assigned_to_fkey" FOREIGN KEY ("assigned_to") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."horticulture_tasks"
    ADD CONSTRAINT "horticulture_tasks_plan_id_fkey" FOREIGN KEY ("plan_id") REFERENCES "public"."horticulture_seasonal_plans"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."horticulture_tasks"
    ADD CONSTRAINT "horticulture_tasks_zone_id_fkey" FOREIGN KEY ("zone_id") REFERENCES "public"."horticulture_zones"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."horticulture_zones"
    ADD CONSTRAINT "horticulture_zones_location_id_fkey" FOREIGN KEY ("location_id") REFERENCES "public"."company_locations"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."indent_items"
    ADD CONSTRAINT "indent_items_indent_id_fkey" FOREIGN KEY ("indent_id") REFERENCES "public"."indents"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."indent_items"
    ADD CONSTRAINT "indent_items_override_approved_by_fkey" FOREIGN KEY ("override_approved_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."indent_items"
    ADD CONSTRAINT "indent_items_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id");



ALTER TABLE ONLY "public"."indents"
    ADD CONSTRAINT "indents_approved_by_fkey" FOREIGN KEY ("approved_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."indents"
    ADD CONSTRAINT "indents_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."indents"
    ADD CONSTRAINT "indents_linked_po_fk" FOREIGN KEY ("linked_po_id") REFERENCES "public"."purchase_orders"("id");



ALTER TABLE ONLY "public"."indents"
    ADD CONSTRAINT "indents_location_id_fkey" FOREIGN KEY ("location_id") REFERENCES "public"."company_locations"("id");



ALTER TABLE ONLY "public"."indents"
    ADD CONSTRAINT "indents_rejected_by_fkey" FOREIGN KEY ("rejected_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."indents"
    ADD CONSTRAINT "indents_requester_id_fkey" FOREIGN KEY ("requester_id") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."indents"
    ADD CONSTRAINT "indents_service_request_id_fkey" FOREIGN KEY ("service_request_id") REFERENCES "public"."requests"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."indents"
    ADD CONSTRAINT "indents_society_id_fkey" FOREIGN KEY ("society_id") REFERENCES "public"."societies"("id");



ALTER TABLE ONLY "public"."indents"
    ADD CONSTRAINT "indents_submitted_by_fkey" FOREIGN KEY ("submitted_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."indents"
    ADD CONSTRAINT "indents_supplier_id_fkey" FOREIGN KEY ("supplier_id") REFERENCES "public"."suppliers"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."indents"
    ADD CONSTRAINT "indents_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."inventory"
    ADD CONSTRAINT "inventory_location_id_fkey" FOREIGN KEY ("location_id") REFERENCES "public"."company_locations"("id");



ALTER TABLE ONLY "public"."inventory"
    ADD CONSTRAINT "inventory_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id");



ALTER TABLE ONLY "public"."job_materials_used"
    ADD CONSTRAINT "job_materials_used_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."job_materials_used"
    ADD CONSTRAINT "job_materials_used_job_session_id_fkey" FOREIGN KEY ("job_session_id") REFERENCES "public"."job_sessions"("id");



ALTER TABLE ONLY "public"."job_materials_used"
    ADD CONSTRAINT "job_materials_used_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id");



ALTER TABLE ONLY "public"."job_materials_used"
    ADD CONSTRAINT "job_materials_used_stock_batch_id_fkey" FOREIGN KEY ("stock_batch_id") REFERENCES "public"."stock_batches"("id");



ALTER TABLE ONLY "public"."job_photos"
    ADD CONSTRAINT "job_photos_job_session_id_fkey" FOREIGN KEY ("job_session_id") REFERENCES "public"."job_sessions"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."job_sessions"
    ADD CONSTRAINT "job_sessions_service_request_id_fkey" FOREIGN KEY ("service_request_id") REFERENCES "public"."service_requests"("id");



ALTER TABLE ONLY "public"."job_sessions"
    ADD CONSTRAINT "job_sessions_technician_id_fkey" FOREIGN KEY ("technician_id") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."leave_applications"
    ADD CONSTRAINT "leave_applications_approved_by_fkey" FOREIGN KEY ("approved_by") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."leave_applications"
    ADD CONSTRAINT "leave_applications_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."leave_applications"
    ADD CONSTRAINT "leave_applications_leave_type_id_fkey" FOREIGN KEY ("leave_type_id") REFERENCES "public"."leave_types"("id");



ALTER TABLE ONLY "public"."maintenance_schedules"
    ADD CONSTRAINT "maintenance_schedules_asset_id_fkey" FOREIGN KEY ("asset_id") REFERENCES "public"."assets"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."maintenance_schedules"
    ADD CONSTRAINT "maintenance_schedules_assigned_to_employee_fkey" FOREIGN KEY ("assigned_to_employee") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."maintenance_schedules"
    ADD CONSTRAINT "maintenance_schedules_assigned_to_role_fkey" FOREIGN KEY ("assigned_to_role") REFERENCES "public"."roles"("id");



ALTER TABLE ONLY "public"."maintenance_schedules"
    ADD CONSTRAINT "maintenance_schedules_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."material_arrival_evidence"
    ADD CONSTRAINT "material_arrival_evidence_logged_by_fkey" FOREIGN KEY ("logged_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."material_arrival_evidence"
    ADD CONSTRAINT "material_arrival_evidence_po_id_fkey" FOREIGN KEY ("po_id") REFERENCES "public"."purchase_orders"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."material_arrival_logs"
    ADD CONSTRAINT "material_arrival_logs_logged_by_fkey" FOREIGN KEY ("logged_by") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."material_arrival_logs"
    ADD CONSTRAINT "material_arrival_logs_po_id_fkey" FOREIGN KEY ("po_id") REFERENCES "public"."purchase_orders"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."material_receipt_items"
    ADD CONSTRAINT "material_receipt_items_material_receipt_id_fkey" FOREIGN KEY ("material_receipt_id") REFERENCES "public"."material_receipts"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."material_receipt_items"
    ADD CONSTRAINT "material_receipt_items_po_item_id_fkey" FOREIGN KEY ("po_item_id") REFERENCES "public"."purchase_order_items"("id");



ALTER TABLE ONLY "public"."material_receipt_items"
    ADD CONSTRAINT "material_receipt_items_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id");



ALTER TABLE ONLY "public"."material_receipts"
    ADD CONSTRAINT "material_receipts_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."material_receipts"
    ADD CONSTRAINT "material_receipts_purchase_order_id_fkey" FOREIGN KEY ("purchase_order_id") REFERENCES "public"."purchase_orders"("id");



ALTER TABLE ONLY "public"."material_receipts"
    ADD CONSTRAINT "material_receipts_quality_checked_by_fkey" FOREIGN KEY ("quality_checked_by") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."material_receipts"
    ADD CONSTRAINT "material_receipts_received_by_fkey" FOREIGN KEY ("received_by") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."material_receipts"
    ADD CONSTRAINT "material_receipts_supplier_id_fkey" FOREIGN KEY ("supplier_id") REFERENCES "public"."suppliers"("id");



ALTER TABLE ONLY "public"."material_receipts"
    ADD CONSTRAINT "material_receipts_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."material_receipts"
    ADD CONSTRAINT "material_receipts_warehouse_id_fkey" FOREIGN KEY ("warehouse_id") REFERENCES "public"."warehouses"("id");



ALTER TABLE ONLY "public"."notification_logs"
    ADD CONSTRAINT "notification_logs_notification_id_fkey" FOREIGN KEY ("notification_id") REFERENCES "public"."notifications"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."notification_logs"
    ADD CONSTRAINT "notification_logs_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."notifications"
    ADD CONSTRAINT "notifications_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."oversight_tickets"
    ADD CONSTRAINT "oversight_tickets_acknowledged_by_fkey" FOREIGN KEY ("acknowledged_by") REFERENCES "auth"."users"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."oversight_tickets"
    ADD CONSTRAINT "oversight_tickets_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."oversight_tickets"
    ADD CONSTRAINT "oversight_tickets_linked_employee_id_fkey" FOREIGN KEY ("linked_employee_id") REFERENCES "public"."employees"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."oversight_tickets"
    ADD CONSTRAINT "oversight_tickets_parent_ticket_id_fkey" FOREIGN KEY ("parent_ticket_id") REFERENCES "public"."oversight_tickets"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."oversight_tickets"
    ADD CONSTRAINT "oversight_tickets_resolved_by_fkey" FOREIGN KEY ("resolved_by") REFERENCES "auth"."users"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."oversight_tickets"
    ADD CONSTRAINT "oversight_tickets_source_visitor_id_fkey" FOREIGN KEY ("source_visitor_id") REFERENCES "public"."visitors"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."panic_alerts"
    ADD CONSTRAINT "panic_alerts_acknowledged_by_fkey" FOREIGN KEY ("acknowledged_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."panic_alerts"
    ADD CONSTRAINT "panic_alerts_guard_id_fkey" FOREIGN KEY ("guard_id") REFERENCES "public"."security_guards"("id");



ALTER TABLE ONLY "public"."panic_alerts"
    ADD CONSTRAINT "panic_alerts_location_id_fkey" FOREIGN KEY ("location_id") REFERENCES "public"."company_locations"("id");



ALTER TABLE ONLY "public"."panic_alerts"
    ADD CONSTRAINT "panic_alerts_resolved_by_fkey" FOREIGN KEY ("resolved_by") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."payments"
    ADD CONSTRAINT "payments_payment_method_id_fkey" FOREIGN KEY ("payment_method_id") REFERENCES "public"."payment_methods"("id");



ALTER TABLE ONLY "public"."payments"
    ADD CONSTRAINT "payments_processed_by_fkey" FOREIGN KEY ("processed_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."payroll_cycles"
    ADD CONSTRAINT "payroll_cycles_approved_by_fkey" FOREIGN KEY ("approved_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."payroll_cycles"
    ADD CONSTRAINT "payroll_cycles_computed_by_fkey" FOREIGN KEY ("computed_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."payroll_cycles"
    ADD CONSTRAINT "payroll_cycles_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."payroll_cycles"
    ADD CONSTRAINT "payroll_cycles_disbursed_by_fkey" FOREIGN KEY ("disbursed_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."payroll_cycles"
    ADD CONSTRAINT "payroll_cycles_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."payslips"
    ADD CONSTRAINT "payslips_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."payslips"
    ADD CONSTRAINT "payslips_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."payslips"
    ADD CONSTRAINT "payslips_payroll_cycle_id_fkey" FOREIGN KEY ("payroll_cycle_id") REFERENCES "public"."payroll_cycles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."payslips"
    ADD CONSTRAINT "payslips_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."personnel_dispatches"
    ADD CONSTRAINT "personnel_dispatches_confirmed_by_fkey" FOREIGN KEY ("confirmed_by") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."personnel_dispatches"
    ADD CONSTRAINT "personnel_dispatches_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."personnel_dispatches"
    ADD CONSTRAINT "personnel_dispatches_deployment_site_id_fkey" FOREIGN KEY ("deployment_site_id") REFERENCES "public"."company_locations"("id");



ALTER TABLE ONLY "public"."personnel_dispatches"
    ADD CONSTRAINT "personnel_dispatches_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."personnel_dispatches"
    ADD CONSTRAINT "personnel_dispatches_service_po_id_fkey" FOREIGN KEY ("service_po_id") REFERENCES "public"."service_purchase_orders"("id") ON DELETE CASCADE NOT VALID;



COMMENT ON CONSTRAINT "personnel_dispatches_service_po_id_fkey" ON "public"."personnel_dispatches" IS 'Dispatch rows must reference service_purchase_orders so staffing deployments persist against SPOs.';



ALTER TABLE ONLY "public"."personnel_dispatches"
    ADD CONSTRAINT "personnel_dispatches_supplier_id_fkey" FOREIGN KEY ("supplier_id") REFERENCES "public"."suppliers"("id");



ALTER TABLE ONLY "public"."pest_control_chemicals"
    ADD CONSTRAINT "pest_control_chemicals_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."pest_control_chemicals"
    ADD CONSTRAINT "pest_control_chemicals_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id");



ALTER TABLE ONLY "public"."pest_control_chemicals"
    ADD CONSTRAINT "pest_control_chemicals_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."pest_control_ppe_verifications"
    ADD CONSTRAINT "pest_control_ppe_verifications_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."pest_control_ppe_verifications"
    ADD CONSTRAINT "pest_control_ppe_verifications_job_session_id_fkey" FOREIGN KEY ("job_session_id") REFERENCES "public"."job_sessions"("id");



ALTER TABLE ONLY "public"."pest_control_ppe_verifications"
    ADD CONSTRAINT "pest_control_ppe_verifications_service_request_id_fkey" FOREIGN KEY ("service_request_id") REFERENCES "public"."service_requests"("id");



ALTER TABLE ONLY "public"."pest_control_ppe_verifications"
    ADD CONSTRAINT "pest_control_ppe_verifications_technician_id_fkey" FOREIGN KEY ("technician_id") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."pest_control_spill_kits"
    ADD CONSTRAINT "pest_control_spill_kits_inspected_by_fkey" FOREIGN KEY ("inspected_by") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."pest_control_spill_kits"
    ADD CONSTRAINT "pest_control_spill_kits_location_id_fkey" FOREIGN KEY ("location_id") REFERENCES "public"."company_locations"("id");



ALTER TABLE ONLY "public"."printing_ad_bookings"
    ADD CONSTRAINT "printing_ad_bookings_approved_by_fkey" FOREIGN KEY ("approved_by") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."printing_ad_bookings"
    ADD CONSTRAINT "printing_ad_bookings_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."printing_ad_spaces"
    ADD CONSTRAINT "printing_ad_spaces_asset_id_fkey" FOREIGN KEY ("asset_id") REFERENCES "public"."assets"("id");



ALTER TABLE ONLY "public"."printing_ad_spaces"
    ADD CONSTRAINT "printing_ad_spaces_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."printing_ad_spaces"
    ADD CONSTRAINT "printing_ad_spaces_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."product_categories"
    ADD CONSTRAINT "product_categories_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."product_categories"
    ADD CONSTRAINT "product_categories_parent_category_id_fkey" FOREIGN KEY ("parent_category_id") REFERENCES "public"."product_categories"("id");



ALTER TABLE ONLY "public"."product_categories"
    ADD CONSTRAINT "product_categories_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."product_subcategories"
    ADD CONSTRAINT "product_subcategories_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "public"."product_categories"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."product_subcategories"
    ADD CONSTRAINT "product_subcategories_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."product_subcategories"
    ADD CONSTRAINT "product_subcategories_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."products"
    ADD CONSTRAINT "products_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "public"."product_categories"("id");



ALTER TABLE ONLY "public"."products"
    ADD CONSTRAINT "products_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."products"
    ADD CONSTRAINT "products_subcategory_id_fkey" FOREIGN KEY ("subcategory_id") REFERENCES "public"."product_subcategories"("id");



ALTER TABLE ONLY "public"."products"
    ADD CONSTRAINT "products_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."purchase_bill_items"
    ADD CONSTRAINT "purchase_bill_items_grn_item_id_fkey" FOREIGN KEY ("grn_item_id") REFERENCES "public"."material_receipt_items"("id");



ALTER TABLE ONLY "public"."purchase_bill_items"
    ADD CONSTRAINT "purchase_bill_items_po_item_id_fkey" FOREIGN KEY ("po_item_id") REFERENCES "public"."purchase_order_items"("id");



ALTER TABLE ONLY "public"."purchase_bill_items"
    ADD CONSTRAINT "purchase_bill_items_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id");



ALTER TABLE ONLY "public"."purchase_bill_items"
    ADD CONSTRAINT "purchase_bill_items_purchase_bill_id_fkey" FOREIGN KEY ("purchase_bill_id") REFERENCES "public"."purchase_bills"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."purchase_bills"
    ADD CONSTRAINT "purchase_bills_budget_id_fkey" FOREIGN KEY ("budget_id") REFERENCES "public"."budgets"("id");



ALTER TABLE ONLY "public"."purchase_bills"
    ADD CONSTRAINT "purchase_bills_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."purchase_bills"
    ADD CONSTRAINT "purchase_bills_material_receipt_id_fkey" FOREIGN KEY ("material_receipt_id") REFERENCES "public"."material_receipts"("id");



ALTER TABLE ONLY "public"."purchase_bills"
    ADD CONSTRAINT "purchase_bills_purchase_order_id_fkey" FOREIGN KEY ("purchase_order_id") REFERENCES "public"."purchase_orders"("id");



ALTER TABLE ONLY "public"."purchase_bills"
    ADD CONSTRAINT "purchase_bills_reconciled_by_fkey" FOREIGN KEY ("reconciled_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."purchase_bills"
    ADD CONSTRAINT "purchase_bills_service_purchase_order_id_fkey" FOREIGN KEY ("service_purchase_order_id") REFERENCES "public"."service_purchase_orders"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."purchase_bills"
    ADD CONSTRAINT "purchase_bills_supplier_id_fkey" FOREIGN KEY ("supplier_id") REFERENCES "public"."suppliers"("id");



ALTER TABLE ONLY "public"."purchase_bills"
    ADD CONSTRAINT "purchase_bills_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."purchase_order_items"
    ADD CONSTRAINT "purchase_order_items_indent_item_id_fkey" FOREIGN KEY ("indent_item_id") REFERENCES "public"."indent_items"("id");



ALTER TABLE ONLY "public"."purchase_order_items"
    ADD CONSTRAINT "purchase_order_items_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id");



ALTER TABLE ONLY "public"."purchase_order_items"
    ADD CONSTRAINT "purchase_order_items_purchase_order_id_fkey" FOREIGN KEY ("purchase_order_id") REFERENCES "public"."purchase_orders"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."purchase_orders"
    ADD CONSTRAINT "purchase_orders_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."purchase_orders"
    ADD CONSTRAINT "purchase_orders_indent_id_fkey" FOREIGN KEY ("indent_id") REFERENCES "public"."indents"("id");



ALTER TABLE ONLY "public"."purchase_orders"
    ADD CONSTRAINT "purchase_orders_md_approved_by_fkey" FOREIGN KEY ("md_approved_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."purchase_orders"
    ADD CONSTRAINT "purchase_orders_supplier_id_fkey" FOREIGN KEY ("supplier_id") REFERENCES "public"."suppliers"("id");



ALTER TABLE ONLY "public"."purchase_orders"
    ADD CONSTRAINT "purchase_orders_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."push_tokens"
    ADD CONSTRAINT "push_tokens_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."qr_batch_logs"
    ADD CONSTRAINT "qr_batch_logs_generated_by_fkey" FOREIGN KEY ("generated_by") REFERENCES "auth"."users"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."qr_batch_logs"
    ADD CONSTRAINT "qr_batch_logs_society_id_fkey" FOREIGN KEY ("society_id") REFERENCES "public"."societies"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."qr_batch_logs"
    ADD CONSTRAINT "qr_batch_logs_warehouse_id_fkey" FOREIGN KEY ("warehouse_id") REFERENCES "public"."warehouses"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."qr_codes"
    ADD CONSTRAINT "qr_codes_asset_id_fkey" FOREIGN KEY ("asset_id") REFERENCES "public"."assets"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."qr_codes"
    ADD CONSTRAINT "qr_codes_claimed_by_fkey" FOREIGN KEY ("claimed_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."qr_codes"
    ADD CONSTRAINT "qr_codes_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."qr_codes"
    ADD CONSTRAINT "qr_codes_society_id_fkey" FOREIGN KEY ("society_id") REFERENCES "public"."societies"("id");



ALTER TABLE ONLY "public"."qr_codes"
    ADD CONSTRAINT "qr_codes_warehouse_id_fkey" FOREIGN KEY ("warehouse_id") REFERENCES "public"."warehouses"("id");



ALTER TABLE ONLY "public"."qr_scans"
    ADD CONSTRAINT "qr_scans_qr_id_fkey" FOREIGN KEY ("qr_id") REFERENCES "public"."qr_codes"("id");



ALTER TABLE ONLY "public"."qr_scans"
    ADD CONSTRAINT "qr_scans_scanned_by_fkey" FOREIGN KEY ("scanned_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."reconciliation_lines"
    ADD CONSTRAINT "reconciliation_lines_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id");



ALTER TABLE ONLY "public"."reconciliation_lines"
    ADD CONSTRAINT "reconciliation_lines_reconciliation_id_fkey" FOREIGN KEY ("reconciliation_id") REFERENCES "public"."reconciliations"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."reconciliation_lines"
    ADD CONSTRAINT "reconciliation_lines_resolved_by_fkey" FOREIGN KEY ("resolved_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."reconciliations"
    ADD CONSTRAINT "reconciliations_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."reconciliations"
    ADD CONSTRAINT "reconciliations_material_receipt_id_fkey" FOREIGN KEY ("material_receipt_id") REFERENCES "public"."material_receipts"("id");



ALTER TABLE ONLY "public"."reconciliations"
    ADD CONSTRAINT "reconciliations_purchase_bill_id_fkey" FOREIGN KEY ("purchase_bill_id") REFERENCES "public"."purchase_bills"("id");



ALTER TABLE ONLY "public"."reconciliations"
    ADD CONSTRAINT "reconciliations_purchase_order_id_fkey" FOREIGN KEY ("purchase_order_id") REFERENCES "public"."purchase_orders"("id");



ALTER TABLE ONLY "public"."reconciliations"
    ADD CONSTRAINT "reconciliations_resolved_by_fkey" FOREIGN KEY ("resolved_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."reconciliations"
    ADD CONSTRAINT "reconciliations_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."reorder_rules"
    ADD CONSTRAINT "reorder_rules_preferred_supplier_id_fkey" FOREIGN KEY ("preferred_supplier_id") REFERENCES "public"."suppliers"("id");



ALTER TABLE ONLY "public"."reorder_rules"
    ADD CONSTRAINT "reorder_rules_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id");



ALTER TABLE ONLY "public"."reorder_rules"
    ADD CONSTRAINT "reorder_rules_warehouse_id_fkey" FOREIGN KEY ("warehouse_id") REFERENCES "public"."warehouses"("id");



ALTER TABLE ONLY "public"."request_items"
    ADD CONSTRAINT "request_items_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id");



ALTER TABLE ONLY "public"."request_items"
    ADD CONSTRAINT "request_items_request_id_fkey" FOREIGN KEY ("request_id") REFERENCES "public"."requests"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."requests"
    ADD CONSTRAINT "requests_buyer_id_fkey" FOREIGN KEY ("buyer_id") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."requests"
    ADD CONSTRAINT "requests_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "public"."product_categories"("id");



ALTER TABLE ONLY "public"."requests"
    ADD CONSTRAINT "requests_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."requests"
    ADD CONSTRAINT "requests_indent_id_fkey" FOREIGN KEY ("indent_id") REFERENCES "public"."indents"("id");



ALTER TABLE ONLY "public"."requests"
    ADD CONSTRAINT "requests_location_id_fkey" FOREIGN KEY ("location_id") REFERENCES "public"."company_locations"("id");



ALTER TABLE ONLY "public"."requests"
    ADD CONSTRAINT "requests_rejected_by_fkey" FOREIGN KEY ("rejected_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."requests"
    ADD CONSTRAINT "requests_site_location_id_fkey" FOREIGN KEY ("site_location_id") REFERENCES "public"."company_locations"("id");



ALTER TABLE ONLY "public"."requests"
    ADD CONSTRAINT "requests_supplier_id_fkey" FOREIGN KEY ("supplier_id") REFERENCES "public"."suppliers"("id");



ALTER TABLE ONLY "public"."requests"
    ADD CONSTRAINT "requests_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."residents"
    ADD CONSTRAINT "residents_auth_user_id_fkey" FOREIGN KEY ("auth_user_id") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."residents"
    ADD CONSTRAINT "residents_flat_id_fkey" FOREIGN KEY ("flat_id") REFERENCES "public"."flats"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."roles"
    ADD CONSTRAINT "roles_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."roles"
    ADD CONSTRAINT "roles_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."rtv_tickets"
    ADD CONSTRAINT "rtv_tickets_po_id_fkey" FOREIGN KEY ("po_id") REFERENCES "public"."purchase_orders"("id");



ALTER TABLE ONLY "public"."rtv_tickets"
    ADD CONSTRAINT "rtv_tickets_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id");



ALTER TABLE ONLY "public"."rtv_tickets"
    ADD CONSTRAINT "rtv_tickets_raised_by_fkey" FOREIGN KEY ("raised_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."rtv_tickets"
    ADD CONSTRAINT "rtv_tickets_receipt_id_fkey" FOREIGN KEY ("receipt_id") REFERENCES "public"."material_receipts"("id");



ALTER TABLE ONLY "public"."rtv_tickets"
    ADD CONSTRAINT "rtv_tickets_supplier_id_fkey" FOREIGN KEY ("supplier_id") REFERENCES "public"."suppliers"("id");



ALTER TABLE ONLY "public"."salary_components"
    ADD CONSTRAINT "salary_components_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."salary_components"
    ADD CONSTRAINT "salary_components_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."sale_bill_items"
    ADD CONSTRAINT "sale_bill_items_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id");



ALTER TABLE ONLY "public"."sale_bill_items"
    ADD CONSTRAINT "sale_bill_items_sale_bill_id_fkey" FOREIGN KEY ("sale_bill_id") REFERENCES "public"."sale_bills"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."sale_bill_items"
    ADD CONSTRAINT "sale_bill_items_service_id_fkey" FOREIGN KEY ("service_id") REFERENCES "public"."services"("id");



ALTER TABLE ONLY "public"."sale_bills"
    ADD CONSTRAINT "sale_bills_buyer_account_id_fkey" FOREIGN KEY ("buyer_account_id") REFERENCES "public"."buyer_accounts"("id");



ALTER TABLE ONLY "public"."sale_bills"
    ADD CONSTRAINT "sale_bills_client_id_fkey" FOREIGN KEY ("client_id") REFERENCES "public"."societies"("id");



ALTER TABLE ONLY "public"."sale_bills"
    ADD CONSTRAINT "sale_bills_contract_id_fkey" FOREIGN KEY ("contract_id") REFERENCES "public"."contracts"("id");



ALTER TABLE ONLY "public"."sale_bills"
    ADD CONSTRAINT "sale_bills_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."sale_bills"
    ADD CONSTRAINT "sale_bills_request_id_fkey" FOREIGN KEY ("request_id") REFERENCES "public"."requests"("id");



ALTER TABLE ONLY "public"."sale_bills"
    ADD CONSTRAINT "sale_bills_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."sale_product_rates"
    ADD CONSTRAINT "sale_product_rates_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."security_guards"
    ADD CONSTRAINT "security_guards_assigned_location_id_fkey" FOREIGN KEY ("assigned_location_id") REFERENCES "public"."company_locations"("id");



ALTER TABLE ONLY "public"."security_guards"
    ADD CONSTRAINT "security_guards_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."service_acknowledgments"
    ADD CONSTRAINT "service_acknowledgments_acknowledged_by_fkey" FOREIGN KEY ("acknowledged_by") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."service_acknowledgments"
    ADD CONSTRAINT "service_acknowledgments_spo_id_fkey" FOREIGN KEY ("spo_id") REFERENCES "public"."service_purchase_orders"("id");



ALTER TABLE ONLY "public"."service_delivery_notes"
    ADD CONSTRAINT "service_delivery_notes_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."service_delivery_notes"
    ADD CONSTRAINT "service_delivery_notes_po_id_fkey" FOREIGN KEY ("po_id") REFERENCES "public"."service_purchase_orders"("id") ON DELETE CASCADE NOT VALID;



ALTER TABLE ONLY "public"."service_delivery_notes"
    ADD CONSTRAINT "service_delivery_notes_verified_by_fkey" FOREIGN KEY ("verified_by") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."service_feedback"
    ADD CONSTRAINT "service_feedback_resident_id_fkey" FOREIGN KEY ("resident_id") REFERENCES "public"."residents"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."service_feedback"
    ADD CONSTRAINT "service_feedback_service_request_id_fkey" FOREIGN KEY ("service_request_id") REFERENCES "public"."service_requests"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."service_feedback"
    ADD CONSTRAINT "service_feedback_society_id_fkey" FOREIGN KEY ("society_id") REFERENCES "public"."societies"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."service_purchase_order_items"
    ADD CONSTRAINT "service_purchase_order_items_spo_id_fkey" FOREIGN KEY ("spo_id") REFERENCES "public"."service_purchase_orders"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."service_purchase_orders"
    ADD CONSTRAINT "service_purchase_orders_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."service_purchase_orders"
    ADD CONSTRAINT "service_purchase_orders_indent_id_fkey" FOREIGN KEY ("indent_id") REFERENCES "public"."indents"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."service_purchase_orders"
    ADD CONSTRAINT "service_purchase_orders_request_id_fkey" FOREIGN KEY ("request_id") REFERENCES "public"."requests"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."service_purchase_orders"
    ADD CONSTRAINT "service_purchase_orders_vendor_id_fkey" FOREIGN KEY ("vendor_id") REFERENCES "public"."suppliers"("id");



ALTER TABLE ONLY "public"."service_rates"
    ADD CONSTRAINT "service_rates_supplier_id_fkey" FOREIGN KEY ("supplier_id") REFERENCES "public"."suppliers"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."service_requests"
    ADD CONSTRAINT "service_requests_asset_id_fkey" FOREIGN KEY ("asset_id") REFERENCES "public"."assets"("id");



ALTER TABLE ONLY "public"."service_requests"
    ADD CONSTRAINT "service_requests_assigned_to_fkey" FOREIGN KEY ("assigned_to") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."service_requests"
    ADD CONSTRAINT "service_requests_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."service_requests"
    ADD CONSTRAINT "service_requests_location_id_fkey" FOREIGN KEY ("location_id") REFERENCES "public"."company_locations"("id");



ALTER TABLE ONLY "public"."service_requests"
    ADD CONSTRAINT "service_requests_maintenance_schedule_id_fkey" FOREIGN KEY ("maintenance_schedule_id") REFERENCES "public"."maintenance_schedules"("id");



ALTER TABLE ONLY "public"."service_requests"
    ADD CONSTRAINT "service_requests_requester_id_fkey" FOREIGN KEY ("requester_id") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."service_requests"
    ADD CONSTRAINT "service_requests_service_id_fkey" FOREIGN KEY ("service_id") REFERENCES "public"."services"("id");



ALTER TABLE ONLY "public"."service_requests"
    ADD CONSTRAINT "service_requests_society_id_fkey" FOREIGN KEY ("society_id") REFERENCES "public"."societies"("id");



ALTER TABLE ONLY "public"."services"
    ADD CONSTRAINT "services_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."services_wise_work"
    ADD CONSTRAINT "services_wise_work_work_id_fkey" FOREIGN KEY ("work_id") REFERENCES "public"."work_master"("id");



ALTER TABLE ONLY "public"."shortage_note_items"
    ADD CONSTRAINT "shortage_note_items_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id");



ALTER TABLE ONLY "public"."shortage_note_items"
    ADD CONSTRAINT "shortage_note_items_shortage_note_id_fkey" FOREIGN KEY ("shortage_note_id") REFERENCES "public"."shortage_notes"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."shortage_notes"
    ADD CONSTRAINT "shortage_notes_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."shortage_notes"
    ADD CONSTRAINT "shortage_notes_po_id_fkey" FOREIGN KEY ("po_id") REFERENCES "public"."purchase_orders"("id");



ALTER TABLE ONLY "public"."shortage_notes"
    ADD CONSTRAINT "shortage_notes_supplier_id_fkey" FOREIGN KEY ("supplier_id") REFERENCES "public"."suppliers"("id");



ALTER TABLE ONLY "public"."stock_batches"
    ADD CONSTRAINT "stock_batches_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id");



ALTER TABLE ONLY "public"."stock_batches"
    ADD CONSTRAINT "stock_batches_warehouse_id_fkey" FOREIGN KEY ("warehouse_id") REFERENCES "public"."warehouses"("id");



ALTER TABLE ONLY "public"."stock_transactions"
    ADD CONSTRAINT "stock_transactions_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."stock_transactions"
    ADD CONSTRAINT "stock_transactions_location_id_fkey" FOREIGN KEY ("location_id") REFERENCES "public"."company_locations"("id");



ALTER TABLE ONLY "public"."stock_transactions"
    ADD CONSTRAINT "stock_transactions_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id");



ALTER TABLE ONLY "public"."supplier_products"
    ADD CONSTRAINT "supplier_products_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."supplier_products"
    ADD CONSTRAINT "supplier_products_supplier_id_fkey" FOREIGN KEY ("supplier_id") REFERENCES "public"."suppliers"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."supplier_rates"
    ADD CONSTRAINT "supplier_rates_supplier_product_id_fkey" FOREIGN KEY ("supplier_product_id") REFERENCES "public"."supplier_products"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."suppliers"
    ADD CONSTRAINT "suppliers_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."suppliers"
    ADD CONSTRAINT "suppliers_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."system_config"
    ADD CONSTRAINT "system_config_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."technician_profiles"
    ADD CONSTRAINT "technician_profiles_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."technician_profiles"
    ADD CONSTRAINT "technician_profiles_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "public"."employees"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "public"."roles"("id");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_supplier_id_fkey" FOREIGN KEY ("supplier_id") REFERENCES "public"."suppliers"("id");



ALTER TABLE ONLY "public"."vendor_wise_services"
    ADD CONSTRAINT "vendor_wise_services_supplier_id_fkey" FOREIGN KEY ("supplier_id") REFERENCES "public"."suppliers"("id");



ALTER TABLE ONLY "public"."visitor_bypass_audit"
    ADD CONSTRAINT "visitor_bypass_audit_entry_guard_id_fkey" FOREIGN KEY ("entry_guard_id") REFERENCES "public"."security_guards"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."visitor_bypass_audit"
    ADD CONSTRAINT "visitor_bypass_audit_flat_id_fkey" FOREIGN KEY ("flat_id") REFERENCES "public"."flats"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."visitor_bypass_audit"
    ADD CONSTRAINT "visitor_bypass_audit_resident_id_fkey" FOREIGN KEY ("resident_id") REFERENCES "public"."residents"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."visitor_bypass_audit"
    ADD CONSTRAINT "visitor_bypass_audit_visitor_id_fkey" FOREIGN KEY ("visitor_id") REFERENCES "public"."visitors"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."visitor_photo_metadata"
    ADD CONSTRAINT "visitor_photo_metadata_guard_id_fkey" FOREIGN KEY ("guard_id") REFERENCES "public"."employees"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."visitor_photo_metadata"
    ADD CONSTRAINT "visitor_photo_metadata_visitor_id_fkey" FOREIGN KEY ("visitor_id") REFERENCES "public"."visitors"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."visitors"
    ADD CONSTRAINT "visitors_entry_guard_id_fkey" FOREIGN KEY ("entry_guard_id") REFERENCES "public"."security_guards"("id");



ALTER TABLE ONLY "public"."visitors"
    ADD CONSTRAINT "visitors_entry_location_id_fkey" FOREIGN KEY ("entry_location_id") REFERENCES "public"."company_locations"("id");



ALTER TABLE ONLY "public"."visitors"
    ADD CONSTRAINT "visitors_exit_guard_id_fkey" FOREIGN KEY ("exit_guard_id") REFERENCES "public"."security_guards"("id");



ALTER TABLE ONLY "public"."visitors"
    ADD CONSTRAINT "visitors_flat_id_fkey" FOREIGN KEY ("flat_id") REFERENCES "public"."flats"("id");



ALTER TABLE ONLY "public"."visitors"
    ADD CONSTRAINT "visitors_resident_id_fkey" FOREIGN KEY ("resident_id") REFERENCES "public"."residents"("id");



ALTER TABLE ONLY "public"."warehouses"
    ADD CONSTRAINT "warehouses_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."warehouses"
    ADD CONSTRAINT "warehouses_location_id_fkey" FOREIGN KEY ("location_id") REFERENCES "public"."company_locations"("id");



ALTER TABLE ONLY "public"."warehouses"
    ADD CONSTRAINT "warehouses_manager_id_fkey" FOREIGN KEY ("manager_id") REFERENCES "public"."employees"("id");



ALTER TABLE ONLY "public"."warehouses"
    ADD CONSTRAINT "warehouses_society_id_fkey" FOREIGN KEY ("society_id") REFERENCES "public"."societies"("id");



CREATE POLICY "Accounts and Admin can manage payments" ON "public"."payments" USING ("public"."is_financial_manager"());



CREATE POLICY "Accounts and Admin can manage reconciliations" ON "public"."reconciliations" USING ("public"."is_financial_manager"());



CREATE POLICY "Admin Manage Documents" ON "public"."employee_documents" TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role"])));



CREATE POLICY "Admin can modify employees" ON "public"."employees" USING ((("auth"."jwt"() ->> 'user_role'::"text") = ANY (ARRAY['admin'::"text", 'super_admin'::"text"])));



CREATE POLICY "Admin/Account can create snapshots" ON "public"."compliance_snapshots" FOR INSERT WITH CHECK (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'account'::"public"."user_role"])));



CREATE POLICY "Admin/Account can view snapshots" ON "public"."compliance_snapshots" FOR SELECT USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'account'::"public"."user_role"])));



CREATE POLICY "Admins can manage all attendance" ON "public"."attendance_logs" TO "authenticated" USING ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"]))) WITH CHECK ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"])));



CREATE POLICY "Admins can manage all panic alerts" ON "public"."panic_alerts" TO "authenticated" USING ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"]))) WITH CHECK ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"])));



CREATE POLICY "Admins can manage all patrol logs" ON "public"."guard_patrol_logs" TO "authenticated" USING ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"]))) WITH CHECK ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"])));



CREATE POLICY "Admins can manage checklist assignments" ON "public"."checklist_assignments" TO "authenticated" USING ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'society_manager'::"text"]))) WITH CHECK ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'society_manager'::"text"])));



CREATE POLICY "Admins can manage checklist responses" ON "public"."checklist_responses" TO "authenticated" USING ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"]))) WITH CHECK ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"])));



CREATE POLICY "Admins can manage checklists" ON "public"."daily_checklists" TO "authenticated" USING ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'society_manager'::"text"]))) WITH CHECK ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'society_manager'::"text"])));



CREATE POLICY "Admins can manage events" ON "public"."company_events" TO "authenticated" USING ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'society_manager'::"text"]))) WITH CHECK ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'society_manager'::"text"])));



CREATE POLICY "Admins can manage gps_tracking" ON "public"."gps_tracking" TO "authenticated" USING ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"]))) WITH CHECK ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"])));



CREATE POLICY "Admins can manage guards" ON "public"."security_guards" TO "authenticated" USING ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"]))) WITH CHECK ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"])));



CREATE POLICY "Admins can manage service requests" ON "public"."service_requests" TO "authenticated" USING ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'society_manager'::"text"]))) WITH CHECK ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'society_manager'::"text"])));



CREATE POLICY "Admins can view visitor bypass audit" ON "public"."visitor_bypass_audit" FOR SELECT USING (("public"."has_role"('admin'::"text") OR "public"."has_role"('super_admin'::"text") OR "public"."has_role"('society_manager'::"text") OR "public"."has_role"('security_supervisor'::"text")));



CREATE POLICY "Admins delete users" ON "public"."users" FOR DELETE USING ("public"."has_role"('admin'::"text"));



CREATE POLICY "Admins insert users" ON "public"."users" FOR INSERT WITH CHECK ("public"."has_role"('admin'::"text"));



CREATE POLICY "Admins manage behavior tickets" ON "public"."employee_behavior_tickets" USING ("public"."has_role"('admin'::"text"));



CREATE POLICY "Admins manage company events" ON "public"."company_events" TO "authenticated" USING (("public"."has_role"('admin'::"text") OR "public"."has_role"('company_hod'::"text") OR "public"."has_role"('company_md'::"text") OR "public"."has_role"('super_admin'::"text"))) WITH CHECK (("public"."has_role"('admin'::"text") OR "public"."has_role"('company_hod'::"text") OR "public"."has_role"('company_md'::"text") OR "public"."has_role"('super_admin'::"text")));



CREATE POLICY "Admins manage emergency contacts" ON "public"."emergency_contacts" USING (("public"."has_role"('admin'::"text") OR "public"."has_role"('society_manager'::"text")));



CREATE POLICY "Admins manage employees" ON "public"."employees" USING ("public"."has_role"('admin'::"text"));



CREATE POLICY "Admins manage holidays" ON "public"."holidays" USING ("public"."has_role"('admin'::"text"));



CREATE POLICY "Admins manage shift assignments" ON "public"."employee_shift_assignments" TO "authenticated" USING (("public"."has_role"('admin'::"text") OR "public"."has_role"('security_supervisor'::"text") OR "public"."has_role"('company_hod'::"text") OR "public"."has_role"('super_admin'::"text"))) WITH CHECK (("public"."has_role"('admin'::"text") OR "public"."has_role"('security_supervisor'::"text") OR "public"."has_role"('company_hod'::"text") OR "public"."has_role"('super_admin'::"text")));



CREATE POLICY "Admins manage shifts" ON "public"."shifts" TO "authenticated" USING (("public"."has_role"('admin'::"text") OR "public"."has_role"('security_supervisor'::"text") OR "public"."has_role"('company_hod'::"text") OR "public"."has_role"('super_admin'::"text"))) WITH CHECK (("public"."has_role"('admin'::"text") OR "public"."has_role"('security_supervisor'::"text") OR "public"."has_role"('company_hod'::"text") OR "public"."has_role"('super_admin'::"text")));



CREATE POLICY "Admins update users" ON "public"."users" FOR UPDATE USING ("public"."has_role"('admin'::"text"));



CREATE POLICY "Admins view all documents" ON "public"."employee_documents" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM ("public"."users" "u"
     JOIN "public"."roles" "r" ON (("u"."role_id" = "r"."id")))
  WHERE (("u"."id" = "auth"."uid"()) AND ("r"."role_name" = ANY (ARRAY['admin'::"public"."user_role", 'company_md'::"public"."user_role", 'company_hod'::"public"."user_role"]))))));



CREATE POLICY "Admins view all notification logs" ON "public"."notification_logs" FOR SELECT USING (("public"."has_role"('admin'::"text") OR "public"."has_role"('society_manager'::"text")));



CREATE POLICY "All authenticated can view payment methods" ON "public"."payment_methods" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Allow authenticated read for service_feedback" ON "public"."service_feedback" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Anyone can join waitlist" ON "public"."waitlist" FOR INSERT TO "authenticated", "anon" WITH CHECK (true);



CREATE POLICY "Anyone can view buildings" ON "public"."buildings" FOR SELECT USING (true);



CREATE POLICY "Anyone can view company locations" ON "public"."company_locations" FOR SELECT USING (true);



CREATE POLICY "Anyone can view designations" ON "public"."designations" FOR SELECT USING (true);



CREATE POLICY "Anyone can view flats" ON "public"."flats" FOR SELECT USING (true);



CREATE POLICY "Anyone can view roles" ON "public"."roles" FOR SELECT USING (true);



CREATE POLICY "Anyone can view societies" ON "public"."societies" FOR SELECT USING (true);



CREATE POLICY "Audit logs visible to Admin and Accounts" ON "public"."audit_logs" FOR SELECT USING ("public"."is_financial_manager"());



CREATE POLICY "Authenticated can insert patrol logs" ON "public"."guard_patrol_logs" FOR INSERT WITH CHECK (("auth"."role"() = 'authenticated'::"text"));



CREATE POLICY "Authenticated can view patrol logs" ON "public"."guard_patrol_logs" FOR SELECT USING (("auth"."role"() = 'authenticated'::"text"));



CREATE POLICY "Authenticated users can insert checklist responses" ON "public"."checklist_responses" FOR INSERT WITH CHECK (("auth"."role"() = 'authenticated'::"text"));



CREATE POLICY "Authenticated users can update checklist responses" ON "public"."checklist_responses" FOR UPDATE USING (("auth"."role"() = 'authenticated'::"text")) WITH CHECK (("auth"."role"() = 'authenticated'::"text"));



CREATE POLICY "Authenticated users can view checklist responses" ON "public"."checklist_responses" FOR SELECT USING (("auth"."role"() = 'authenticated'::"text"));



CREATE POLICY "Authenticated users can view checklists" ON "public"."daily_checklists" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Authenticated users can view events" ON "public"."company_events" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Authenticated users can view leave types" ON "public"."leave_types" FOR SELECT USING (("auth"."role"() = 'authenticated'::"text"));



CREATE POLICY "Authenticated users can view shifts" ON "public"."shifts" FOR SELECT USING (("auth"."role"() = 'authenticated'::"text"));



CREATE POLICY "Authenticated users view shift assignments" ON "public"."employee_shift_assignments" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Authenticated users view shifts" ON "public"."shifts" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Budgets manageable by finance/admin" ON "public"."budgets" TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'account'::"public"."user_role"])));



CREATE POLICY "Budgets viewable by relevant roles" ON "public"."budgets" FOR SELECT TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'account'::"public"."user_role", 'company_hod'::"public"."user_role", 'company_md'::"public"."user_role"])));



CREATE POLICY "Buyers Update Own Pending Requests" ON "public"."requests" FOR UPDATE TO "authenticated" USING ((("buyer_id" = "auth"."uid"()) AND ("status" = 'pending'::"public"."request_status"))) WITH CHECK ((("buyer_id" = "auth"."uid"()) AND ("status" = 'pending'::"public"."request_status")));



CREATE POLICY "Buyers View Own Invoices" ON "public"."sale_bills" FOR SELECT TO "authenticated" USING ((("public"."get_user_role"() = 'buyer'::"public"."user_role") AND ("client_id" IN ( SELECT "b"."society_id"
   FROM (("public"."residents" "r"
     JOIN "public"."flats" "f" ON (("r"."flat_id" = "f"."id")))
     JOIN "public"."buildings" "b" ON (("f"."building_id" = "b"."id")))
  WHERE ("r"."auth_user_id" = "auth"."uid"())))));



CREATE POLICY "Create Indents" ON "public"."indents" FOR INSERT TO "authenticated" WITH CHECK (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'super_admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'account'::"public"."user_role", 'security_supervisor'::"public"."user_role", 'society_manager'::"public"."user_role"])));



CREATE POLICY "Create Sessions" ON "public"."job_sessions" FOR INSERT TO "authenticated" WITH CHECK ((("technician_id" IN ( SELECT "employees"."id"
   FROM "public"."employees"
  WHERE ("employees"."auth_user_id" = "auth"."uid"()))) OR ("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'society_manager'::"public"."user_role"]))));



CREATE POLICY "Delete Asset Categories" ON "public"."asset_categories" FOR DELETE TO "authenticated" USING (("public"."get_user_role"() = 'admin'::"public"."user_role"));



CREATE POLICY "Delete Assets" ON "public"."assets" FOR DELETE TO "authenticated" USING (("public"."get_user_role"() = 'admin'::"public"."user_role"));



CREATE POLICY "Delete Draft Indents" ON "public"."indents" FOR DELETE TO "authenticated" USING (((("requester_id" IN ( SELECT "employees"."id"
   FROM "public"."employees"
  WHERE ("employees"."auth_user_id" = "auth"."uid"()))) AND ("status" = 'draft'::"public"."indent_status")) OR ("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'super_admin'::"public"."user_role"]))));



CREATE POLICY "Employee can view own record" ON "public"."employees" FOR SELECT USING (("id" IN ( SELECT "users"."employee_id"
   FROM "public"."users"
  WHERE ("users"."id" = "auth"."uid"()))));



CREATE POLICY "Employee sees own documents" ON "public"."employee_documents" FOR SELECT TO "authenticated" USING (("employee_id" = ( SELECT "e"."id"
   FROM ("public"."employees" "e"
     JOIN "public"."users" "u" ON (("u"."employee_id" = "e"."id")))
  WHERE ("u"."id" = "auth"."uid"()))));



CREATE POLICY "Employee uploads own documents" ON "public"."employee_documents" FOR INSERT TO "authenticated" WITH CHECK (("employee_id" = ( SELECT "e"."id"
   FROM ("public"."employees" "e"
     JOIN "public"."users" "u" ON (("u"."employee_id" = "e"."id")))
  WHERE ("u"."id" = "auth"."uid"()))));



CREATE POLICY "Employees View Own Documents" ON "public"."employee_documents" FOR SELECT TO "authenticated" USING ((("employee_id" IN ( SELECT "users"."employee_id"
   FROM "public"."users"
  WHERE ("users"."id" = "auth"."uid"()))) OR ("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'company_md'::"public"."user_role"]))));



CREATE POLICY "Employees self update" ON "public"."employees" FOR UPDATE USING (("auth_user_id" = "auth"."uid"()));



CREATE POLICY "Employees self view" ON "public"."employees" FOR SELECT USING (("auth_user_id" = "auth"."uid"()));



CREATE POLICY "Enable insert for authenticated users only" ON "public"."safety_equipment" FOR INSERT WITH CHECK (("auth"."role"() = 'authenticated'::"text"));



CREATE POLICY "Enable read access for all users" ON "public"."safety_equipment" FOR SELECT USING (true);



CREATE POLICY "Enable update for authenticated users only" ON "public"."safety_equipment" FOR UPDATE USING (("auth"."role"() = 'authenticated'::"text"));



CREATE POLICY "Everyone views emergency contacts" ON "public"."emergency_contacts" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Everyone views holidays" ON "public"."holidays" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Finance can manage payments" ON "public"."payments" TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'account'::"public"."user_role"])));



CREATE POLICY "Finance can view all payments" ON "public"."payments" FOR SELECT TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'account'::"public"."user_role", 'company_md'::"public"."user_role"])));



CREATE POLICY "Financial periods manageable by admin" ON "public"."financial_periods" TO "authenticated" USING (("public"."get_user_role"() = 'admin'::"public"."user_role"));



CREATE POLICY "Financial periods viewable by finance/admin" ON "public"."financial_periods" FOR SELECT TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'account'::"public"."user_role", 'company_md'::"public"."user_role"])));



CREATE POLICY "Guards can clock in" ON "public"."attendance_logs" FOR INSERT TO "authenticated" WITH CHECK (("employee_id" IN ( SELECT "employees"."id"
   FROM "public"."employees"
  WHERE ("employees"."auth_user_id" = "auth"."uid"()))));



CREATE POLICY "Guards can clock in and out" ON "public"."attendance_logs" FOR INSERT WITH CHECK (("employee_id" = "auth"."uid"()));



CREATE POLICY "Guards can clock out" ON "public"."attendance_logs" FOR UPDATE TO "authenticated" USING (("employee_id" IN ( SELECT "employees"."id"
   FROM "public"."employees"
  WHERE ("employees"."auth_user_id" = "auth"."uid"())))) WITH CHECK (("employee_id" IN ( SELECT "employees"."id"
   FROM "public"."employees"
  WHERE ("employees"."auth_user_id" = "auth"."uid"()))));



CREATE POLICY "Guards can insert GPS 2026_02" ON "public"."gps_tracking_2026_02" FOR INSERT WITH CHECK (("employee_id" = "auth"."uid"()));



CREATE POLICY "Guards can insert GPS 2026_03" ON "public"."gps_tracking_2026_03" FOR INSERT WITH CHECK (("employee_id" = "auth"."uid"()));



CREATE POLICY "Guards can insert GPS 2026_04" ON "public"."gps_tracking_2026_04" FOR INSERT WITH CHECK (("employee_id" = "auth"."uid"()));



CREATE POLICY "Guards can insert GPS default" ON "public"."gps_tracking_default" FOR INSERT WITH CHECK (("employee_id" = "auth"."uid"()));



CREATE POLICY "Guards can insert patrol logs" ON "public"."guard_patrol_logs" FOR INSERT TO "authenticated" WITH CHECK (("guard_id" IN ( SELECT "sg"."id"
   FROM ("public"."security_guards" "sg"
     JOIN "public"."employees" "e" ON (("e"."id" = "sg"."employee_id")))
  WHERE ("e"."auth_user_id" = "auth"."uid"()))));



CREATE POLICY "Guards can insert their own GPS data" ON "public"."gps_tracking" FOR INSERT TO "authenticated" WITH CHECK (("employee_id" IN ( SELECT "sg"."id"
   FROM ("public"."security_guards" "sg"
     JOIN "public"."employees" "e" ON (("e"."id" = "sg"."employee_id")))
  WHERE ("e"."auth_user_id" = "auth"."uid"()))));



CREATE POLICY "Guards can insert their own panic alerts" ON "public"."panic_alerts" FOR INSERT TO "authenticated" WITH CHECK (("guard_id" IN ( SELECT "sg"."id"
   FROM ("public"."security_guards" "sg"
     JOIN "public"."employees" "e" ON (("e"."id" = "sg"."employee_id")))
  WHERE ("e"."auth_user_id" = "auth"."uid"()))));



CREATE POLICY "Guards can submit checklist responses" ON "public"."checklist_responses" FOR INSERT TO "authenticated" WITH CHECK (("employee_id" IN ( SELECT "users"."employee_id"
   FROM "public"."users"
  WHERE (("users"."id" = "auth"."uid"()) AND ("users"."employee_id" IS NOT NULL)))));



CREATE POLICY "Guards can update their own checklist responses" ON "public"."checklist_responses" FOR UPDATE TO "authenticated" USING (("employee_id" IN ( SELECT "users"."employee_id"
   FROM "public"."users"
  WHERE (("users"."id" = "auth"."uid"()) AND ("users"."employee_id" IS NOT NULL))))) WITH CHECK (("employee_id" IN ( SELECT "users"."employee_id"
   FROM "public"."users"
  WHERE (("users"."id" = "auth"."uid"()) AND ("users"."employee_id" IS NOT NULL)))));



CREATE POLICY "Guards can update their own panic alerts" ON "public"."panic_alerts" FOR UPDATE TO "authenticated" USING (("guard_id" IN ( SELECT "sg"."id"
   FROM ("public"."security_guards" "sg"
     JOIN "public"."employees" "e" ON (("e"."id" = "sg"."employee_id")))
  WHERE ("e"."auth_user_id" = "auth"."uid"())))) WITH CHECK (("guard_id" IN ( SELECT "sg"."id"
   FROM ("public"."security_guards" "sg"
     JOIN "public"."employees" "e" ON (("e"."id" = "sg"."employee_id")))
  WHERE ("e"."auth_user_id" = "auth"."uid"()))));



CREATE POLICY "Guards can update their own patrol logs" ON "public"."guard_patrol_logs" FOR UPDATE TO "authenticated" USING (("guard_id" IN ( SELECT "sg"."id"
   FROM ("public"."security_guards" "sg"
     JOIN "public"."employees" "e" ON (("e"."id" = "sg"."employee_id")))
  WHERE ("e"."auth_user_id" = "auth"."uid"())))) WITH CHECK (("guard_id" IN ( SELECT "sg"."id"
   FROM ("public"."security_guards" "sg"
     JOIN "public"."employees" "e" ON (("e"."id" = "sg"."employee_id")))
  WHERE ("e"."auth_user_id" = "auth"."uid"()))));



CREATE POLICY "Guards can update their own record" ON "public"."security_guards" FOR UPDATE TO "authenticated" USING (("employee_id" IN ( SELECT "employees"."id"
   FROM "public"."employees"
  WHERE ("employees"."auth_user_id" = "auth"."uid"())))) WITH CHECK (("employee_id" IN ( SELECT "employees"."id"
   FROM "public"."employees"
  WHERE ("employees"."auth_user_id" = "auth"."uid"()))));



CREATE POLICY "Guards can view GPS 2026_02" ON "public"."gps_tracking_2026_02" FOR SELECT USING (("employee_id" = "auth"."uid"()));



CREATE POLICY "Guards can view GPS 2026_03" ON "public"."gps_tracking_2026_03" FOR SELECT USING (("employee_id" = "auth"."uid"()));



CREATE POLICY "Guards can view GPS 2026_04" ON "public"."gps_tracking_2026_04" FOR SELECT USING (("employee_id" = "auth"."uid"()));



CREATE POLICY "Guards can view GPS default" ON "public"."gps_tracking_default" FOR SELECT USING (("employee_id" = "auth"."uid"()));



CREATE POLICY "Guards can view photos they captured" ON "public"."visitor_photo_metadata" FOR SELECT USING (("auth"."uid"() = ( SELECT "employees"."auth_user_id"
   FROM "public"."employees"
  WHERE ("employees"."id" = "visitor_photo_metadata"."guard_id"))));



CREATE POLICY "Guards can view their own GPS history" ON "public"."gps_tracking" FOR SELECT TO "authenticated" USING (("employee_id" IN ( SELECT "sg"."id"
   FROM ("public"."security_guards" "sg"
     JOIN "public"."employees" "e" ON (("e"."id" = "sg"."employee_id")))
  WHERE ("e"."auth_user_id" = "auth"."uid"()))));



CREATE POLICY "Guards can view their own GPS tracking" ON "public"."guard_gps_tracking" FOR SELECT USING (("auth"."uid"() = ( SELECT "employees"."auth_user_id"
   FROM "public"."employees"
  WHERE ("employees"."id" = "guard_gps_tracking"."guard_id"))));



CREATE POLICY "Guards can view their own attendance" ON "public"."attendance_logs" FOR SELECT TO "authenticated" USING (("employee_id" IN ( SELECT "employees"."id"
   FROM "public"."employees"
  WHERE ("employees"."auth_user_id" = "auth"."uid"()))));



CREATE POLICY "Guards can view their own checklist assignments" ON "public"."checklist_assignments" FOR SELECT TO "authenticated" USING (("employee_id" IN ( SELECT "users"."employee_id"
   FROM "public"."users"
  WHERE (("users"."id" = "auth"."uid"()) AND ("users"."employee_id" IS NOT NULL)))));



CREATE POLICY "Guards can view their own checklist responses" ON "public"."checklist_responses" FOR SELECT TO "authenticated" USING (("employee_id" IN ( SELECT "users"."employee_id"
   FROM "public"."users"
  WHERE (("users"."id" = "auth"."uid"()) AND ("users"."employee_id" IS NOT NULL)))));



CREATE POLICY "Guards can view their own panic alerts" ON "public"."guard_panic_alerts" FOR SELECT USING (("auth"."uid"() = ( SELECT "employees"."auth_user_id"
   FROM "public"."employees"
  WHERE ("employees"."id" = "guard_panic_alerts"."guard_id"))));



CREATE POLICY "Guards can view their own panic alerts" ON "public"."panic_alerts" FOR SELECT TO "authenticated" USING (("guard_id" IN ( SELECT "sg"."id"
   FROM ("public"."security_guards" "sg"
     JOIN "public"."employees" "e" ON (("e"."id" = "sg"."employee_id")))
  WHERE ("e"."auth_user_id" = "auth"."uid"()))));



CREATE POLICY "Guards can view their own patrol logs" ON "public"."guard_patrol_logs" FOR SELECT TO "authenticated" USING (("guard_id" IN ( SELECT "sg"."id"
   FROM ("public"."security_guards" "sg"
     JOIN "public"."employees" "e" ON (("e"."id" = "sg"."employee_id")))
  WHERE ("e"."auth_user_id" = "auth"."uid"()))));



CREATE POLICY "Guards can view their own record" ON "public"."security_guards" FOR SELECT TO "authenticated" USING (("employee_id" IN ( SELECT "employees"."id"
   FROM "public"."employees"
  WHERE ("employees"."auth_user_id" = "auth"."uid"()))));



CREATE POLICY "Higher roles view employees" ON "public"."employees" FOR SELECT USING (("public"."has_role"('admin'::"text") OR "public"."has_role"('super_admin'::"text") OR "public"."has_role"('account'::"text") OR "public"."has_role"('security_supervisor'::"text") OR "public"."has_role"('society_manager'::"text") OR "public"."has_role"('company_hod'::"text")));



CREATE POLICY "Insert Asset Categories" ON "public"."asset_categories" FOR INSERT TO "authenticated" WITH CHECK (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'society_manager'::"public"."user_role"])));



CREATE POLICY "Insert Assets" ON "public"."assets" FOR INSERT TO "authenticated" WITH CHECK (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'society_manager'::"public"."user_role"])));



CREATE POLICY "Insert Job Materials" ON "public"."job_materials_used" FOR INSERT TO "authenticated" WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."job_sessions" "js"
  WHERE (("js"."id" = "job_materials_used"."job_session_id") AND (("js"."technician_id" IN ( SELECT "employees"."id"
           FROM "public"."employees"
          WHERE ("employees"."auth_user_id" = "auth"."uid"()))) OR ("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'society_manager'::"public"."user_role"])))))));



CREATE POLICY "Insert Job Photos" ON "public"."job_photos" FOR INSERT TO "authenticated" WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."job_sessions" "js"
  WHERE (("js"."id" = "job_photos"."job_session_id") AND (("js"."technician_id" IN ( SELECT "employees"."id"
           FROM "public"."employees"
          WHERE ("employees"."auth_user_id" = "auth"."uid"()))) OR ("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'society_manager'::"public"."user_role"])))))));



CREATE POLICY "Insert QR Scans" ON "public"."qr_scans" FOR INSERT TO "authenticated" WITH CHECK (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'society_manager'::"public"."user_role", 'service_boy'::"public"."user_role"])));



CREATE POLICY "Insert Request Items" ON "public"."request_items" FOR INSERT TO "authenticated" WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."requests" "r"
  WHERE (("r"."id" = "request_items"."request_id") AND ("r"."buyer_id" = "auth"."uid"()) AND ("r"."status" = 'pending'::"public"."request_status")))));



CREATE POLICY "Insert behavior tickets" ON "public"."employee_behavior_tickets" FOR INSERT TO "authenticated" WITH CHECK (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'super_admin'::"public"."user_role", 'site_supervisor'::"public"."user_role", 'society_manager'::"public"."user_role", 'company_hod'::"public"."user_role"])));



CREATE POLICY "Insert visitors" ON "public"."visitors" FOR INSERT TO "authenticated" WITH CHECK (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'super_admin'::"public"."user_role", 'site_supervisor'::"public"."user_role", 'society_manager'::"public"."user_role", 'security_guard'::"public"."user_role"])));



CREATE POLICY "Internal staff can view employees" ON "public"."employees" FOR SELECT USING ((("auth"."jwt"() ->> 'user_role'::"text") = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'company_md'::"text", 'company_hod'::"text", 'account'::"text", 'storekeeper'::"text", 'site_supervisor'::"text", 'security_supervisor'::"text", 'society_manager'::"text"])));



CREATE POLICY "Interviewers Update Own Interviews" ON "public"."candidate_interviews" FOR UPDATE TO "authenticated" USING (("interviewer_id" IN ( SELECT "employees"."id"
   FROM "public"."employees"
  WHERE ("employees"."auth_user_id" = "auth"."uid"()))));



CREATE POLICY "Manage Candidate Interviews" ON "public"."candidate_interviews" TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role"])));



CREATE POLICY "Manage Candidates" ON "public"."candidates" TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role"])));



CREATE POLICY "Manage Contracts" ON "public"."contracts" TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'company_md'::"public"."user_role"])));



CREATE POLICY "Manage Indent Items" ON "public"."indent_items" TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."indents" "i"
  WHERE (("i"."id" = "indent_items"."indent_id") AND ((("i"."requester_id" IN ( SELECT "employees"."id"
           FROM "public"."employees"
          WHERE ("employees"."auth_user_id" = "auth"."uid"()))) AND ("i"."status" = 'draft'::"public"."indent_status")) OR ("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'super_admin'::"public"."user_role", 'company_hod'::"public"."user_role"])))))));



CREATE POLICY "Manage Maintenance Schedules" ON "public"."maintenance_schedules" TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'society_manager'::"public"."user_role"])));



CREATE POLICY "Manage Material Receipt Items" ON "public"."material_receipt_items" TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'account'::"public"."user_role"])));



CREATE POLICY "Manage Material Receipts" ON "public"."material_receipts" TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'account'::"public"."user_role"])));



CREATE POLICY "Manage Purchase Bill Items" ON "public"."purchase_bill_items" TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'account'::"public"."user_role"])));



CREATE POLICY "Manage Purchase Bills" ON "public"."purchase_bills" TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'account'::"public"."user_role"])));



CREATE POLICY "Manage Purchase Order Items" ON "public"."purchase_order_items" TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'super_admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'account'::"public"."user_role"])));



CREATE POLICY "Manage Purchase Orders" ON "public"."purchase_orders" TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'super_admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'account'::"public"."user_role"])));



CREATE POLICY "Manage QR Codes" ON "public"."qr_codes" FOR INSERT TO "authenticated" WITH CHECK (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'society_manager'::"public"."user_role"])));



CREATE POLICY "Manage Reconciliation Lines" ON "public"."reconciliation_lines" TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'super_admin'::"public"."user_role", 'account'::"public"."user_role"])));



CREATE POLICY "Manage Reconciliations" ON "public"."reconciliations" TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'super_admin'::"public"."user_role", 'account'::"public"."user_role"])));



CREATE POLICY "Manage Reorder Rules" ON "public"."reorder_rules" TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'account'::"public"."user_role"])));



CREATE POLICY "Manage Sale Bill Items" ON "public"."sale_bill_items" TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'account'::"public"."user_role", 'company_md'::"public"."user_role"])));



CREATE POLICY "Manage Sale Bills" ON "public"."sale_bills" TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'account'::"public"."user_role", 'company_md'::"public"."user_role"])));



CREATE POLICY "Manage Services" ON "public"."services" TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role"])));



CREATE POLICY "Manage Stock Batches" ON "public"."stock_batches" TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'account'::"public"."user_role"])));



CREATE POLICY "Manage Technician Profiles" ON "public"."technician_profiles" TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role"])));



CREATE POLICY "Manage Warehouses" ON "public"."warehouses" TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role"])));



CREATE POLICY "Manage checklist items" ON "public"."daily_checklist_items" TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM ("public"."users" "u"
     JOIN "public"."roles" "r" ON (("u"."role_id" = "r"."id")))
  WHERE (("u"."id" = "auth"."uid"()) AND ("r"."role_name" = ANY (ARRAY['admin'::"public"."user_role", 'company_md'::"public"."user_role", 'company_hod'::"public"."user_role", 'society_manager'::"public"."user_role", 'security_supervisor'::"public"."user_role"]))))));



CREATE POLICY "Manage service rates for admins" ON "public"."service_rates" TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'super_admin'::"public"."user_role"])));



CREATE POLICY "Managers can manage tickets" ON "public"."behaviour_tickets" TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM ("public"."users" "u"
     JOIN "public"."roles" "r" ON (("u"."role_id" = "r"."id")))
  WHERE (("u"."id" = "auth"."uid"()) AND ("r"."role_name" = ANY (ARRAY['admin'::"public"."user_role", 'company_md'::"public"."user_role", 'company_hod'::"public"."user_role", 'society_manager'::"public"."user_role", 'security_supervisor'::"public"."user_role"]))))));



CREATE POLICY "Managers can update panic alerts" ON "public"."panic_alerts" FOR UPDATE TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'super_admin'::"public"."user_role", 'site_supervisor'::"public"."user_role", 'society_manager'::"public"."user_role", 'security_supervisor'::"public"."user_role"]))) WITH CHECK (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'super_admin'::"public"."user_role", 'site_supervisor'::"public"."user_role", 'society_manager'::"public"."user_role", 'security_supervisor'::"public"."user_role"])));



CREATE POLICY "Managers can view GPS tracking" ON "public"."gps_tracking" FOR SELECT TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'super_admin'::"public"."user_role", 'site_supervisor'::"public"."user_role", 'society_manager'::"public"."user_role", 'security_supervisor'::"public"."user_role"])));



CREATE POLICY "Managers can view service requests" ON "public"."service_requests" FOR SELECT TO "authenticated" USING ((("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'super_admin'::"public"."user_role", 'site_supervisor'::"public"."user_role", 'society_manager'::"public"."user_role", 'company_hod'::"public"."user_role"])) OR (("public"."get_user_role"() = 'buyer'::"public"."user_role") AND ("society_id" IN ( SELECT "buyer_accounts"."society_id"
   FROM "public"."buyer_accounts"
  WHERE ("buyer_accounts"."auth_user_id" = "auth"."uid"()))))));



CREATE POLICY "PC Chemicals manageable by staff" ON "public"."pest_control_chemicals" TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'society_manager'::"public"."user_role", 'company_hod'::"public"."user_role"])));



CREATE POLICY "PC Chemicals viewable by authenticated" ON "public"."pest_control_chemicals" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Payer/Payee can view their own payments" ON "public"."payments" FOR SELECT USING ((("payer_id" = "auth"."uid"()) OR ("payee_id" = "auth"."uid"()) OR "public"."is_financial_manager"()));



CREATE POLICY "Personnel update service requests" ON "public"."service_requests" FOR UPDATE USING ((("assigned_to" IN ( SELECT "employees"."id"
   FROM "public"."employees"
  WHERE ("employees"."auth_user_id" = "auth"."uid"()))) OR ("public"."has_role"('admin'::"text") OR "public"."has_role"('company_hod'::"text") OR "public"."has_role"('society_manager'::"text"))));



CREATE POLICY "Public read for authenticated users" ON "public"."company_events" FOR SELECT USING (("auth"."role"() = 'authenticated'::"text"));



CREATE POLICY "Public read for authenticated users" ON "public"."holiday_master" FOR SELECT USING (("auth"."role"() = 'authenticated'::"text"));



CREATE POLICY "Public read for authenticated users" ON "public"."product_categories" FOR SELECT USING (("auth"."role"() = 'authenticated'::"text"));



CREATE POLICY "Public read for authenticated users" ON "public"."product_subcategories" FOR SELECT USING (("auth"."role"() = 'authenticated'::"text"));



CREATE POLICY "Public read for authenticated users" ON "public"."products" FOR SELECT USING (("auth"."role"() = 'authenticated'::"text"));



CREATE POLICY "Public read for authenticated users" ON "public"."sale_product_rates" FOR SELECT USING (("auth"."role"() = 'authenticated'::"text"));



CREATE POLICY "Public read for authenticated users" ON "public"."service_rates" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Public read for authenticated users" ON "public"."service_tasks" FOR SELECT USING (("auth"."role"() = 'authenticated'::"text"));



CREATE POLICY "Public read for authenticated users" ON "public"."services_wise_work" FOR SELECT USING (("auth"."role"() = 'authenticated'::"text"));



CREATE POLICY "Public read for authenticated users" ON "public"."supplier_products" FOR SELECT USING (("auth"."role"() = 'authenticated'::"text"));



CREATE POLICY "Public read for authenticated users" ON "public"."supplier_rates" FOR SELECT USING (("auth"."role"() = 'authenticated'::"text"));



CREATE POLICY "Public read for authenticated users" ON "public"."suppliers" FOR SELECT USING (("auth"."role"() = 'authenticated'::"text"));



CREATE POLICY "Public read for authenticated users" ON "public"."vendor_wise_services" FOR SELECT USING (("auth"."role"() = 'authenticated'::"text"));



CREATE POLICY "Public read for authenticated users" ON "public"."work_master" FOR SELECT USING (("auth"."role"() = 'authenticated'::"text"));



CREATE POLICY "Read checklist items" ON "public"."daily_checklist_items" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Requesters can view their own service requests" ON "public"."service_requests" FOR SELECT TO "authenticated" USING (("requester_id" = "auth"."uid"()));



CREATE POLICY "Residents can create service requests" ON "public"."service_requests" FOR INSERT TO "authenticated" WITH CHECK (("requester_id" = "auth"."uid"()));



CREATE POLICY "Residents can delete their flat visitors" ON "public"."visitors" FOR DELETE TO "authenticated" USING ((("flat_id" IN ( SELECT "residents"."flat_id"
   FROM "public"."residents"
  WHERE ("residents"."auth_user_id" = "auth"."uid"()))) AND (("entry_time" IS NULL) OR ("entry_time" > ("now"() - '00:05:00'::interval)))));



CREATE POLICY "Residents can view visitor photos" ON "public"."visitor_photo_metadata" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM "public"."visitors" "v"
  WHERE (("v"."id" = "visitor_photo_metadata"."visitor_id") AND ("v"."resident_id" = ( SELECT "residents"."id"
           FROM "public"."residents"
          WHERE ("residents"."auth_user_id" = "auth"."uid"())))))));



CREATE POLICY "Service role manages waitlist" ON "public"."waitlist" TO "service_role" USING (true);



CREATE POLICY "Site managers view attendance" ON "public"."attendance_logs" FOR SELECT TO "authenticated" USING ((("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'super_admin'::"public"."user_role", 'site_supervisor'::"public"."user_role", 'society_manager'::"public"."user_role"])) OR (("public"."get_user_role"() = 'buyer'::"public"."user_role") AND (EXISTS ( SELECT 1
   FROM "public"."buyer_accounts"
  WHERE ("buyer_accounts"."auth_user_id" = "auth"."uid"()))))));



CREATE POLICY "Site users view each other" ON "public"."users" FOR SELECT USING (true);



CREATE POLICY "Supervisors can resolve panic alerts" ON "public"."panic_alerts" FOR UPDATE TO "authenticated" USING ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'security_supervisor'::"text", 'society_manager'::"text"]))) WITH CHECK ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'security_supervisor'::"text", 'society_manager'::"text"])));



CREATE POLICY "Supervisors can update attendance" ON "public"."attendance_logs" FOR UPDATE TO "authenticated" USING ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'security_supervisor'::"text"]))) WITH CHECK ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'security_supervisor'::"text"])));



CREATE POLICY "Supervisors can update patrol logs" ON "public"."guard_patrol_logs" FOR UPDATE TO "authenticated" USING ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'security_supervisor'::"text"]))) WITH CHECK ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'security_supervisor'::"text"])));



CREATE POLICY "Supervisors can view all GPS data" ON "public"."gps_tracking" FOR SELECT TO "authenticated" USING ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'security_supervisor'::"text", 'society_manager'::"text"])));



CREATE POLICY "Supervisors can view all checklist assignments" ON "public"."checklist_assignments" FOR SELECT TO "authenticated" USING ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'security_supervisor'::"text", 'society_manager'::"text"])));



CREATE POLICY "Supervisors can view all checklist responses" ON "public"."checklist_responses" FOR SELECT TO "authenticated" USING ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'security_supervisor'::"text", 'society_manager'::"text"])));



CREATE POLICY "Supervisors can view all guards" ON "public"."security_guards" FOR SELECT TO "authenticated" USING ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'security_supervisor'::"text", 'society_manager'::"text"])));



CREATE POLICY "Supervisors can view all panic alerts" ON "public"."panic_alerts" FOR SELECT TO "authenticated" USING ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'security_supervisor'::"text", 'society_manager'::"text"])));



CREATE POLICY "Supervisors can view all patrol logs" ON "public"."guard_patrol_logs" FOR SELECT TO "authenticated" USING ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'security_supervisor'::"text", 'society_manager'::"text"])));



CREATE POLICY "Supervisors create behavior tickets" ON "public"."employee_behavior_tickets" FOR INSERT WITH CHECK (("public"."has_role"('admin'::"text") OR "public"."has_role"('society_manager'::"text") OR "public"."has_role"('security_supervisor'::"text")));



CREATE POLICY "Supervisors view behavior tickets" ON "public"."employee_behavior_tickets" FOR SELECT USING (("public"."has_role"('admin'::"text") OR "public"."has_role"('society_manager'::"text") OR "public"."has_role"('security_supervisor'::"text") OR "public"."has_role"('company_hod'::"text")));



CREATE POLICY "Suppliers can create purchase bills" ON "public"."purchase_bills" FOR INSERT WITH CHECK (("supplier_id" IN ( SELECT "users"."supplier_id"
   FROM "public"."users"
  WHERE ("users"."id" = "auth"."uid"()))));



CREATE POLICY "Suppliers can update assigned requests" ON "public"."requests" FOR UPDATE USING (("supplier_id" IN ( SELECT "users"."supplier_id"
   FROM "public"."users"
  WHERE ("users"."id" = "auth"."uid"())))) WITH CHECK (("supplier_id" IN ( SELECT "users"."supplier_id"
   FROM "public"."users"
  WHERE ("users"."id" = "auth"."uid"()))));



CREATE POLICY "Suppliers can update own purchase orders" ON "public"."purchase_orders" FOR UPDATE USING (("supplier_id" IN ( SELECT "users"."supplier_id"
   FROM "public"."users"
  WHERE ("users"."id" = "auth"."uid"())))) WITH CHECK (("supplier_id" IN ( SELECT "users"."supplier_id"
   FROM "public"."users"
  WHERE ("users"."id" = "auth"."uid"()))));



CREATE POLICY "Suppliers can view assigned requests" ON "public"."requests" FOR SELECT USING (("supplier_id" IN ( SELECT "users"."supplier_id"
   FROM "public"."users"
  WHERE ("users"."id" = "auth"."uid"()))));



CREATE POLICY "Suppliers can view own purchase bills" ON "public"."purchase_bills" FOR SELECT USING (("supplier_id" IN ( SELECT "users"."supplier_id"
   FROM "public"."users"
  WHERE ("users"."id" = "auth"."uid"()))));



CREATE POLICY "Suppliers can view own purchase orders" ON "public"."purchase_orders" FOR SELECT USING (("supplier_id" IN ( SELECT "users"."supplier_id"
   FROM "public"."users"
  WHERE ("users"."id" = "auth"."uid"()))));



CREATE POLICY "System can insert GPS tracking" ON "public"."guard_gps_tracking" FOR INSERT WITH CHECK (true);



CREATE POLICY "System can insert audit logs" ON "public"."audit_logs" FOR INSERT TO "authenticated" WITH CHECK (("actor_id" = "auth"."uid"()));



CREATE POLICY "System can insert panic alerts" ON "public"."guard_panic_alerts" FOR INSERT WITH CHECK (true);



CREATE POLICY "System can insert visitor photo metadata" ON "public"."visitor_photo_metadata" FOR INSERT WITH CHECK (true);



CREATE POLICY "Technicians can insert own PPE verifications" ON "public"."pest_control_ppe_verifications" FOR INSERT TO "authenticated" WITH CHECK ((("technician_id" IN ( SELECT "employees"."id"
   FROM "public"."employees"
  WHERE ("employees"."auth_user_id" = "auth"."uid"()))) OR ("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'society_manager'::"public"."user_role", 'company_hod'::"public"."user_role"]))));



CREATE POLICY "Technicians can update own PPE verifications" ON "public"."pest_control_ppe_verifications" FOR UPDATE TO "authenticated" USING ((("technician_id" IN ( SELECT "employees"."id"
   FROM "public"."employees"
  WHERE ("employees"."auth_user_id" = "auth"."uid"()))) OR ("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'society_manager'::"public"."user_role", 'company_hod'::"public"."user_role"]))));



CREATE POLICY "Update Asset Categories" ON "public"."asset_categories" FOR UPDATE TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'society_manager'::"public"."user_role"])));



CREATE POLICY "Update Assets" ON "public"."assets" FOR UPDATE TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'society_manager'::"public"."user_role"])));



CREATE POLICY "Update Own Indents" ON "public"."indents" FOR UPDATE TO "authenticated" USING (((("requester_id" IN ( SELECT "employees"."id"
   FROM "public"."employees"
  WHERE ("employees"."auth_user_id" = "auth"."uid"()))) AND ("status" = 'draft'::"public"."indent_status")) OR ("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'super_admin'::"public"."user_role", 'company_hod'::"public"."user_role"]))));



CREATE POLICY "Update Own Sessions" ON "public"."job_sessions" FOR UPDATE TO "authenticated" USING ((("technician_id" IN ( SELECT "employees"."id"
   FROM "public"."employees"
  WHERE ("employees"."auth_user_id" = "auth"."uid"()))) OR ("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'society_manager'::"public"."user_role"]))));



CREATE POLICY "Update visitors" ON "public"."visitors" FOR UPDATE TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'super_admin'::"public"."user_role", 'site_supervisor'::"public"."user_role", 'society_manager'::"public"."user_role", 'security_guard'::"public"."user_role"])));



CREATE POLICY "Upload Own Documents" ON "public"."employee_documents" FOR INSERT TO "authenticated" WITH CHECK ((("employee_id" IN ( SELECT "users"."employee_id"
   FROM "public"."users"
  WHERE ("users"."id" = "auth"."uid"()))) OR ("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role"]))));



CREATE POLICY "Users can read panic alerts for their society" ON "public"."panic_alerts" FOR SELECT TO "authenticated" USING ((("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'super_admin'::"public"."user_role", 'site_supervisor'::"public"."user_role", 'society_manager'::"public"."user_role", 'security_guard'::"public"."user_role", 'security_supervisor'::"public"."user_role"])) OR (("public"."get_user_role"() = 'resident'::"public"."user_role") AND ("auth"."uid"() IN ( SELECT "residents"."auth_user_id"
   FROM "public"."residents"
  WHERE ("residents"."flat_id" IN ( SELECT "f"."id"
           FROM ("public"."flats" "f"
             JOIN "public"."buildings" "b" ON (("b"."id" = "f"."building_id")))
          WHERE ("b"."society_id" IN ( SELECT "company_locations"."society_id"
                   FROM "public"."company_locations"
                  WHERE ("company_locations"."id" = "panic_alerts"."location_id"))))))))));



CREATE POLICY "Users can update their own profile" ON "public"."users" FOR UPDATE USING (("id" = "auth"."uid"())) WITH CHECK (("id" = "auth"."uid"()));



CREATE POLICY "Users can view their notifications" ON "public"."notifications" FOR SELECT USING (("user_id" = "auth"."uid"()));



CREATE POLICY "Users can view their own leave applications" ON "public"."leave_applications" FOR SELECT USING (("employee_id" = ( SELECT "users"."employee_id"
   FROM "public"."users"
  WHERE ("users"."id" = "auth"."uid"()))));



CREATE POLICY "Users can view their own shift assignments" ON "public"."employee_shift_assignments" FOR SELECT USING (("employee_id" = ( SELECT "users"."employee_id"
   FROM "public"."users"
  WHERE ("users"."id" = "auth"."uid"()))));



CREATE POLICY "Users create own service requests" ON "public"."service_requests" FOR INSERT WITH CHECK ((("auth"."uid"() IS NOT NULL) AND ("created_by" = "auth"."uid"()) AND ("requester_id" = "auth"."uid"())));



CREATE POLICY "Users manage own tokens" ON "public"."push_tokens" USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users update own record" ON "public"."users" FOR UPDATE USING (("id" = "auth"."uid"()));



CREATE POLICY "Users view own notification logs" ON "public"."notification_logs" FOR SELECT USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users view relevant service requests" ON "public"."service_requests" FOR SELECT USING ((("assigned_to" IN ( SELECT "employees"."id"
   FROM "public"."employees"
  WHERE ("employees"."auth_user_id" = "auth"."uid"()))) OR ("requester_id" = "auth"."uid"()) OR ("public"."has_role"('admin'::"text") OR "public"."has_role"('company_hod'::"text") OR "public"."has_role"('society_manager'::"text"))));



CREATE POLICY "View Asset Categories" ON "public"."asset_categories" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "View Candidate Interviews" ON "public"."candidate_interviews" FOR SELECT TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'company_md'::"public"."user_role"])));



CREATE POLICY "View Candidates" ON "public"."candidates" FOR SELECT TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'company_md'::"public"."user_role"])));



CREATE POLICY "View Contracts" ON "public"."contracts" FOR SELECT TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'account'::"public"."user_role", 'company_md'::"public"."user_role", 'society_manager'::"public"."user_role"])));



CREATE POLICY "View Indent Items" ON "public"."indent_items" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."indents" "i"
  WHERE (("i"."id" = "indent_items"."indent_id") AND (("i"."requester_id" IN ( SELECT "employees"."id"
           FROM "public"."employees"
          WHERE ("employees"."auth_user_id" = "auth"."uid"()))) OR ("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'super_admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'account'::"public"."user_role", 'company_md'::"public"."user_role"])))))));



CREATE POLICY "View Indents" ON "public"."indents" FOR SELECT TO "authenticated" USING ((("requester_id" IN ( SELECT "employees"."id"
   FROM "public"."employees"
  WHERE ("employees"."auth_user_id" = "auth"."uid"()))) OR ("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'super_admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'account'::"public"."user_role", 'company_md'::"public"."user_role"]))));



CREATE POLICY "View Material Receipt Items" ON "public"."material_receipt_items" FOR SELECT TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'account'::"public"."user_role", 'company_md'::"public"."user_role"])));



CREATE POLICY "View Material Receipts" ON "public"."material_receipts" FOR SELECT TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'account'::"public"."user_role", 'company_md'::"public"."user_role"])));



CREATE POLICY "View Own Sessions" ON "public"."job_sessions" FOR SELECT TO "authenticated" USING ((("technician_id" IN ( SELECT "employees"."id"
   FROM "public"."employees"
  WHERE ("employees"."auth_user_id" = "auth"."uid"()))) OR ("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'society_manager'::"public"."user_role"]))));



CREATE POLICY "View Purchase Bill Items" ON "public"."purchase_bill_items" FOR SELECT TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'account'::"public"."user_role", 'company_md'::"public"."user_role"])));



CREATE POLICY "View Purchase Bills" ON "public"."purchase_bills" FOR SELECT TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'account'::"public"."user_role", 'company_md'::"public"."user_role"])));



CREATE POLICY "View Purchase Order Items" ON "public"."purchase_order_items" FOR SELECT TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'super_admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'account'::"public"."user_role", 'company_md'::"public"."user_role"])));



CREATE POLICY "View Purchase Orders" ON "public"."purchase_orders" FOR SELECT TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'super_admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'account'::"public"."user_role", 'company_md'::"public"."user_role"])));



CREATE POLICY "View QR Scans" ON "public"."qr_scans" FOR SELECT TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'society_manager'::"public"."user_role", 'service_boy'::"public"."user_role"])));



CREATE POLICY "View Reconciliation Lines" ON "public"."reconciliation_lines" FOR SELECT TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'super_admin'::"public"."user_role", 'account'::"public"."user_role", 'company_hod'::"public"."user_role", 'company_md'::"public"."user_role"])));



CREATE POLICY "View Reconciliations" ON "public"."reconciliations" FOR SELECT TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'super_admin'::"public"."user_role", 'account'::"public"."user_role", 'company_hod'::"public"."user_role", 'company_md'::"public"."user_role"])));



CREATE POLICY "View Reorder Rules" ON "public"."reorder_rules" FOR SELECT TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'account'::"public"."user_role", 'society_manager'::"public"."user_role", 'service_boy'::"public"."user_role", 'security_supervisor'::"public"."user_role", 'buyer'::"public"."user_role"])));



CREATE POLICY "View Request Items" ON "public"."request_items" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."requests" "r"
  WHERE (("r"."id" = "request_items"."request_id") AND (("r"."buyer_id" = "auth"."uid"()) OR ("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'super_admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'account'::"public"."user_role"])))))));



CREATE POLICY "View Sale Bill Items" ON "public"."sale_bill_items" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."sale_bills"
  WHERE (("sale_bills"."id" = "sale_bill_items"."sale_bill_id") AND ("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'account'::"public"."user_role", 'company_md'::"public"."user_role", 'society_manager'::"public"."user_role"]))))));



CREATE POLICY "View Sale Bills" ON "public"."sale_bills" FOR SELECT TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'company_hod'::"public"."user_role", 'account'::"public"."user_role", 'company_md'::"public"."user_role", 'society_manager'::"public"."user_role"])));



CREATE POLICY "View Services" ON "public"."services" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "View behavior tickets" ON "public"."employee_behavior_tickets" FOR SELECT TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'super_admin'::"public"."user_role", 'site_supervisor'::"public"."user_role", 'society_manager'::"public"."user_role", 'company_hod'::"public"."user_role"])));



CREATE POLICY "View visitors (society-only)" ON "public"."visitors" FOR SELECT TO "authenticated" USING ((("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'super_admin'::"public"."user_role", 'site_supervisor'::"public"."user_role", 'society_manager'::"public"."user_role", 'security_guard'::"public"."user_role", 'security_supervisor'::"public"."user_role"])) OR (("public"."get_user_role"() = 'buyer'::"public"."user_role") AND ("flat_id" IN ( SELECT "f"."id"
   FROM (("public"."flats" "f"
     JOIN "public"."buildings" "b" ON (("b"."id" = "f"."building_id")))
     JOIN "public"."buyer_accounts" "ba" ON (("ba"."society_id" = "b"."society_id")))
  WHERE ("ba"."auth_user_id" = "auth"."uid"())))) OR (("public"."get_user_role"() = 'resident'::"public"."user_role") AND ("auth"."uid"() IN ( SELECT "residents"."auth_user_id"
   FROM "public"."residents"
  WHERE ("residents"."id" = "visitors"."resident_id"))))));



CREATE POLICY "ad_bookings_insert" ON "public"."printing_ad_bookings" FOR INSERT TO "authenticated" WITH CHECK (("auth"."uid"() IS NOT NULL));



CREATE POLICY "ad_bookings_select" ON "public"."printing_ad_bookings" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "ad_bookings_select_isolation" ON "public"."printing_ad_bookings" FOR SELECT TO "authenticated" USING (("ad_space_id" IN ( SELECT "ads"."id"
   FROM ("public"."printing_ad_spaces" "ads"
     JOIN "public"."assets" "a" ON (("ads"."asset_id" = "a"."id")))
  WHERE ("a"."society_id" IN ( SELECT "public"."get_my_managed_societies"() AS "get_my_managed_societies")))));



CREATE POLICY "ad_bookings_update_admin" ON "public"."printing_ad_bookings" FOR UPDATE TO "authenticated" USING (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'account'::"text"]))) WITH CHECK (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'account'::"text"])));



CREATE POLICY "ad_spaces_select_isolation" ON "public"."printing_ad_spaces" FOR SELECT TO "authenticated" USING (("asset_id" IN ( SELECT "assets"."id"
   FROM "public"."assets"
  WHERE ("assets"."society_id" IN ( SELECT "public"."get_my_managed_societies"() AS "get_my_managed_societies")))));



CREATE POLICY "all_can_view_arrival_logs" ON "public"."material_arrival_logs" FOR SELECT TO "authenticated" USING (true);



ALTER TABLE "public"."asset_categories" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."assets" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "assets_select_isolation" ON "public"."assets" FOR SELECT TO "authenticated" USING (("society_id" IN ( SELECT "public"."get_my_managed_societies"() AS "get_my_managed_societies")));



CREATE POLICY "attendance_insert_isolation" ON "public"."attendance_logs" FOR INSERT TO "authenticated" WITH CHECK ((("employee_id" IN ( SELECT "employees"."id"
   FROM "public"."employees"
  WHERE ("employees"."auth_user_id" = "auth"."uid"()))) OR (("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'society_manager'::"text", 'company_hod'::"text", 'security_supervisor'::"text"]))));



ALTER TABLE "public"."attendance_logs" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "attendance_select_isolation" ON "public"."attendance_logs" FOR SELECT TO "authenticated" USING ((("employee_id" IN ( SELECT "employees"."id"
   FROM "public"."employees"
  WHERE ("employees"."auth_user_id" = "auth"."uid"()))) OR ("employee_id" IN ( SELECT "public"."get_employee_ids_in_managed_societies"() AS "get_employee_ids_in_managed_societies"))));



ALTER TABLE "public"."audit_logs" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "audit_logs_super_admin_insert" ON "public"."audit_logs" FOR INSERT TO "authenticated" WITH CHECK ((("public"."get_my_app_role"() = 'super_admin'::"text") AND (("actor_id" IS NULL) OR ("actor_id" = "auth"."uid"()))));



CREATE POLICY "audit_logs_super_admin_select" ON "public"."audit_logs" FOR SELECT TO "authenticated" USING (("public"."get_my_app_role"() = 'super_admin'::"text"));



ALTER TABLE "public"."background_verifications" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."behaviour_tickets" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "bgv_insert" ON "public"."background_verifications" FOR INSERT TO "authenticated" WITH CHECK (("auth"."uid"() IS NOT NULL));



CREATE POLICY "bgv_select" ON "public"."background_verifications" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "bgv_select_isolation" ON "public"."background_verifications" FOR SELECT TO "authenticated" USING ((("employee_id" IN ( SELECT "public"."get_employee_ids_in_managed_societies"() AS "get_employee_ids_in_managed_societies")) OR (("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"]))));



CREATE POLICY "bgv_update_admin_hr" ON "public"."background_verifications" FOR UPDATE TO "authenticated" USING (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'company_hod'::"text"]))) WITH CHECK (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'company_hod'::"text"])));



ALTER TABLE "public"."budgets" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "building_delete_admin" ON "public"."buildings" FOR DELETE TO "authenticated" USING ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"])));



CREATE POLICY "building_insert_admin" ON "public"."buildings" FOR INSERT TO "authenticated" WITH CHECK ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"])));



CREATE POLICY "building_select_isolation" ON "public"."buildings" FOR SELECT TO "authenticated" USING (("society_id" IN ( SELECT "public"."get_my_managed_societies"() AS "get_my_managed_societies")));



CREATE POLICY "building_update_admin" ON "public"."buildings" FOR UPDATE TO "authenticated" USING ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"]))) WITH CHECK ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"])));



ALTER TABLE "public"."buildings" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."buyer_accounts" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "buyer_accounts_admin_full" ON "public"."buyer_accounts" TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'super_admin'::"public"."user_role"]))) WITH CHECK (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'super_admin'::"public"."user_role"])));



CREATE POLICY "buyer_accounts_buyer_read_own" ON "public"."buyer_accounts" FOR SELECT TO "authenticated" USING ((("public"."get_user_role"() = 'buyer'::"public"."user_role") AND ("auth_user_id" = "auth"."uid"())));



ALTER TABLE "public"."buyer_feedback" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "buyer_feedback_insert" ON "public"."buyer_feedback" FOR INSERT TO "authenticated" WITH CHECK (("auth"."uid"() IS NOT NULL));



CREATE POLICY "buyer_feedback_select" ON "public"."buyer_feedback" FOR SELECT TO "authenticated" USING (true);



ALTER TABLE "public"."candidate_interviews" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."candidates" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."checklist_assignments" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "checklist_response_insert_isolation" ON "public"."checklist_responses" FOR INSERT TO "authenticated" WITH CHECK (("location_id" IN ( SELECT "company_locations"."id"
   FROM "public"."company_locations"
  WHERE ("company_locations"."society_id" IN ( SELECT "public"."get_my_managed_societies"() AS "get_my_managed_societies")))));



CREATE POLICY "checklist_response_select_isolation" ON "public"."checklist_responses" FOR SELECT TO "authenticated" USING (((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"])) OR ("location_id" IN ( SELECT "company_locations"."id"
   FROM "public"."company_locations"
  WHERE ("company_locations"."society_id" IN ( SELECT "public"."get_my_managed_societies"() AS "get_my_managed_societies"))))));



ALTER TABLE "public"."checklist_responses" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."company_events" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "company_events_select_isolation" ON "public"."company_events" FOR SELECT TO "authenticated" USING (("location_id" IN ( SELECT "company_locations"."id"
   FROM "public"."company_locations"
  WHERE ("company_locations"."society_id" IN ( SELECT "public"."get_my_managed_societies"() AS "get_my_managed_societies")))));



ALTER TABLE "public"."company_locations" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "company_locations_admin_full" ON "public"."company_locations" TO "authenticated" USING ((COALESCE("public"."get_my_app_role"(), ("public"."get_user_role"())::"text") = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'company_hod'::"text"]))) WITH CHECK ((COALESCE("public"."get_my_app_role"(), ("public"."get_user_role"())::"text") = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'company_hod'::"text"])));



CREATE POLICY "company_locations_authenticated_read" ON "public"."company_locations" FOR SELECT TO "authenticated" USING (("auth"."uid"() IS NOT NULL));



ALTER TABLE "public"."compliance_snapshots" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."contracts" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."credit_notes" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "credit_notes_admin_crud" ON "public"."credit_notes" TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'super_admin'::"public"."user_role", 'account'::"public"."user_role"]))) WITH CHECK (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'super_admin'::"public"."user_role", 'account'::"public"."user_role"])));



CREATE POLICY "credit_notes_buyer_read_own" ON "public"."credit_notes" FOR SELECT TO "authenticated" USING ((("public"."get_user_role"() = 'buyer'::"public"."user_role") AND ("sale_bill_id" IN ( SELECT "sb"."id"
   FROM ("public"."sale_bills" "sb"
     JOIN "public"."buyer_accounts" "ba" ON (("ba"."id" = "sb"."buyer_account_id")))
  WHERE ("ba"."auth_user_id" = "auth"."uid"())))));



ALTER TABLE "public"."daily_checklist_items" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."daily_checklists" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."debit_notes" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "debit_notes_admin_crud" ON "public"."debit_notes" TO "authenticated" USING (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'super_admin'::"public"."user_role", 'account'::"public"."user_role"]))) WITH CHECK (("public"."get_user_role"() = ANY (ARRAY['admin'::"public"."user_role", 'super_admin'::"public"."user_role", 'account'::"public"."user_role"])));



CREATE POLICY "debit_notes_buyer_read_own" ON "public"."debit_notes" FOR SELECT TO "authenticated" USING ((("public"."get_user_role"() = 'buyer'::"public"."user_role") AND ("sale_bill_id" IN ( SELECT "sb"."id"
   FROM ("public"."sale_bills" "sb"
     JOIN "public"."buyer_accounts" "ba" ON (("ba"."id" = "sb"."buyer_account_id")))
  WHERE ("ba"."auth_user_id" = "auth"."uid"())))));



CREATE POLICY "delivery_boy_can_log_arrivals" ON "public"."material_arrival_logs" FOR INSERT TO "authenticated" WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."users" "u"
     JOIN "public"."roles" "r" ON (("u"."role_id" = "r"."id")))
  WHERE (("u"."id" = "auth"."uid"()) AND (("r"."role_name")::"text" = ANY (ARRAY['delivery_boy'::"text", 'security_guard'::"text"]))))));



ALTER TABLE "public"."designations" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "designations_admin_full" ON "public"."designations" TO "authenticated" USING ((COALESCE("public"."get_my_app_role"(), ("public"."get_user_role"())::"text") = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'company_hod'::"text"]))) WITH CHECK ((COALESCE("public"."get_my_app_role"(), ("public"."get_user_role"())::"text") = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'company_hod'::"text"])));



CREATE POLICY "designations_authenticated_read" ON "public"."designations" FOR SELECT TO "authenticated" USING (("auth"."uid"() IS NOT NULL));



CREATE POLICY "dispatches_insert" ON "public"."personnel_dispatches" FOR INSERT TO "authenticated" WITH CHECK (("auth"."uid"() IS NOT NULL));



CREATE POLICY "dispatches_update_admin" ON "public"."personnel_dispatches" FOR UPDATE TO "authenticated" USING (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'site_supervisor'::"text"]))) WITH CHECK (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'site_supervisor'::"text"])));



ALTER TABLE "public"."emergency_contacts" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."employee_behavior_tickets" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."employee_documents" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "employee_manage_isolation" ON "public"."employees" TO "authenticated" USING ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'society_manager'::"text", 'company_hod'::"text"]))) WITH CHECK ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'society_manager'::"text", 'company_hod'::"text"])));



ALTER TABLE "public"."employee_salary_structure" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "employee_salary_structure_manage" ON "public"."employee_salary_structure" TO "authenticated" USING ((COALESCE("public"."get_my_app_role"(), ("public"."get_user_role"())::"text") = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'account'::"text"]))) WITH CHECK ((COALESCE("public"."get_my_app_role"(), ("public"."get_user_role"())::"text") = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'account'::"text"])));



CREATE POLICY "employee_salary_structure_select" ON "public"."employee_salary_structure" FOR SELECT TO "authenticated" USING ((("employee_id" IN ( SELECT "e"."id"
   FROM "public"."employees" "e"
  WHERE ("e"."auth_user_id" = "auth"."uid"()))) OR (COALESCE("public"."get_my_app_role"(), ("public"."get_user_role"())::"text") = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'account'::"text", 'company_hod'::"text", 'company_md'::"text"]))));



CREATE POLICY "employee_select_isolation" ON "public"."employees" FOR SELECT TO "authenticated" USING ((("auth_user_id" = "auth"."uid"()) OR (("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"])) OR ("id" IN ( SELECT "public"."get_employee_ids_in_managed_societies"() AS "get_employee_ids_in_managed_societies"))));



ALTER TABLE "public"."employee_shift_assignments" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."employees" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."financial_periods" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "flat_delete_admin" ON "public"."flats" FOR DELETE TO "authenticated" USING ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"])));



CREATE POLICY "flat_insert_admin" ON "public"."flats" FOR INSERT TO "authenticated" WITH CHECK ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"])));



CREATE POLICY "flat_select_isolation" ON "public"."flats" FOR SELECT TO "authenticated" USING (("building_id" IN ( SELECT "buildings"."id"
   FROM "public"."buildings"
  WHERE ("buildings"."society_id" IN ( SELECT "public"."get_my_managed_societies"() AS "get_my_managed_societies")))));



CREATE POLICY "flat_update_admin" ON "public"."flats" FOR UPDATE TO "authenticated" USING ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"]))) WITH CHECK ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"])));



ALTER TABLE "public"."flats" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "gps_admin_select_2026_05" ON "public"."gps_tracking_2026_05" FOR SELECT TO "authenticated" USING (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'security_supervisor'::"text", 'society_manager'::"text", 'site_supervisor'::"text"])));



CREATE POLICY "gps_admin_select_2026_06" ON "public"."gps_tracking_2026_06" FOR SELECT TO "authenticated" USING (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'security_supervisor'::"text", 'society_manager'::"text", 'site_supervisor'::"text"])));



CREATE POLICY "gps_admin_select_2026_07" ON "public"."gps_tracking_2026_07" FOR SELECT TO "authenticated" USING (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'security_supervisor'::"text", 'society_manager'::"text", 'site_supervisor'::"text"])));



CREATE POLICY "gps_admin_select_2026_08" ON "public"."gps_tracking_2026_08" FOR SELECT TO "authenticated" USING (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'security_supervisor'::"text", 'society_manager'::"text", 'site_supervisor'::"text"])));



CREATE POLICY "gps_admin_select_2026_09" ON "public"."gps_tracking_2026_09" FOR SELECT TO "authenticated" USING (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'security_supervisor'::"text", 'society_manager'::"text", 'site_supervisor'::"text"])));



CREATE POLICY "gps_admin_select_2026_10" ON "public"."gps_tracking_2026_10" FOR SELECT TO "authenticated" USING (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'security_supervisor'::"text", 'society_manager'::"text", 'site_supervisor'::"text"])));



CREATE POLICY "gps_admin_select_2026_11" ON "public"."gps_tracking_2026_11" FOR SELECT TO "authenticated" USING (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'security_supervisor'::"text", 'society_manager'::"text", 'site_supervisor'::"text"])));



CREATE POLICY "gps_admin_select_2026_12" ON "public"."gps_tracking_2026_12" FOR SELECT TO "authenticated" USING (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'security_supervisor'::"text", 'society_manager'::"text", 'site_supervisor'::"text"])));



CREATE POLICY "gps_guard_own_2026_05" ON "public"."gps_tracking_2026_05" TO "authenticated" USING (("employee_id" = ( SELECT "sg"."id"
   FROM ("public"."security_guards" "sg"
     JOIN "public"."users" "u" ON (("u"."employee_id" = "sg"."employee_id")))
  WHERE ("u"."id" = "auth"."uid"())
 LIMIT 1))) WITH CHECK (("employee_id" = ( SELECT "sg"."id"
   FROM ("public"."security_guards" "sg"
     JOIN "public"."users" "u" ON (("u"."employee_id" = "sg"."employee_id")))
  WHERE ("u"."id" = "auth"."uid"())
 LIMIT 1)));



CREATE POLICY "gps_guard_own_2026_06" ON "public"."gps_tracking_2026_06" TO "authenticated" USING (("employee_id" = ( SELECT "sg"."id"
   FROM ("public"."security_guards" "sg"
     JOIN "public"."users" "u" ON (("u"."employee_id" = "sg"."employee_id")))
  WHERE ("u"."id" = "auth"."uid"())
 LIMIT 1))) WITH CHECK (("employee_id" = ( SELECT "sg"."id"
   FROM ("public"."security_guards" "sg"
     JOIN "public"."users" "u" ON (("u"."employee_id" = "sg"."employee_id")))
  WHERE ("u"."id" = "auth"."uid"())
 LIMIT 1)));



CREATE POLICY "gps_guard_own_2026_07" ON "public"."gps_tracking_2026_07" TO "authenticated" USING (("employee_id" = ( SELECT "sg"."id"
   FROM ("public"."security_guards" "sg"
     JOIN "public"."users" "u" ON (("u"."employee_id" = "sg"."employee_id")))
  WHERE ("u"."id" = "auth"."uid"())
 LIMIT 1))) WITH CHECK (("employee_id" = ( SELECT "sg"."id"
   FROM ("public"."security_guards" "sg"
     JOIN "public"."users" "u" ON (("u"."employee_id" = "sg"."employee_id")))
  WHERE ("u"."id" = "auth"."uid"())
 LIMIT 1)));



CREATE POLICY "gps_guard_own_2026_08" ON "public"."gps_tracking_2026_08" TO "authenticated" USING (("employee_id" = ( SELECT "sg"."id"
   FROM ("public"."security_guards" "sg"
     JOIN "public"."users" "u" ON (("u"."employee_id" = "sg"."employee_id")))
  WHERE ("u"."id" = "auth"."uid"())
 LIMIT 1))) WITH CHECK (("employee_id" = ( SELECT "sg"."id"
   FROM ("public"."security_guards" "sg"
     JOIN "public"."users" "u" ON (("u"."employee_id" = "sg"."employee_id")))
  WHERE ("u"."id" = "auth"."uid"())
 LIMIT 1)));



CREATE POLICY "gps_guard_own_2026_09" ON "public"."gps_tracking_2026_09" TO "authenticated" USING (("employee_id" = ( SELECT "sg"."id"
   FROM ("public"."security_guards" "sg"
     JOIN "public"."users" "u" ON (("u"."employee_id" = "sg"."employee_id")))
  WHERE ("u"."id" = "auth"."uid"())
 LIMIT 1))) WITH CHECK (("employee_id" = ( SELECT "sg"."id"
   FROM ("public"."security_guards" "sg"
     JOIN "public"."users" "u" ON (("u"."employee_id" = "sg"."employee_id")))
  WHERE ("u"."id" = "auth"."uid"())
 LIMIT 1)));



CREATE POLICY "gps_guard_own_2026_10" ON "public"."gps_tracking_2026_10" TO "authenticated" USING (("employee_id" = ( SELECT "sg"."id"
   FROM ("public"."security_guards" "sg"
     JOIN "public"."users" "u" ON (("u"."employee_id" = "sg"."employee_id")))
  WHERE ("u"."id" = "auth"."uid"())
 LIMIT 1))) WITH CHECK (("employee_id" = ( SELECT "sg"."id"
   FROM ("public"."security_guards" "sg"
     JOIN "public"."users" "u" ON (("u"."employee_id" = "sg"."employee_id")))
  WHERE ("u"."id" = "auth"."uid"())
 LIMIT 1)));



CREATE POLICY "gps_guard_own_2026_11" ON "public"."gps_tracking_2026_11" TO "authenticated" USING (("employee_id" = ( SELECT "sg"."id"
   FROM ("public"."security_guards" "sg"
     JOIN "public"."users" "u" ON (("u"."employee_id" = "sg"."employee_id")))
  WHERE ("u"."id" = "auth"."uid"())
 LIMIT 1))) WITH CHECK (("employee_id" = ( SELECT "sg"."id"
   FROM ("public"."security_guards" "sg"
     JOIN "public"."users" "u" ON (("u"."employee_id" = "sg"."employee_id")))
  WHERE ("u"."id" = "auth"."uid"())
 LIMIT 1)));



CREATE POLICY "gps_guard_own_2026_12" ON "public"."gps_tracking_2026_12" TO "authenticated" USING (("employee_id" = ( SELECT "sg"."id"
   FROM ("public"."security_guards" "sg"
     JOIN "public"."users" "u" ON (("u"."employee_id" = "sg"."employee_id")))
  WHERE ("u"."id" = "auth"."uid"())
 LIMIT 1))) WITH CHECK (("employee_id" = ( SELECT "sg"."id"
   FROM ("public"."security_guards" "sg"
     JOIN "public"."users" "u" ON (("u"."employee_id" = "sg"."employee_id")))
  WHERE ("u"."id" = "auth"."uid"())
 LIMIT 1)));



ALTER TABLE "public"."gps_tracking" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."gps_tracking_2026_02" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."gps_tracking_2026_03" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."gps_tracking_2026_04" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."gps_tracking_2026_05" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."gps_tracking_2026_06" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."gps_tracking_2026_07" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."gps_tracking_2026_08" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."gps_tracking_2026_09" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."gps_tracking_2026_10" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."gps_tracking_2026_11" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."gps_tracking_2026_12" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."gps_tracking_default" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."guard_gps_tracking" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."guard_panic_alerts" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."guard_patrol_logs" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."holiday_master" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."holidays" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."horticulture_seasonal_plans" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "horticulture_seasonal_plans_insert_plantation" ON "public"."horticulture_seasonal_plans" FOR INSERT TO "authenticated" WITH CHECK (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'site_supervisor'::"text"])));



CREATE POLICY "horticulture_seasonal_plans_select_plantation" ON "public"."horticulture_seasonal_plans" FOR SELECT TO "authenticated" USING (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'site_supervisor'::"text", 'pest_control_technician'::"text"])));



CREATE POLICY "horticulture_seasonal_plans_update_plantation" ON "public"."horticulture_seasonal_plans" FOR UPDATE TO "authenticated" USING (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'site_supervisor'::"text"]))) WITH CHECK (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'site_supervisor'::"text"])));



ALTER TABLE "public"."horticulture_tasks" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "horticulture_tasks_insert_plantation" ON "public"."horticulture_tasks" FOR INSERT TO "authenticated" WITH CHECK (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'site_supervisor'::"text"])));



CREATE POLICY "horticulture_tasks_select_isolation" ON "public"."horticulture_tasks" FOR SELECT TO "authenticated" USING (("zone_id" IN ( SELECT "horticulture_zones"."id"
   FROM "public"."horticulture_zones"
  WHERE ("horticulture_zones"."location_id" IN ( SELECT "company_locations"."id"
           FROM "public"."company_locations"
          WHERE ("company_locations"."society_id" IN ( SELECT "public"."get_my_managed_societies"() AS "get_my_managed_societies")))))));



CREATE POLICY "horticulture_tasks_select_plantation" ON "public"."horticulture_tasks" FOR SELECT TO "authenticated" USING ((("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'site_supervisor'::"text"])) OR (("public"."get_my_app_role"() = 'pest_control_technician'::"text") AND ("assigned_to" = "public"."get_employee_id"()))));



CREATE POLICY "horticulture_tasks_update_plantation" ON "public"."horticulture_tasks" FOR UPDATE TO "authenticated" USING ((("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'site_supervisor'::"text"])) OR (("public"."get_my_app_role"() = 'pest_control_technician'::"text") AND ("assigned_to" = "public"."get_employee_id"())))) WITH CHECK ((("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'site_supervisor'::"text"])) OR (("public"."get_my_app_role"() = 'pest_control_technician'::"text") AND ("assigned_to" = "public"."get_employee_id"()))));



ALTER TABLE "public"."horticulture_zones" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "horticulture_zones_insert_plantation" ON "public"."horticulture_zones" FOR INSERT TO "authenticated" WITH CHECK (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'site_supervisor'::"text"])));



CREATE POLICY "horticulture_zones_select_isolation" ON "public"."horticulture_zones" FOR SELECT TO "authenticated" USING (("location_id" IN ( SELECT "company_locations"."id"
   FROM "public"."company_locations"
  WHERE ("company_locations"."society_id" IN ( SELECT "public"."get_my_managed_societies"() AS "get_my_managed_societies")))));



CREATE POLICY "horticulture_zones_select_plantation" ON "public"."horticulture_zones" FOR SELECT TO "authenticated" USING (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'site_supervisor'::"text", 'pest_control_technician'::"text"])));



CREATE POLICY "horticulture_zones_update_plantation" ON "public"."horticulture_zones" FOR UPDATE TO "authenticated" USING (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'site_supervisor'::"text"]))) WITH CHECK (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'site_supervisor'::"text"])));



ALTER TABLE "public"."indent_items" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."indents" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."inventory" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "inventory_admin_storekeeper_full" ON "public"."inventory" TO "authenticated" USING (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'storekeeper'::"text"]))) WITH CHECK (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'storekeeper'::"text"])));



CREATE POLICY "inventory_buyer_account_select" ON "public"."inventory" FOR SELECT TO "authenticated" USING (("public"."get_my_app_role"() = ANY (ARRAY['buyer'::"text", 'account'::"text", 'company_hod'::"text", 'site_supervisor'::"text"])));



ALTER TABLE "public"."job_materials_used" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "job_materials_used_select_isolation" ON "public"."job_materials_used" FOR SELECT TO "authenticated" USING (("job_session_id" IN ( SELECT "js"."id"
   FROM ("public"."job_sessions" "js"
     JOIN "public"."service_requests" "sr" ON (("js"."service_request_id" = "sr"."id")))
  WHERE ("sr"."location_id" IN ( SELECT "company_locations"."id"
           FROM "public"."company_locations"
          WHERE ("company_locations"."society_id" IN ( SELECT "public"."get_my_managed_societies"() AS "get_my_managed_societies")))))));



ALTER TABLE "public"."job_photos" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "job_photos_select_isolation" ON "public"."job_photos" FOR SELECT TO "authenticated" USING (("job_session_id" IN ( SELECT "js"."id"
   FROM ("public"."job_sessions" "js"
     JOIN "public"."service_requests" "sr" ON (("js"."service_request_id" = "sr"."id")))
  WHERE ("sr"."location_id" IN ( SELECT "company_locations"."id"
           FROM "public"."company_locations"
          WHERE ("company_locations"."society_id" IN ( SELECT "public"."get_my_managed_societies"() AS "get_my_managed_societies")))))));



ALTER TABLE "public"."job_sessions" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."leave_applications" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "leave_applications_insert_own" ON "public"."leave_applications" FOR INSERT TO "authenticated" WITH CHECK ((("employee_id" IN ( SELECT "e"."id"
   FROM "public"."employees" "e"
  WHERE ("e"."auth_user_id" = "auth"."uid"()))) AND (("status")::"text" = 'pending'::"text") AND ("approved_by" IS NULL)));



CREATE POLICY "leave_applications_select" ON "public"."leave_applications" FOR SELECT TO "authenticated" USING ((("employee_id" IN ( SELECT "e"."id"
   FROM "public"."employees" "e"
  WHERE ("e"."auth_user_id" = "auth"."uid"()))) OR (COALESCE("public"."get_my_app_role"(), ("public"."get_user_role"())::"text") = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'company_hod'::"text", 'society_manager'::"text", 'security_supervisor'::"text"]))));



CREATE POLICY "leave_applications_update_managers" ON "public"."leave_applications" FOR UPDATE TO "authenticated" USING ((COALESCE("public"."get_my_app_role"(), ("public"."get_user_role"())::"text") = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'company_hod'::"text", 'society_manager'::"text", 'security_supervisor'::"text"]))) WITH CHECK ((COALESCE("public"."get_my_app_role"(), ("public"."get_user_role"())::"text") = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'company_hod'::"text", 'society_manager'::"text", 'security_supervisor'::"text"])));



ALTER TABLE "public"."leave_types" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "location_delete_admin" ON "public"."company_locations" FOR DELETE TO "authenticated" USING ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"])));



CREATE POLICY "location_insert_admin" ON "public"."company_locations" FOR INSERT TO "authenticated" WITH CHECK ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"])));



CREATE POLICY "location_select_isolation" ON "public"."company_locations" FOR SELECT TO "authenticated" USING (("society_id" IN ( SELECT "public"."get_my_managed_societies"() AS "get_my_managed_societies")));



CREATE POLICY "location_update_admin" ON "public"."company_locations" FOR UPDATE TO "authenticated" USING ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"]))) WITH CHECK ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"])));



ALTER TABLE "public"."login_rate_limits" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "login_rate_limits_block_direct" ON "public"."login_rate_limits" TO "authenticated" USING (false);



ALTER TABLE "public"."maintenance_schedules" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "maintenance_schedules_select_isolation" ON "public"."maintenance_schedules" FOR SELECT TO "authenticated" USING (("asset_id" IN ( SELECT "assets"."id"
   FROM "public"."assets"
  WHERE ("assets"."society_id" IN ( SELECT "public"."get_my_managed_societies"() AS "get_my_managed_societies")))));



CREATE POLICY "mat_arrival_evidence_admin_delivery" ON "public"."material_arrival_evidence" TO "authenticated" USING (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'storekeeper'::"text", 'delivery_personnel'::"text"]))) WITH CHECK (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'storekeeper'::"text", 'delivery_personnel'::"text"])));



CREATE POLICY "mat_arrival_evidence_select_buyer" ON "public"."material_arrival_evidence" FOR SELECT TO "authenticated" USING (("public"."get_my_app_role"() = ANY (ARRAY['buyer'::"text", 'account'::"text", 'company_hod'::"text"])));



ALTER TABLE "public"."material_arrival_evidence" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."material_arrival_logs" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."material_receipt_items" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."material_receipts" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."notification_logs" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."notifications" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "notifications_insert_restricted" ON "public"."notifications" FOR INSERT TO "authenticated" WITH CHECK ((("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text"])) OR ("user_id" = "auth"."uid"())));



CREATE POLICY "notifications_insert_service_role" ON "public"."notifications" FOR INSERT TO "service_role" WITH CHECK (true);



CREATE POLICY "notifications_select_own" ON "public"."notifications" FOR SELECT TO "authenticated" USING (("user_id" = "auth"."uid"()));



CREATE POLICY "notifications_update_own" ON "public"."notifications" FOR UPDATE TO "authenticated" USING (("user_id" = "auth"."uid"()));



ALTER TABLE "public"."oversight_tickets" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "oversight_tickets_insert" ON "public"."oversight_tickets" FOR INSERT TO "authenticated" WITH CHECK ((("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'security_supervisor'::"text", 'society_manager'::"text"])) AND ("created_by" = "auth"."uid"())));



CREATE POLICY "oversight_tickets_select" ON "public"."oversight_tickets" FOR SELECT TO "authenticated" USING (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'security_supervisor'::"text", 'society_manager'::"text"])));



CREATE POLICY "oversight_tickets_update" ON "public"."oversight_tickets" FOR UPDATE TO "authenticated" USING (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'security_supervisor'::"text", 'society_manager'::"text"]))) WITH CHECK (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'security_supervisor'::"text", 'society_manager'::"text"])));



ALTER TABLE "public"."panic_alerts" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."payment_methods" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."payments" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."payroll_cycles" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "payroll_cycles_manage_admin" ON "public"."payroll_cycles" TO "authenticated" USING ((COALESCE("public"."get_my_app_role"(), ("public"."get_user_role"())::"text") = ANY (ARRAY['admin'::"text", 'super_admin'::"text"]))) WITH CHECK ((COALESCE("public"."get_my_app_role"(), ("public"."get_user_role"())::"text") = ANY (ARRAY['admin'::"text", 'super_admin'::"text"])));



CREATE POLICY "payroll_cycles_select" ON "public"."payroll_cycles" FOR SELECT TO "authenticated" USING ((COALESCE("public"."get_my_app_role"(), ("public"."get_user_role"())::"text") = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'account'::"text"])));



ALTER TABLE "public"."payslips" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "payslips_manage_admin" ON "public"."payslips" TO "authenticated" USING ((COALESCE("public"."get_my_app_role"(), ("public"."get_user_role"())::"text") = ANY (ARRAY['admin'::"text", 'super_admin'::"text"]))) WITH CHECK ((COALESCE("public"."get_my_app_role"(), ("public"."get_user_role"())::"text") = ANY (ARRAY['admin'::"text", 'super_admin'::"text"])));



CREATE POLICY "payslips_select" ON "public"."payslips" FOR SELECT TO "authenticated" USING ((("employee_id" IN ( SELECT "e"."id"
   FROM "public"."employees" "e"
  WHERE ("e"."auth_user_id" = "auth"."uid"()))) OR (COALESCE("public"."get_my_app_role"(), ("public"."get_user_role"())::"text") = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'account'::"text"]))));



ALTER TABLE "public"."personnel_dispatches" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "personnel_dispatches_select_isolation" ON "public"."personnel_dispatches" FOR SELECT TO "authenticated" USING (("deployment_site_id" IN ( SELECT "company_locations"."id"
   FROM "public"."company_locations"
  WHERE ("company_locations"."society_id" IN ( SELECT "public"."get_my_managed_societies"() AS "get_my_managed_societies")))));



CREATE POLICY "personnel_dispatches_update_isolation" ON "public"."personnel_dispatches" FOR UPDATE TO "authenticated" USING ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'society_manager'::"text"])));



ALTER TABLE "public"."pest_control_chemicals" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."pest_control_ppe_verifications" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."pest_control_spill_kits" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "ppe_verifications_select_isolation" ON "public"."pest_control_ppe_verifications" FOR SELECT TO "authenticated" USING (("service_request_id" IN ( SELECT "service_requests"."id"
   FROM "public"."service_requests"
  WHERE ("service_requests"."location_id" IN ( SELECT "company_locations"."id"
           FROM "public"."company_locations"
          WHERE ("company_locations"."society_id" IN ( SELECT "public"."get_my_managed_societies"() AS "get_my_managed_societies")))))));



ALTER TABLE "public"."printing_ad_bookings" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."printing_ad_spaces" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."product_categories" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."product_subcategories" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."products" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."purchase_bill_items" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."purchase_bills" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."purchase_order_items" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."purchase_orders" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."push_tokens" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "qr_batch_admin_storekeeper" ON "public"."qr_batch_logs" TO "authenticated" USING (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'storekeeper'::"text"]))) WITH CHECK (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'storekeeper'::"text"])));



ALTER TABLE "public"."qr_batch_logs" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."qr_codes" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "qr_codes_select_isolation" ON "public"."qr_codes" FOR SELECT TO "authenticated" USING (("society_id" IN ( SELECT "public"."get_my_managed_societies"() AS "get_my_managed_societies")));



CREATE POLICY "qr_codes_update_isolation" ON "public"."qr_codes" FOR UPDATE TO "authenticated" USING ((("society_id" IN ( SELECT "public"."get_my_managed_societies"() AS "get_my_managed_societies")) AND (("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'society_manager'::"text"])))) WITH CHECK ((("society_id" IN ( SELECT "public"."get_my_managed_societies"() AS "get_my_managed_societies")) AND (("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'society_manager'::"text"]))));



ALTER TABLE "public"."qr_scans" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."reconciliation_lines" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."reconciliations" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."reorder_rules" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."request_items" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "request_manage_isolation" ON "public"."requests" TO "authenticated" USING ((("buyer_id" = "auth"."uid"()) OR (("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'society_manager'::"text"])))) WITH CHECK ((("buyer_id" = "auth"."uid"()) OR (("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'society_manager'::"text"]))));



CREATE POLICY "request_select_isolation" ON "public"."requests" FOR SELECT TO "authenticated" USING ((("buyer_id" = "auth"."uid"()) OR (("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"])) OR ("location_id" IN ( SELECT "company_locations"."id"
   FROM "public"."company_locations"
  WHERE ("company_locations"."society_id" IN ( SELECT "public"."get_my_managed_societies"() AS "get_my_managed_societies"))))));



ALTER TABLE "public"."requests" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "resident_insert_isolation" ON "public"."residents" FOR INSERT TO "authenticated" WITH CHECK ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'society_manager'::"text"])));



CREATE POLICY "resident_select_isolation" ON "public"."residents" FOR SELECT TO "authenticated" USING ((("auth_user_id" = "auth"."uid"()) OR ("flat_id" IN ( SELECT "f"."id"
   FROM ("public"."flats" "f"
     JOIN "public"."buildings" "b" ON (("f"."building_id" = "b"."id")))
  WHERE ("b"."society_id" IN ( SELECT "public"."get_my_managed_societies"() AS "get_my_managed_societies"))))));



CREATE POLICY "resident_update_isolation" ON "public"."residents" FOR UPDATE TO "authenticated" USING ((("auth_user_id" = "auth"."uid"()) OR (("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'society_manager'::"text"])))) WITH CHECK ((("auth_user_id" = "auth"."uid"()) OR (("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'society_manager'::"text"]))));



ALTER TABLE "public"."residents" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."roles" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "roles_read_all" ON "public"."roles" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "roles_super_admin_full" ON "public"."roles" TO "authenticated" USING (("public"."get_my_app_role"() = 'super_admin'::"text")) WITH CHECK (("public"."get_my_app_role"() = 'super_admin'::"text"));



ALTER TABLE "public"."rtv_tickets" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "rtv_tickets_delete" ON "public"."rtv_tickets" FOR DELETE TO "authenticated" USING (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text"])));



CREATE POLICY "rtv_tickets_insert" ON "public"."rtv_tickets" FOR INSERT TO "authenticated" WITH CHECK ((("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'buyer'::"text", 'account'::"text", 'storekeeper'::"text"])) AND ("raised_by" = "auth"."uid"())));



CREATE POLICY "rtv_tickets_select" ON "public"."rtv_tickets" FOR SELECT TO "authenticated" USING ((("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'buyer'::"text", 'account'::"text", 'storekeeper'::"text", 'company_md'::"text", 'company_hod'::"text", 'site_supervisor'::"text"])) OR ("raised_by" = "auth"."uid"())));



CREATE POLICY "rtv_tickets_select_isolation" ON "public"."rtv_tickets" FOR SELECT TO "authenticated" USING (("po_id" IN ( SELECT "po"."id"
   FROM ("public"."purchase_orders" "po"
     JOIN "public"."indents" "i" ON (("po"."indent_id" = "i"."id")))
  WHERE ("i"."society_id" IN ( SELECT "public"."get_my_managed_societies"() AS "get_my_managed_societies")))));



CREATE POLICY "rtv_tickets_update" ON "public"."rtv_tickets" FOR UPDATE TO "authenticated" USING ((("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'account'::"text"])) OR (("public"."get_my_app_role"() = ANY (ARRAY['buyer'::"text", 'storekeeper'::"text"])) AND ("raised_by" = "auth"."uid"())))) WITH CHECK ((("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'account'::"text"])) OR (("public"."get_my_app_role"() = ANY (ARRAY['buyer'::"text", 'storekeeper'::"text"])) AND ("raised_by" = "auth"."uid"()))));



ALTER TABLE "public"."safety_equipment" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."salary_components" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "salary_components_manage" ON "public"."salary_components" TO "authenticated" USING ((COALESCE("public"."get_my_app_role"(), ("public"."get_user_role"())::"text") = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'account'::"text"]))) WITH CHECK ((COALESCE("public"."get_my_app_role"(), ("public"."get_user_role"())::"text") = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'account'::"text"])));



CREATE POLICY "salary_components_select" ON "public"."salary_components" FOR SELECT TO "authenticated" USING ((COALESCE("public"."get_my_app_role"(), ("public"."get_user_role"())::"text") = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'company_hod'::"text", 'company_md'::"text", 'account'::"text"])));



ALTER TABLE "public"."sale_bill_items" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."sale_bills" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."sale_product_rates" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."security_guards" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."service_acknowledgments" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."service_delivery_notes" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "service_delivery_notes_insert" ON "public"."service_delivery_notes" FOR INSERT TO "authenticated" WITH CHECK (("auth"."uid"() IS NOT NULL));



CREATE POLICY "service_delivery_notes_select_isolation" ON "public"."service_delivery_notes" FOR SELECT TO "authenticated" USING (("po_id" IN ( SELECT "po"."id"
   FROM ("public"."purchase_orders" "po"
     JOIN "public"."indents" "i" ON (("po"."indent_id" = "i"."id")))
  WHERE ("i"."society_id" IN ( SELECT "public"."get_my_managed_societies"() AS "get_my_managed_societies")))));



CREATE POLICY "service_delivery_notes_update_admin" ON "public"."service_delivery_notes" FOR UPDATE TO "authenticated" USING (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'site_supervisor'::"text", 'account'::"text"]))) WITH CHECK (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'site_supervisor'::"text", 'account'::"text"])));



ALTER TABLE "public"."service_feedback" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "service_feedback_insert_restricted" ON "public"."service_feedback" FOR INSERT TO "authenticated" WITH CHECK (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'buyer'::"text", 'resident'::"text", 'society_manager'::"text"])));



CREATE POLICY "service_feedback_select_isolation" ON "public"."service_feedback" FOR SELECT TO "authenticated" USING (("society_id" IN ( SELECT "public"."get_my_managed_societies"() AS "get_my_managed_societies")));



ALTER TABLE "public"."service_purchase_order_items" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."service_purchase_orders" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."service_rates" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "service_request_manage_isolation" ON "public"."service_requests" TO "authenticated" USING ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'society_manager'::"text", 'site_supervisor'::"text"]))) WITH CHECK ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'society_manager'::"text", 'site_supervisor'::"text"])));



CREATE POLICY "service_request_select_isolation" ON "public"."service_requests" FOR SELECT TO "authenticated" USING ((("requester_id" = "auth"."uid"()) OR (("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"])) OR ("location_id" IN ( SELECT "company_locations"."id"
   FROM "public"."company_locations"
  WHERE ("company_locations"."society_id" IN ( SELECT "public"."get_my_managed_societies"() AS "get_my_managed_societies"))))));



ALTER TABLE "public"."service_requests" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "service_requests_insert_own" ON "public"."service_requests" FOR INSERT TO "authenticated" WITH CHECK ((("created_by" = "auth"."uid"()) OR ("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'buyer'::"text", 'site_supervisor'::"text"]))));



ALTER TABLE "public"."service_tasks" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."services" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."services_wise_work" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."shifts" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."shortage_note_items" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "shortage_note_items_insert" ON "public"."shortage_note_items" FOR INSERT TO "authenticated" WITH CHECK (("auth"."uid"() IS NOT NULL));



CREATE POLICY "shortage_note_items_select_isolation" ON "public"."shortage_note_items" FOR SELECT TO "authenticated" USING (("shortage_note_id" IN ( SELECT "shortage_notes"."id"
   FROM "public"."shortage_notes"
  WHERE true)));



ALTER TABLE "public"."shortage_notes" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "shortage_notes_insert" ON "public"."shortage_notes" FOR INSERT TO "authenticated" WITH CHECK (("auth"."uid"() IS NOT NULL));



CREATE POLICY "shortage_notes_select_isolation" ON "public"."shortage_notes" FOR SELECT TO "authenticated" USING ((("po_id" IN ( SELECT "po"."id"
   FROM ("public"."purchase_orders" "po"
     JOIN "public"."indents" "i" ON (("po"."indent_id" = "i"."id")))
  WHERE ("i"."society_id" IN ( SELECT "public"."get_my_managed_societies"() AS "get_my_managed_societies")))) OR (("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'account'::"text", 'company_md'::"text"]))));



CREATE POLICY "shortage_notes_update_admin" ON "public"."shortage_notes" FOR UPDATE TO "authenticated" USING (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'storekeeper'::"text", 'account'::"text"]))) WITH CHECK (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'storekeeper'::"text", 'account'::"text"])));



ALTER TABLE "public"."societies" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "society_delete_admin" ON "public"."societies" FOR DELETE TO "authenticated" USING ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"])));



CREATE POLICY "society_insert_admin" ON "public"."societies" FOR INSERT TO "authenticated" WITH CHECK ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"])));



CREATE POLICY "society_select_isolation" ON "public"."societies" FOR SELECT TO "authenticated" USING (("id" IN ( SELECT "public"."get_my_managed_societies"() AS "get_my_managed_societies")));



CREATE POLICY "society_update_admin" ON "public"."societies" FOR UPDATE TO "authenticated" USING ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"]))) WITH CHECK ((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"])));



CREATE POLICY "spill_kits_insert" ON "public"."pest_control_spill_kits" FOR INSERT TO "authenticated" WITH CHECK (("auth"."uid"() IS NOT NULL));



CREATE POLICY "spill_kits_select" ON "public"."pest_control_spill_kits" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "spill_kits_select_isolation" ON "public"."pest_control_spill_kits" FOR SELECT TO "authenticated" USING (("location_id" IN ( SELECT "company_locations"."id"
   FROM "public"."company_locations"
  WHERE ("company_locations"."society_id" IN ( SELECT "public"."get_my_managed_societies"() AS "get_my_managed_societies")))));



CREATE POLICY "spill_kits_update_admin" ON "public"."pest_control_spill_kits" FOR UPDATE TO "authenticated" USING (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'site_supervisor'::"text"]))) WITH CHECK (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'site_supervisor'::"text"])));



CREATE POLICY "spo_admin_full" ON "public"."service_purchase_orders" TO "authenticated" USING (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'account'::"text", 'company_hod'::"text"]))) WITH CHECK (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'account'::"text", 'company_hod'::"text"])));



CREATE POLICY "spo_items_admin_full" ON "public"."service_purchase_order_items" TO "authenticated" USING (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'account'::"text", 'company_hod'::"text"]))) WITH CHECK (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'account'::"text", 'company_hod'::"text"])));



CREATE POLICY "spo_items_supplier_select" ON "public"."service_purchase_order_items" FOR SELECT TO "authenticated" USING ((("public"."get_my_app_role"() = ANY (ARRAY['supplier'::"text", 'vendor'::"text"])) AND ("spo_id" IN ( SELECT "service_purchase_orders"."id"
   FROM "public"."service_purchase_orders"
  WHERE ("service_purchase_orders"."vendor_id" IN ( SELECT "users"."supplier_id"
           FROM "public"."users"
          WHERE ("users"."id" = "auth"."uid"())))))));



CREATE POLICY "spo_supplier_select" ON "public"."service_purchase_orders" FOR SELECT TO "authenticated" USING ((("public"."get_my_app_role"() = ANY (ARRAY['supplier'::"text", 'vendor'::"text"])) AND ("vendor_id" IN ( SELECT "users"."supplier_id"
   FROM "public"."users"
  WHERE ("users"."id" = "auth"."uid"())))));



ALTER TABLE "public"."stock_batches" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "stock_batches_select_isolation" ON "public"."stock_batches" FOR SELECT TO "authenticated" USING (("warehouse_id" IN ( SELECT "warehouses"."id"
   FROM "public"."warehouses"
  WHERE ("warehouses"."society_id" IN ( SELECT "public"."get_my_managed_societies"() AS "get_my_managed_societies")))));



ALTER TABLE "public"."stock_transactions" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "stock_transactions_admin_storekeeper" ON "public"."stock_transactions" TO "authenticated" USING (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'storekeeper'::"text"]))) WITH CHECK (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'storekeeper'::"text"])));



CREATE POLICY "stock_transactions_select_buyer" ON "public"."stock_transactions" FOR SELECT TO "authenticated" USING (("public"."get_my_app_role"() = ANY (ARRAY['buyer'::"text", 'account'::"text", 'company_hod'::"text", 'site_supervisor'::"text"])));



ALTER TABLE "public"."storage_deletion_queue" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "storage_deletion_queue_block_direct" ON "public"."storage_deletion_queue" TO "authenticated" USING (false);



ALTER TABLE "public"."supplier_products" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."supplier_rates" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."suppliers" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "suppliers_admin_full" ON "public"."suppliers" TO "authenticated" USING (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'account'::"text", 'company_hod'::"text"]))) WITH CHECK (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'account'::"text", 'company_hod'::"text"])));



CREATE POLICY "suppliers_self_update" ON "public"."suppliers" FOR UPDATE TO "authenticated" USING (("id" IN ( SELECT "users"."supplier_id"
   FROM "public"."users"
  WHERE ("users"."id" = "auth"."uid"())))) WITH CHECK (("id" IN ( SELECT "users"."supplier_id"
   FROM "public"."users"
  WHERE ("users"."id" = "auth"."uid"()))));



CREATE POLICY "svc_ack_admin_supervisor" ON "public"."service_acknowledgments" TO "authenticated" USING (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'site_supervisor'::"text"]))) WITH CHECK (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'site_supervisor'::"text"])));



CREATE POLICY "svc_ack_supplier_select" ON "public"."service_acknowledgments" FOR SELECT TO "authenticated" USING ((("public"."get_my_app_role"() = ANY (ARRAY['supplier'::"text", 'vendor'::"text"])) AND ("spo_id" IN ( SELECT "service_purchase_orders"."id"
   FROM "public"."service_purchase_orders"
  WHERE ("service_purchase_orders"."vendor_id" IN ( SELECT "users"."supplier_id"
           FROM "public"."users"
          WHERE ("users"."id" = "auth"."uid"())))))));



ALTER TABLE "public"."system_config" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "system_config_permission_manage" ON "public"."system_config" TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM ("public"."users" "u"
     JOIN "public"."roles" "r" ON (("r"."id" = "u"."role_id")))
  WHERE (("u"."id" = "auth"."uid"()) AND ((("jsonb_typeof"(COALESCE("r"."permissions", '[]'::"jsonb")) = 'array'::"text") AND (COALESCE("r"."permissions", '[]'::"jsonb") @> '["platform.config.manage"]'::"jsonb")) OR (("jsonb_typeof"(COALESCE("r"."permissions", '{}'::"jsonb")) = 'object'::"text") AND (COALESCE(("r"."permissions" ->> 'platform.config.manage'::"text"), 'false'::"text") = 'true'::"text"))))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."users" "u"
     JOIN "public"."roles" "r" ON (("r"."id" = "u"."role_id")))
  WHERE (("u"."id" = "auth"."uid"()) AND ((("jsonb_typeof"(COALESCE("r"."permissions", '[]'::"jsonb")) = 'array'::"text") AND (COALESCE("r"."permissions", '[]'::"jsonb") @> '["platform.config.manage"]'::"jsonb")) OR (("jsonb_typeof"(COALESCE("r"."permissions", '{}'::"jsonb")) = 'object'::"text") AND (COALESCE(("r"."permissions" ->> 'platform.config.manage'::"text"), 'false'::"text") = 'true'::"text")))))));



CREATE POLICY "system_config_read_authenticated" ON "public"."system_config" FOR SELECT TO "authenticated" USING (true);



ALTER TABLE "public"."technician_profiles" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "technician_profiles_select_isolation" ON "public"."technician_profiles" FOR SELECT TO "authenticated" USING (((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"])) OR ("employee_id" IN ( SELECT "public"."get_employee_ids_in_managed_societies"() AS "get_employee_ids_in_managed_societies"))));



CREATE POLICY "user_select_isolation" ON "public"."users" FOR SELECT TO "authenticated" USING ((("id" = "auth"."uid"()) OR (("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"])) OR ("employee_id" IN ( SELECT "public"."get_employee_ids_in_managed_societies"() AS "get_employee_ids_in_managed_societies"))));



ALTER TABLE "public"."users" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "users_admin_insert_non_admin" ON "public"."users" FOR INSERT TO "authenticated" WITH CHECK ((("public"."get_my_app_role"() = 'admin'::"text") AND (COALESCE(( SELECT ("roles"."role_name")::"text" AS "role_name"
   FROM "public"."roles"
  WHERE ("roles"."id" = "users"."role_id")), ''::"text") <> ALL (ARRAY['admin'::"text", 'super_admin'::"text"]))));



CREATE POLICY "users_admin_update_non_admin" ON "public"."users" FOR UPDATE TO "authenticated" USING ((("public"."get_my_app_role"() = 'admin'::"text") AND (COALESCE(( SELECT ("roles"."role_name")::"text" AS "role_name"
   FROM "public"."roles"
  WHERE ("roles"."id" = "users"."role_id")), ''::"text") <> ALL (ARRAY['admin'::"text", 'super_admin'::"text"])))) WITH CHECK ((("public"."get_my_app_role"() = 'admin'::"text") AND (COALESCE(( SELECT ("roles"."role_name")::"text" AS "role_name"
   FROM "public"."roles"
  WHERE ("roles"."id" = "users"."role_id")), ''::"text") <> ALL (ARRAY['admin'::"text", 'super_admin'::"text"]))));



CREATE POLICY "users_select_authenticated" ON "public"."users" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "users_super_admin_manage" ON "public"."users" TO "authenticated" USING (("public"."get_my_app_role"() = 'super_admin'::"text")) WITH CHECK (("public"."get_my_app_role"() = 'super_admin'::"text"));



ALTER TABLE "public"."vendor_wise_services" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."visitor_bypass_audit" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "visitor_insert_isolation" ON "public"."visitors" FOR INSERT TO "authenticated" WITH CHECK (((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"])) OR ("flat_id" IN ( SELECT "f"."id"
   FROM ("public"."flats" "f"
     JOIN "public"."buildings" "b" ON (("f"."building_id" = "b"."id")))
  WHERE ("b"."society_id" IN ( SELECT "public"."get_my_managed_societies"() AS "get_my_managed_societies"))))));



ALTER TABLE "public"."visitor_photo_metadata" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "visitor_select_isolation" ON "public"."visitors" FOR SELECT TO "authenticated" USING (((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"])) OR ("flat_id" IN ( SELECT "f"."id"
   FROM ("public"."flats" "f"
     JOIN "public"."buildings" "b" ON (("f"."building_id" = "b"."id")))
  WHERE ("b"."society_id" IN ( SELECT "public"."get_my_managed_societies"() AS "get_my_managed_societies"))))));



CREATE POLICY "visitor_update_isolation" ON "public"."visitors" FOR UPDATE TO "authenticated" USING (((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"])) OR ("flat_id" IN ( SELECT "f"."id"
   FROM ("public"."flats" "f"
     JOIN "public"."buildings" "b" ON (("f"."building_id" = "b"."id")))
  WHERE ("b"."society_id" IN ( SELECT "public"."get_my_managed_societies"() AS "get_my_managed_societies")))))) WITH CHECK (((("public"."get_user_role"())::"text" = ANY (ARRAY['admin'::"text", 'super_admin'::"text"])) OR ("flat_id" IN ( SELECT "f"."id"
   FROM ("public"."flats" "f"
     JOIN "public"."buildings" "b" ON (("f"."building_id" = "b"."id")))
  WHERE ("b"."society_id" IN ( SELECT "public"."get_my_managed_societies"() AS "get_my_managed_societies"))))));



ALTER TABLE "public"."visitors" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "visitors_society_ops_update" ON "public"."visitors" FOR UPDATE TO "authenticated" USING (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'security_supervisor'::"text", 'society_manager'::"text"]))) WITH CHECK (("public"."get_my_app_role"() = ANY (ARRAY['admin'::"text", 'super_admin'::"text", 'security_supervisor'::"text", 'society_manager'::"text"])));



ALTER TABLE "public"."waitlist" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."warehouses" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "warehouses_select_isolation" ON "public"."warehouses" FOR SELECT TO "authenticated" USING (("society_id" IN ( SELECT "public"."get_my_managed_societies"() AS "get_my_managed_societies")));



ALTER TABLE "public"."work_master" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";






ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."audit_logs";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."personnel_dispatches";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."rtv_tickets";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."service_delivery_notes";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."visitors";






GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";






GRANT ALL ON FUNCTION "public"."gbtreekey16_in"("cstring") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey16_in"("cstring") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey16_in"("cstring") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey16_in"("cstring") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbtreekey16_out"("public"."gbtreekey16") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey16_out"("public"."gbtreekey16") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey16_out"("public"."gbtreekey16") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey16_out"("public"."gbtreekey16") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbtreekey2_in"("cstring") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey2_in"("cstring") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey2_in"("cstring") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey2_in"("cstring") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbtreekey2_out"("public"."gbtreekey2") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey2_out"("public"."gbtreekey2") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey2_out"("public"."gbtreekey2") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey2_out"("public"."gbtreekey2") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbtreekey32_in"("cstring") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey32_in"("cstring") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey32_in"("cstring") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey32_in"("cstring") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbtreekey32_out"("public"."gbtreekey32") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey32_out"("public"."gbtreekey32") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey32_out"("public"."gbtreekey32") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey32_out"("public"."gbtreekey32") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbtreekey4_in"("cstring") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey4_in"("cstring") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey4_in"("cstring") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey4_in"("cstring") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbtreekey4_out"("public"."gbtreekey4") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey4_out"("public"."gbtreekey4") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey4_out"("public"."gbtreekey4") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey4_out"("public"."gbtreekey4") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbtreekey8_in"("cstring") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey8_in"("cstring") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey8_in"("cstring") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey8_in"("cstring") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbtreekey8_out"("public"."gbtreekey8") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey8_out"("public"."gbtreekey8") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey8_out"("public"."gbtreekey8") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey8_out"("public"."gbtreekey8") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbtreekey_var_in"("cstring") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey_var_in"("cstring") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey_var_in"("cstring") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey_var_in"("cstring") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbtreekey_var_out"("public"."gbtreekey_var") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey_var_out"("public"."gbtreekey_var") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey_var_out"("public"."gbtreekey_var") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey_var_out"("public"."gbtreekey_var") TO "service_role";











































































































































































GRANT ALL ON FUNCTION "public"."acknowledge_mobile_panic_alert"("p_alert_id" "uuid", "p_notes" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."acknowledge_mobile_panic_alert"("p_alert_id" "uuid", "p_notes" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."acknowledge_mobile_panic_alert"("p_alert_id" "uuid", "p_notes" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."acknowledge_panic_alert"("p_alert_id" "uuid", "p_acknowledged_by" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."acknowledge_panic_alert"("p_alert_id" "uuid", "p_acknowledged_by" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."acknowledge_panic_alert"("p_alert_id" "uuid", "p_acknowledged_by" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."acknowledge_site_incident"("p_incident_id" "uuid", "p_supervisor_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."acknowledge_site_incident"("p_incident_id" "uuid", "p_supervisor_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."acknowledge_site_incident"("p_incident_id" "uuid", "p_supervisor_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."approve_leave_request"("p_leave_id" "uuid", "p_approver_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."approve_leave_request"("p_leave_id" "uuid", "p_approver_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."approve_leave_request"("p_leave_id" "uuid", "p_approver_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."approve_md_item"("p_item_id" "uuid", "p_approver_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."approve_md_item"("p_item_id" "uuid", "p_approver_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."approve_md_item"("p_item_id" "uuid", "p_approver_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."approve_visitor"("p_visitor_id" "uuid", "p_user_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."approve_visitor"("p_visitor_id" "uuid", "p_user_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."approve_visitor"("p_visitor_id" "uuid", "p_user_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."audit_payslip_changes"() TO "anon";
GRANT ALL ON FUNCTION "public"."audit_payslip_changes"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."audit_payslip_changes"() TO "service_role";



GRANT ALL ON FUNCTION "public"."audit_reconciliation_changes"() TO "anon";
GRANT ALL ON FUNCTION "public"."audit_reconciliation_changes"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."audit_reconciliation_changes"() TO "service_role";



GRANT ALL ON FUNCTION "public"."auto_exit_stale_visitors"() TO "anon";
GRANT ALL ON FUNCTION "public"."auto_exit_stale_visitors"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."auto_exit_stale_visitors"() TO "service_role";



GRANT ALL ON FUNCTION "public"."auto_punch_out_idle_employees"() TO "anon";
GRANT ALL ON FUNCTION "public"."auto_punch_out_idle_employees"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."auto_punch_out_idle_employees"() TO "service_role";



GRANT ALL ON FUNCTION "public"."block_expired_chemical_issuance"() TO "anon";
GRANT ALL ON FUNCTION "public"."block_expired_chemical_issuance"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."block_expired_chemical_issuance"() TO "service_role";



GRANT ALL ON FUNCTION "public"."bytea_to_text"("data" "bytea") TO "postgres";
GRANT ALL ON FUNCTION "public"."bytea_to_text"("data" "bytea") TO "anon";
GRANT ALL ON FUNCTION "public"."bytea_to_text"("data" "bytea") TO "authenticated";
GRANT ALL ON FUNCTION "public"."bytea_to_text"("data" "bytea") TO "service_role";



GRANT ALL ON FUNCTION "public"."calculate_employee_salary"("p_employee_id" "uuid", "p_period_start" "date", "p_period_end" "date", "p_total_working_days" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."calculate_employee_salary"("p_employee_id" "uuid", "p_period_start" "date", "p_period_end" "date", "p_total_working_days" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."calculate_employee_salary"("p_employee_id" "uuid", "p_period_start" "date", "p_period_end" "date", "p_total_working_days" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."cash_dist"("money", "money") TO "postgres";
GRANT ALL ON FUNCTION "public"."cash_dist"("money", "money") TO "anon";
GRANT ALL ON FUNCTION "public"."cash_dist"("money", "money") TO "authenticated";
GRANT ALL ON FUNCTION "public"."cash_dist"("money", "money") TO "service_role";



GRANT ALL ON FUNCTION "public"."check_all_ppe_items"("checklist" "jsonb") TO "anon";
GRANT ALL ON FUNCTION "public"."check_all_ppe_items"("checklist" "jsonb") TO "authenticated";
GRANT ALL ON FUNCTION "public"."check_all_ppe_items"("checklist" "jsonb") TO "service_role";



GRANT ALL ON FUNCTION "public"."check_budget_threshold"() TO "anon";
GRANT ALL ON FUNCTION "public"."check_budget_threshold"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."check_budget_threshold"() TO "service_role";



GRANT ALL ON FUNCTION "public"."check_compliance"() TO "anon";
GRANT ALL ON FUNCTION "public"."check_compliance"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."check_compliance"() TO "service_role";



GRANT ALL ON FUNCTION "public"."check_finance_closure"() TO "anon";
GRANT ALL ON FUNCTION "public"."check_finance_closure"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."check_finance_closure"() TO "service_role";



GRANT ALL ON FUNCTION "public"."check_geofence"("p_lat" double precision, "p_lng" double precision, "p_site_lat" double precision, "p_site_lng" double precision, "p_radius_meters" double precision) TO "anon";
GRANT ALL ON FUNCTION "public"."check_geofence"("p_lat" double precision, "p_lng" double precision, "p_site_lat" double precision, "p_site_lng" double precision, "p_radius_meters" double precision) TO "authenticated";
GRANT ALL ON FUNCTION "public"."check_geofence"("p_lat" double precision, "p_lng" double precision, "p_site_lat" double precision, "p_site_lng" double precision, "p_radius_meters" double precision) TO "service_role";



GRANT ALL ON FUNCTION "public"."check_grn_item_quality"() TO "anon";
GRANT ALL ON FUNCTION "public"."check_grn_item_quality"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."check_grn_item_quality"() TO "service_role";



GRANT ALL ON FUNCTION "public"."check_rate_before_forward"() TO "anon";
GRANT ALL ON FUNCTION "public"."check_rate_before_forward"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."check_rate_before_forward"() TO "service_role";



GRANT ALL ON FUNCTION "public"."check_service_acknowledgment_gate"() TO "anon";
GRANT ALL ON FUNCTION "public"."check_service_acknowledgment_gate"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."check_service_acknowledgment_gate"() TO "service_role";



GRANT ALL ON FUNCTION "public"."check_visitor_immutability"() TO "anon";
GRANT ALL ON FUNCTION "public"."check_visitor_immutability"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."check_visitor_immutability"() TO "service_role";



GRANT ALL ON FUNCTION "public"."checkout_visitor"("p_visitor_id" "uuid", "p_user_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."checkout_visitor"("p_visitor_id" "uuid", "p_user_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."checkout_visitor"("p_visitor_id" "uuid", "p_user_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."complete_service_task"("p_request_id" "uuid", "p_after_photo_url" "text", "p_completion_notes" "text", "p_signature_url" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."complete_service_task"("p_request_id" "uuid", "p_after_photo_url" "text", "p_completion_notes" "text", "p_signature_url" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."complete_service_task"("p_request_id" "uuid", "p_after_photo_url" "text", "p_completion_notes" "text", "p_signature_url" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."create_behavior_ticket"("p_subject_name" "text", "p_category" "text", "p_severity" "text", "p_note" "text", "p_evidence_urls" "jsonb", "p_location_name" "text", "p_linked_employee_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."create_behavior_ticket"("p_subject_name" "text", "p_category" "text", "p_severity" "text", "p_note" "text", "p_evidence_urls" "jsonb", "p_location_name" "text", "p_linked_employee_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_behavior_ticket"("p_subject_name" "text", "p_category" "text", "p_severity" "text", "p_note" "text", "p_evidence_urls" "jsonb", "p_location_name" "text", "p_linked_employee_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."create_material_ticket"("p_subject_name" "text", "p_category" "text", "p_note" "text", "p_material_issue_type" "text", "p_severity" "text", "p_batch_number" "text", "p_ordered_quantity" numeric, "p_received_quantity" numeric, "p_return_quantity" numeric, "p_evidence_urls" "jsonb", "p_location_name" "text", "p_source_visitor_id" "uuid", "p_inspection_outcome" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."create_material_ticket"("p_subject_name" "text", "p_category" "text", "p_note" "text", "p_material_issue_type" "text", "p_severity" "text", "p_batch_number" "text", "p_ordered_quantity" numeric, "p_received_quantity" numeric, "p_return_quantity" numeric, "p_evidence_urls" "jsonb", "p_location_name" "text", "p_source_visitor_id" "uuid", "p_inspection_outcome" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_material_ticket"("p_subject_name" "text", "p_category" "text", "p_note" "text", "p_material_issue_type" "text", "p_severity" "text", "p_batch_number" "text", "p_ordered_quantity" numeric, "p_received_quantity" numeric, "p_return_quantity" numeric, "p_evidence_urls" "jsonb", "p_location_name" "text", "p_source_visitor_id" "uuid", "p_inspection_outcome" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."create_mobile_visitor"("p_visitor_name" "text", "p_phone" "text", "p_purpose" "text", "p_flat_id" "uuid", "p_vehicle_number" "text", "p_photo_url" "text", "p_is_frequent_visitor" boolean) TO "anon";
GRANT ALL ON FUNCTION "public"."create_mobile_visitor"("p_visitor_name" "text", "p_phone" "text", "p_purpose" "text", "p_flat_id" "uuid", "p_vehicle_number" "text", "p_photo_url" "text", "p_is_frequent_visitor" boolean) TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_mobile_visitor"("p_visitor_name" "text", "p_phone" "text", "p_purpose" "text", "p_flat_id" "uuid", "p_vehicle_number" "text", "p_photo_url" "text", "p_is_frequent_visitor" boolean) TO "service_role";



GRANT ALL ON FUNCTION "public"."create_mobile_visitor"("p_visitor_name" "text", "p_phone" "text", "p_purpose" "text", "p_flat_id" "uuid", "p_vehicle_number" "text", "p_photo_url" "text", "p_is_frequent_visitor" boolean, "p_visitor_type" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."create_mobile_visitor"("p_visitor_name" "text", "p_phone" "text", "p_purpose" "text", "p_flat_id" "uuid", "p_vehicle_number" "text", "p_photo_url" "text", "p_is_frequent_visitor" boolean, "p_visitor_type" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_mobile_visitor"("p_visitor_name" "text", "p_phone" "text", "p_purpose" "text", "p_flat_id" "uuid", "p_vehicle_number" "text", "p_photo_url" "text", "p_is_frequent_visitor" boolean, "p_visitor_type" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."create_po_from_supplier_request"("p_request_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."create_po_from_supplier_request"("p_request_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_po_from_supplier_request"("p_request_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."create_qr_for_asset"() TO "anon";
GRANT ALL ON FUNCTION "public"."create_qr_for_asset"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_qr_for_asset"() TO "service_role";



GRANT ALL ON FUNCTION "public"."create_resident_invited_visitor"("p_visitor_name" "text", "p_visitor_type" "text", "p_phone" "text", "p_purpose" "text", "p_vehicle_number" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."create_resident_invited_visitor"("p_visitor_name" "text", "p_visitor_type" "text", "p_phone" "text", "p_purpose" "text", "p_vehicle_number" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_resident_invited_visitor"("p_visitor_name" "text", "p_visitor_type" "text", "p_phone" "text", "p_purpose" "text", "p_vehicle_number" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."date_dist"("date", "date") TO "postgres";
GRANT ALL ON FUNCTION "public"."date_dist"("date", "date") TO "anon";
GRANT ALL ON FUNCTION "public"."date_dist"("date", "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."date_dist"("date", "date") TO "service_role";



GRANT ALL ON FUNCTION "public"."deduct_stock_on_material_use"() TO "anon";
GRANT ALL ON FUNCTION "public"."deduct_stock_on_material_use"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."deduct_stock_on_material_use"() TO "service_role";



GRANT ALL ON FUNCTION "public"."deny_visitor"("p_visitor_id" "uuid", "p_user_id" "uuid", "p_reason" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."deny_visitor"("p_visitor_id" "uuid", "p_user_id" "uuid", "p_reason" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."deny_visitor"("p_visitor_id" "uuid", "p_user_id" "uuid", "p_reason" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."detect_expiring_items"("p_days_ahead" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."detect_expiring_items"("p_days_ahead" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."detect_expiring_items"("p_days_ahead" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."detect_geofence_breaches"() TO "anon";
GRANT ALL ON FUNCTION "public"."detect_geofence_breaches"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."detect_geofence_breaches"() TO "service_role";



GRANT ALL ON FUNCTION "public"."detect_inactive_guards"("p_threshold_minutes" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."detect_inactive_guards"("p_threshold_minutes" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."detect_inactive_guards"("p_threshold_minutes" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."detect_incomplete_checklists"() TO "anon";
GRANT ALL ON FUNCTION "public"."detect_incomplete_checklists"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."detect_incomplete_checklists"() TO "service_role";



GRANT ALL ON FUNCTION "public"."detect_incomplete_checklists"("p_completion_threshold" numeric, "p_only_past_midpoint" boolean) TO "anon";
GRANT ALL ON FUNCTION "public"."detect_incomplete_checklists"("p_completion_threshold" numeric, "p_only_past_midpoint" boolean) TO "authenticated";
GRANT ALL ON FUNCTION "public"."detect_incomplete_checklists"("p_completion_threshold" numeric, "p_only_past_midpoint" boolean) TO "service_role";



GRANT ALL ON FUNCTION "public"."detect_stationary_guards"() TO "anon";
GRANT ALL ON FUNCTION "public"."detect_stationary_guards"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."detect_stationary_guards"() TO "service_role";



GRANT ALL ON FUNCTION "public"."enforce_feedback_before_close"() TO "anon";
GRANT ALL ON FUNCTION "public"."enforce_feedback_before_close"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."enforce_feedback_before_close"() TO "service_role";



GRANT ALL ON FUNCTION "public"."enforce_pest_control_ppe"() TO "anon";
GRANT ALL ON FUNCTION "public"."enforce_pest_control_ppe"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."enforce_pest_control_ppe"() TO "service_role";



GRANT ALL ON FUNCTION "public"."enforce_request_status_transition"() TO "anon";
GRANT ALL ON FUNCTION "public"."enforce_request_status_transition"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."enforce_request_status_transition"() TO "service_role";



GRANT ALL ON FUNCTION "public"."enforce_service_completion_evidence"() TO "anon";
GRANT ALL ON FUNCTION "public"."enforce_service_completion_evidence"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."enforce_service_completion_evidence"() TO "service_role";



GRANT ALL ON FUNCTION "public"."execute_reconciliation_match"("p_reconciliation_id" "uuid", "p_user_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."execute_reconciliation_match"("p_reconciliation_id" "uuid", "p_user_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."execute_reconciliation_match"("p_reconciliation_id" "uuid", "p_user_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."expire_mobile_visitor_decisions"() TO "anon";
GRANT ALL ON FUNCTION "public"."expire_mobile_visitor_decisions"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."expire_mobile_visitor_decisions"() TO "service_role";



GRANT ALL ON FUNCTION "public"."float4_dist"(real, real) TO "postgres";
GRANT ALL ON FUNCTION "public"."float4_dist"(real, real) TO "anon";
GRANT ALL ON FUNCTION "public"."float4_dist"(real, real) TO "authenticated";
GRANT ALL ON FUNCTION "public"."float4_dist"(real, real) TO "service_role";



GRANT ALL ON FUNCTION "public"."float8_dist"(double precision, double precision) TO "postgres";
GRANT ALL ON FUNCTION "public"."float8_dist"(double precision, double precision) TO "anon";
GRANT ALL ON FUNCTION "public"."float8_dist"(double precision, double precision) TO "authenticated";
GRANT ALL ON FUNCTION "public"."float8_dist"(double precision, double precision) TO "service_role";



GRANT ALL ON FUNCTION "public"."force_match_bill"("p_bill_id" "uuid", "p_reason" "text", "p_evidence_url" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."force_match_bill"("p_bill_id" "uuid", "p_reason" "text", "p_evidence_url" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."force_match_bill"("p_bill_id" "uuid", "p_reason" "text", "p_evidence_url" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bit_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bit_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bit_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bit_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bit_consistent"("internal", bit, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bit_consistent"("internal", bit, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bit_consistent"("internal", bit, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bit_consistent"("internal", bit, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bit_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bit_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bit_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bit_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bit_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bit_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bit_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bit_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bit_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bit_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bit_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bit_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bit_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bit_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bit_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bit_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bool_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bool_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bool_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bool_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bool_consistent"("internal", boolean, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bool_consistent"("internal", boolean, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bool_consistent"("internal", boolean, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bool_consistent"("internal", boolean, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bool_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bool_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bool_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bool_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bool_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bool_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bool_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bool_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bool_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bool_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bool_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bool_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bool_same"("public"."gbtreekey2", "public"."gbtreekey2", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bool_same"("public"."gbtreekey2", "public"."gbtreekey2", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bool_same"("public"."gbtreekey2", "public"."gbtreekey2", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bool_same"("public"."gbtreekey2", "public"."gbtreekey2", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bool_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bool_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bool_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bool_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bpchar_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bpchar_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bpchar_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bpchar_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bpchar_consistent"("internal", character, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bpchar_consistent"("internal", character, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bpchar_consistent"("internal", character, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bpchar_consistent"("internal", character, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bytea_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bytea_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bytea_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bytea_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bytea_consistent"("internal", "bytea", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bytea_consistent"("internal", "bytea", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bytea_consistent"("internal", "bytea", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bytea_consistent"("internal", "bytea", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bytea_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bytea_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bytea_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bytea_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bytea_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bytea_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bytea_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bytea_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bytea_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bytea_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bytea_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bytea_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bytea_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bytea_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bytea_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bytea_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_cash_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_cash_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_cash_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_cash_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_cash_consistent"("internal", "money", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_cash_consistent"("internal", "money", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_cash_consistent"("internal", "money", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_cash_consistent"("internal", "money", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_cash_distance"("internal", "money", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_cash_distance"("internal", "money", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_cash_distance"("internal", "money", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_cash_distance"("internal", "money", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_cash_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_cash_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_cash_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_cash_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_cash_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_cash_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_cash_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_cash_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_cash_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_cash_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_cash_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_cash_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_cash_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_cash_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_cash_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_cash_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_cash_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_cash_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_cash_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_cash_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_date_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_date_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_date_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_date_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_date_consistent"("internal", "date", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_date_consistent"("internal", "date", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_date_consistent"("internal", "date", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_date_consistent"("internal", "date", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_date_distance"("internal", "date", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_date_distance"("internal", "date", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_date_distance"("internal", "date", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_date_distance"("internal", "date", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_date_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_date_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_date_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_date_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_date_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_date_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_date_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_date_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_date_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_date_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_date_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_date_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_date_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_date_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_date_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_date_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_date_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_date_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_date_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_date_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_decompress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_decompress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_decompress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_decompress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_enum_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_enum_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_enum_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_enum_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_enum_consistent"("internal", "anyenum", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_enum_consistent"("internal", "anyenum", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_enum_consistent"("internal", "anyenum", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_enum_consistent"("internal", "anyenum", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_enum_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_enum_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_enum_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_enum_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_enum_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_enum_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_enum_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_enum_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_enum_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_enum_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_enum_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_enum_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_enum_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_enum_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_enum_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_enum_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_enum_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_enum_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_enum_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_enum_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float4_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float4_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float4_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float4_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float4_consistent"("internal", real, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float4_consistent"("internal", real, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float4_consistent"("internal", real, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float4_consistent"("internal", real, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float4_distance"("internal", real, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float4_distance"("internal", real, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float4_distance"("internal", real, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float4_distance"("internal", real, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float4_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float4_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float4_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float4_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float4_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float4_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float4_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float4_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float4_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float4_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float4_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float4_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float4_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float4_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float4_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float4_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float4_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float4_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float4_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float4_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float8_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float8_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float8_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float8_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float8_consistent"("internal", double precision, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float8_consistent"("internal", double precision, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float8_consistent"("internal", double precision, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float8_consistent"("internal", double precision, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float8_distance"("internal", double precision, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float8_distance"("internal", double precision, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float8_distance"("internal", double precision, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float8_distance"("internal", double precision, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float8_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float8_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float8_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float8_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float8_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float8_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float8_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float8_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float8_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float8_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float8_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float8_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float8_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float8_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float8_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float8_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_inet_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_inet_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_inet_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_inet_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_inet_consistent"("internal", "inet", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_inet_consistent"("internal", "inet", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_inet_consistent"("internal", "inet", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_inet_consistent"("internal", "inet", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_inet_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_inet_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_inet_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_inet_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_inet_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_inet_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_inet_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_inet_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_inet_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_inet_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_inet_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_inet_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_inet_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_inet_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_inet_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_inet_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int2_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int2_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int2_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int2_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int2_consistent"("internal", smallint, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int2_consistent"("internal", smallint, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int2_consistent"("internal", smallint, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int2_consistent"("internal", smallint, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int2_distance"("internal", smallint, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int2_distance"("internal", smallint, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int2_distance"("internal", smallint, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int2_distance"("internal", smallint, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int2_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int2_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int2_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int2_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int2_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int2_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int2_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int2_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int2_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int2_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int2_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int2_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int2_same"("public"."gbtreekey4", "public"."gbtreekey4", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int2_same"("public"."gbtreekey4", "public"."gbtreekey4", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int2_same"("public"."gbtreekey4", "public"."gbtreekey4", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int2_same"("public"."gbtreekey4", "public"."gbtreekey4", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int2_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int2_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int2_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int2_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int4_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int4_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int4_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int4_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int4_consistent"("internal", integer, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int4_consistent"("internal", integer, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int4_consistent"("internal", integer, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int4_consistent"("internal", integer, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int4_distance"("internal", integer, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int4_distance"("internal", integer, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int4_distance"("internal", integer, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int4_distance"("internal", integer, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int4_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int4_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int4_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int4_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int4_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int4_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int4_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int4_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int4_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int4_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int4_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int4_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int4_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int4_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int4_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int4_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int4_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int4_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int4_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int4_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int8_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int8_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int8_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int8_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int8_consistent"("internal", bigint, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int8_consistent"("internal", bigint, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int8_consistent"("internal", bigint, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int8_consistent"("internal", bigint, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int8_distance"("internal", bigint, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int8_distance"("internal", bigint, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int8_distance"("internal", bigint, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int8_distance"("internal", bigint, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int8_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int8_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int8_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int8_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int8_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int8_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int8_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int8_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int8_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int8_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int8_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int8_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int8_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int8_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int8_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int8_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_intv_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_intv_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_intv_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_intv_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_intv_consistent"("internal", interval, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_intv_consistent"("internal", interval, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_intv_consistent"("internal", interval, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_intv_consistent"("internal", interval, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_intv_decompress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_intv_decompress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_intv_decompress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_intv_decompress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_intv_distance"("internal", interval, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_intv_distance"("internal", interval, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_intv_distance"("internal", interval, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_intv_distance"("internal", interval, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_intv_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_intv_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_intv_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_intv_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_intv_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_intv_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_intv_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_intv_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_intv_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_intv_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_intv_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_intv_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_intv_same"("public"."gbtreekey32", "public"."gbtreekey32", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_intv_same"("public"."gbtreekey32", "public"."gbtreekey32", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_intv_same"("public"."gbtreekey32", "public"."gbtreekey32", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_intv_same"("public"."gbtreekey32", "public"."gbtreekey32", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_intv_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_intv_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_intv_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_intv_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad8_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad8_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad8_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad8_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad8_consistent"("internal", "macaddr8", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad8_consistent"("internal", "macaddr8", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad8_consistent"("internal", "macaddr8", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad8_consistent"("internal", "macaddr8", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad8_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad8_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad8_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad8_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad8_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad8_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad8_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad8_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad8_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad8_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad8_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad8_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad8_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad8_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad8_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad8_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad_consistent"("internal", "macaddr", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad_consistent"("internal", "macaddr", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad_consistent"("internal", "macaddr", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad_consistent"("internal", "macaddr", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_numeric_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_numeric_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_numeric_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_numeric_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_numeric_consistent"("internal", numeric, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_numeric_consistent"("internal", numeric, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_numeric_consistent"("internal", numeric, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_numeric_consistent"("internal", numeric, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_numeric_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_numeric_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_numeric_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_numeric_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_numeric_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_numeric_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_numeric_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_numeric_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_numeric_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_numeric_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_numeric_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_numeric_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_numeric_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_numeric_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_numeric_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_numeric_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_oid_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_oid_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_oid_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_oid_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_oid_consistent"("internal", "oid", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_oid_consistent"("internal", "oid", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_oid_consistent"("internal", "oid", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_oid_consistent"("internal", "oid", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_oid_distance"("internal", "oid", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_oid_distance"("internal", "oid", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_oid_distance"("internal", "oid", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_oid_distance"("internal", "oid", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_oid_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_oid_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_oid_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_oid_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_oid_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_oid_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_oid_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_oid_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_oid_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_oid_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_oid_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_oid_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_oid_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_oid_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_oid_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_oid_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_oid_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_oid_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_oid_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_oid_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_text_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_text_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_text_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_text_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_text_consistent"("internal", "text", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_text_consistent"("internal", "text", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_text_consistent"("internal", "text", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_text_consistent"("internal", "text", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_text_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_text_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_text_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_text_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_text_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_text_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_text_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_text_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_text_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_text_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_text_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_text_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_text_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_text_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_text_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_text_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_time_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_time_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_time_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_time_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_time_consistent"("internal", time without time zone, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_time_consistent"("internal", time without time zone, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_time_consistent"("internal", time without time zone, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_time_consistent"("internal", time without time zone, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_time_distance"("internal", time without time zone, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_time_distance"("internal", time without time zone, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_time_distance"("internal", time without time zone, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_time_distance"("internal", time without time zone, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_time_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_time_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_time_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_time_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_time_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_time_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_time_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_time_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_time_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_time_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_time_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_time_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_time_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_time_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_time_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_time_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_time_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_time_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_time_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_time_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_timetz_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_timetz_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_timetz_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_timetz_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_timetz_consistent"("internal", time with time zone, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_timetz_consistent"("internal", time with time zone, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_timetz_consistent"("internal", time with time zone, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_timetz_consistent"("internal", time with time zone, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_ts_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_ts_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_ts_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_ts_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_ts_consistent"("internal", timestamp without time zone, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_ts_consistent"("internal", timestamp without time zone, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_ts_consistent"("internal", timestamp without time zone, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_ts_consistent"("internal", timestamp without time zone, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_ts_distance"("internal", timestamp without time zone, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_ts_distance"("internal", timestamp without time zone, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_ts_distance"("internal", timestamp without time zone, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_ts_distance"("internal", timestamp without time zone, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_ts_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_ts_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_ts_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_ts_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_ts_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_ts_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_ts_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_ts_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_ts_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_ts_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_ts_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_ts_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_ts_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_ts_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_ts_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_ts_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_ts_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_ts_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_ts_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_ts_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_tstz_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_tstz_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_tstz_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_tstz_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_tstz_consistent"("internal", timestamp with time zone, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_tstz_consistent"("internal", timestamp with time zone, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_tstz_consistent"("internal", timestamp with time zone, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_tstz_consistent"("internal", timestamp with time zone, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_tstz_distance"("internal", timestamp with time zone, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_tstz_distance"("internal", timestamp with time zone, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_tstz_distance"("internal", timestamp with time zone, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_tstz_distance"("internal", timestamp with time zone, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_uuid_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_uuid_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_uuid_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_uuid_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_uuid_consistent"("internal", "uuid", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_uuid_consistent"("internal", "uuid", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_uuid_consistent"("internal", "uuid", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_uuid_consistent"("internal", "uuid", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_uuid_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_uuid_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_uuid_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_uuid_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_uuid_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_uuid_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_uuid_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_uuid_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_uuid_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_uuid_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_uuid_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_uuid_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_uuid_same"("public"."gbtreekey32", "public"."gbtreekey32", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_uuid_same"("public"."gbtreekey32", "public"."gbtreekey32", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_uuid_same"("public"."gbtreekey32", "public"."gbtreekey32", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_uuid_same"("public"."gbtreekey32", "public"."gbtreekey32", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_uuid_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_uuid_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_uuid_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_uuid_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_var_decompress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_var_decompress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_var_decompress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_var_decompress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_var_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_var_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_var_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_var_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."generate_ad_booking_number"() TO "anon";
GRANT ALL ON FUNCTION "public"."generate_ad_booking_number"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."generate_ad_booking_number"() TO "service_role";



GRANT ALL ON FUNCTION "public"."generate_asset_code"() TO "anon";
GRANT ALL ON FUNCTION "public"."generate_asset_code"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."generate_asset_code"() TO "service_role";



GRANT ALL ON FUNCTION "public"."generate_behavior_ticket_number"() TO "anon";
GRANT ALL ON FUNCTION "public"."generate_behavior_ticket_number"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."generate_behavior_ticket_number"() TO "service_role";



GRANT ALL ON FUNCTION "public"."generate_bill_number"() TO "anon";
GRANT ALL ON FUNCTION "public"."generate_bill_number"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."generate_bill_number"() TO "service_role";



GRANT ALL ON FUNCTION "public"."generate_bill_number_trigger"() TO "anon";
GRANT ALL ON FUNCTION "public"."generate_bill_number_trigger"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."generate_bill_number_trigger"() TO "service_role";



GRANT ALL ON FUNCTION "public"."generate_budget_code"() TO "anon";
GRANT ALL ON FUNCTION "public"."generate_budget_code"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."generate_budget_code"() TO "service_role";



GRANT ALL ON FUNCTION "public"."generate_candidate_code"() TO "anon";
GRANT ALL ON FUNCTION "public"."generate_candidate_code"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."generate_candidate_code"() TO "service_role";



GRANT ALL ON FUNCTION "public"."generate_daily_compliance_snapshot"() TO "anon";
GRANT ALL ON FUNCTION "public"."generate_daily_compliance_snapshot"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."generate_daily_compliance_snapshot"() TO "service_role";



GRANT ALL ON FUNCTION "public"."generate_delivery_note_number"() TO "anon";
GRANT ALL ON FUNCTION "public"."generate_delivery_note_number"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."generate_delivery_note_number"() TO "service_role";



GRANT ALL ON FUNCTION "public"."generate_dispatch_number"() TO "anon";
GRANT ALL ON FUNCTION "public"."generate_dispatch_number"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."generate_dispatch_number"() TO "service_role";



GRANT ALL ON FUNCTION "public"."generate_document_code"() TO "anon";
GRANT ALL ON FUNCTION "public"."generate_document_code"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."generate_document_code"() TO "service_role";



GRANT ALL ON FUNCTION "public"."generate_grn_number"() TO "anon";
GRANT ALL ON FUNCTION "public"."generate_grn_number"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."generate_grn_number"() TO "service_role";



GRANT ALL ON FUNCTION "public"."generate_indent_number"() TO "anon";
GRANT ALL ON FUNCTION "public"."generate_indent_number"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."generate_indent_number"() TO "service_role";



GRANT ALL ON FUNCTION "public"."generate_oversight_ticket_number"() TO "anon";
GRANT ALL ON FUNCTION "public"."generate_oversight_ticket_number"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."generate_oversight_ticket_number"() TO "service_role";



GRANT ALL ON FUNCTION "public"."generate_payment_number"() TO "anon";
GRANT ALL ON FUNCTION "public"."generate_payment_number"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."generate_payment_number"() TO "service_role";



GRANT ALL ON FUNCTION "public"."generate_payroll_cycle"("p_cycle_id" "uuid", "p_user_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."generate_payroll_cycle"("p_cycle_id" "uuid", "p_user_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."generate_payroll_cycle"("p_cycle_id" "uuid", "p_user_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."generate_payslip_number"() TO "anon";
GRANT ALL ON FUNCTION "public"."generate_payslip_number"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."generate_payslip_number"() TO "service_role";



GRANT ALL ON FUNCTION "public"."generate_po_number"() TO "anon";
GRANT ALL ON FUNCTION "public"."generate_po_number"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."generate_po_number"() TO "service_role";



GRANT ALL ON FUNCTION "public"."generate_reconciliation_number"() TO "anon";
GRANT ALL ON FUNCTION "public"."generate_reconciliation_number"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."generate_reconciliation_number"() TO "service_role";



GRANT ALL ON FUNCTION "public"."generate_request_number"() TO "anon";
GRANT ALL ON FUNCTION "public"."generate_request_number"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."generate_request_number"() TO "service_role";



GRANT ALL ON FUNCTION "public"."generate_sale_invoice_number"() TO "anon";
GRANT ALL ON FUNCTION "public"."generate_sale_invoice_number"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."generate_sale_invoice_number"() TO "service_role";



GRANT ALL ON FUNCTION "public"."generate_service_purchase_order_number"() TO "anon";
GRANT ALL ON FUNCTION "public"."generate_service_purchase_order_number"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."generate_service_purchase_order_number"() TO "service_role";



GRANT ALL ON FUNCTION "public"."generate_service_request_number"() TO "anon";
GRANT ALL ON FUNCTION "public"."generate_service_request_number"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."generate_service_request_number"() TO "service_role";



GRANT ALL ON FUNCTION "public"."generate_shortage_note_number"() TO "anon";
GRANT ALL ON FUNCTION "public"."generate_shortage_note_number"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."generate_shortage_note_number"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_account_finance_summary"("p_company_id" "uuid", "p_user_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_account_finance_summary"("p_company_id" "uuid", "p_user_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_account_finance_summary"("p_company_id" "uuid", "p_user_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_active_panic_alerts"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_active_panic_alerts"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_active_panic_alerts"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_admin_dashboard_summary"("p_user_id" "uuid", "p_company_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_admin_dashboard_summary"("p_user_id" "uuid", "p_company_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_admin_dashboard_summary"("p_user_id" "uuid", "p_company_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_all_companies_health"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_all_companies_health"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_all_companies_health"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_clocked_in_guards"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_clocked_in_guards"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_clocked_in_guards"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_employee_id"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_employee_id"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_employee_id"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_employee_ids_in_managed_societies"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_employee_ids_in_managed_societies"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_employee_ids_in_managed_societies"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_expiring_chemicals"("p_days_ahead" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."get_expiring_chemicals"("p_days_ahead" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_expiring_chemicals"("p_days_ahead" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."get_guard_checklist_completion"("p_guard_id" "uuid", "p_checklist_date" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."get_guard_checklist_completion"("p_guard_id" "uuid", "p_checklist_date" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_guard_checklist_completion"("p_guard_id" "uuid", "p_checklist_date" "date") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_guard_checklist_items"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_guard_checklist_items"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_guard_checklist_items"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_guard_emergency_contacts"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_guard_emergency_contacts"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_guard_emergency_contacts"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_guard_id"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_guard_id"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_guard_id"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_guard_last_position"("p_guard_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_guard_last_position"("p_guard_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_guard_last_position"("p_guard_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_guard_location_history"("p_guard_id" "uuid", "p_hours_back" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."get_guard_location_history"("p_guard_id" "uuid", "p_hours_back" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_guard_location_history"("p_guard_id" "uuid", "p_hours_back" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."get_guard_movement_variance"("p_guard_id" "uuid", "p_duration_minutes" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."get_guard_movement_variance"("p_guard_id" "uuid", "p_duration_minutes" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_guard_movement_variance"("p_guard_id" "uuid", "p_duration_minutes" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."get_guard_roster"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_guard_roster"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_guard_roster"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_guard_visitors"("p_include_checked_out" boolean) TO "anon";
GRANT ALL ON FUNCTION "public"."get_guard_visitors"("p_include_checked_out" boolean) TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_guard_visitors"("p_include_checked_out" boolean) TO "service_role";



GRANT ALL ON FUNCTION "public"."get_hod_leave_requests"("p_user_id" "uuid", "p_company_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_hod_leave_requests"("p_user_id" "uuid", "p_company_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_hod_leave_requests"("p_user_id" "uuid", "p_company_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_hod_summary"("p_user_id" "uuid", "p_company_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_hod_summary"("p_user_id" "uuid", "p_company_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_hod_summary"("p_user_id" "uuid", "p_company_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_hod_team_members"("p_user_id" "uuid", "p_company_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_hod_team_members"("p_user_id" "uuid", "p_company_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_hod_team_members"("p_user_id" "uuid", "p_company_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_md_approval_queue"("p_user_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_md_approval_queue"("p_user_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_md_approval_queue"("p_user_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_md_executive_summary"("p_user_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_md_executive_summary"("p_user_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_md_executive_summary"("p_user_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_mobile_oversight_tickets"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_mobile_oversight_tickets"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_mobile_oversight_tickets"() TO "service_role";



REVOKE ALL ON FUNCTION "public"."get_my_app_role"() FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."get_my_app_role"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_my_app_role"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_my_app_role"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_my_managed_societies"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_my_managed_societies"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_my_managed_societies"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_next_rtv_number"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_next_rtv_number"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_next_rtv_number"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_oversight_alert_feed"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_oversight_alert_feed"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_oversight_alert_feed"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_oversight_attendance_log"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_oversight_attendance_log"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_oversight_attendance_log"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_oversight_live_guards"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_oversight_live_guards"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_oversight_live_guards"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_oversight_visitor_stats"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_oversight_visitor_stats"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_oversight_visitor_stats"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_panic_alert_status"("p_alert_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_panic_alert_status"("p_alert_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_panic_alert_status"("p_alert_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_pending_grns"("p_user_id" "uuid", "p_company_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_pending_grns"("p_user_id" "uuid", "p_company_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_pending_grns"("p_user_id" "uuid", "p_company_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_pending_material_delivery_events"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_pending_material_delivery_events"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_pending_material_delivery_events"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_qr_batch_statistics"("p_society_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_qr_batch_statistics"("p_society_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_qr_batch_statistics"("p_society_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_resident_id"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_resident_id"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_resident_id"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_resident_pending_visitors"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_resident_pending_visitors"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_resident_pending_visitors"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_shift_checklist_items"("p_shift_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_shift_checklist_items"("p_shift_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_shift_checklist_items"("p_shift_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_shift_time_info"("p_shift_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_shift_time_info"("p_shift_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_shift_time_info"("p_shift_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_site_incidents"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_site_incidents"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_site_incidents"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_site_supervisor_summary"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_site_supervisor_summary"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_site_supervisor_summary"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_stock_alerts"("p_user_id" "uuid", "p_company_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_stock_alerts"("p_user_id" "uuid", "p_company_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_stock_alerts"("p_user_id" "uuid", "p_company_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_storekeeper_summary"("p_user_id" "uuid", "p_company_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_storekeeper_summary"("p_user_id" "uuid", "p_company_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_storekeeper_summary"("p_user_id" "uuid", "p_company_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_super_admin_platform_summary"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_super_admin_platform_summary"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_super_admin_platform_summary"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_unlinked_qr_codes"("p_society_id" "uuid", "p_limit" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."get_unlinked_qr_codes"("p_society_id" "uuid", "p_limit" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_unlinked_qr_codes"("p_society_id" "uuid", "p_limit" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."get_user_role"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_user_role"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_user_role"() TO "service_role";



GRANT ALL ON FUNCTION "public"."has_active_checklist_alert"("p_guard_id" "uuid", "p_date" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."has_active_checklist_alert"("p_guard_id" "uuid", "p_date" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."has_active_checklist_alert"("p_guard_id" "uuid", "p_date" "date") TO "service_role";



GRANT ALL ON FUNCTION "public"."has_active_inactivity_alert"("p_guard_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."has_active_inactivity_alert"("p_guard_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."has_active_inactivity_alert"("p_guard_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."has_role"("required_role" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."has_role"("required_role" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."has_role"("required_role" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."http"("request" "public"."http_request") TO "postgres";
GRANT ALL ON FUNCTION "public"."http"("request" "public"."http_request") TO "anon";
GRANT ALL ON FUNCTION "public"."http"("request" "public"."http_request") TO "authenticated";
GRANT ALL ON FUNCTION "public"."http"("request" "public"."http_request") TO "service_role";



GRANT ALL ON FUNCTION "public"."http_delete"("uri" character varying) TO "postgres";
GRANT ALL ON FUNCTION "public"."http_delete"("uri" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."http_delete"("uri" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_delete"("uri" character varying) TO "service_role";



GRANT ALL ON FUNCTION "public"."http_delete"("uri" character varying, "content" character varying, "content_type" character varying) TO "postgres";
GRANT ALL ON FUNCTION "public"."http_delete"("uri" character varying, "content" character varying, "content_type" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."http_delete"("uri" character varying, "content" character varying, "content_type" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_delete"("uri" character varying, "content" character varying, "content_type" character varying) TO "service_role";



GRANT ALL ON FUNCTION "public"."http_get"("uri" character varying) TO "postgres";
GRANT ALL ON FUNCTION "public"."http_get"("uri" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."http_get"("uri" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_get"("uri" character varying) TO "service_role";



GRANT ALL ON FUNCTION "public"."http_get"("uri" character varying, "data" "jsonb") TO "postgres";
GRANT ALL ON FUNCTION "public"."http_get"("uri" character varying, "data" "jsonb") TO "anon";
GRANT ALL ON FUNCTION "public"."http_get"("uri" character varying, "data" "jsonb") TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_get"("uri" character varying, "data" "jsonb") TO "service_role";



GRANT ALL ON FUNCTION "public"."http_head"("uri" character varying) TO "postgres";
GRANT ALL ON FUNCTION "public"."http_head"("uri" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."http_head"("uri" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_head"("uri" character varying) TO "service_role";



GRANT ALL ON FUNCTION "public"."http_header"("field" character varying, "value" character varying) TO "postgres";
GRANT ALL ON FUNCTION "public"."http_header"("field" character varying, "value" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."http_header"("field" character varying, "value" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_header"("field" character varying, "value" character varying) TO "service_role";



GRANT ALL ON FUNCTION "public"."http_list_curlopt"() TO "postgres";
GRANT ALL ON FUNCTION "public"."http_list_curlopt"() TO "anon";
GRANT ALL ON FUNCTION "public"."http_list_curlopt"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_list_curlopt"() TO "service_role";



GRANT ALL ON FUNCTION "public"."http_patch"("uri" character varying, "content" character varying, "content_type" character varying) TO "postgres";
GRANT ALL ON FUNCTION "public"."http_patch"("uri" character varying, "content" character varying, "content_type" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."http_patch"("uri" character varying, "content" character varying, "content_type" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_patch"("uri" character varying, "content" character varying, "content_type" character varying) TO "service_role";



GRANT ALL ON FUNCTION "public"."http_post"("uri" character varying, "data" "jsonb") TO "postgres";
GRANT ALL ON FUNCTION "public"."http_post"("uri" character varying, "data" "jsonb") TO "anon";
GRANT ALL ON FUNCTION "public"."http_post"("uri" character varying, "data" "jsonb") TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_post"("uri" character varying, "data" "jsonb") TO "service_role";



GRANT ALL ON FUNCTION "public"."http_post"("uri" character varying, "content" character varying, "content_type" character varying) TO "postgres";
GRANT ALL ON FUNCTION "public"."http_post"("uri" character varying, "content" character varying, "content_type" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."http_post"("uri" character varying, "content" character varying, "content_type" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_post"("uri" character varying, "content" character varying, "content_type" character varying) TO "service_role";



GRANT ALL ON FUNCTION "public"."http_put"("uri" character varying, "content" character varying, "content_type" character varying) TO "postgres";
GRANT ALL ON FUNCTION "public"."http_put"("uri" character varying, "content" character varying, "content_type" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."http_put"("uri" character varying, "content" character varying, "content_type" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_put"("uri" character varying, "content" character varying, "content_type" character varying) TO "service_role";



GRANT ALL ON FUNCTION "public"."http_reset_curlopt"() TO "postgres";
GRANT ALL ON FUNCTION "public"."http_reset_curlopt"() TO "anon";
GRANT ALL ON FUNCTION "public"."http_reset_curlopt"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_reset_curlopt"() TO "service_role";



GRANT ALL ON FUNCTION "public"."http_set_curlopt"("curlopt" character varying, "value" character varying) TO "postgres";
GRANT ALL ON FUNCTION "public"."http_set_curlopt"("curlopt" character varying, "value" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."http_set_curlopt"("curlopt" character varying, "value" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_set_curlopt"("curlopt" character varying, "value" character varying) TO "service_role";



GRANT ALL ON FUNCTION "public"."int2_dist"(smallint, smallint) TO "postgres";
GRANT ALL ON FUNCTION "public"."int2_dist"(smallint, smallint) TO "anon";
GRANT ALL ON FUNCTION "public"."int2_dist"(smallint, smallint) TO "authenticated";
GRANT ALL ON FUNCTION "public"."int2_dist"(smallint, smallint) TO "service_role";



GRANT ALL ON FUNCTION "public"."int4_dist"(integer, integer) TO "postgres";
GRANT ALL ON FUNCTION "public"."int4_dist"(integer, integer) TO "anon";
GRANT ALL ON FUNCTION "public"."int4_dist"(integer, integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."int4_dist"(integer, integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."int8_dist"(bigint, bigint) TO "postgres";
GRANT ALL ON FUNCTION "public"."int8_dist"(bigint, bigint) TO "anon";
GRANT ALL ON FUNCTION "public"."int8_dist"(bigint, bigint) TO "authenticated";
GRANT ALL ON FUNCTION "public"."int8_dist"(bigint, bigint) TO "service_role";



GRANT ALL ON FUNCTION "public"."interval_dist"(interval, interval) TO "postgres";
GRANT ALL ON FUNCTION "public"."interval_dist"(interval, interval) TO "anon";
GRANT ALL ON FUNCTION "public"."interval_dist"(interval, interval) TO "authenticated";
GRANT ALL ON FUNCTION "public"."interval_dist"(interval, interval) TO "service_role";



GRANT ALL ON FUNCTION "public"."is_admin"() TO "anon";
GRANT ALL ON FUNCTION "public"."is_admin"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."is_admin"() TO "service_role";



GRANT ALL ON FUNCTION "public"."is_employee"() TO "anon";
GRANT ALL ON FUNCTION "public"."is_employee"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."is_employee"() TO "service_role";



GRANT ALL ON FUNCTION "public"."is_financial_manager"() TO "anon";
GRANT ALL ON FUNCTION "public"."is_financial_manager"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."is_financial_manager"() TO "service_role";



GRANT ALL ON FUNCTION "public"."is_guard"() TO "anon";
GRANT ALL ON FUNCTION "public"."is_guard"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."is_guard"() TO "service_role";



GRANT ALL ON FUNCTION "public"."is_period_closed"("p_date" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."is_period_closed"("p_date" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."is_period_closed"("p_date" "date") TO "service_role";



GRANT ALL ON FUNCTION "public"."is_resident"() TO "anon";
GRANT ALL ON FUNCTION "public"."is_resident"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."is_resident"() TO "service_role";



GRANT ALL ON FUNCTION "public"."link_pest_control_ppe_on_session_start"() TO "anon";
GRANT ALL ON FUNCTION "public"."link_pest_control_ppe_on_session_start"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."link_pest_control_ppe_on_session_start"() TO "service_role";



GRANT ALL ON FUNCTION "public"."log_financial_audit"() TO "anon";
GRANT ALL ON FUNCTION "public"."log_financial_audit"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."log_financial_audit"() TO "service_role";



GRANT ALL ON FUNCTION "public"."log_gate_entry"("p_po_id" "uuid", "p_photo_url" "text", "p_signature_url" "text", "p_vehicle_number" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."log_gate_entry"("p_po_id" "uuid", "p_photo_url" "text", "p_signature_url" "text", "p_vehicle_number" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."log_gate_entry"("p_po_id" "uuid", "p_photo_url" "text", "p_signature_url" "text", "p_vehicle_number" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."log_gate_entry"("p_po_id" "uuid", "p_photo_url" "text", "p_signature_url" "text", "p_vehicle_number" "text", "p_driver_name" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."log_gate_entry"("p_po_id" "uuid", "p_photo_url" "text", "p_signature_url" "text", "p_vehicle_number" "text", "p_driver_name" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."log_gate_entry"("p_po_id" "uuid", "p_photo_url" "text", "p_signature_url" "text", "p_vehicle_number" "text", "p_driver_name" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."log_gate_entry"("p_po_id" "uuid", "p_photo_url" "text", "p_signature_url" "text", "p_vehicle_number" "text", "p_gate_location" "text", "p_notes" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."log_gate_entry"("p_po_id" "uuid", "p_photo_url" "text", "p_signature_url" "text", "p_vehicle_number" "text", "p_gate_location" "text", "p_notes" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."log_gate_entry"("p_po_id" "uuid", "p_photo_url" "text", "p_signature_url" "text", "p_vehicle_number" "text", "p_gate_location" "text", "p_notes" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."log_material_arrival"("p_po_id" "uuid", "p_vehicle_number" "text", "p_arrival_photo_url" "text", "p_arrival_signature_url" "text", "p_gate_location" "text", "p_notes" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."log_material_arrival"("p_po_id" "uuid", "p_vehicle_number" "text", "p_arrival_photo_url" "text", "p_arrival_signature_url" "text", "p_gate_location" "text", "p_notes" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."log_material_arrival"("p_po_id" "uuid", "p_vehicle_number" "text", "p_arrival_photo_url" "text", "p_arrival_signature_url" "text", "p_gate_location" "text", "p_notes" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."log_visitor_bypass_audit"() TO "anon";
GRANT ALL ON FUNCTION "public"."log_visitor_bypass_audit"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."log_visitor_bypass_audit"() TO "service_role";



GRANT ALL ON FUNCTION "public"."map_leave_type_to_attendance_status"("p_leave_type" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."map_leave_type_to_attendance_status"("p_leave_type" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."map_leave_type_to_attendance_status"("p_leave_type" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."mobile_insert_notification"("p_user_id" "uuid", "p_title" "text", "p_body" "text", "p_type" "text", "p_priority" "text", "p_action_url" "text", "p_data" "jsonb", "p_delivery_state" "text", "p_fallback_state" "text", "p_sms_fallback_at" timestamp with time zone) TO "anon";
GRANT ALL ON FUNCTION "public"."mobile_insert_notification"("p_user_id" "uuid", "p_title" "text", "p_body" "text", "p_type" "text", "p_priority" "text", "p_action_url" "text", "p_data" "jsonb", "p_delivery_state" "text", "p_fallback_state" "text", "p_sms_fallback_at" timestamp with time zone) TO "authenticated";
GRANT ALL ON FUNCTION "public"."mobile_insert_notification"("p_user_id" "uuid", "p_title" "text", "p_body" "text", "p_type" "text", "p_priority" "text", "p_action_url" "text", "p_data" "jsonb", "p_delivery_state" "text", "p_fallback_state" "text", "p_sms_fallback_at" timestamp with time zone) TO "service_role";



GRANT ALL ON FUNCTION "public"."mobile_refresh_visitor_decision_state"() TO "anon";
GRANT ALL ON FUNCTION "public"."mobile_refresh_visitor_decision_state"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."mobile_refresh_visitor_decision_state"() TO "service_role";



GRANT ALL ON FUNCTION "public"."notify_payment_failure"() TO "anon";
GRANT ALL ON FUNCTION "public"."notify_payment_failure"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."notify_payment_failure"() TO "service_role";



GRANT ALL ON FUNCTION "public"."oid_dist"("oid", "oid") TO "postgres";
GRANT ALL ON FUNCTION "public"."oid_dist"("oid", "oid") TO "anon";
GRANT ALL ON FUNCTION "public"."oid_dist"("oid", "oid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."oid_dist"("oid", "oid") TO "service_role";



GRANT ALL ON FUNCTION "public"."proc_check_login_blocked"("p_ip" "inet") TO "anon";
GRANT ALL ON FUNCTION "public"."proc_check_login_blocked"("p_ip" "inet") TO "authenticated";
GRANT ALL ON FUNCTION "public"."proc_check_login_blocked"("p_ip" "inet") TO "service_role";



GRANT ALL ON FUNCTION "public"."proc_enqueue_old_photos"() TO "anon";
GRANT ALL ON FUNCTION "public"."proc_enqueue_old_photos"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."proc_enqueue_old_photos"() TO "service_role";



GRANT ALL ON FUNCTION "public"."proc_handle_login_attempt"("p_ip" "inet", "p_is_failure" boolean) TO "anon";
GRANT ALL ON FUNCTION "public"."proc_handle_login_attempt"("p_ip" "inet", "p_is_failure" boolean) TO "authenticated";
GRANT ALL ON FUNCTION "public"."proc_handle_login_attempt"("p_ip" "inet", "p_is_failure" boolean) TO "service_role";



GRANT ALL ON FUNCTION "public"."process_overdue_alerts"() TO "anon";
GRANT ALL ON FUNCTION "public"."process_overdue_alerts"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."process_overdue_alerts"() TO "service_role";



GRANT ALL ON FUNCTION "public"."propagate_payment_status_to_request"() TO "anon";
GRANT ALL ON FUNCTION "public"."propagate_payment_status_to_request"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."propagate_payment_status_to_request"() TO "service_role";



GRANT ALL ON FUNCTION "public"."purge_expired_visitor_personal_data"() TO "anon";
GRANT ALL ON FUNCTION "public"."purge_expired_visitor_personal_data"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."purge_expired_visitor_personal_data"() TO "service_role";



GRANT ALL ON FUNCTION "public"."recalculate_indent_totals"() TO "anon";
GRANT ALL ON FUNCTION "public"."recalculate_indent_totals"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."recalculate_indent_totals"() TO "service_role";



GRANT ALL ON FUNCTION "public"."recalculate_po_totals"() TO "anon";
GRANT ALL ON FUNCTION "public"."recalculate_po_totals"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."recalculate_po_totals"() TO "service_role";



GRANT ALL ON FUNCTION "public"."record_guard_gps_tracking"("p_guard_id" "uuid", "p_latitude" numeric, "p_longitude" numeric, "p_accuracy_meters" integer, "p_is_within_fence" boolean, "p_shift_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."record_guard_gps_tracking"("p_guard_id" "uuid", "p_latitude" numeric, "p_longitude" numeric, "p_accuracy_meters" integer, "p_is_within_fence" boolean, "p_shift_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."record_guard_gps_tracking"("p_guard_id" "uuid", "p_latitude" numeric, "p_longitude" numeric, "p_accuracy_meters" integer, "p_is_within_fence" boolean, "p_shift_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."reject_leave_request"("p_leave_id" "uuid", "p_approver_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."reject_leave_request"("p_leave_id" "uuid", "p_approver_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."reject_leave_request"("p_leave_id" "uuid", "p_approver_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."reject_md_item"("p_item_id" "uuid", "p_approver_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."reject_md_item"("p_item_id" "uuid", "p_approver_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."reject_md_item"("p_item_id" "uuid", "p_approver_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."reopen_guard_checklist"("p_guard_id" "uuid", "p_reason" "text", "p_checklist_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."reopen_guard_checklist"("p_guard_id" "uuid", "p_reason" "text", "p_checklist_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."reopen_guard_checklist"("p_guard_id" "uuid", "p_reason" "text", "p_checklist_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."resolve_mobile_panic_alert"("p_alert_id" "uuid", "p_notes" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."resolve_mobile_panic_alert"("p_alert_id" "uuid", "p_notes" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."resolve_mobile_panic_alert"("p_alert_id" "uuid", "p_notes" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."resolve_panic_alert"("p_alert_id" "uuid", "p_resolved_by" "uuid", "p_resolution_notes" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."resolve_panic_alert"("p_alert_id" "uuid", "p_resolved_by" "uuid", "p_resolution_notes" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."resolve_panic_alert"("p_alert_id" "uuid", "p_resolved_by" "uuid", "p_resolution_notes" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."search_resident_destinations"("p_search" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."search_resident_destinations"("p_search" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."search_resident_destinations"("p_search" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."search_residents"("p_query" "text", "p_society_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."search_residents"("p_query" "text", "p_society_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."search_residents"("p_query" "text", "p_society_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."send_custom_sms"("p_phone_number" "text", "p_message" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."send_custom_sms"("p_phone_number" "text", "p_message" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."send_custom_sms"("p_phone_number" "text", "p_message" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."send_panic_alert_sms"("p_alert_type" "text", "p_guard_name" "text", "p_guard_phone" "text", "p_latitude" numeric, "p_longitude" numeric, "p_manager_phone" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."send_panic_alert_sms"("p_alert_type" "text", "p_guard_name" "text", "p_guard_phone" "text", "p_latitude" numeric, "p_longitude" numeric, "p_manager_phone" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."send_panic_alert_sms"("p_alert_type" "text", "p_guard_name" "text", "p_guard_phone" "text", "p_latitude" numeric, "p_longitude" numeric, "p_manager_phone" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."send_push_notification_to_manager"("p_alert_type" "text", "p_guard_name" "text", "p_latitude" numeric, "p_longitude" numeric) TO "anon";
GRANT ALL ON FUNCTION "public"."send_push_notification_to_manager"("p_alert_type" "text", "p_guard_name" "text", "p_latitude" numeric, "p_longitude" numeric) TO "authenticated";
GRANT ALL ON FUNCTION "public"."send_push_notification_to_manager"("p_alert_type" "text", "p_guard_name" "text", "p_latitude" numeric, "p_longitude" numeric) TO "service_role";



GRANT ALL ON FUNCTION "public"."service_request_can_bridge_to_bill_generated"("p_request_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."service_request_can_bridge_to_bill_generated"("p_request_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."service_request_can_bridge_to_bill_generated"("p_request_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."set_resident_frequent_visitor"("p_visitor_id" "uuid", "p_is_frequent" boolean) TO "anon";
GRANT ALL ON FUNCTION "public"."set_resident_frequent_visitor"("p_visitor_id" "uuid", "p_is_frequent" boolean) TO "authenticated";
GRANT ALL ON FUNCTION "public"."set_resident_frequent_visitor"("p_visitor_id" "uuid", "p_is_frequent" boolean) TO "service_role";



GRANT ALL ON FUNCTION "public"."stamp_server_time"() TO "anon";
GRANT ALL ON FUNCTION "public"."stamp_server_time"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."stamp_server_time"() TO "service_role";



GRANT ALL ON FUNCTION "public"."start_mobile_panic_alert"("p_alert_type" "text", "p_latitude" numeric, "p_longitude" numeric, "p_photo_url" "text", "p_description" "text", "p_metadata" "jsonb") TO "anon";
GRANT ALL ON FUNCTION "public"."start_mobile_panic_alert"("p_alert_type" "text", "p_latitude" numeric, "p_longitude" numeric, "p_photo_url" "text", "p_description" "text", "p_metadata" "jsonb") TO "authenticated";
GRANT ALL ON FUNCTION "public"."start_mobile_panic_alert"("p_alert_type" "text", "p_latitude" numeric, "p_longitude" numeric, "p_photo_url" "text", "p_description" "text", "p_metadata" "jsonb") TO "service_role";



GRANT ALL ON FUNCTION "public"."start_service_task"("p_request_id" "uuid", "p_before_photo_url" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."start_service_task"("p_request_id" "uuid", "p_before_photo_url" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."start_service_task"("p_request_id" "uuid", "p_before_photo_url" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."submit_mobile_guard_checklist"("p_checklist_id" "uuid", "p_responses" "jsonb", "p_is_complete" boolean) TO "anon";
GRANT ALL ON FUNCTION "public"."submit_mobile_guard_checklist"("p_checklist_id" "uuid", "p_responses" "jsonb", "p_is_complete" boolean) TO "authenticated";
GRANT ALL ON FUNCTION "public"."submit_mobile_guard_checklist"("p_checklist_id" "uuid", "p_responses" "jsonb", "p_is_complete" boolean) TO "service_role";



GRANT ALL ON FUNCTION "public"."supplier_transition_service_po_status"("p_spo_id" "uuid", "p_new_status" "text", "p_headcount_expected" integer, "p_grade_verified" boolean, "p_notes" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."supplier_transition_service_po_status"("p_spo_id" "uuid", "p_new_status" "text", "p_headcount_expected" integer, "p_grade_verified" boolean, "p_notes" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."supplier_transition_service_po_status"("p_spo_id" "uuid", "p_new_status" "text", "p_headcount_expected" integer, "p_grade_verified" boolean, "p_notes" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."sync_leave_application_attendance"("p_leave_application_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."sync_leave_application_attendance"("p_leave_application_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."sync_leave_application_attendance"("p_leave_application_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."sync_purchase_bill_match_status_from_reconciliation"() TO "anon";
GRANT ALL ON FUNCTION "public"."sync_purchase_bill_match_status_from_reconciliation"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."sync_purchase_bill_match_status_from_reconciliation"() TO "service_role";



GRANT ALL ON FUNCTION "public"."sync_request_status_from_purchase_bill"() TO "anon";
GRANT ALL ON FUNCTION "public"."sync_request_status_from_purchase_bill"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."sync_request_status_from_purchase_bill"() TO "service_role";



GRANT ALL ON FUNCTION "public"."text_to_bytea"("data" "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."text_to_bytea"("data" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."text_to_bytea"("data" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."text_to_bytea"("data" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."time_dist"(time without time zone, time without time zone) TO "postgres";
GRANT ALL ON FUNCTION "public"."time_dist"(time without time zone, time without time zone) TO "anon";
GRANT ALL ON FUNCTION "public"."time_dist"(time without time zone, time without time zone) TO "authenticated";
GRANT ALL ON FUNCTION "public"."time_dist"(time without time zone, time without time zone) TO "service_role";



GRANT ALL ON FUNCTION "public"."transition_po_status"("p_po_id" "uuid", "p_new_status" "text", "p_user_id" "uuid", "p_vehicle_details" "text", "p_dispatch_notes" "text", "p_dispatched_at" timestamp with time zone) TO "anon";
GRANT ALL ON FUNCTION "public"."transition_po_status"("p_po_id" "uuid", "p_new_status" "text", "p_user_id" "uuid", "p_vehicle_details" "text", "p_dispatch_notes" "text", "p_dispatched_at" timestamp with time zone) TO "authenticated";
GRANT ALL ON FUNCTION "public"."transition_po_status"("p_po_id" "uuid", "p_new_status" "text", "p_user_id" "uuid", "p_vehicle_details" "text", "p_dispatch_notes" "text", "p_dispatched_at" timestamp with time zone) TO "service_role";



GRANT ALL ON FUNCTION "public"."trg_cleanup_leave_application_attendance"() TO "anon";
GRANT ALL ON FUNCTION "public"."trg_cleanup_leave_application_attendance"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."trg_cleanup_leave_application_attendance"() TO "service_role";



GRANT ALL ON FUNCTION "public"."trg_sync_leave_application_attendance"() TO "anon";
GRANT ALL ON FUNCTION "public"."trg_sync_leave_application_attendance"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."trg_sync_leave_application_attendance"() TO "service_role";



GRANT ALL ON FUNCTION "public"."trigger_checklist_check"() TO "anon";
GRANT ALL ON FUNCTION "public"."trigger_checklist_check"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."trigger_checklist_check"() TO "service_role";



GRANT ALL ON FUNCTION "public"."trigger_daily_mobile_checklist_reminders"() TO "anon";
GRANT ALL ON FUNCTION "public"."trigger_daily_mobile_checklist_reminders"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."trigger_daily_mobile_checklist_reminders"() TO "service_role";



GRANT ALL ON FUNCTION "public"."trigger_inactivity_check"() TO "anon";
GRANT ALL ON FUNCTION "public"."trigger_inactivity_check"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."trigger_inactivity_check"() TO "service_role";



GRANT ALL ON FUNCTION "public"."trigger_mobile_notification_queue"() TO "anon";
GRANT ALL ON FUNCTION "public"."trigger_mobile_notification_queue"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."trigger_mobile_notification_queue"() TO "service_role";



GRANT ALL ON FUNCTION "public"."trigger_panic_alert"("p_guard_id" "uuid", "p_latitude" numeric, "p_longitude" numeric, "p_shift_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."trigger_panic_alert"("p_guard_id" "uuid", "p_latitude" numeric, "p_longitude" numeric, "p_shift_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."trigger_panic_alert"("p_guard_id" "uuid", "p_latitude" numeric, "p_longitude" numeric, "p_shift_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."trigger_shift_end_checklist_reminder"() TO "anon";
GRANT ALL ON FUNCTION "public"."trigger_shift_end_checklist_reminder"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."trigger_shift_end_checklist_reminder"() TO "service_role";



GRANT ALL ON FUNCTION "public"."ts_dist"(timestamp without time zone, timestamp without time zone) TO "postgres";
GRANT ALL ON FUNCTION "public"."ts_dist"(timestamp without time zone, timestamp without time zone) TO "anon";
GRANT ALL ON FUNCTION "public"."ts_dist"(timestamp without time zone, timestamp without time zone) TO "authenticated";
GRANT ALL ON FUNCTION "public"."ts_dist"(timestamp without time zone, timestamp without time zone) TO "service_role";



GRANT ALL ON FUNCTION "public"."tstz_dist"(timestamp with time zone, timestamp with time zone) TO "postgres";
GRANT ALL ON FUNCTION "public"."tstz_dist"(timestamp with time zone, timestamp with time zone) TO "anon";
GRANT ALL ON FUNCTION "public"."tstz_dist"(timestamp with time zone, timestamp with time zone) TO "authenticated";
GRANT ALL ON FUNCTION "public"."tstz_dist"(timestamp with time zone, timestamp with time zone) TO "service_role";



GRANT ALL ON FUNCTION "public"."update_ad_booking_updated_at"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_ad_booking_updated_at"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_ad_booking_updated_at"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_bgv_updated_at"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_bgv_updated_at"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_bgv_updated_at"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_bill_due_amount"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_bill_due_amount"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_bill_due_amount"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_budget_usage"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_budget_usage"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_budget_usage"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_delivery_note_updated_at"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_delivery_note_updated_at"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_delivery_note_updated_at"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_dispatch_updated_at"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_dispatch_updated_at"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_dispatch_updated_at"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_oversight_ticket_status"("p_ticket_id" "uuid", "p_status" "text", "p_resolution_notes" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."update_oversight_ticket_status"("p_ticket_id" "uuid", "p_status" "text", "p_resolution_notes" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_oversight_ticket_status"("p_ticket_id" "uuid", "p_status" "text", "p_resolution_notes" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."update_panic_alert_location"("p_alert_id" "uuid", "p_latitude" numeric, "p_longitude" numeric, "p_captured_at" timestamp with time zone) TO "anon";
GRANT ALL ON FUNCTION "public"."update_panic_alert_location"("p_alert_id" "uuid", "p_latitude" numeric, "p_longitude" numeric, "p_captured_at" timestamp with time zone) TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_panic_alert_location"("p_alert_id" "uuid", "p_latitude" numeric, "p_longitude" numeric, "p_captured_at" timestamp with time zone) TO "service_role";



GRANT ALL ON FUNCTION "public"."update_phase_b_updated_at"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_phase_b_updated_at"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_phase_b_updated_at"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_po_receipt_status"("p_po_id" "uuid", "p_user_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."update_po_receipt_status"("p_po_id" "uuid", "p_user_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_po_receipt_status"("p_po_id" "uuid", "p_user_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."update_ppe_all_items_checked"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_ppe_all_items_checked"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_ppe_all_items_checked"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_qr_link_status"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_qr_link_status"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_qr_link_status"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_shortage_note_updated_at"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_shortage_note_updated_at"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_shortage_note_updated_at"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_spill_kit_updated_at"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_spill_kit_updated_at"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_spill_kit_updated_at"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_updated_at_column"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_updated_at_column"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_updated_at_column"() TO "service_role";



GRANT ALL ON FUNCTION "public"."upsert_employee_salary_component"("p_employee_id" "uuid", "p_component_id" "uuid", "p_amount" bigint, "p_effective_from" "date", "p_notes" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."upsert_employee_salary_component"("p_employee_id" "uuid", "p_component_id" "uuid", "p_amount" bigint, "p_effective_from" "date", "p_notes" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."upsert_employee_salary_component"("p_employee_id" "uuid", "p_component_id" "uuid", "p_amount" bigint, "p_effective_from" "date", "p_notes" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."upsert_push_token"("p_token" "text", "p_device_type" "text", "p_token_type" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."upsert_push_token"("p_token" "text", "p_device_type" "text", "p_token_type" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."upsert_push_token"("p_token" "text", "p_device_type" "text", "p_token_type" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."urlencode"("string" "bytea") TO "postgres";
GRANT ALL ON FUNCTION "public"."urlencode"("string" "bytea") TO "anon";
GRANT ALL ON FUNCTION "public"."urlencode"("string" "bytea") TO "authenticated";
GRANT ALL ON FUNCTION "public"."urlencode"("string" "bytea") TO "service_role";



GRANT ALL ON FUNCTION "public"."urlencode"("data" "jsonb") TO "postgres";
GRANT ALL ON FUNCTION "public"."urlencode"("data" "jsonb") TO "anon";
GRANT ALL ON FUNCTION "public"."urlencode"("data" "jsonb") TO "authenticated";
GRANT ALL ON FUNCTION "public"."urlencode"("data" "jsonb") TO "service_role";



GRANT ALL ON FUNCTION "public"."urlencode"("string" character varying) TO "postgres";
GRANT ALL ON FUNCTION "public"."urlencode"("string" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."urlencode"("string" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."urlencode"("string" character varying) TO "service_role";



GRANT ALL ON FUNCTION "public"."validate_bill_for_payout"("p_bill_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."validate_bill_for_payout"("p_bill_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."validate_bill_for_payout"("p_bill_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."validate_clock_in_geofence"() TO "anon";
GRANT ALL ON FUNCTION "public"."validate_clock_in_geofence"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."validate_clock_in_geofence"() TO "service_role";



GRANT ALL ON FUNCTION "public"."validate_indent_rate"("p_indent_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."validate_indent_rate"("p_indent_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."validate_indent_rate"("p_indent_id" "uuid") TO "service_role";
























GRANT ALL ON SEQUENCE "public"."ad_booking_number_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."ad_booking_number_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."ad_booking_number_seq" TO "service_role";



GRANT ALL ON TABLE "public"."asset_categories" TO "anon";
GRANT ALL ON TABLE "public"."asset_categories" TO "authenticated";
GRANT ALL ON TABLE "public"."asset_categories" TO "service_role";



GRANT ALL ON TABLE "public"."assets" TO "anon";
GRANT ALL ON TABLE "public"."assets" TO "authenticated";
GRANT ALL ON TABLE "public"."assets" TO "service_role";



GRANT ALL ON TABLE "public"."company_locations" TO "anon";
GRANT ALL ON TABLE "public"."company_locations" TO "authenticated";
GRANT ALL ON TABLE "public"."company_locations" TO "service_role";



GRANT ALL ON TABLE "public"."qr_codes" TO "anon";
GRANT ALL ON TABLE "public"."qr_codes" TO "authenticated";
GRANT ALL ON TABLE "public"."qr_codes" TO "service_role";



GRANT ALL ON TABLE "public"."suppliers" TO "anon";
GRANT ALL ON TABLE "public"."suppliers" TO "authenticated";
GRANT ALL ON TABLE "public"."suppliers" TO "service_role";



GRANT ALL ON TABLE "public"."assets_with_details" TO "anon";
GRANT ALL ON TABLE "public"."assets_with_details" TO "authenticated";
GRANT ALL ON TABLE "public"."assets_with_details" TO "service_role";



GRANT ALL ON TABLE "public"."attendance_logs" TO "anon";
GRANT ALL ON TABLE "public"."attendance_logs" TO "authenticated";
GRANT ALL ON TABLE "public"."attendance_logs" TO "service_role";



GRANT ALL ON TABLE "public"."audit_logs" TO "anon";
GRANT ALL ON TABLE "public"."audit_logs" TO "authenticated";
GRANT ALL ON TABLE "public"."audit_logs" TO "service_role";



GRANT ALL ON TABLE "public"."background_verifications" TO "anon";
GRANT ALL ON TABLE "public"."background_verifications" TO "authenticated";
GRANT ALL ON TABLE "public"."background_verifications" TO "service_role";



GRANT ALL ON SEQUENCE "public"."behavior_ticket_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."behavior_ticket_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."behavior_ticket_seq" TO "service_role";



GRANT ALL ON TABLE "public"."behaviour_tickets" TO "anon";
GRANT ALL ON TABLE "public"."behaviour_tickets" TO "authenticated";
GRANT ALL ON TABLE "public"."behaviour_tickets" TO "service_role";



GRANT ALL ON SEQUENCE "public"."bill_number_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."bill_number_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."bill_number_seq" TO "service_role";



GRANT ALL ON SEQUENCE "public"."budget_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."budget_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."budget_seq" TO "service_role";



GRANT ALL ON TABLE "public"."budgets" TO "anon";
GRANT ALL ON TABLE "public"."budgets" TO "authenticated";
GRANT ALL ON TABLE "public"."budgets" TO "service_role";



GRANT ALL ON TABLE "public"."buildings" TO "anon";
GRANT ALL ON TABLE "public"."buildings" TO "authenticated";
GRANT ALL ON TABLE "public"."buildings" TO "service_role";



GRANT ALL ON TABLE "public"."buyer_accounts" TO "anon";
GRANT ALL ON TABLE "public"."buyer_accounts" TO "authenticated";
GRANT ALL ON TABLE "public"."buyer_accounts" TO "service_role";



GRANT ALL ON TABLE "public"."buyer_feedback" TO "anon";
GRANT ALL ON TABLE "public"."buyer_feedback" TO "authenticated";
GRANT ALL ON TABLE "public"."buyer_feedback" TO "service_role";



GRANT ALL ON TABLE "public"."candidate_interviews" TO "anon";
GRANT ALL ON TABLE "public"."candidate_interviews" TO "authenticated";
GRANT ALL ON TABLE "public"."candidate_interviews" TO "service_role";



GRANT ALL ON TABLE "public"."candidates" TO "anon";
GRANT ALL ON TABLE "public"."candidates" TO "authenticated";
GRANT ALL ON TABLE "public"."candidates" TO "service_role";



GRANT ALL ON TABLE "public"."employees" TO "anon";
GRANT ALL ON TABLE "public"."employees" TO "authenticated";
GRANT ALL ON TABLE "public"."employees" TO "service_role";



GRANT ALL ON TABLE "public"."candidate_interviews_with_details" TO "anon";
GRANT ALL ON TABLE "public"."candidate_interviews_with_details" TO "authenticated";
GRANT ALL ON TABLE "public"."candidate_interviews_with_details" TO "service_role";



GRANT ALL ON SEQUENCE "public"."candidate_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."candidate_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."candidate_seq" TO "service_role";



GRANT ALL ON TABLE "public"."designations" TO "anon";
GRANT ALL ON TABLE "public"."designations" TO "authenticated";
GRANT ALL ON TABLE "public"."designations" TO "service_role";



GRANT ALL ON TABLE "public"."candidates_with_details" TO "anon";
GRANT ALL ON TABLE "public"."candidates_with_details" TO "authenticated";
GRANT ALL ON TABLE "public"."candidates_with_details" TO "service_role";



GRANT ALL ON TABLE "public"."checklist_assignments" TO "anon";
GRANT ALL ON TABLE "public"."checklist_assignments" TO "authenticated";
GRANT ALL ON TABLE "public"."checklist_assignments" TO "service_role";



GRANT ALL ON TABLE "public"."checklist_response_override_audit" TO "anon";
GRANT ALL ON TABLE "public"."checklist_response_override_audit" TO "authenticated";
GRANT ALL ON TABLE "public"."checklist_response_override_audit" TO "service_role";



GRANT ALL ON TABLE "public"."checklist_responses" TO "anon";
GRANT ALL ON TABLE "public"."checklist_responses" TO "authenticated";
GRANT ALL ON TABLE "public"."checklist_responses" TO "service_role";



GRANT ALL ON TABLE "public"."company_events" TO "anon";
GRANT ALL ON TABLE "public"."company_events" TO "authenticated";
GRANT ALL ON TABLE "public"."company_events" TO "service_role";



GRANT ALL ON TABLE "public"."compliance_snapshots" TO "anon";
GRANT ALL ON TABLE "public"."compliance_snapshots" TO "authenticated";
GRANT ALL ON TABLE "public"."compliance_snapshots" TO "service_role";



GRANT ALL ON TABLE "public"."contracts" TO "anon";
GRANT ALL ON TABLE "public"."contracts" TO "authenticated";
GRANT ALL ON TABLE "public"."contracts" TO "service_role";



GRANT ALL ON TABLE "public"."credit_notes" TO "anon";
GRANT ALL ON TABLE "public"."credit_notes" TO "authenticated";
GRANT ALL ON TABLE "public"."credit_notes" TO "service_role";



GRANT ALL ON TABLE "public"."daily_checklist_items" TO "anon";
GRANT ALL ON TABLE "public"."daily_checklist_items" TO "authenticated";
GRANT ALL ON TABLE "public"."daily_checklist_items" TO "service_role";



GRANT ALL ON TABLE "public"."daily_checklists" TO "anon";
GRANT ALL ON TABLE "public"."daily_checklists" TO "authenticated";
GRANT ALL ON TABLE "public"."daily_checklists" TO "service_role";



GRANT ALL ON TABLE "public"."debit_notes" TO "anon";
GRANT ALL ON TABLE "public"."debit_notes" TO "authenticated";
GRANT ALL ON TABLE "public"."debit_notes" TO "service_role";



GRANT ALL ON SEQUENCE "public"."delivery_note_number_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."delivery_note_number_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."delivery_note_number_seq" TO "service_role";



GRANT ALL ON TABLE "public"."maintenance_schedules" TO "anon";
GRANT ALL ON TABLE "public"."maintenance_schedules" TO "authenticated";
GRANT ALL ON TABLE "public"."maintenance_schedules" TO "service_role";



GRANT ALL ON TABLE "public"."due_maintenance_schedules" TO "anon";
GRANT ALL ON TABLE "public"."due_maintenance_schedules" TO "authenticated";
GRANT ALL ON TABLE "public"."due_maintenance_schedules" TO "service_role";



GRANT ALL ON TABLE "public"."emergency_contacts" TO "anon";
GRANT ALL ON TABLE "public"."emergency_contacts" TO "authenticated";
GRANT ALL ON TABLE "public"."emergency_contacts" TO "service_role";



GRANT ALL ON TABLE "public"."employee_behavior_tickets" TO "anon";
GRANT ALL ON TABLE "public"."employee_behavior_tickets" TO "authenticated";
GRANT ALL ON TABLE "public"."employee_behavior_tickets" TO "service_role";



GRANT ALL ON TABLE "public"."employee_documents" TO "anon";
GRANT ALL ON TABLE "public"."employee_documents" TO "authenticated";
GRANT ALL ON TABLE "public"."employee_documents" TO "service_role";



GRANT ALL ON TABLE "public"."users" TO "anon";
GRANT ALL ON TABLE "public"."users" TO "authenticated";
GRANT ALL ON TABLE "public"."users" TO "service_role";



GRANT ALL ON TABLE "public"."employee_documents_with_details" TO "anon";
GRANT ALL ON TABLE "public"."employee_documents_with_details" TO "authenticated";
GRANT ALL ON TABLE "public"."employee_documents_with_details" TO "service_role";



GRANT ALL ON TABLE "public"."employee_salary_structure" TO "anon";
GRANT ALL ON TABLE "public"."employee_salary_structure" TO "authenticated";
GRANT ALL ON TABLE "public"."employee_salary_structure" TO "service_role";



GRANT ALL ON TABLE "public"."salary_components" TO "anon";
GRANT ALL ON TABLE "public"."salary_components" TO "authenticated";
GRANT ALL ON TABLE "public"."salary_components" TO "service_role";



GRANT ALL ON TABLE "public"."employee_salary_structure_with_details" TO "anon";
GRANT ALL ON TABLE "public"."employee_salary_structure_with_details" TO "authenticated";
GRANT ALL ON TABLE "public"."employee_salary_structure_with_details" TO "service_role";



GRANT ALL ON TABLE "public"."employee_shift_assignments" TO "anon";
GRANT ALL ON TABLE "public"."employee_shift_assignments" TO "authenticated";
GRANT ALL ON TABLE "public"."employee_shift_assignments" TO "service_role";



GRANT ALL ON TABLE "public"."products" TO "anon";
GRANT ALL ON TABLE "public"."products" TO "authenticated";
GRANT ALL ON TABLE "public"."products" TO "service_role";



GRANT ALL ON TABLE "public"."safety_equipment" TO "anon";
GRANT ALL ON TABLE "public"."safety_equipment" TO "authenticated";
GRANT ALL ON TABLE "public"."safety_equipment" TO "service_role";



GRANT ALL ON TABLE "public"."stock_batches" TO "anon";
GRANT ALL ON TABLE "public"."stock_batches" TO "authenticated";
GRANT ALL ON TABLE "public"."stock_batches" TO "service_role";



GRANT ALL ON TABLE "public"."expiry_tracking" TO "anon";
GRANT ALL ON TABLE "public"."expiry_tracking" TO "authenticated";
GRANT ALL ON TABLE "public"."expiry_tracking" TO "service_role";



GRANT ALL ON TABLE "public"."financial_periods" TO "anon";
GRANT ALL ON TABLE "public"."financial_periods" TO "authenticated";
GRANT ALL ON TABLE "public"."financial_periods" TO "service_role";



GRANT ALL ON TABLE "public"."flats" TO "anon";
GRANT ALL ON TABLE "public"."flats" TO "authenticated";
GRANT ALL ON TABLE "public"."flats" TO "service_role";



GRANT ALL ON TABLE "public"."gps_tracking" TO "anon";
GRANT ALL ON TABLE "public"."gps_tracking" TO "authenticated";
GRANT ALL ON TABLE "public"."gps_tracking" TO "service_role";



GRANT ALL ON TABLE "public"."gps_tracking_2026_02" TO "anon";
GRANT ALL ON TABLE "public"."gps_tracking_2026_02" TO "authenticated";
GRANT ALL ON TABLE "public"."gps_tracking_2026_02" TO "service_role";



GRANT ALL ON TABLE "public"."gps_tracking_2026_03" TO "anon";
GRANT ALL ON TABLE "public"."gps_tracking_2026_03" TO "authenticated";
GRANT ALL ON TABLE "public"."gps_tracking_2026_03" TO "service_role";



GRANT ALL ON TABLE "public"."gps_tracking_2026_04" TO "anon";
GRANT ALL ON TABLE "public"."gps_tracking_2026_04" TO "authenticated";
GRANT ALL ON TABLE "public"."gps_tracking_2026_04" TO "service_role";



GRANT ALL ON TABLE "public"."gps_tracking_2026_05" TO "anon";
GRANT ALL ON TABLE "public"."gps_tracking_2026_05" TO "authenticated";
GRANT ALL ON TABLE "public"."gps_tracking_2026_05" TO "service_role";



GRANT ALL ON TABLE "public"."gps_tracking_2026_06" TO "anon";
GRANT ALL ON TABLE "public"."gps_tracking_2026_06" TO "authenticated";
GRANT ALL ON TABLE "public"."gps_tracking_2026_06" TO "service_role";



GRANT ALL ON TABLE "public"."gps_tracking_2026_07" TO "anon";
GRANT ALL ON TABLE "public"."gps_tracking_2026_07" TO "authenticated";
GRANT ALL ON TABLE "public"."gps_tracking_2026_07" TO "service_role";



GRANT ALL ON TABLE "public"."gps_tracking_2026_08" TO "anon";
GRANT ALL ON TABLE "public"."gps_tracking_2026_08" TO "authenticated";
GRANT ALL ON TABLE "public"."gps_tracking_2026_08" TO "service_role";



GRANT ALL ON TABLE "public"."gps_tracking_2026_09" TO "anon";
GRANT ALL ON TABLE "public"."gps_tracking_2026_09" TO "authenticated";
GRANT ALL ON TABLE "public"."gps_tracking_2026_09" TO "service_role";



GRANT ALL ON TABLE "public"."gps_tracking_2026_10" TO "anon";
GRANT ALL ON TABLE "public"."gps_tracking_2026_10" TO "authenticated";
GRANT ALL ON TABLE "public"."gps_tracking_2026_10" TO "service_role";



GRANT ALL ON TABLE "public"."gps_tracking_2026_11" TO "anon";
GRANT ALL ON TABLE "public"."gps_tracking_2026_11" TO "authenticated";
GRANT ALL ON TABLE "public"."gps_tracking_2026_11" TO "service_role";



GRANT ALL ON TABLE "public"."gps_tracking_2026_12" TO "anon";
GRANT ALL ON TABLE "public"."gps_tracking_2026_12" TO "authenticated";
GRANT ALL ON TABLE "public"."gps_tracking_2026_12" TO "service_role";



GRANT ALL ON TABLE "public"."gps_tracking_default" TO "anon";
GRANT ALL ON TABLE "public"."gps_tracking_default" TO "authenticated";
GRANT ALL ON TABLE "public"."gps_tracking_default" TO "service_role";



GRANT ALL ON SEQUENCE "public"."grn_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."grn_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."grn_seq" TO "service_role";



GRANT ALL ON TABLE "public"."guard_gps_tracking" TO "anon";
GRANT ALL ON TABLE "public"."guard_gps_tracking" TO "authenticated";
GRANT ALL ON TABLE "public"."guard_gps_tracking" TO "service_role";



GRANT ALL ON TABLE "public"."guard_panic_alerts" TO "anon";
GRANT ALL ON TABLE "public"."guard_panic_alerts" TO "authenticated";
GRANT ALL ON TABLE "public"."guard_panic_alerts" TO "service_role";



GRANT ALL ON TABLE "public"."guard_patrol_logs" TO "anon";
GRANT ALL ON TABLE "public"."guard_patrol_logs" TO "authenticated";
GRANT ALL ON TABLE "public"."guard_patrol_logs" TO "service_role";



GRANT ALL ON TABLE "public"."holiday_master" TO "anon";
GRANT ALL ON TABLE "public"."holiday_master" TO "authenticated";
GRANT ALL ON TABLE "public"."holiday_master" TO "service_role";



GRANT ALL ON TABLE "public"."holidays" TO "anon";
GRANT ALL ON TABLE "public"."holidays" TO "authenticated";
GRANT ALL ON TABLE "public"."holidays" TO "service_role";



GRANT ALL ON TABLE "public"."horticulture_seasonal_plans" TO "anon";
GRANT ALL ON TABLE "public"."horticulture_seasonal_plans" TO "authenticated";
GRANT ALL ON TABLE "public"."horticulture_seasonal_plans" TO "service_role";



GRANT ALL ON TABLE "public"."horticulture_tasks" TO "anon";
GRANT ALL ON TABLE "public"."horticulture_tasks" TO "authenticated";
GRANT ALL ON TABLE "public"."horticulture_tasks" TO "service_role";



GRANT ALL ON TABLE "public"."horticulture_zones" TO "anon";
GRANT ALL ON TABLE "public"."horticulture_zones" TO "authenticated";
GRANT ALL ON TABLE "public"."horticulture_zones" TO "service_role";



GRANT ALL ON TABLE "public"."indent_items" TO "anon";
GRANT ALL ON TABLE "public"."indent_items" TO "authenticated";
GRANT ALL ON TABLE "public"."indent_items" TO "service_role";



GRANT ALL ON SEQUENCE "public"."indent_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."indent_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."indent_seq" TO "service_role";



GRANT ALL ON TABLE "public"."indents" TO "anon";
GRANT ALL ON TABLE "public"."indents" TO "authenticated";
GRANT ALL ON TABLE "public"."indents" TO "service_role";



GRANT ALL ON TABLE "public"."societies" TO "anon";
GRANT ALL ON TABLE "public"."societies" TO "authenticated";
GRANT ALL ON TABLE "public"."societies" TO "service_role";



GRANT ALL ON TABLE "public"."indents_with_details" TO "anon";
GRANT ALL ON TABLE "public"."indents_with_details" TO "authenticated";
GRANT ALL ON TABLE "public"."indents_with_details" TO "service_role";



GRANT ALL ON TABLE "public"."inventory" TO "anon";
GRANT ALL ON TABLE "public"."inventory" TO "authenticated";
GRANT ALL ON TABLE "public"."inventory" TO "service_role";



GRANT ALL ON TABLE "public"."job_materials_used" TO "anon";
GRANT ALL ON TABLE "public"."job_materials_used" TO "authenticated";
GRANT ALL ON TABLE "public"."job_materials_used" TO "service_role";



GRANT ALL ON TABLE "public"."job_photos" TO "anon";
GRANT ALL ON TABLE "public"."job_photos" TO "authenticated";
GRANT ALL ON TABLE "public"."job_photos" TO "service_role";



GRANT ALL ON TABLE "public"."job_sessions" TO "anon";
GRANT ALL ON TABLE "public"."job_sessions" TO "authenticated";
GRANT ALL ON TABLE "public"."job_sessions" TO "service_role";



GRANT ALL ON TABLE "public"."leave_applications" TO "anon";
GRANT ALL ON TABLE "public"."leave_applications" TO "authenticated";
GRANT ALL ON TABLE "public"."leave_applications" TO "service_role";



GRANT ALL ON TABLE "public"."leave_types" TO "anon";
GRANT ALL ON TABLE "public"."leave_types" TO "authenticated";
GRANT ALL ON TABLE "public"."leave_types" TO "service_role";



GRANT ALL ON TABLE "public"."login_rate_limits" TO "anon";
GRANT ALL ON TABLE "public"."login_rate_limits" TO "authenticated";
GRANT ALL ON TABLE "public"."login_rate_limits" TO "service_role";



GRANT ALL ON TABLE "public"."material_arrival_evidence" TO "anon";
GRANT ALL ON TABLE "public"."material_arrival_evidence" TO "authenticated";
GRANT ALL ON TABLE "public"."material_arrival_evidence" TO "service_role";



GRANT ALL ON TABLE "public"."material_arrival_logs" TO "anon";
GRANT ALL ON TABLE "public"."material_arrival_logs" TO "authenticated";
GRANT ALL ON TABLE "public"."material_arrival_logs" TO "service_role";



GRANT ALL ON TABLE "public"."material_receipt_items" TO "anon";
GRANT ALL ON TABLE "public"."material_receipt_items" TO "authenticated";
GRANT ALL ON TABLE "public"."material_receipt_items" TO "service_role";



GRANT ALL ON TABLE "public"."material_receipts" TO "anon";
GRANT ALL ON TABLE "public"."material_receipts" TO "authenticated";
GRANT ALL ON TABLE "public"."material_receipts" TO "service_role";



GRANT ALL ON TABLE "public"."purchase_orders" TO "anon";
GRANT ALL ON TABLE "public"."purchase_orders" TO "authenticated";
GRANT ALL ON TABLE "public"."purchase_orders" TO "service_role";



GRANT ALL ON TABLE "public"."warehouses" TO "anon";
GRANT ALL ON TABLE "public"."warehouses" TO "authenticated";
GRANT ALL ON TABLE "public"."warehouses" TO "service_role";



GRANT ALL ON TABLE "public"."material_receipts_with_details" TO "anon";
GRANT ALL ON TABLE "public"."material_receipts_with_details" TO "authenticated";
GRANT ALL ON TABLE "public"."material_receipts_with_details" TO "service_role";



GRANT ALL ON TABLE "public"."notification_logs" TO "anon";
GRANT ALL ON TABLE "public"."notification_logs" TO "authenticated";
GRANT ALL ON TABLE "public"."notification_logs" TO "service_role";



GRANT ALL ON TABLE "public"."notifications" TO "anon";
GRANT ALL ON TABLE "public"."notifications" TO "authenticated";
GRANT ALL ON TABLE "public"."notifications" TO "service_role";



GRANT ALL ON SEQUENCE "public"."oversight_ticket_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."oversight_ticket_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."oversight_ticket_seq" TO "service_role";



GRANT ALL ON TABLE "public"."oversight_tickets" TO "anon";
GRANT ALL ON TABLE "public"."oversight_tickets" TO "authenticated";
GRANT ALL ON TABLE "public"."oversight_tickets" TO "service_role";



GRANT ALL ON TABLE "public"."panic_alerts" TO "anon";
GRANT ALL ON TABLE "public"."panic_alerts" TO "authenticated";
GRANT ALL ON TABLE "public"."panic_alerts" TO "service_role";



GRANT ALL ON TABLE "public"."payment_methods" TO "anon";
GRANT ALL ON TABLE "public"."payment_methods" TO "authenticated";
GRANT ALL ON TABLE "public"."payment_methods" TO "service_role";



GRANT ALL ON SEQUENCE "public"."payment_num_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."payment_num_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."payment_num_seq" TO "service_role";



GRANT ALL ON TABLE "public"."payments" TO "anon";
GRANT ALL ON TABLE "public"."payments" TO "authenticated";
GRANT ALL ON TABLE "public"."payments" TO "service_role";



GRANT ALL ON TABLE "public"."payroll_cycles" TO "anon";
GRANT ALL ON TABLE "public"."payroll_cycles" TO "authenticated";
GRANT ALL ON TABLE "public"."payroll_cycles" TO "service_role";



GRANT ALL ON SEQUENCE "public"."payslip_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."payslip_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."payslip_seq" TO "service_role";



GRANT ALL ON TABLE "public"."payslips" TO "anon";
GRANT ALL ON TABLE "public"."payslips" TO "authenticated";
GRANT ALL ON TABLE "public"."payslips" TO "service_role";



GRANT ALL ON TABLE "public"."payslips_with_details" TO "anon";
GRANT ALL ON TABLE "public"."payslips_with_details" TO "authenticated";
GRANT ALL ON TABLE "public"."payslips_with_details" TO "service_role";



GRANT ALL ON SEQUENCE "public"."personnel_dispatch_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."personnel_dispatch_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."personnel_dispatch_seq" TO "service_role";



GRANT ALL ON TABLE "public"."personnel_dispatches" TO "anon";
GRANT ALL ON TABLE "public"."personnel_dispatches" TO "authenticated";
GRANT ALL ON TABLE "public"."personnel_dispatches" TO "service_role";



GRANT ALL ON TABLE "public"."pest_control_chemicals" TO "anon";
GRANT ALL ON TABLE "public"."pest_control_chemicals" TO "authenticated";
GRANT ALL ON TABLE "public"."pest_control_chemicals" TO "service_role";



GRANT ALL ON TABLE "public"."pest_control_ppe_verifications" TO "anon";
GRANT ALL ON TABLE "public"."pest_control_ppe_verifications" TO "authenticated";
GRANT ALL ON TABLE "public"."pest_control_ppe_verifications" TO "service_role";



GRANT ALL ON TABLE "public"."pest_control_spill_kits" TO "anon";
GRANT ALL ON TABLE "public"."pest_control_spill_kits" TO "authenticated";
GRANT ALL ON TABLE "public"."pest_control_spill_kits" TO "service_role";



GRANT ALL ON SEQUENCE "public"."po_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."po_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."po_seq" TO "service_role";



GRANT ALL ON TABLE "public"."printing_ad_bookings" TO "anon";
GRANT ALL ON TABLE "public"."printing_ad_bookings" TO "authenticated";
GRANT ALL ON TABLE "public"."printing_ad_bookings" TO "service_role";



GRANT ALL ON TABLE "public"."printing_ad_spaces" TO "anon";
GRANT ALL ON TABLE "public"."printing_ad_spaces" TO "authenticated";
GRANT ALL ON TABLE "public"."printing_ad_spaces" TO "service_role";



GRANT ALL ON TABLE "public"."product_categories" TO "anon";
GRANT ALL ON TABLE "public"."product_categories" TO "authenticated";
GRANT ALL ON TABLE "public"."product_categories" TO "service_role";



GRANT ALL ON TABLE "public"."product_subcategories" TO "anon";
GRANT ALL ON TABLE "public"."product_subcategories" TO "authenticated";
GRANT ALL ON TABLE "public"."product_subcategories" TO "service_role";



GRANT ALL ON TABLE "public"."purchase_bill_items" TO "anon";
GRANT ALL ON TABLE "public"."purchase_bill_items" TO "authenticated";
GRANT ALL ON TABLE "public"."purchase_bill_items" TO "service_role";



GRANT ALL ON SEQUENCE "public"."purchase_bill_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."purchase_bill_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."purchase_bill_seq" TO "service_role";



GRANT ALL ON TABLE "public"."purchase_bills" TO "anon";
GRANT ALL ON TABLE "public"."purchase_bills" TO "authenticated";
GRANT ALL ON TABLE "public"."purchase_bills" TO "service_role";



GRANT ALL ON TABLE "public"."purchase_bills_with_details" TO "anon";
GRANT ALL ON TABLE "public"."purchase_bills_with_details" TO "authenticated";
GRANT ALL ON TABLE "public"."purchase_bills_with_details" TO "service_role";



GRANT ALL ON TABLE "public"."purchase_order_items" TO "anon";
GRANT ALL ON TABLE "public"."purchase_order_items" TO "authenticated";
GRANT ALL ON TABLE "public"."purchase_order_items" TO "service_role";



GRANT ALL ON TABLE "public"."purchase_orders_with_details" TO "anon";
GRANT ALL ON TABLE "public"."purchase_orders_with_details" TO "authenticated";
GRANT ALL ON TABLE "public"."purchase_orders_with_details" TO "service_role";



GRANT ALL ON TABLE "public"."push_tokens" TO "anon";
GRANT ALL ON TABLE "public"."push_tokens" TO "authenticated";
GRANT ALL ON TABLE "public"."push_tokens" TO "service_role";



GRANT ALL ON TABLE "public"."qr_batch_logs" TO "anon";
GRANT ALL ON TABLE "public"."qr_batch_logs" TO "authenticated";
GRANT ALL ON TABLE "public"."qr_batch_logs" TO "service_role";



GRANT ALL ON TABLE "public"."qr_codes_with_batch_info" TO "anon";
GRANT ALL ON TABLE "public"."qr_codes_with_batch_info" TO "authenticated";
GRANT ALL ON TABLE "public"."qr_codes_with_batch_info" TO "service_role";



GRANT ALL ON TABLE "public"."qr_scans" TO "anon";
GRANT ALL ON TABLE "public"."qr_scans" TO "authenticated";
GRANT ALL ON TABLE "public"."qr_scans" TO "service_role";



GRANT ALL ON TABLE "public"."reconciliation_lines" TO "anon";
GRANT ALL ON TABLE "public"."reconciliation_lines" TO "authenticated";
GRANT ALL ON TABLE "public"."reconciliation_lines" TO "service_role";



GRANT ALL ON TABLE "public"."reconciliations" TO "anon";
GRANT ALL ON TABLE "public"."reconciliations" TO "authenticated";
GRANT ALL ON TABLE "public"."reconciliations" TO "service_role";



GRANT ALL ON TABLE "public"."reconciliation_lines_with_details" TO "anon";
GRANT ALL ON TABLE "public"."reconciliation_lines_with_details" TO "authenticated";
GRANT ALL ON TABLE "public"."reconciliation_lines_with_details" TO "service_role";



GRANT ALL ON SEQUENCE "public"."reconciliation_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."reconciliation_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."reconciliation_seq" TO "service_role";



GRANT ALL ON TABLE "public"."reconciliations_with_details" TO "anon";
GRANT ALL ON TABLE "public"."reconciliations_with_details" TO "authenticated";
GRANT ALL ON TABLE "public"."reconciliations_with_details" TO "service_role";



GRANT ALL ON TABLE "public"."reorder_rules" TO "anon";
GRANT ALL ON TABLE "public"."reorder_rules" TO "authenticated";
GRANT ALL ON TABLE "public"."reorder_rules" TO "service_role";



GRANT ALL ON TABLE "public"."request_items" TO "anon";
GRANT ALL ON TABLE "public"."request_items" TO "authenticated";
GRANT ALL ON TABLE "public"."request_items" TO "service_role";



GRANT ALL ON SEQUENCE "public"."request_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."request_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."request_seq" TO "service_role";



GRANT ALL ON TABLE "public"."requests" TO "anon";
GRANT ALL ON TABLE "public"."requests" TO "authenticated";
GRANT ALL ON TABLE "public"."requests" TO "service_role";



GRANT ALL ON TABLE "public"."residents" TO "anon";
GRANT ALL ON TABLE "public"."residents" TO "authenticated";
GRANT ALL ON TABLE "public"."residents" TO "service_role";



GRANT ALL ON TABLE "public"."resident_directory" TO "anon";
GRANT ALL ON TABLE "public"."resident_directory" TO "authenticated";
GRANT ALL ON TABLE "public"."resident_directory" TO "service_role";



GRANT ALL ON TABLE "public"."roles" TO "anon";
GRANT ALL ON TABLE "public"."roles" TO "authenticated";
GRANT ALL ON TABLE "public"."roles" TO "service_role";



GRANT ALL ON SEQUENCE "public"."rtv_ticket_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."rtv_ticket_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."rtv_ticket_seq" TO "service_role";



GRANT ALL ON TABLE "public"."rtv_tickets" TO "anon";
GRANT ALL ON TABLE "public"."rtv_tickets" TO "authenticated";
GRANT ALL ON TABLE "public"."rtv_tickets" TO "service_role";



GRANT ALL ON TABLE "public"."sale_bill_items" TO "anon";
GRANT ALL ON TABLE "public"."sale_bill_items" TO "authenticated";
GRANT ALL ON TABLE "public"."sale_bill_items" TO "service_role";



GRANT ALL ON TABLE "public"."sale_bills" TO "anon";
GRANT ALL ON TABLE "public"."sale_bills" TO "authenticated";
GRANT ALL ON TABLE "public"."sale_bills" TO "service_role";



GRANT ALL ON SEQUENCE "public"."sale_invoice_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."sale_invoice_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."sale_invoice_seq" TO "service_role";



GRANT ALL ON TABLE "public"."sale_product_rates" TO "anon";
GRANT ALL ON TABLE "public"."sale_product_rates" TO "authenticated";
GRANT ALL ON TABLE "public"."sale_product_rates" TO "service_role";



GRANT ALL ON TABLE "public"."security_guards" TO "anon";
GRANT ALL ON TABLE "public"."security_guards" TO "authenticated";
GRANT ALL ON TABLE "public"."security_guards" TO "service_role";



GRANT ALL ON TABLE "public"."service_acknowledgments" TO "anon";
GRANT ALL ON TABLE "public"."service_acknowledgments" TO "authenticated";
GRANT ALL ON TABLE "public"."service_acknowledgments" TO "service_role";



GRANT ALL ON TABLE "public"."service_delivery_notes" TO "anon";
GRANT ALL ON TABLE "public"."service_delivery_notes" TO "authenticated";
GRANT ALL ON TABLE "public"."service_delivery_notes" TO "service_role";



GRANT ALL ON TABLE "public"."service_feedback" TO "anon";
GRANT ALL ON TABLE "public"."service_feedback" TO "authenticated";
GRANT ALL ON TABLE "public"."service_feedback" TO "service_role";



GRANT ALL ON TABLE "public"."service_purchase_order_items" TO "anon";
GRANT ALL ON TABLE "public"."service_purchase_order_items" TO "authenticated";
GRANT ALL ON TABLE "public"."service_purchase_order_items" TO "service_role";



GRANT ALL ON SEQUENCE "public"."service_purchase_order_number_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."service_purchase_order_number_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."service_purchase_order_number_seq" TO "service_role";



GRANT ALL ON TABLE "public"."service_purchase_orders" TO "anon";
GRANT ALL ON TABLE "public"."service_purchase_orders" TO "authenticated";
GRANT ALL ON TABLE "public"."service_purchase_orders" TO "service_role";



GRANT ALL ON TABLE "public"."service_rates" TO "anon";
GRANT ALL ON TABLE "public"."service_rates" TO "authenticated";
GRANT ALL ON TABLE "public"."service_rates" TO "service_role";



GRANT ALL ON TABLE "public"."service_requests" TO "anon";
GRANT ALL ON TABLE "public"."service_requests" TO "authenticated";
GRANT ALL ON TABLE "public"."service_requests" TO "service_role";



GRANT ALL ON TABLE "public"."services" TO "anon";
GRANT ALL ON TABLE "public"."services" TO "authenticated";
GRANT ALL ON TABLE "public"."services" TO "service_role";



GRANT ALL ON TABLE "public"."service_requests_with_details" TO "anon";
GRANT ALL ON TABLE "public"."service_requests_with_details" TO "authenticated";
GRANT ALL ON TABLE "public"."service_requests_with_details" TO "service_role";



GRANT ALL ON TABLE "public"."service_tasks" TO "anon";
GRANT ALL ON TABLE "public"."service_tasks" TO "authenticated";
GRANT ALL ON TABLE "public"."service_tasks" TO "service_role";



GRANT ALL ON TABLE "public"."services_wise_work" TO "anon";
GRANT ALL ON TABLE "public"."services_wise_work" TO "authenticated";
GRANT ALL ON TABLE "public"."services_wise_work" TO "service_role";



GRANT ALL ON TABLE "public"."shifts" TO "anon";
GRANT ALL ON TABLE "public"."shifts" TO "authenticated";
GRANT ALL ON TABLE "public"."shifts" TO "service_role";



GRANT ALL ON TABLE "public"."shortage_note_items" TO "anon";
GRANT ALL ON TABLE "public"."shortage_note_items" TO "authenticated";
GRANT ALL ON TABLE "public"."shortage_note_items" TO "service_role";



GRANT ALL ON SEQUENCE "public"."shortage_note_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."shortage_note_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."shortage_note_seq" TO "service_role";



GRANT ALL ON TABLE "public"."shortage_notes" TO "anon";
GRANT ALL ON TABLE "public"."shortage_notes" TO "authenticated";
GRANT ALL ON TABLE "public"."shortage_notes" TO "service_role";



GRANT ALL ON TABLE "public"."stock_levels" TO "anon";
GRANT ALL ON TABLE "public"."stock_levels" TO "authenticated";
GRANT ALL ON TABLE "public"."stock_levels" TO "service_role";



GRANT ALL ON TABLE "public"."stock_transactions" TO "anon";
GRANT ALL ON TABLE "public"."stock_transactions" TO "authenticated";
GRANT ALL ON TABLE "public"."stock_transactions" TO "service_role";



GRANT ALL ON TABLE "public"."storage_deletion_queue" TO "anon";
GRANT ALL ON TABLE "public"."storage_deletion_queue" TO "authenticated";
GRANT ALL ON TABLE "public"."storage_deletion_queue" TO "service_role";



GRANT ALL ON TABLE "public"."supplier_products" TO "anon";
GRANT ALL ON TABLE "public"."supplier_products" TO "authenticated";
GRANT ALL ON TABLE "public"."supplier_products" TO "service_role";



GRANT ALL ON TABLE "public"."supplier_rates" TO "anon";
GRANT ALL ON TABLE "public"."supplier_rates" TO "authenticated";
GRANT ALL ON TABLE "public"."supplier_rates" TO "service_role";



GRANT ALL ON TABLE "public"."system_config" TO "anon";
GRANT ALL ON TABLE "public"."system_config" TO "authenticated";
GRANT ALL ON TABLE "public"."system_config" TO "service_role";



GRANT ALL ON TABLE "public"."technician_profiles" TO "anon";
GRANT ALL ON TABLE "public"."technician_profiles" TO "authenticated";
GRANT ALL ON TABLE "public"."technician_profiles" TO "service_role";



GRANT ALL ON TABLE "public"."vendor_wise_services" TO "anon";
GRANT ALL ON TABLE "public"."vendor_wise_services" TO "authenticated";
GRANT ALL ON TABLE "public"."vendor_wise_services" TO "service_role";



GRANT ALL ON TABLE "public"."vendor_scorecards" TO "anon";
GRANT ALL ON TABLE "public"."vendor_scorecards" TO "authenticated";
GRANT ALL ON TABLE "public"."vendor_scorecards" TO "service_role";



GRANT ALL ON TABLE "public"."view_attendance_by_dept" TO "anon";
GRANT ALL ON TABLE "public"."view_attendance_by_dept" TO "authenticated";
GRANT ALL ON TABLE "public"."view_attendance_by_dept" TO "service_role";



GRANT ALL ON TABLE "public"."view_financial_kpis" TO "anon";
GRANT ALL ON TABLE "public"."view_financial_kpis" TO "authenticated";
GRANT ALL ON TABLE "public"."view_financial_kpis" TO "service_role";



GRANT ALL ON TABLE "public"."view_financial_monthly_trends" TO "anon";
GRANT ALL ON TABLE "public"."view_financial_monthly_trends" TO "authenticated";
GRANT ALL ON TABLE "public"."view_financial_monthly_trends" TO "service_role";



GRANT ALL ON TABLE "public"."view_financial_revenue_by_category" TO "anon";
GRANT ALL ON TABLE "public"."view_financial_revenue_by_category" TO "authenticated";
GRANT ALL ON TABLE "public"."view_financial_revenue_by_category" TO "service_role";



GRANT ALL ON TABLE "public"."view_inventory_velocity" TO "anon";
GRANT ALL ON TABLE "public"."view_inventory_velocity" TO "authenticated";
GRANT ALL ON TABLE "public"."view_inventory_velocity" TO "service_role";



GRANT ALL ON TABLE "public"."view_inventory_summary" TO "anon";
GRANT ALL ON TABLE "public"."view_inventory_summary" TO "authenticated";
GRANT ALL ON TABLE "public"."view_inventory_summary" TO "service_role";



GRANT ALL ON TABLE "public"."view_service_performance" TO "anon";
GRANT ALL ON TABLE "public"."view_service_performance" TO "authenticated";
GRANT ALL ON TABLE "public"."view_service_performance" TO "service_role";



GRANT ALL ON TABLE "public"."visitor_bypass_audit" TO "anon";
GRANT ALL ON TABLE "public"."visitor_bypass_audit" TO "authenticated";
GRANT ALL ON TABLE "public"."visitor_bypass_audit" TO "service_role";



GRANT ALL ON TABLE "public"."visitor_photo_metadata" TO "anon";
GRANT ALL ON TABLE "public"."visitor_photo_metadata" TO "authenticated";
GRANT ALL ON TABLE "public"."visitor_photo_metadata" TO "service_role";



GRANT ALL ON TABLE "public"."visitors" TO "anon";
GRANT ALL ON TABLE "public"."visitors" TO "authenticated";
GRANT ALL ON TABLE "public"."visitors" TO "service_role";



GRANT ALL ON TABLE "public"."waitlist" TO "anon";
GRANT ALL ON TABLE "public"."waitlist" TO "authenticated";
GRANT ALL ON TABLE "public"."waitlist" TO "service_role";



GRANT ALL ON TABLE "public"."work_master" TO "anon";
GRANT ALL ON TABLE "public"."work_master" TO "authenticated";
GRANT ALL ON TABLE "public"."work_master" TO "service_role";









ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";
































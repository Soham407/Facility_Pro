-- Phase 5: Prune Ghost and Zombie Tables
DROP TABLE IF EXISTS public.asset_categories CASCADE;
DROP TABLE IF EXISTS public.assets CASCADE;
DROP VIEW IF EXISTS public.assets_with_details CASCADE;

DROP TABLE IF EXISTS public.background_verifications CASCADE;
DROP TABLE IF EXISTS public.budgets CASCADE;
DROP TABLE IF EXISTS public.buyer_accounts CASCADE;

DROP TABLE IF EXISTS public.candidate_interviews CASCADE;
DROP VIEW IF EXISTS public.candidate_interviews_with_details CASCADE;
DROP TABLE IF EXISTS public.candidates CASCADE;
DROP VIEW IF EXISTS public.candidates_with_details CASCADE;
DROP TABLE IF EXISTS public.checklist_assignments CASCADE;
DROP TABLE IF EXISTS public.checklist_response_override_audit CASCADE;
DROP TABLE IF EXISTS public.company_events CASCADE;
DROP TABLE IF EXISTS public.compliance_snapshots CASCADE;
DROP TABLE IF EXISTS public.contracts CASCADE;
DROP TABLE IF EXISTS public.credit_notes CASCADE;
DROP TABLE IF EXISTS public.daily_checklist_items CASCADE;
DROP TABLE IF EXISTS public.debit_notes CASCADE;
DROP TABLE IF EXISTS public.due_maintenance_schedules CASCADE;
DROP TABLE IF EXISTS public.emergency_contacts CASCADE;
DROP VIEW IF EXISTS public.employee_documents_with_details CASCADE;
DROP TABLE IF EXISTS public.employee_salary_structure CASCADE;
DROP VIEW IF EXISTS public.employee_salary_structure_with_details CASCADE;
DROP TABLE IF EXISTS public.financial_periods CASCADE;
DROP TABLE IF EXISTS public.gps_tracking_2026_02 CASCADE;
DROP TABLE IF EXISTS public.gps_tracking_2026_03 CASCADE;
DROP TABLE IF EXISTS public.gps_tracking_2026_04 CASCADE;
DROP TABLE IF EXISTS public.gps_tracking_2026_05 CASCADE;
DROP TABLE IF EXISTS public.gps_tracking_2026_06 CASCADE;
DROP TABLE IF EXISTS public.gps_tracking_2026_07 CASCADE;
DROP TABLE IF EXISTS public.gps_tracking_2026_08 CASCADE;
DROP TABLE IF EXISTS public.gps_tracking_2026_09 CASCADE;
DROP TABLE IF EXISTS public.gps_tracking_2026_10 CASCADE;
DROP TABLE IF EXISTS public.gps_tracking_2026_11 CASCADE;
DROP TABLE IF EXISTS public.gps_tracking_2026_12 CASCADE;
DROP TABLE IF EXISTS public.gps_tracking_default CASCADE;
DROP TABLE IF EXISTS public.guard_gps_tracking CASCADE;
DROP TABLE IF EXISTS public.guard_panic_alerts CASCADE;
DROP TABLE IF EXISTS public.holiday_master CASCADE;
DROP TABLE IF EXISTS public.horticulture_seasonal_plans CASCADE;
DROP TABLE IF EXISTS public.horticulture_tasks CASCADE;
DROP TABLE IF EXISTS public.horticulture_zones CASCADE;
DROP VIEW IF EXISTS public.indents_with_details CASCADE;
DROP TABLE IF EXISTS public.job_materials_used CASCADE;
DROP TABLE IF EXISTS public.job_photos CASCADE;
DROP TABLE IF EXISTS public.job_sessions CASCADE;
DROP TABLE IF EXISTS public.login_rate_limits CASCADE;
DROP TABLE IF EXISTS public.maintenance_schedules CASCADE;
DROP TABLE IF EXISTS public.material_arrival_evidence CASCADE;
DROP TABLE IF EXISTS public.material_arrival_logs CASCADE;
DROP TABLE IF EXISTS public.material_receipt_items CASCADE;
DROP VIEW IF EXISTS public.material_receipts_with_details CASCADE;
DROP TABLE IF EXISTS public.notification_logs CASCADE;

DROP TABLE IF EXISTS public.oversight_tickets CASCADE;
DROP TABLE IF EXISTS public.payment_methods CASCADE;
DROP VIEW IF EXISTS public.payslips_with_details CASCADE;
DROP TABLE IF EXISTS public.personnel_dispatches CASCADE;
DROP TABLE IF EXISTS public.pest_control_chemicals CASCADE;
DROP TABLE IF EXISTS public.pest_control_ppe_verifications CASCADE;
DROP TABLE IF EXISTS public.pest_control_spill_kits CASCADE;
DROP TABLE IF EXISTS public.printing_ad_bookings CASCADE;
DROP TABLE IF EXISTS public.printing_ad_spaces CASCADE;
DROP TABLE IF EXISTS public.product_subcategories CASCADE;
DROP TABLE IF EXISTS public.purchase_bill_items CASCADE;
DROP VIEW IF EXISTS public.purchase_bills_with_details CASCADE;
DROP VIEW IF EXISTS public.purchase_orders_with_details CASCADE;
DROP TABLE IF EXISTS public.push_tokens CASCADE;
DROP TABLE IF EXISTS public.qr_batch_logs CASCADE;
DROP TABLE IF EXISTS public.qr_codes CASCADE;
DROP VIEW IF EXISTS public.qr_codes_with_batch_info CASCADE;
DROP TABLE IF EXISTS public.qr_scans CASCADE;
DROP TABLE IF EXISTS public.reconciliation_lines CASCADE;
DROP VIEW IF EXISTS public.reconciliation_lines_with_details CASCADE;
DROP VIEW IF EXISTS public.reconciliations_with_details CASCADE;

DROP VIEW IF EXISTS public.resident_directory CASCADE;
DROP TABLE IF EXISTS public.sale_bill_items CASCADE;
DROP TABLE IF EXISTS public.sale_product_rates CASCADE;

DROP TABLE IF EXISTS public.service_delivery_notes CASCADE;
DROP TABLE IF EXISTS public.service_feedback CASCADE;
DROP TABLE IF EXISTS public.service_purchase_order_items CASCADE;

DROP VIEW IF EXISTS public.service_requests_with_details CASCADE;
DROP TABLE IF EXISTS public.services_wise_work CASCADE;
DROP TABLE IF EXISTS public.shortage_note_items CASCADE;
DROP TABLE IF EXISTS public.storage_deletion_queue CASCADE;
DROP TABLE IF EXISTS public.supplier_rates CASCADE;
DROP TABLE IF EXISTS public.system_config CASCADE;
DROP TABLE IF EXISTS public.vendor_scorecards CASCADE;
DROP TABLE IF EXISTS public.vendor_wise_services CASCADE;
DROP VIEW IF EXISTS public.view_attendance_by_dept CASCADE;
DROP VIEW IF EXISTS public.view_financial_kpis CASCADE;
DROP VIEW IF EXISTS public.view_financial_monthly_trends CASCADE;
DROP VIEW IF EXISTS public.view_financial_revenue_by_category CASCADE;
DROP VIEW IF EXISTS public.view_inventory_summary CASCADE;
DROP VIEW IF EXISTS public.view_inventory_velocity CASCADE;
DROP VIEW IF EXISTS public.view_service_performance CASCADE;
DROP TABLE IF EXISTS public.visitor_bypass_audit CASCADE;
DROP TABLE IF EXISTS public.visitor_photo_metadata CASCADE;
DROP TABLE IF EXISTS public.waitlist CASCADE;

-- Phase 5: Add missing RLS policies
ALTER TABLE public.leave_types ENABLE ROW LEVEL SECURITY;
CREATE POLICY "leave_types_select_authenticated" ON public.leave_types FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "leave_types_all_admin" ON public.leave_types FOR ALL USING (
  get_my_app_role() IN ('admin', 'super_admin', 'company_md', 'company_hod')
);
-- Migration: Add missing master data tables for Supply, Buyer, and Services modules

-- ============================================================================
-- 1. Buyer Module Masters
-- ============================================================================

-- Table: buyer_details
CREATE TABLE IF NOT EXISTS public.buyer_details (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    buyer_code VARCHAR(50) UNIQUE,
    company_name VARCHAR(255) NOT NULL,
    contact_person VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(20),
    billing_address TEXT,
    shipping_address TEXT,
    gst_number VARCHAR(20),
    pan_number VARCHAR(20),
    credit_period_days INT DEFAULT 30 CHECK (credit_period_days >= 0),
    user_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Table: unit_branch_details
CREATE TABLE IF NOT EXISTS public.unit_branch_details (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    buyer_id UUID NOT NULL REFERENCES public.buyer_details(id) ON DELETE CASCADE,
    unit_branch_code VARCHAR(50),
    unit_branch_name VARCHAR(255) NOT NULL,
    contact_person VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(20),
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(100),
    pincode VARCHAR(20),
    gst_number VARCHAR(20),
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Table: site_details
CREATE TABLE IF NOT EXISTS public.site_details (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    unit_branch_id UUID NOT NULL REFERENCES public.unit_branch_details(id) ON DELETE CASCADE,
    buyer_id UUID NOT NULL REFERENCES public.buyer_details(id) ON DELETE CASCADE,
    site_code VARCHAR(50),
    site_name VARCHAR(255) NOT NULL,
    site_type VARCHAR(100),
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(100),
    pincode VARCHAR(20),
    latitude NUMERIC(10, 8),
    longitude NUMERIC(11, 8),
    contact_person VARCHAR(255),
    phone VARCHAR(20),
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Table: asset_master
CREATE TABLE IF NOT EXISTS public.asset_master (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    site_id UUID REFERENCES public.site_details(id) ON DELETE SET NULL,
    unit_branch_id UUID REFERENCES public.unit_branch_details(id) ON DELETE SET NULL,
    buyer_id UUID REFERENCES public.buyer_details(id) ON DELETE SET NULL,
    asset_code VARCHAR(50) UNIQUE NOT NULL,
    asset_name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    model_number VARCHAR(100),
    serial_number VARCHAR(100),
    manufacturer VARCHAR(100),
    installation_date DATE,
    warranty_expiry DATE,
    purchase_cost NUMERIC(15, 2),
    location_description TEXT,
    status VARCHAR(50) DEFAULT 'operational',
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================================
-- 2. Supply Module Masters
-- ============================================================================

-- Table: suppliers_wise_products
CREATE TABLE IF NOT EXISTS public.suppliers_wise_products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    supplier_id UUID NOT NULL REFERENCES public.suppliers(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
    supplier_product_code VARCHAR(100),
    remarks TEXT,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT suppliers_wise_products_supplier_product_unique UNIQUE (supplier_id, product_id)
);

-- Table: suppliers_wise_product_rates
CREATE TABLE IF NOT EXISTS public.suppliers_wise_product_rates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    supplier_wise_product_id UUID NOT NULL REFERENCES public.suppliers_wise_products(id) ON DELETE CASCADE,
    rate NUMERIC(15, 2) NOT NULL CHECK (rate >= 0),
    effective_from DATE NOT NULL DEFAULT CURRENT_DATE,
    effective_to DATE CHECK (effective_to IS NULL OR effective_to >= effective_from),
    currency VARCHAR(10) DEFAULT 'INR',
    gst_percentage NUMERIC(5, 2) DEFAULT 0 CHECK (gst_percentage >= 0 AND gst_percentage <= 100),
    remarks TEXT,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Table: sale_product_rates
CREATE TABLE IF NOT EXISTS public.sale_product_rates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
    rate NUMERIC(15, 2) NOT NULL CHECK (rate >= 0),
    effective_from DATE NOT NULL DEFAULT CURRENT_DATE,
    effective_to DATE CHECK (effective_to IS NULL OR effective_to >= effective_from),
    currency VARCHAR(10) DEFAULT 'INR',
    gst_percentage NUMERIC(5, 2) DEFAULT 0 CHECK (gst_percentage >= 0 AND gst_percentage <= 100),
    margin_percentage NUMERIC(5, 2) DEFAULT 0 CHECK (margin_percentage >= 0),
    remarks TEXT,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================================
-- 3. Services Module Masters
-- ============================================================================

-- Table: complaint_request_nature_master
CREATE TABLE IF NOT EXISTS public.complaint_request_nature_master (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nature_code VARCHAR(50) UNIQUE,
    nature_name VARCHAR(255) NOT NULL,
    category_name VARCHAR(100),
    priority_default VARCHAR(20) DEFAULT 'medium',
    sla_resolution_hours INT DEFAULT 24,
    description TEXT,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Table: service_categories_master
CREATE TABLE IF NOT EXISTS public.service_categories_master (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_code VARCHAR(50) UNIQUE,
    category_name VARCHAR(255) NOT NULL,
    description TEXT,
    icon_url TEXT,
    display_order INT DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================================
-- 4. Triggers for updated_at
-- ============================================================================

CREATE TRIGGER update_buyer_details_updated_at
    BEFORE UPDATE ON public.buyer_details
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_unit_branch_details_updated_at
    BEFORE UPDATE ON public.unit_branch_details
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_site_details_updated_at
    BEFORE UPDATE ON public.site_details
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_asset_master_updated_at
    BEFORE UPDATE ON public.asset_master
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_suppliers_wise_products_updated_at
    BEFORE UPDATE ON public.suppliers_wise_products
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_suppliers_wise_product_rates_updated_at
    BEFORE UPDATE ON public.suppliers_wise_product_rates
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_sale_product_rates_updated_at
    BEFORE UPDATE ON public.sale_product_rates
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_complaint_request_nature_master_updated_at
    BEFORE UPDATE ON public.complaint_request_nature_master
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_service_categories_master_updated_at
    BEFORE UPDATE ON public.service_categories_master
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- 5. Indexes for Performance
-- ============================================================================

CREATE INDEX IF NOT EXISTS idx_unit_branch_details_buyer_id ON public.unit_branch_details(buyer_id);
CREATE INDEX IF NOT EXISTS idx_site_details_unit_branch_id ON public.site_details(unit_branch_id);
CREATE INDEX IF NOT EXISTS idx_site_details_buyer_id ON public.site_details(buyer_id);
CREATE INDEX IF NOT EXISTS idx_asset_master_site_id ON public.asset_master(site_id);
CREATE INDEX IF NOT EXISTS idx_suppliers_wise_products_supplier_id ON public.suppliers_wise_products(supplier_id);
CREATE INDEX IF NOT EXISTS idx_suppliers_wise_products_product_id ON public.suppliers_wise_products(product_id);
CREATE INDEX IF NOT EXISTS idx_suppliers_wise_product_rates_swp_id ON public.suppliers_wise_product_rates(supplier_wise_product_id);
CREATE INDEX IF NOT EXISTS idx_sale_product_rates_product_id ON public.sale_product_rates(product_id);

-- ============================================================================
-- 6. Row Level Security (RLS) Policies using get_my_app_role()
-- ============================================================================

ALTER TABLE public.buyer_details ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.unit_branch_details ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.site_details ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.asset_master ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.suppliers_wise_products ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.suppliers_wise_product_rates ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sale_product_rates ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.complaint_request_nature_master ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.service_categories_master ENABLE ROW LEVEL SECURITY;

-- buyer_details Policies
CREATE POLICY "buyer_details_admin_full" ON public.buyer_details
    FOR ALL TO authenticated
    USING (get_my_app_role() IN ('admin', 'super_admin'))
    WITH CHECK (get_my_app_role() IN ('admin', 'super_admin'));

CREATE POLICY "buyer_details_read_authenticated" ON public.buyer_details
    FOR SELECT TO authenticated
    USING (true);

-- unit_branch_details Policies
CREATE POLICY "unit_branch_details_admin_full" ON public.unit_branch_details
    FOR ALL TO authenticated
    USING (get_my_app_role() IN ('admin', 'super_admin'))
    WITH CHECK (get_my_app_role() IN ('admin', 'super_admin'));

CREATE POLICY "unit_branch_details_read_authenticated" ON public.unit_branch_details
    FOR SELECT TO authenticated
    USING (true);

-- site_details Policies
CREATE POLICY "site_details_admin_full" ON public.site_details
    FOR ALL TO authenticated
    USING (get_my_app_role() IN ('admin', 'super_admin'))
    WITH CHECK (get_my_app_role() IN ('admin', 'super_admin'));

CREATE POLICY "site_details_read_authenticated" ON public.site_details
    FOR SELECT TO authenticated
    USING (true);

-- asset_master Policies
CREATE POLICY "asset_master_admin_full" ON public.asset_master
    FOR ALL TO authenticated
    USING (get_my_app_role() IN ('admin', 'super_admin'))
    WITH CHECK (get_my_app_role() IN ('admin', 'super_admin'));

CREATE POLICY "asset_master_read_authenticated" ON public.asset_master
    FOR SELECT TO authenticated
    USING (true);

-- suppliers_wise_products Policies
CREATE POLICY "suppliers_wise_products_admin_full" ON public.suppliers_wise_products
    FOR ALL TO authenticated
    USING (get_my_app_role() IN ('admin', 'super_admin'))
    WITH CHECK (get_my_app_role() IN ('admin', 'super_admin'));

CREATE POLICY "suppliers_wise_products_read_authenticated" ON public.suppliers_wise_products
    FOR SELECT TO authenticated
    USING (true);

-- suppliers_wise_product_rates Policies
CREATE POLICY "suppliers_wise_product_rates_admin_full" ON public.suppliers_wise_product_rates
    FOR ALL TO authenticated
    USING (get_my_app_role() IN ('admin', 'super_admin'))
    WITH CHECK (get_my_app_role() IN ('admin', 'super_admin'));

CREATE POLICY "suppliers_wise_product_rates_read_authenticated" ON public.suppliers_wise_product_rates
    FOR SELECT TO authenticated
    USING (true);

-- sale_product_rates Policies
CREATE POLICY "sale_product_rates_admin_full" ON public.sale_product_rates
    FOR ALL TO authenticated
    USING (get_my_app_role() IN ('admin', 'super_admin'))
    WITH CHECK (get_my_app_role() IN ('admin', 'super_admin'));

CREATE POLICY "sale_product_rates_read_authenticated" ON public.sale_product_rates
    FOR SELECT TO authenticated
    USING (true);

-- complaint_request_nature_master Policies
CREATE POLICY "complaint_request_nature_master_admin_full" ON public.complaint_request_nature_master
    FOR ALL TO authenticated
    USING (get_my_app_role() IN ('admin', 'super_admin'))
    WITH CHECK (get_my_app_role() IN ('admin', 'super_admin'));

CREATE POLICY "complaint_request_nature_master_read_authenticated" ON public.complaint_request_nature_master
    FOR SELECT TO authenticated
    USING (true);

-- service_categories_master Policies
CREATE POLICY "service_categories_master_admin_full" ON public.service_categories_master
    FOR ALL TO authenticated
    USING (get_my_app_role() IN ('admin', 'super_admin'))
    WITH CHECK (get_my_app_role() IN ('admin', 'super_admin'));

CREATE POLICY "service_categories_master_read_authenticated" ON public.service_categories_master
    FOR SELECT TO authenticated
    USING (true);

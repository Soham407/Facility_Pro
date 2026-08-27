import { describe, expect, it } from "vitest";
import { readRepoFile, sourceContainsAll } from "../helpers/source-files";

describe("RLS contract: missing master data entities", () => {
  it("defines all 9 missing master data tables with strict RLS policies using get_my_app_role()", async () => {
    const migrationSource = await readRepoFile(
      "supabase/migrations/20260726071403_add_missing_master_data.sql"
    );

    const requiredTables = [
      "buyer_details",
      "unit_branch_details",
      "site_details",
      "asset_master",
      "suppliers_wise_products",
      "suppliers_wise_product_rates",
      "sale_product_rates",
      "complaint_request_nature_master",
      "service_categories_master",
    ];

    for (const table of requiredTables) {
      expect(migrationSource).toContain(`CREATE TABLE IF NOT EXISTS public.${table}`);
      expect(migrationSource).toContain(`ALTER TABLE public.${table} ENABLE ROW LEVEL SECURITY;`);
      expect(migrationSource).toContain(`CREATE POLICY "${table}_admin_full" ON public.${table}`);
      expect(migrationSource).toContain(`CREATE POLICY "${table}_read_authenticated" ON public.${table}`);
    }

    expect(
      sourceContainsAll(migrationSource, [
        "get_my_app_role() IN ('admin', 'super_admin')",
        "FOR ALL TO authenticated",
        "FOR SELECT TO authenticated",
        "BEFORE UPDATE ON",
        "update_updated_at_column()",
      ])
    ).toBe(true);
  });
});

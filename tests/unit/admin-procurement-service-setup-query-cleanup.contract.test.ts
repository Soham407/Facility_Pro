import { describe, expect, it } from "vitest";

import { readRepoFile, sourceContainsAll } from "../helpers/source-files";

describe("admin procurement/service setup query cleanup contracts", () => {
  it("keeps supplier/product active setup reads compatible with legacy status shapes", async () => {
    const suppliersHookSource = await readRepoFile("hooks/useSuppliers.ts");
    const productsHookSource = await readRepoFile("hooks/useProducts.ts");

    expect(
      sourceContainsAll(suppliersHookSource, [
        "if (filters.status === \"active\")",
        "query = query.eq(\"is_active\", true)",
        "if (filters.status === \"inactive\")",
        "query = query.eq(\"is_active\", false)",
      ])
    ).toBe(true);

    expect(
      sourceContainsAll(productsHookSource, [
        "if (filters.status === \"active\")",
        "query = query.eq(\"is_active\", true)",
        "if (filters.status === \"inactive\")",
        "query = query.eq(\"is_active\", false)",
      ])
    ).toBe(true);
  });

  it("keeps services setup reads tolerant of nullable active flags", async () => {
    const servicesHookSource = await readRepoFile("hooks/useServices.ts");

    expect(
      sourceContainsAll(servicesHookSource, [
        ".or(\"is_active.eq.true,is_active.is.null\")",
        ".order(\"service_name\")",
      ])
    ).toBe(true);
  });

  it("keeps smoke coverage for admin supplier/product/service setup loading", async () => {
    const smokeSource = await readRepoFile("e2e/admin-procurement.spec.ts");

    expect(
      sourceContainsAll(smokeSource, [
        "loads at least one supplier in admin procurement setup",
        "loads at least one product in admin procurement setup",
        "loads at least one service in admin service setup",
        "/inventory/purchase-orders",
        "/inventory/indents/create",
        "/services/masters/vendor-services",
      ])
    ).toBe(true);
  });
});

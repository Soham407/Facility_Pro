import { describe, expect, it } from "vitest";

import { readRepoFile, sourceContainsAll } from "../helpers/source-files";

describe("supplier PO, bill, return, and settlement workflow", () => {
  it("keeps dedicated supplier return handling, settlement truth, and e2e coverage in place", async () => {
    const supplierReturnsPage = await readRepoFile("app/(dashboard)/supplier/returns/page.tsx");
    const supplierWorkflowSpec = await readRepoFile("e2e/supplier-po-bill-return-settlement.spec.ts");
    const supplierReturnsRoute = await readRepoFile("app/api/supplier/returns/route.ts");
    const proxySource = await readRepoFile("proxy.ts");

    expect(
      sourceContainsAll(supplierReturnsPage, [
        "Supplier Returns",
        "useSupplierPortal",
        "useRTVTickets",
        "Return status",
        "Issue Credit Note",
        "supplierTickets",
      ])
    ).toBe(true);

    expect(
      sourceContainsAll(supplierReturnsRoute, [
        'from("users")',
        'select("supplier_id, roles(role_name)")',
        'from("rtv_tickets")',
        "supplier_id !== supplierId",
        "coerceRTVTicketRows(data).map(mapRTVTicketRow)",
      ])
    ).toBe(true);

    expect(proxySource.includes('/api/supplier/returns')).toBe(true);

    expect(
      sourceContainsAll(supplierWorkflowSpec, [
        "Supplier PO → Bill → Return → Settlement",
        "/supplier/purchase-orders",
        "/supplier/bills",
        "/supplier/returns",
        "purchase_bills",
        "rtv_tickets",
      ])
    ).toBe(true);
  });
});

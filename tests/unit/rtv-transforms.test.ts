import { describe, expect, it } from "vitest";

import { coerceRTVTicketRows } from "@/src/lib/rtv/rtvTransforms";

describe("coerceRTVTicketRows", () => {
  it("keeps only rows that satisfy the RTV ticket contract", () => {
    const rows = coerceRTVTicketRows([
      {
        id: "ticket-1",
        rtv_number: "RTV-001",
        po_id: null,
        supplier_id: "supplier-1",
        product_id: "product-1",
        receipt_id: null,
        return_reason: "Damaged",
        quantity: 2,
      },
      {
        error: true,
      },
      null,
    ]);

    expect(rows).toEqual([
      expect.objectContaining({
        id: "ticket-1",
        rtv_number: "RTV-001",
        supplier_id: "supplier-1",
        product_id: "product-1",
        quantity: 2,
      }),
    ]);
  });
});

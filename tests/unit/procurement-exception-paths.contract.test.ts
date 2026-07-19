import { describe, expect, it } from "vitest";

import { readRepoFile, sourceContainsAll } from "../helpers/source-files";

describe("procurement exception path contracts", () => {
  it("keeps shortage note creation, resolution, and notification branches explicit", async () => {
    const hookSource = await readRepoFile("hooks/useShortageNotes.ts");
    const pageSource = await readRepoFile("app/(dashboard)/tickets/quality/page.tsx");

    expect(
      sourceContainsAll(hookSource, [
        'status: "open"',
        'notificationType: "shortage_note_raised"',
        "resolveNote",
        '.update({ status: "resolved", resolution })',
      ])
    ).toBe(true);

    expect(
      sourceContainsAll(pageSource, [
        'issueType: "Shortage"',
        '"Damaged"',
        'qualityStatus === "partial"',
        'qualityStatus === "rejected"',
        'status = "Resolved"',
        'status = "Debit Note Raised"',
        'status = "Returned"',
        "Shortage Notes",
      ])
    ).toBe(true);
  });

  it("keeps RTV dispatch, vendor acceptance, credit note, and rejection branches explicit", async () => {
    const hookSource = await readRepoFile("hooks/useRTVTickets.ts");
    const pageSource = await readRepoFile("app/(dashboard)/tickets/returns/page.tsx");

    expect(
      sourceContainsAll(hookSource, [
        "pending_dispatch",
        "in_transit",
        "accepted_by_vendor",
        "credit_note_issued",
      ])
    ).toBe(true);

    expect(
      sourceContainsAll(pageSource, [
        "CLOSED_RTV_STATUSES",
        "pending_dispatch",
        "in_transit",
        "accepted_by_vendor",
        "credit_note_issued",
        "credit_issued",
        "rejected_by_vendor",
        "Mark In Transit",
        "Accepted by Vendor",
        "Credit Note Issued",
        "Reject by Vendor",
      ])
    ).toBe(true);
  });
});

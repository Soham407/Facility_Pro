import { describe, expect, it } from "vitest";

import { readRepoFile, sourceContainsAll } from "../helpers/source-files";

describe("issue #33 society visitor/resident operations query cleanup contracts", () => {
  it("keeps society visitor reads pinned to explicit relations and managed-society scoping", async () => {
    const visitorsHookSource = await readRepoFile("hooks/useVisitors.ts");

    expect(
      sourceContainsAll(visitorsHookSource, [
        "flat:flats!visitors_flat_id_fkey(",
        "building:buildings!flats_building_id_fkey(",
        "query = query.in(\"flat_id\", managedFlatIds)",
        "if (!isAdmin && managedSocietyIds.length === 0)",
      ]),
    ).toBe(true);
  });

  it("keeps guard gate/location reads on the active location source", async () => {
    const attendanceSource = await readRepoFile("hooks/useAttendance.ts");

    expect(
      sourceContainsAll(attendanceSource, [
        ".from(\"company_locations\")",
        ".eq(\"location_code\", MAIN_GATE_CODE)",
        ".eq(\"is_active\", true)",
        ".maybeSingle()",
      ]),
    ).toBe(true);
  });

  it("keeps smoke coverage for society manager visitor/resident operations setup reads", async () => {
    const smokeSource = await readRepoFile("e2e/guard-routine.spec.ts");

    expect(
      sourceContainsAll(smokeSource, [
        "society manager can load one visitor and one resident record on operations surfaces",
        "/society/visitors",
        "/society/residents",
        "Main gate",
      ]),
    ).toBe(true);
  });
});

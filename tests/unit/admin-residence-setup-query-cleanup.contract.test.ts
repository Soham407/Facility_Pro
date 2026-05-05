import { describe, expect, it } from "vitest";

import { readRepoFile, sourceContainsAll } from "../helpers/source-files";

describe("issue #31 admin residence setup query cleanup contracts", () => {
  it("keeps a one-record linked read probe for residence setup and active gate/location", async () => {
    const pageSource = await readRepoFile("app/(dashboard)/admin/residents/page.tsx");
    const probeSource = await readRepoFile("src/lib/admin/residenceSetupReadProbe.ts");

    expect(
      sourceContainsAll(pageSource, [
        "probeAdminResidenceSetupReads",
        "Residence setup data check failed",
      ])
    ).toBe(true);

    expect(
      sourceContainsAll(probeSource, [
        '.from("societies")',
        '.select("id, society_name")',
        '.eq("is_active", true)',
        ".limit(1)",
        ".maybeSingle()",
        '.from("buildings")',
        '.eq("society_id", societyRow.id)',
        '.from("flats")',
        '.eq("building_id", buildingRow.id)',
        '.from("residents")',
        '.eq("flat_id", flatRow.id)',
        '.from("company_locations")',
      ])
    ).toBe(true);
  });
});

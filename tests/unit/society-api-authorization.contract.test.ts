import { describe, expect, it } from "vitest";

import { readRepoFile, sourceContainsAll } from "../helpers/source-files";

describe("society API authorization contracts", () => {
  it("keeps resident management API restricted to admin and society manager roles", async () => {
    const source = await readRepoFile("app/api/society/residents/route.ts");
    const rolesSource = await readRepoFile("src/lib/auth/roles.ts");

    expect(
      sourceContainsAll(source, [
        '"admin"',
        '"super_admin"',
        '"society_manager"',
        "RESIDENT_MANAGEMENT_ROLES",
      ]),
    ).toBe(true);

    const residentManagementRoles = source.match(/const RESIDENT_MANAGEMENT_ROLES = new Set\(\[([\s\S]*?)\]\);/)?.[1] ?? "";
    expect(residentManagementRoles).not.toContain("security_guard");
    expect(residentManagementRoles).not.toContain("security_supervisor");
    expect(rolesSource).not.toContain('"/society/residents"');
  });

  it("scopes guard and supervisor visitor mutations to assigned guard/location records", async () => {
    const source = await readRepoFile("app/api/society/visitors/[visitorId]/route.ts");

    expect(
      sourceContainsAll(source, [
        "getSecurityScopeForUser",
        "entry_guard_id",
        "entry_location_id",
        "scope.guardIds.has",
        "scope.locationIds.has",
        "if (!(await canManageVisitor(visitorId, auth.userId!, auth.roleName)))",
      ]),
    ).toBe(true);
  });
});

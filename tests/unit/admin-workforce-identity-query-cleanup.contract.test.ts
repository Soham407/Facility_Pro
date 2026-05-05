import { describe, expect, it } from "vitest";

import { readRepoFile, sourceContainsAll } from "../helpers/source-files";

describe("admin workforce identity query cleanup contracts", () => {
  it("keeps admin workforce identity reads pinned to explicit relation joins", async () => {
    const source = await readRepoFile("hooks/useEmployees.ts");

    expect(
      sourceContainsAll(source, [
        ".from(\"employees\")",
        "designations:designations!designation_id(designation_name)",
        ".from(\"users\")",
        "roles!role_id(role_name)",
        ".from(\"security_guards\")",
        "assigned_location:company_locations!assigned_location_id(location_name)",
      ])
    ).toBe(true);
  });

  it("keeps smoke coverage on admin workforce setup surfaces", async () => {
    const smokeSource = await readRepoFile("e2e/workflow-dead-ui.spec.ts");

    expect(
      sourceContainsAll(smokeSource, [
        "services/security: guard list and GPS tracking load",
        "company/employees: Add Employee navigates to create page",
        "company/users: user master loads without query errors",
      ])
    ).toBe(true);
  });
});

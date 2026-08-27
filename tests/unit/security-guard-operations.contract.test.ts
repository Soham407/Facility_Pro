import { describe, expect, it } from "vitest";

import { readRepoFile, sourceContainsAll, sourceContainsNone } from "../helpers/source-files";

describe.skip("issue #34 security guard operations query cleanup contracts", () => {
  it("keeps the guard station on the active guard, panic, and attendance sources", async () => {
    const guardHooks = await readRepoFile("hooks/useSecurityGuards.ts");
    const panicHistory = await readRepoFile("hooks/usePanicAlertHistory.ts");
    const panicSubscription = await readRepoFile("hooks/usePanicAlertSubscription.ts");
    const attendanceHook = await readRepoFile("hooks/useAttendance.ts");

    expect(
      sourceContainsAll(guardHooks, [
        '.from("security_guards")',
        '.from("company_locations")',
        '.from("employee_shift_assignments")',
        '.from("attendance_logs")',
        '.from("panic_alerts")',
      ]),
    ).toBe(true);

    expect(
      sourceContainsAll(panicHistory, [
        '.from("panic_alerts")',
        "guard:security_guards(",
        "location:company_locations(",
        'import { getCurrentEmployeeId }',
      ]),
    ).toBe(true);

    expect(
      sourceContainsAll(panicSubscription, [
        '.from("panic_alerts")',
        "guard:security_guards (",
        "location:company_locations (",
        'import { getCurrentEmployeeId }',
      ]),
    ).toBe(true);

    expect(
      sourceContainsAll(attendanceHook, [
        '.from("attendance_logs")',
        '.from("employee_shift_assignments")',
        '.from("company_locations")',
        '.eq("location_code", MAIN_GATE_CODE)',
        '.eq("is_active", true)',
        '.maybeSingle()',
      ]),
    ).toBe(true);

    expect(
      sourceContainsNone(attendanceHook, [
        '.from("legacy_guard_locations")',
        '.from("guard_locations")',
      ]),
    ).toBe(true);
  });

  it("keeps the checklist and emergency surfaces on their active tables", async () => {
    const checklistPage = await readRepoFile("app/(dashboard)/society/checklists/page.tsx");
    const panicPage = await readRepoFile("app/(dashboard)/society/panic-alerts/page.tsx");
    const statsHook = await readRepoFile("hooks/useSocietyStats.ts");

    expect(
      sourceContainsAll(checklistPage, [
        '.from("daily_checklists")',
        '.from("daily_checklist_items")',
        '.from("checklist_responses")',
        '.eq("is_active", true)',
      ]),
    ).toBe(true);

    expect(
      sourceContainsAll(panicPage, [
        "usePanicAlertHistory",
        ".createSignedUrl(",
      ]),
    ).toBe(true);

    expect(
      sourceContainsAll(statsHook, [
        '.from("security_guards")',
        '.from("attendance_logs")',
        '.from("checklist_responses")',
      ]),
    ).toBe(true);
  });
});

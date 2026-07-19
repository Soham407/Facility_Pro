import { describe, expect, it } from "vitest";

import {
  readRepoFile,
  sourceContainsAll,
  sourceContainsNone,
} from "../helpers/source-files";

describe("production surface freeze", () => {
  it("keeps test-only dashboard chunks out of the checked-in production service worker", async () => {
    const serviceWorker = await readRepoFile("public/sw.js");

    expect(
      sourceContainsNone(serviceWorker, [
        "app/(dashboard)/test-guard/",
        "app/(dashboard)/test-resident/",
        "app/(dashboard)/test-delivery/",
      ])
    ).toBe(true);
  });

  it("keeps printing and advertising as an admin-owned production service surface", async () => {
    const buyerDashboard = await readRepoFile("app/(dashboard)/buyer/page.tsx");
    const buyerRequestForm = await readRepoFile("app/(dashboard)/buyer/requests/new/page.tsx");
    const deploymentMasters = await readRepoFile("hooks/useServiceDeploymentMasters.ts");
    const printingRoute = await readRepoFile("app/(dashboard)/services/printing/page.tsx");

    expect(sourceContainsNone(buyerDashboard, ["Printing & Advertising", "category=printing"])).toBe(true);
    expect(sourceContainsNone(buyerRequestForm, ["Printing Services Request", 'printing: "printing"'])).toBe(true);
    expect(sourceContainsNone(deploymentMasters, ['value: "printing"', "printing & advertising"])).toBe(true);
    expect(sourceContainsAll(printingRoute, ["Printing & Advertising", "IDPrintingModule", "AdBookingDialog"])).toBe(true);
    expect(sourceContainsNone(printingRoute, ["notFound()"])).toBe(true);
  });

  it("hides known incomplete action controls instead of surfacing unavailable toasts", async () => {
    const acDashboard = await readRepoFile("components/dashboards/ACTechnicianDashboard.tsx");
    const pestDashboard = await readRepoFile("components/dashboards/PestControlTechnicianDashboard.tsx");
    const serviceBoyDashboard = await readRepoFile("components/dashboards/ServiceBoyDashboard.tsx");
    const hodDashboard = await readRepoFile("components/dashboards/HODDashboard.tsx");
    const assetDetail = await readRepoFile("app/(dashboard)/assets/[id]/page.tsx");

    for (const source of [acDashboard, pestDashboard, serviceBoyDashboard]) {
      expect(sourceContainsNone(source, ["handleAddPhoto", "Add Photo", "Photo upload is not available"])).toBe(true);
    }

    expect(sourceContainsNone(hodDashboard, ["Filter Dept", "Department filter is not available"])).toBe(true);
    expect(sourceContainsNone(assetDetail, ["Activity History", "Activity history is not available"])).toBe(true);
  });
});

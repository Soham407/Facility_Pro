import { describe, expect, it } from "vitest";

import { readRepoFile, sourceContainsAll, sourceContainsNone } from "../helpers/source-files";

describe("mobile app contracts", () => {
  it("keeps the login preview lane dev-only and hidden once a demo backend is configured", async () => {
    const authSource = await readRepoFile("../Solvesxx_mobile/src/lib/auth.ts");
    const loginSource = await readRepoFile("../Solvesxx_mobile/src/screens/auth/LoginScreen.tsx");

    expect(
      sourceContainsAll(authSource, [
        "if (!__DEV__ || isDemoOtpBackendConfigured())",
        "return null;",
        "getDevPreviewCredentials()",
        "isDevPreviewPhone",
        "isDevPreviewOtp",
        "getDevPreviewRole",
        "Demo OTP backend URL is not configured.",
      ])
    ).toBe(true);

    expect(
      sourceContainsAll(loginSource, [
        "Test / Preview Access",
        "Internal QA only.",
        "Preview buyer",
        "Preview AC technician",
        "Staging email sign-in",
      ])
    ).toBe(true);

    expect(sourceContainsNone(loginSource, ["TODO", "stub", "coming soon"])).toBe(true);
  });

  it("renders guard photo capture previews from the captured uri instead of a generic placeholder", async () => {
    const source = await readRepoFile("../Solvesxx_mobile/src/components/guard/PhotoCapture.tsx");

    expect(
      sourceContainsAll(source, [
        "import { Image, View, Text, Pressable, StyleSheet, ActivityIndicator, Alert } from 'react-native';",
        "source={{ uri: capturedPhotoUri }}",
        "Photo captured",
        "Ready to upload",
        "previewImage",
      ])
    ).toBe(true);

    expect(sourceContainsNone(source, ["UploadIcon"])).toBe(true);
  });

  it("keeps service proof capture locked behind attendance and proof-stage validation", async () => {
    const source = await readRepoFile("../Solvesxx_mobile/src/screens/service/ServiceProofScreen.tsx");

    expect(
      sourceContainsAll(source, [
        "Complete selfie attendance before capturing service proof.",
        "Use delivery proof capture for delivery tasks.",
        "Delivery proof is only available on delivery tasks.",
        "await attachTaskProof(selectedTask.id, stage, photo.uri);",
      ])
    ).toBe(true);
  });

  it("keeps the mobile navigator and onboarding flow on the right route for each role", async () => {
    const appNavigatorSource = await readRepoFile("../Solvesxx_mobile/src/navigation/AppNavigator.tsx");
    const authNavigatorSource = await readRepoFile("../Solvesxx_mobile/src/navigation/AuthNavigator.tsx");
    const onboardingNavigatorSource = await readRepoFile("../Solvesxx_mobile/src/navigation/OnboardingNavigator.tsx");
    const guardNavigatorSource = await readRepoFile("../Solvesxx_mobile/src/navigation/GuardNavigator.tsx");

    expect(
      sourceContainsAll(appNavigatorSource, [
        "if (profile?.role === 'security_guard' && !profile.employeePhotoUrl)",
        "return 'profile-photo';",
        "return 'geo-fence';",
        "if (session && isBiometricLocked)",
        "pendingStep ? (",
        "<OnboardingNavigator key={pendingStep} initialStep={pendingStep} />",
        "<RoleNavigator role={profile?.role ?? null} />",
      ])
    ).toBe(true);

    expect(
      sourceContainsAll(authNavigatorSource, [
        "const showStagingEmailLogin = Boolean(getDevPreviewCredentials());",
        "showStagingEmailLogin ? <Stack.Screen component={EmailLoginScreen} name=\"EmailLogin\" /> : null",
      ])
    ).toBe(true);

    expect(
      sourceContainsAll(onboardingNavigatorSource, [
        "biometric: 'BiometricSetup'",
        "'profile-photo': 'ProfilePhoto'",
        "'geo-fence': 'GeoFenceCalibration'",
      ])
    ).toBe(true);

    expect(
      sourceContainsAll(guardNavigatorSource, [
        "tabBarButtonTestID: 'qa_guard_tab_home'",
        "tabBarButtonTestID: 'qa_guard_tab_checklist'",
        "tabBarButtonTestID: 'qa_guard_tab_visitors'",
        "tabBarButtonTestID: 'qa_guard_tab_contacts'",
      ])
    ).toBe(true);
  });

  it("keeps the guard geofence break flow wired from store through the home screen and monitor", async () => {
    const storeSource = await readRepoFile("../Solvesxx_mobile/src/store/useGuardStore.ts");
    const gpsSource = await readRepoFile("../Solvesxx_mobile/src/lib/gpsService.ts");
    const homeSource = await readRepoFile("../Solvesxx_mobile/src/screens/guard/GuardHomeScreen.tsx");

    expect(
      sourceContainsAll(storeSource, [
        "geofenceBreakUntilAt: null",
        "requestGeofenceBreak: async (durationMinutes)",
        "clearGeofenceBreak: async () =>",
        "setGeofenceBreakUntilAt(hydratedState.geofenceBreakUntilAt);",
      ])
    ).toBe(true);

    expect(
      sourceContainsAll(gpsSource, [
        "geofenceBreakUntilAt: number | null",
        "setGeofenceBreakUntilAt(value: string | number | null)",
        "if (state.geofenceBreakUntilAt && Date.now() < state.geofenceBreakUntilAt)",
        "if (state.geofenceBreakUntilAt && Date.now() >= state.geofenceBreakUntilAt)",
      ])
    ).toBe(true);

    expect(
      sourceContainsAll(homeSource, [
        "qa_guard_geofence_break",
        "Pause geofence 15m",
        "End geofence break",
        "Monitoring paused until",
      ])
    ).toBe(true);
  });

  it("lets the buyer mobile ledger record outstanding invoice payments and settle partial dues", async () => {
    const storeSource = await readRepoFile("../Solvesxx_mobile/src/store/useBuyerStore.ts");
    const invoiceSource = await readRepoFile("../Solvesxx_mobile/src/screens/buyer/BuyerInvoicesScreen.tsx");

    expect(
      sourceContainsAll(storeSource, [
        "recordInvoicePayment: (input: { id: string; amountPaise: number }) => Promise<{ updated: boolean }>",
        "if (!paymentAmount)",
        "return {",
        "updated: false,",
        "updated: true,",
        "paymentStatus: nextDue === 0 ? 'paid' : 'partial'",
        "dueAmountPaise: nextDue",
        "Buyer recorded the final payment from the mobile invoice desk.",
      ])
    ).toBe(true);

    expect(
      sourceContainsAll(invoiceSource, [
        "const recordInvoicePayment = useBuyerStore((state) => state.recordInvoicePayment);",
        "qa_buyer_invoice_payment_amount_",
        "qa_buyer_invoice_payment_",
        "Record payment",
        "Enter a positive payment amount before recording payment.",
        "Payment for",
        "could not be recorded.",
      ])
    ).toBe(true);
  });

  it("lets the supplier mobile billing lane mark AP receipts as paid instead of freezing on partial status", async () => {
    const storeSource = await readRepoFile("../Solvesxx_mobile/src/store/useSupplierStore.ts");
    const billSource = await readRepoFile("../Solvesxx_mobile/src/screens/supplier/SupplierBillingScreen.tsx");

    expect(
      sourceContainsAll(storeSource, [
        "recordBillPayment: (id: string) => Promise<{ updated: boolean }>",
        "paymentStatus: 'paid'",
        "status: 'paid'",
        "Buyer/AP payment received and closed from the mobile supplier desk.",
      ])
    ).toBe(true);

    expect(
      sourceContainsAll(billSource, [
        "const recordBillPayment = useSupplierStore((state) => state.recordBillPayment);",
        "qa_supplier_bill_mark_paid_",
        "Mark payment received",
        "could not be marked as paid from its current state.",
      ])
    ).toBe(true);
  });

  it("advances every dispatched supplier PO during portal refresh instead of only the newest one", async () => {
    const storeSource = await readRepoFile("../Solvesxx_mobile/src/store/useSupplierStore.ts");
    const homeSource = await readRepoFile("../Solvesxx_mobile/src/screens/supplier/SupplierHomeScreen.tsx");

    expect(
      sourceContainsAll(storeSource, [
        "refreshPortal: () => Promise<{ receivedCount: number }>",
        "const dispatchedPoIds = sortPOsByCreatedAt(get().pos)",
        ".filter((po) => po.status === 'dispatched')",
        ".map((po) => po.id);",
        "const receivedCount = dispatchedPoIds.length;",
        "dispatchedPoIds.includes(po.id) && po.status === 'dispatched'",
        "return {",
        "receivedCount,",
      ])
    ).toBe(true);

    expect(
      sourceContainsAll(homeSource, [
        "const result = await refreshPortal();",
        "result.receivedCount",
        "moved to received",
        "latest local PO state",
      ])
    ).toBe(true);
  });

  it("keeps supplier PO state transitions on the right sequence before acknowledge and dispatch", async () => {
    const storeSource = await readRepoFile("../Solvesxx_mobile/src/store/useSupplierStore.ts");
    const ordersSource = await readRepoFile("../Solvesxx_mobile/src/screens/supplier/SupplierOrdersScreen.tsx");
    const indentsSource = await readRepoFile("../Solvesxx_mobile/src/screens/supplier/SupplierIndentsScreen.tsx");
    const billingSource = await readRepoFile("../Solvesxx_mobile/src/screens/supplier/SupplierBillingScreen.tsx");

    expect(
      sourceContainsAll(storeSource, [
        "respondToIndent: (id: string, decision: 'accept' | 'reject') => Promise<{ updated: boolean }>",
        "acknowledgePO: async (id) =>",
        "targetPo.status !== 'sent_to_vendor'",
        "return {",
        "updated: false,",
        "updated: true,",
        "dispatchPO: async (id, input) =>",
        "targetPo.status !== 'acknowledged'",
      ])
    ).toBe(true);

    expect(
      sourceContainsAll(storeSource, [
        "submitBill: async (input) =>",
        "!['acknowledged', 'dispatched', 'received'].includes(targetPo.status)",
        "return {",
        "submitted: false,",
        "submitted: true,",
      ])
    ).toBe(true);

    expect(
      sourceContainsAll(ordersSource, [
        "result.updated",
        "could not be acknowledged from its current state",
        "could not be dispatched from its current state",
      ])
    ).toBe(true);

    expect(
      sourceContainsAll(indentsSource, [
        "const handleRespond = async (indentId: string, requestNumber: string, decision: 'accept' | 'reject') =>",
        "result.updated",
        "could not be updated from its current state",
      ])
    ).toBe(true);

    expect(
      sourceContainsAll(billingSource, [
        "const result = await submitBill({",
        "if (!result.submitted)",
        "Select a purchase order that is ready for billing.",
      ])
    ).toBe(true);
  });

  it("keeps resident denial reasons visible across the guard preview store and visitor screen", async () => {
    const guardTypesSource = await readRepoFile("../Solvesxx_mobile/src/types/guard.ts");
    const guardStoreSource = await readRepoFile("../Solvesxx_mobile/src/store/useGuardStore.ts");
    const guardVisitorsSource = await readRepoFile("../Solvesxx_mobile/src/screens/guard/GuardVisitorsScreen.tsx");
    const residentApprovalsSource = await readRepoFile("../Solvesxx_mobile/src/screens/resident/ResidentApprovalsScreen.tsx");
    const residentHomeSource = await readRepoFile("../Solvesxx_mobile/src/screens/resident/ResidentHomeScreen.tsx");

    expect(sourceContainsAll(guardTypesSource, ["rejectionReason: string | null;"])).toBe(true);

    expect(
      sourceContainsAll(guardStoreSource, [
        "rejectionReason: visitor.rejectionReason ?? null",
        "rejectionReason: null,",
        "rejectionReason: _reason?.trim() || 'Visitor denied by resident approval.'",
        "refreshVisitorApprovals: () => Promise<void>;",
        "approvalDeadlineAt = new Date(Date.now() + 15 * 60 * 1000).toISOString();",
        "approvalStatus: 'timed_out' as GuardVisitorEntry['approvalStatus'],",
        "decisionAt: visitor.decisionAt ?? new Date().toISOString(),",
      ])
    ).toBe(true);

    expect(
      sourceContainsAll(guardVisitorsSource, [
        "const refreshVisitorApprovals = useGuardStore((state) => state.refreshVisitorApprovals);",
        "void refreshVisitorApprovals();",
        "setInterval(() => {",
        "Rejection reason:",
        "visitor.rejectionReason",
      ])
    ).toBe(true);

    expect(
      sourceContainsAll(residentApprovalsSource, [
        "const refreshVisitorApprovals = useGuardStore((state) => state.refreshVisitorApprovals);",
        "void refreshVisitorApprovals();",
        "setInterval(() => {",
      ])
    ).toBe(true);

    expect(
      sourceContainsAll(residentHomeSource, [
        "const refreshVisitorApprovals = useGuardStore((state) => state.refreshVisitorApprovals);",
        "void refreshVisitorApprovals();",
        "setInterval(() => {",
      ])
    ).toBe(true);
  });

  it("keeps oversight tickets on the acknowledge-then-close sequence instead of allowing direct closure", async () => {
    const oversightStoreSource = await readRepoFile("../Solvesxx_mobile/src/store/useOversightStore.ts");
    const oversightTicketsSource = await readRepoFile("../Solvesxx_mobile/src/screens/oversight/OversightTicketsScreen.tsx");

    expect(
      sourceContainsAll(oversightStoreSource, [
        "setTicketStatus: (",
        ") => Promise<{ updated: boolean }>;",
        "(status === 'acknowledged' && ticket.status !== 'open')",
        "(status === 'closed' && ticket.status !== 'acknowledged')",
        "updated: false,",
        "updated: true,",
      ])
    ).toBe(true);

    expect(
      sourceContainsAll(oversightTicketsSource, [
        "const result = await setTicketStatus(ticketId, status);",
        "if (!result.updated)",
        "Ticket could not be updated from its current state.",
        "disabled={ticket.status !== 'acknowledged' || updatingTicketId === ticket.id}",
      ])
    ).toBe(true);
  });

  it("clears resident presence state on sign-out so the next session does not inherit stale flat members", async () => {
    const appStoreSource = await readRepoFile("../Solvesxx_mobile/src/store/useAppStore.ts");
    const notificationStoreSource = await readRepoFile("../Solvesxx_mobile/src/store/useNotificationStore.ts");

    expect(
      sourceContainsAll(appStoreSource, [
        "import { useResidentPresenceStore } from './useResidentPresenceStore';",
        "import { useNotificationStore } from './useNotificationStore';",
        "clearGuardState(),",
        "clearBuyerState(),",
        "clearSupplierState(),",
        "clearServiceState(),",
        "clearOversightState(),",
        "clearHrmsPreviewState('dev-preview-employee'),",
        "await Promise.all([",
        "useResidentPresenceStore.getState().reset(),",
        "useNotificationStore.getState().reset(),",
      ])
    ).toBe(true);

    expect(
      sourceContainsAll(notificationStoreSource, [
        "reset: () => Promise<void>;",
        "const nextState = createDefaultState(null);",
        "hasHydrated: true,",
      ])
    ).toBe(true);
  });

  it("advances every eligible buyer request during dashboard refresh instead of only the newest one", async () => {
    const storeSource = await readRepoFile("../Solvesxx_mobile/src/store/useBuyerStore.ts");
    const homeSource = await readRepoFile("../Solvesxx_mobile/src/screens/buyer/BuyerHomeScreen.tsx");
    const invoicesSource = await readRepoFile("../Solvesxx_mobile/src/screens/buyer/BuyerInvoicesScreen.tsx");

    expect(
      sourceContainsAll(storeSource, [
        "refreshDashboard: () => Promise<{ advancedCount: number }>",
        "const eligibleRequestIds = sortRequestsByCreatedAt(get().requests)",
        ".filter((request) => request.status === 'po_dispatched' || request.status === 'material_received')",
        ".map((request) => request.id);",
        "const advancedCount = eligibleRequestIds.length;",
        "eligibleRequestIds.includes(request.id)",
        "return {",
        "advancedCount,",
      ])
    ).toBe(true);

    expect(
      sourceContainsAll(homeSource, [
        "const result = await refreshDashboard();",
        "result.advancedCount",
        "moved forward",
        "Buyer order timeline refreshed with the latest local workflow state.",
      ])
    ).toBe(true);

    expect(
      sourceContainsAll(invoicesSource, [
        "acknowledgeInvoice(invoice.id).then((result) => {",
        "could not be acknowledged from its current state",
        "disputeInvoice(invoice.id, disputeDrafts[invoice.id] ?? '').then((result) => {",
        "could not be moved into dispute review.",
      ])
    ).toBe(true);
  });

  it("advances every pending service material approval during workspace refresh instead of only the first item", async () => {
    const storeSource = await readRepoFile("../Solvesxx_mobile/src/store/useServiceStore.ts");
    const homeSource = await readRepoFile("../Solvesxx_mobile/src/screens/service/ServiceHomeScreen.tsx");
    const materialsSource = await readRepoFile("../Solvesxx_mobile/src/screens/service/ServiceMaterialsScreen.tsx");
    const tasksSource = await readRepoFile("../Solvesxx_mobile/src/screens/service/ServiceTasksScreen.tsx");

    expect(
      sourceContainsAll(storeSource, [
        "refreshWorkspace: () => Promise<{ approvedCount: number }>",
        "const pendingRequestIds = get()",
        ".filter((request) => request.status === 'pending_approval')",
        ".map((request) => request.id);",
        "const approvedCount = pendingRequestIds.length;",
        "pendingRequestIds.includes(request.id)",
        "pendingRequestIds.includes(request.id) && request.taskId === task.id",
        "return {",
        "approvedCount,",
        "stockLedger: createDefaultStockLedger(role),",
        "if (get().stockLedger[request.requestType] < request.quantity)",
        "stockLedger: {",
        "[request.requestType]: state.stockLedger[request.requestType] - request.quantity,",
        "if (task.requiresResidentNotification && !task.residentNotificationSentAt)",
        "queuePreviewRoute('pest_control_alert', profile)",
        "const remainingStock = get().stockLedger[request.requestType];",
        "queuePreviewRoute('low_stock_alert', profile)",
      ])
    ).toBe(true);

    expect(
      sourceContainsAll(homeSource, [
        "const result = await refreshWorkspace();",
        "result.approvedCount",
        "moved forward locally",
        "Workspace refreshed and live location captured.",
      ])
    ).toBe(true);

    expect(
      sourceContainsAll(materialsSource, [
        "apply manager approval locally",
        "Material request submitted.",
        "const handleMarkIssued = async (requestId: string, labelName: string) => {",
        "result.updated",
        "result.reason",
        "Stock on hand",
      ])
    ).toBe(true);

    expect(
      sourceContainsAll(tasksSource, [
        "const ppeChecklist = useServiceStore((state) => state.ppeChecklist);",
        "const hasRequiredPpe = ppeChecklist.every((item) => !item.required || item.checked);",
        "Mark in transit",
        "Proof required",
        "PPE required",
        "Mark delivered",
        "Complete task",
        "Delivery proof pending",
      ])
    ).toBe(true);
  });
});

# FacilityPro Demo Checklist

> Current route-based walkthrough for the web app.
> This is a scenario checklist, not a verification record.
> Canonical status and scope still live in [root `STATUS.md`](../../../STATUS.md).

## Canonical Routes

| Role | Primary route | Focus |
| --- | --- | --- |
| Admin | `/dashboard` | Navigate into `/admin`, `/company`, `/inventory`, `/finance`, `/society`, `/services`, `/settings` |
| Buyer | `/buyer` | Requests, invoices, feedback |
| Supplier | `/supplier` | Indents, purchase orders, bills, returns |
| Security Guard | `/guard` | Guard workflow and society/security operations |
| Resident | `/resident` | Visitor decisions, visitor history, community, alerts |
| Delivery / field execution | `/delivery` or `/service-boy` | Delivery proof or general field-task execution, depending on the seeded role |

## Demo Notes

- Use production-facing routes above. Do not use `test-*` routes as canonical demo surfaces.
- `/service-boy` is a real field-execution route in the current app. Use it when the environment is seeded for `service_boy` rather than `delivery_boy`.
- If a workflow depends on notification delivery, treat transport proof as environment-dependent.
- If a workflow depends on mobile device capabilities, use the mobile app and its own testing/docs instead of the web checklist.

## Suggested Walkthrough

1. Admin
   - Verify `/dashboard` loads.
   - Navigate to `/admin`, `/company`, `/inventory`, `/finance`, `/society`, `/services`, and `/settings`.
   - Show at least one procurement workflow and one society/security workflow.
2. Buyer
   - Open `/buyer`.
   - Show request creation or request status, invoice visibility, and feedback path.
3. Supplier
   - Open `/supplier`.
   - Show indents, purchase orders, and bills or returns.
4. Guard
   - Open `/guard`.
   - Show visitor logging, checklist, or panic/security-related surface.
5. Resident
   - Open `/resident`.
   - Show visitor approval/denial, visitor history, and notifications/community surfaces.
6. Delivery / field execution
   - Open `/delivery` for delivery proof flow or `/service-boy` for general field-task execution.
   - Show assignment/proof/update flow for the seeded role.

import { registerRoleSmokeSuite } from "./helpers/auth";
import { pickRoleTestConfigs } from "./role-matrix";

registerRoleSmokeSuite(
  "Field Roles Smoke",
  pickRoleTestConfigs([
    "delivery_agent",
    "security_guard",
    "security_supervisor",
    "society_manager",
    "field_technician",
    "ac_technician",
    "pest_control_technician",
  ])
);

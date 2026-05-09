export type AppRole =
  | "admin"
  | "company_md"
  | "company_hod"
  | "account"
  | "delivery_agent"
  | "buyer"
  | "supplier"
  // security_guard and security_supervisor are sub-contracted person-roles (ADR-0010 §3).
  // They have personal logins for shift-log, visitor-log, panic-alerts, checklists.
  // NOT tracked in HRMS payroll — attendance informs SLA only.
  | "security_guard"
  | "security_supervisor"
  // society_manager is deprecated — migrate existing users to site_supervisor (PR-C).
  | "society_manager"
  | "field_technician"
  | "resident"
  | "storekeeper"
  | "site_supervisor"
  | "super_admin"
  | "ac_technician"
  | "pest_control_technician";

export const ROLE_LANDING_PATHS: Partial<Record<AppRole, string>> = {
  buyer: "/buyer",
  supplier: "/supplier",
  resident: "/resident",
  delivery_agent: "/delivery",
};

/**
 * Role-based access mapping
 * Each role can access paths starting with these prefixes
 */
export const ROLE_ACCESS: Record<AppRole, string[]> = {
  admin: ["/"],
  company_md: ["/dashboard", "/reports", "/finance"],
  company_hod: ["/dashboard", "/hrms", "/service-requests", "/tickets", "/services", "/company"],
  account: ["/dashboard", "/finance", "/reports", "/hrms/payroll"],
  delivery_agent: ["/dashboard", "/delivery"],
  buyer: ["/dashboard", "/buyer"],
  supplier: ["/dashboard", "/supplier"],
  // Guards access the guard portal + specific society sub-routes for visitor/resident lookup.
  // /society (broad) is excluded — guards must not reach society admin, billing, or management routes.
  security_guard: [
    "/dashboard",
    "/guard",
    "/society/visitors",
    "/society/residents",
    "/society/panic-alerts",
    "/hrms/attendance",
    "/hrms/leave",
  ],
  security_supervisor: [
    "/dashboard",
    "/tickets/behavior",
    "/tickets/incidents",
    "/society/visitors",
    "/society/residents",
    "/society/panic-alerts",
    "/hrms/attendance",
    "/services/security",
    "/admin/guards",
  ],
  // Deprecated — migrate users to site_supervisor via PR-C migration.
  society_manager: ["/dashboard", "/society", "/resident", "/tickets", "/finance/compliance", "/service-requests", "/hrms/attendance", "/hrms/leave"],
  field_technician: ["/dashboard", "/field-technician", "/service-requests"],
  resident: ["/resident", "/society/my-flat"],
  storekeeper: ["/dashboard", "/inventory", "/tickets/quality", "/tickets/returns"],
  site_supervisor: ["/dashboard", "/society", "/tickets", "/hrms/attendance", "/service-requests", "/services/plantation"],
  super_admin: ["/"],
  ac_technician: ["/dashboard", "/service-requests", "/services/ac", "/inventory", "/hrms/attendance", "/hrms/leave"],
  pest_control_technician: ["/dashboard", "/service-requests", "/services/pest-control", "/services/plantation", "/inventory", "/hrms/attendance", "/hrms/leave"],
};

export function hasAccess(role: AppRole, pathname: string): boolean {
  if (role === "admin" || role === "super_admin") return true;

  // Explicitly restrict guards from resident-specific portals
  if ((role === "security_guard" || role === "security_supervisor") && pathname.startsWith("/society/my-flat")) {
    return false;
  }

  const prefixes = ROLE_ACCESS[role];
  if (!prefixes) return false;
  
  // Special case for dashboard which should be accessible to all roles
  if (pathname === "/dashboard") return true;

  return prefixes.some(prefix => pathname.startsWith(prefix));
}

export function getRoleLandingPath(role: AppRole | null | undefined): string {
  if (!role) {
    return "/dashboard";
  }

  return ROLE_LANDING_PATHS[role] ?? "/dashboard";
}

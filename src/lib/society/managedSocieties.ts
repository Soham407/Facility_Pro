import { createServiceRoleClient } from "@/src/lib/platform/server";

type ServiceClient = ReturnType<typeof createServiceRoleClient>;

export async function getManagedSocietyIdsForUser(
  supabaseAdmin: ServiceClient,
  authUserId: string,
): Promise<Set<string>> {
  const employeesQuery = supabaseAdmin.from("employees");
  const employeeSelect = employeesQuery?.select?.("id");
  const employeeLookup = employeeSelect?.eq?.("auth_user_id", authUserId);

  if (!employeeLookup?.maybeSingle) {
    return new Set<string>();
  }

  const { data: employee, error: employeeError } = await employeeLookup.maybeSingle();

  if (employeeError) {
    return new Set<string>();
  }

  if (!employee?.id) {
    return new Set<string>();
  }

  const { data: societies, error: societiesError } = await supabaseAdmin
    .from("societies")
    .select("id")
    .eq("society_manager_id", employee.id);

  if (societiesError) {
    throw societiesError;
  }

  return new Set((societies ?? []).map((row) => row.id as string));
}

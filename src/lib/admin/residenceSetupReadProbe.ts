import { supabase } from "@/src/lib/supabaseClient";

type SocietyProbeRow = {
  id: string;
  society_name: string | null;
};

type BuildingProbeRow = {
  id: string;
  building_name: string | null;
  society_id: string | null;
};

type FlatProbeRow = {
  id: string;
  flat_number: string | null;
  building_id: string | null;
};

type ResidentProbeRow = {
  id: string;
  full_name: string | null;
  flat_id: string | null;
};

type LocationProbeRow = {
  id: string;
  location_name: string | null;
};

export type ResidenceSetupProbeResult = {
  society: SocietyProbeRow;
  building: BuildingProbeRow;
  flat: FlatProbeRow;
  resident: ResidentProbeRow;
  location: LocationProbeRow;
};

export async function probeAdminResidenceSetupReads(
  client: typeof supabase = supabase
): Promise<ResidenceSetupProbeResult> {
  const { data: societyRow, error: societyError } = await client
    .from("societies")
    .select("id, society_name")
    .eq("is_active", true)
    .order("society_name", { ascending: true })
    .limit(1)
    .maybeSingle();

  if (societyError) throw societyError;
  if (!societyRow?.id) {
    throw new Error("No active society found");
  }

  const { data: buildingRow, error: buildingError } = await client
    .from("buildings")
    .select("id, building_name, society_id")
    .eq("society_id", societyRow.id)
    .eq("is_active", true)
    .order("building_name", { ascending: true })
    .limit(1)
    .maybeSingle();

  if (buildingError) throw buildingError;
  if (!buildingRow?.id) {
    throw new Error("No active building found for selected society");
  }

  const { data: flatRow, error: flatError } = await client
    .from("flats")
    .select("id, flat_number, building_id")
    .eq("building_id", buildingRow.id)
    .eq("is_active", true)
    .order("flat_number", { ascending: true })
    .limit(1)
    .maybeSingle();

  if (flatError) throw flatError;
  if (!flatRow?.id) {
    throw new Error("No active flat found for selected building");
  }

  const { data: residentRow, error: residentError } = await client
    .from("residents")
    .select("id, full_name, flat_id")
    .eq("flat_id", flatRow.id)
    .eq("is_active", true)
    .order("created_at", { ascending: true })
    .limit(1)
    .maybeSingle();

  if (residentError) throw residentError;
  if (!residentRow?.id) {
    throw new Error("No active resident found for selected flat");
  }

  const { data: locationRow, error: locationError } = await client
    .from("company_locations")
    .select("id, location_name")
    .eq("is_active", true)
    .order("location_name", { ascending: true })
    .limit(1)
    .maybeSingle();

  if (locationError) throw locationError;
  if (!locationRow?.id) {
    throw new Error("No active location found");
  }

  return {
    society: societyRow as SocietyProbeRow,
    building: buildingRow as BuildingProbeRow,
    flat: flatRow as FlatProbeRow,
    resident: residentRow as ResidentProbeRow,
    location: locationRow as LocationProbeRow,
  };
}

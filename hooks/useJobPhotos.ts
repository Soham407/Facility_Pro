import { useSupabaseMutation } from "@/hooks/lib/useSupabaseMutation";
import { supabase } from "@/src/lib/supabaseClient";
import type { Database } from "@/src/types/supabase";

type JobPhotoInsert = Database["public"]["Tables"]["job_photos"]["Insert"];

export function useJobPhotos() {
  const { execute: addPhotos, isLoading: isAddingPhotos } = useSupabaseMutation<
    JobPhotoInsert[],
    void
  >(
    async (photos) => {
      if (photos.length > 0) {
        // @ts-ignore
        const { error } = await supabase.from("job_photos").insert(photos);
        if (error) throw error;
      }
    },
    { successMessage: "Photos added successfully" }
  );

  return { addPhotos, isAddingPhotos };
}

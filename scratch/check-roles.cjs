const { createClient } = require("@supabase/supabase-js");
const { loadEnvConfig } = require("@next/env");
loadEnvConfig(process.cwd());
console.log("Service Key:", process.env.SUPABASE_SERVICE_ROLE_KEY ? "EXISTS" : "MISSING");
const supabase = createClient(process.env.NEXT_PUBLIC_SUPABASE_URL, process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY);
supabase.from("roles").select("*").then(res => { console.log("Rows:", res.data?.length); console.log("Error:", res.error); });

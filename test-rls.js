const { createServerClient } = require('@supabase/ssr');
const { Buffer } = require('node:buffer');

const anonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0";
const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || 'http://127.0.0.1:54321';

async function run() {
  const adminClient = createServerClient(supabaseUrl, anonKey, {
    cookies: { getAll: () => [], setAll: () => {} }
  });
  
  const { data, error } = await adminClient.auth.signInWithPassword({
    email: 'superadmin@test.com',
    password: 'Test@1234'
  });
  
  if (error) throw error;
  
  const session = data.session;
  
  const ssrClient = createServerClient(supabaseUrl, anonKey, {
    cookies: {
      getAll: () => [{name: "sb-127-auth-token", value: "base64-" + Buffer.from(JSON.stringify(session), "utf8").toString("base64url")}],
      setAll: () => {},
      get: (name) => null
    }
  });
  
  const { data: dbData, error: dbError } = await ssrClient
    .from('users')
    .select('is_active, must_change_password, roles!inner(role_name, permissions)')
    .eq('id', session.user.id)
    .maybeSingle();
    
  console.log("Query result:", JSON.stringify(dbData, null, 2));
  console.log("Query error:", dbError);
}
run();

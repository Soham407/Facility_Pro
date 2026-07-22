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
  
  if (error) {
    console.error("Login Error:", error);
    return;
  }
  
  const session = data.session;
  console.log("Logged in successfully. Access token:", session.access_token.substring(0, 20) + "...");
  
  const json = JSON.stringify(session);
  const encoded = "base64-" + Buffer.from(json, "utf8").toString("base64url");
  
  console.log("Cookie value (first 40 chars):", encoded.substring(0, 40));
  
  const storedCookies = {
    "sb-127-auth-token": encoded
  };
  
  const ssrClient = createServerClient(supabaseUrl, anonKey, {
    cookies: {
      getAll: () => Object.entries(storedCookies).map(([n, v]) => ({name: n, value: v})),
      setAll: () => {},
      get: (name) => storedCookies[name]
    }
  });
  
  const { data: userData, error: userError } = await ssrClient.auth.getUser();
  console.log("SSR getUser() result:");
  console.log("User:", userData?.user?.id);
  console.log("Error:", userError);
}

run();

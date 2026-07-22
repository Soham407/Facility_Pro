const { chromium } = require('playwright');
const { createServerClient } = require('@supabase/ssr');
const { Buffer } = require('node:buffer');

const anonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0";
const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || 'http://127.0.0.1:54321';

async function run() {
  const adminClient = createServerClient(supabaseUrl, anonKey, {
    cookies: { getAll: () => [], setAll: () => {} }
  });
  const { data } = await adminClient.auth.signInWithPassword({
    email: 'superadmin@test.com',
    password: 'Test@1234'
  });
  const session = data.session;
  
  const json = JSON.stringify(session);
  const encoded = "base64-" + Buffer.from(json, "utf8").toString("base64url");
  const urlEncoded = encodeURIComponent(encoded);

  const cookies = [];
  let remaining = urlEncoded;
  let idx = 0;
  while (remaining.length > 0) {
    let head = remaining.slice(0, 3180);
    const lastPct = head.lastIndexOf("%");
    if (lastPct > 3180 - 3) head = head.slice(0, lastPct);
    let value = "";
    let attempt = head;
    while (attempt.length > 0) {
      try {
        value = decodeURIComponent(attempt);
        break;
      } catch {
        attempt = attempt.slice(0, attempt.length - 3);
      }
    }
    cookies.push({ name: `sb-127-auth-token.${idx}`, value, url: 'http://127.0.0.1:3000' });
    remaining = remaining.slice(head.length);
    idx++;
  }

  console.log("Injecting chunks:", cookies.length);
  
  const browser = await chromium.launch();
  const context = await browser.newContext();
  await context.addCookies(cookies);
  const page = await context.newPage();
  
  console.log("Navigating...");
  await page.goto('http://127.0.0.1:3000/dashboard');
  
  console.log("Done");
  await browser.close();
}
run();

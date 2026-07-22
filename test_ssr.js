const { createServerClient } = require('@supabase/ssr');
const { Buffer } = require('node:buffer');

const SESSION = { access_token: "mock-access", refresh_token: "mock-refresh", user: { id: "mock-id" } };
const json = JSON.stringify(SESSION);
const encoded = "base64-" + Buffer.from(json, "utf8").toString("base64url");
const urlEncoded = encodeURIComponent(encoded);

console.log("Encoded chunk:", urlEncoded);

let storedCookies = {
  "sb-127-auth-token": urlEncoded
};

const supabase = createServerClient('http://127.0.0.1:54321', 'anon', {
  cookies: {
    getAll: () => Object.entries(storedCookies).map(([n, v]) => ({name: n, value: v})),
    setAll: () => {},
    get: (name) => storedCookies[name]
  }
});

supabase.auth.getSession().then(({data, error}) => {
  console.log("Parsed session:", data.session);
  console.log("Error:", error);
});

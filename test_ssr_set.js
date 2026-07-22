const { createServerClient } = require('@supabase/ssr');

const savedCookies = [];

const supabase = createServerClient('http://127.0.0.1:54321', 'anon', {
  cookies: {
    getAll: () => [],
    setAll: (cookies) => {
      savedCookies.push(...cookies);
    }
  }
});

const session = { access_token: "mock-access", refresh_token: "mock-refresh", user: { id: "mock-id" } };

supabase.auth.setSession(session).then(() => {
  console.log("Saved Cookies:", savedCookies);
});

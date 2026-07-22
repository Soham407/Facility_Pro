const { createServerClient } = require('@supabase/ssr');
const requestedCookies = [];
const supabase = createServerClient('http://127.0.0.1:54321', 'anon', {
  cookies: {
    getAll: () => [],
    setAll: () => {},
    get: (name) => {
      requestedCookies.push(name);
      return undefined;
    }
  }
});
supabase.auth.getUser().then(() => {
  console.log("Requested Cookies:", requestedCookies);
});

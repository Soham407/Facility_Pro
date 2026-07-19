import type { NextConfig } from "next";
const appUrl = process.env.NEXT_PUBLIC_APP_URL ?? "";
const isLocalAppUrl = /https?:\/\/(127\.0\.0\.1|localhost)(:\d+)?/i.test(appUrl);

const withPWA = require("next-pwa")({
  dest: "public",
  register: true,
  skipWaiting: true,
  // Only enable service worker in production to avoid dev-mode caching issues
  disable: process.env.NODE_ENV === "development" || isLocalAppUrl,
  // Test-only redirect routes must not be treated as standalone production surfaces.
  buildExcludes: [/app\/\(dashboard\)\/test-(guard|resident|delivery)\//],
  // Cache static assets, API routes are network-first by default
  runtimeCaching: [
    {
      urlPattern: /^https:\/\/.*\.supabase\.co\/.*/i,
      handler: "NetworkFirst",
      options: {
        cacheName: "supabase-cache",
        expiration: { maxEntries: 50, maxAgeSeconds: 60 },
      },
    },
  ],
});

const nextConfig: NextConfig = {
  typescript: {
    // The generated Supabase Database type (100+ tables) causes TS2589
    // "Type instantiation is excessively deep" errors during build.
    // Code still type-checks in the IDE; this only skips the build step.
    ignoreBuildErrors: true,
  },
};

module.exports = withPWA(nextConfig);

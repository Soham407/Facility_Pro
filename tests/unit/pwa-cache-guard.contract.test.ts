import { describe, expect, it } from "vitest";

import { readRepoFile, sourceContainsAll } from "../helpers/source-files";

describe("pwa cache guard contracts", () => {
  it("disables the production service worker on localhost-style app URLs", async () => {
    const nextConfigSource = await readRepoFile("next.config.ts");

    expect(
      sourceContainsAll(nextConfigSource, [
        "NEXT_PUBLIC_APP_URL",
        "localhost",
        "127\\.0\\.0\\.1",
        "disable:",
      ])
    ).toBe(true);
  });
});

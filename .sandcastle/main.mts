// Local AFK issue runner.
//
// The Docker-backed Sandcastle provider is currently unreliable in this repo:
// worktree bind mounts intermittently start Codex without a usable workspace.
// This runner keeps the same issue planning model, but executes Codex directly
// in host git worktrees so branch isolation remains deterministic.

import { execFileSync, spawn, spawnSync } from "node:child_process";
import {
  existsSync,
  mkdirSync,
  readFileSync,
  rmSync,
  writeFileSync,
} from "node:fs";
import http from "node:http";
import os from "node:os";
import path from "node:path";

const MAX_ITERATIONS = 10;
const BATCH_SIZE = 1;
const cwd = process.cwd();
const worktreesDir = path.join(cwd, ".sandcastle", "worktrees");
const logsDir = path.join(cwd, ".sandcastle", "logs");
const orchestratorEnvPath = path.join(cwd, ".sandcastle", ".env");
const implementPromptPath = path.join(cwd, ".sandcastle", "implement-prompt.md");
const ollamaProxyPort = Number(process.env.SANDCASTLE_OLLAMA_PROXY_PORT ?? 11434);
const ollamaTarget = {
  hostname: process.env.SANDCASTLE_OLLAMA_HOST ?? "127.0.0.1",
  port: Number(process.env.SANDCASTLE_OLLAMA_PORT ?? 11435),
};

const readEnvValue = (key: string): string | undefined => {
  try {
    const content = readFileSync(orchestratorEnvPath, "utf8");
    for (const line of content.split("\n")) {
      const trimmed = line.trim();
      if (!trimmed || trimmed.startsWith("#")) continue;
      const eqIndex = trimmed.indexOf("=");
      if (eqIndex === -1) continue;
      if (trimmed.slice(0, eqIndex).trim() !== key) continue;
      let value = trimmed.slice(eqIndex + 1).trim();
      if (
        value.length >= 2 &&
        ((value[0] === '"' && value[value.length - 1] === '"') ||
          (value[0] === "'" && value[value.length - 1] === "'"))
      ) {
        value = value.slice(1, -1);
      }
      return value;
    }
  } catch {
    // Local env file is optional.
  }
  return undefined;
};

const ghToken = process.env.GH_TOKEN ?? readEnvValue("GH_TOKEN");
const codexHome = (() => {
  const configured = process.env.CODEX_HOME
    ? path.resolve(process.env.CODEX_HOME)
    : undefined;
  if (configured && existsSync(configured)) return configured;
  return path.join(os.homedir(), ".codex");
})();

if (!ghToken) {
  throw new Error(
    `GH_TOKEN is missing. Set it in ${orchestratorEnvPath} or export it before running npm run sandcastle.`,
  );
}

if (!existsSync(codexHome)) {
  throw new Error(
    `Codex auth directory not found at ${codexHome}. Run \`codex --login\` on the host first.`,
  );
}

mkdirSync(worktreesDir, { recursive: true });
mkdirSync(logsDir, { recursive: true });

const startOllamaShim = async () => {
  const targetReady = () =>
    spawnSync(
      "curl",
      ["-fsS", `http://${ollamaTarget.hostname}:${ollamaTarget.port}/v1/models`],
      { encoding: "utf8" },
    ).status === 0;

  const waitForTarget = async () => {
    for (let attempt = 0; attempt < 60; attempt += 1) {
      if (targetReady()) return;
      await new Promise((resolve) => setTimeout(resolve, 1000));
    }
    throw new Error(
      `Ollama did not start on ${ollamaTarget.hostname}:${ollamaTarget.port}.`,
    );
  };

  if (!targetReady()) {
    const serverProcess = spawn("ollama", ["serve"], {
      env: {
        ...process.env,
        OLLAMA_HOST: `127.0.0.1:${ollamaTarget.port}`,
      },
      stdio: "ignore",
      detached: true,
    });

    serverProcess.unref();
  }

  await waitForTarget();

  const server = http.createServer((req, res) => {
    const upstream = http.request(
      {
        hostname: ollamaTarget.hostname,
        port: ollamaTarget.port,
        method: req.method,
        path: req.url,
        headers: req.headers,
      },
      (upstreamRes) => {
        const isModelList =
          req.url?.includes("/models") || req.url?.includes("/tags") || false;

        if (!isModelList) {
          res.writeHead(upstreamRes.statusCode ?? 502, upstreamRes.headers);
          upstreamRes.pipe(res);
          return;
        }

        const chunks: Buffer[] = [];
        upstreamRes.on("data", (chunk) => chunks.push(Buffer.from(chunk)));
        upstreamRes.on("end", () => {
          const bodyText = Buffer.concat(chunks).toString("utf8");
          let payload: unknown = {};

          try {
            payload = JSON.parse(bodyText);
          } catch {
            payload = {};
          }

          const data = Array.isArray((payload as { data?: unknown }).data)
            ? (payload as { data: unknown[] }).data
            : Array.isArray((payload as { models?: unknown }).models)
              ? (payload as { models: unknown[] }).models
              : [];

          const rewritten = JSON.stringify({
            object: "list",
            data,
            models: data,
          });

          res.writeHead(upstreamRes.statusCode ?? 200, {
            ...upstreamRes.headers,
            "content-length": Buffer.byteLength(rewritten),
            "content-type": "application/json",
          });
          res.end(rewritten);
        });
      },
    );

    upstream.on("error", (error) => {
      res.statusCode = 502;
      res.end(String(error));
    });

    req.pipe(upstream);
  });

  await new Promise<void>((resolve, reject) => {
    server.once("error", reject);
    server.listen(ollamaProxyPort, "127.0.0.1", () => resolve());
  });
};

await startOllamaShim();

const completedIssueIds = new Set<string>();

const run = (
  command: string,
  args: string[],
  options: { cwd?: string; input?: string; allowFailure?: boolean } = {},
) => {
  const result = spawnSync(command, args, {
    cwd: options.cwd ?? cwd,
    encoding: "utf8",
    input: options.input,
    env: {
      ...process.env,
      GH_TOKEN: ghToken,
      CODEX_HOME: codexHome,
    },
    maxBuffer: 1024 * 1024 * 200,
  });

  if (result.error) throw result.error;
  if (!options.allowFailure && result.status !== 0) {
    throw new Error(
      `${command} ${args.join(" ")} failed with code ${result.status}\n${result.stderr}${result.stdout}`,
    );
  }
  return result;
};

const output = (command: string, args: string[], workdir = cwd) =>
  execFileSync(command, args, {
    cwd: workdir,
    encoding: "utf8",
    env: {
      ...process.env,
      GH_TOKEN: ghToken,
      CODEX_HOME: codexHome,
    },
    maxBuffer: 1024 * 1024 * 100,
  });

type Issue = {
  id: string;
  title: string;
  body: string;
  branch: string;
};

const slugify = (title: string) =>
  title
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "")
    .slice(0, 80);

const planIssues = (): Issue[] => {
  const raw = output("gh", [
    "issue",
    "list",
    "--state",
    "open",
    "--label",
    "ready-for-agent",
    "--limit",
    "100",
    "--json",
    "number,title,body,labels",
  ]);

  const parsed = JSON.parse(raw) as {
    number: number;
    title: string;
    body?: string;
    labels?: { name: string }[];
  }[];

  const openNumbers = new Set(parsed.map((issue) => issue.number));

  return parsed
    .filter((issue) => {
      if (completedIssueIds.has(String(issue.number))) return false;

      const labels = new Set((issue.labels ?? []).map((label) => label.name));
      if (labels.has("blocked")) return false;

      const blockers = [...(issue.body ?? "").matchAll(/Blocked by:\s*#(\d+)/gi)]
        .map((match) => Number(match[1]))
        .filter(Number.isFinite);

      return blockers.every((blocker) => !openNumbers.has(blocker));
    })
    .sort((a, b) => a.number - b.number)
    .slice(0, BATCH_SIZE)
    .map((issue) => ({
      id: String(issue.number),
      title: issue.title,
      body: issue.body ?? "",
      branch: `sandcastle/issue-${issue.number}-${slugify(issue.title)}`,
    }));
};

const branchExists = (branch: string) =>
  run("git", ["rev-parse", "--verify", branch], { allowFailure: true }).status === 0;

const prepareWorktree = (issue: Issue) => {
  const dir = path.join(worktreesDir, issue.branch.replace(/[^a-zA-Z0-9._-]+/g, "-"));
  if (existsSync(dir)) {
    run("git", ["worktree", "remove", "--force", dir], { allowFailure: true });
    rmSync(dir, { recursive: true, force: true });
  }

  if (branchExists(issue.branch)) {
    run("git", ["worktree", "add", dir, issue.branch]);
  } else {
    run("git", ["worktree", "add", "-b", issue.branch, dir, "main"]);
  }

  return dir;
};

const expandShellExpressions = (prompt: string, worktree: string) =>
  prompt.replace(/!`([^`]+)`/g, (_match, command: string) =>
    run("sh", ["-lc", command], { cwd: worktree, allowFailure: true }).stdout.trim(),
  );

const buildPrompt = (issue: Issue, worktree: string) => {
  const template = readFileSync(implementPromptPath, "utf8");
  const substituted = template
    .replaceAll("{{TASK_ID}}", issue.id)
    .replaceAll("{{ISSUE_TITLE}}", issue.title)
    .replaceAll("{{BRANCH}}", issue.branch);
  return expandShellExpressions(substituted, worktree);
};

const commitCount = (branch: string) =>
  Number(output("git", ["rev-list", `main..${branch}`, "--count"]).trim());

const agentBackend = process.env.SANDCASTLE_AGENT_BACKEND ?? "gemini";

const agentArgs = (worktree: string) => {
  if (agentBackend === "codex") {
    const model = process.env.SANDCASTLE_OSS_MODEL ?? "qwen2.5-coder:0.5b";
    return [
      "codex",
      [
        "exec",
        "--oss",
        "--local-provider",
        "ollama",
        "--model",
        model,
        "--json",
        "--dangerously-bypass-approvals-and-sandbox",
        "-c",
        'model_reasoning_effort="high"',
      ],
    ] as const;
  }

  const model = process.env.SANDCASTLE_GEMINI_MODEL ?? "gemini-2.5-flash";
  return [
    "gemini",
    [
      "-o",
      "json",
      "-y",
      "-m",
      model,
      "--include-directories",
      cwd,
    ],
  ] as const;
};

const runIssue = (issue: Issue) => {
  const worktree = prepareWorktree(issue);
  const prompt = buildPrompt(issue, worktree);
  const logPath = path.join(
    logsDir,
    `${issue.branch.replace(/[^a-zA-Z0-9._-]+/g, "-")}-local-runner.log`,
  );

  console.log(`[implementer-${issue.id}] Worktree: ${worktree}`);
  console.log(`[implementer-${issue.id}] Log: ${logPath}`);

  const [command, args] = agentArgs(worktree);
  const result = run(command, args, {
    cwd: worktree,
    input: prompt,
    allowFailure: true,
  });

  writeFileSync(
    logPath,
    [
      `--- Run started: ${new Date().toISOString()} ---`,
      `Issue: ${issue.id} ${issue.title}`,
      `Branch: ${issue.branch}`,
      "",
      "STDOUT",
      result.stdout,
      "",
      "STDERR",
      result.stderr,
      "",
    ].join("\n"),
  );

  if (result.status !== 0) {
    console.error(
      `[implementer-${issue.id}] ${command} failed with code ${result.status}. See ${logPath}`,
    );
    return false;
  }

  const commits = commitCount(issue.branch);
  if (commits <= 0) {
    console.log(`[implementer-${issue.id}] No commits produced.`);
    return false;
  }

  console.log(`[implementer-${issue.id}] Produced ${commits} commit(s).`);
  return true;
};

const mergeIssue = (issue: Issue) => {
  console.log(`[merger] Merging ${issue.branch}`);
  run("git", ["merge", issue.branch, "--no-edit"]);
  run("npm", ["run", "typecheck"]);
  run("npm", ["run", "test"], { allowFailure: true });
  run("gh", ["issue", "edit", issue.id, "--remove-label", "ready-for-agent"], {
    allowFailure: true,
  });
  run("gh", ["issue", "close", issue.id, "--comment", "Merged via local sandcastle runner"], {
    allowFailure: true,
  });
  completedIssueIds.add(issue.id);
};

for (let iteration = 1; iteration <= MAX_ITERATIONS; iteration++) {
  console.log(`\n=== Iteration ${iteration}/${MAX_ITERATIONS} ===\n`);

  const issues = planIssues();
  if (issues.length === 0) {
    console.log("No unblocked issues to work on. Exiting.");
    break;
  }

  console.log(`Planning complete. ${issues.length} issue(s) to run:`);
  for (const issue of issues) {
    console.log(`  ${issue.id}: ${issue.title} -> ${issue.branch}`);
  }

  const completed = issues.filter(runIssue);
  if (completed.length === 0) {
    console.log("No completed branches to merge this round.");
    break;
  }

  for (const issue of completed) {
    mergeIssue(issue);
  }
}

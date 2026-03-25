---
name: codex-delegate
description: This skill delegates implementation tasks to Codex CLI while Claude retains planning and review. It should be used when the user wants to hand off coding work to Codex, delegate implementation, run codex on a task, or use their GPT Pro subscription for code generation. Trigger on phrases like "have codex implement this", "delegate to codex", "codex build this", "hand off to codex", "use codex for implementation", or when a design/plan is ready and the user wants implementation without manual copy-paste.
---

# Codex Delegate

Hand off implementation tasks to Codex CLI while Claude retains planning, review, and orchestration. Uses the GPT Pro subscription — zero additional API cost.

## Why This Exists

The manual workflow is: Claude writes a spec → user copy-pastes to Codex → Codex implements → user copy-pastes results back to Claude. This skill automates the middle steps.

## How It Works

1. **Claude formats the task** as a Codex-ready prompt (clear, self-contained, implementation-focused)
2. **Claude calls `codex exec`** via Bash, piping the prompt via stdin
3. **Codex implements** in the current working directory using the GPT Pro subscription
4. **Claude reviews the results** — reads changed files, git diff, Codex's summary

## Workflow

### Step 1: Prepare the Prompt

Before delegating, construct a self-contained implementation prompt. Codex reads AGENTS.md automatically, but it needs explicit context about what to build. Include:

- **What to implement** — specific feature, fix, or task
- **Acceptance criteria** — how to know it's done
- **Key files** — which files to read and modify
- **Constraints** — patterns to follow, things to avoid
- **Tests** — what tests to write or run

Format as a clear, imperative prompt. Don't assume Codex has conversational context — it starts fresh.

**Example prompt:**
```
Implement the GrantSource model and database schema for the grant-pipeline project.

Requirements:
- Create src/models/grant_source.py with Pydantic model
- Fields: id, name, url, source_type (federal/state/foundation/corporate), check_frequency, last_checked, active
- Create src/db/migrations/001_grant_sources.sql
- Add CRUD operations in src/db/grant_sources.py
- Write tests in tests/test_grant_sources.py

Constraints:
- Use SQLite via aiosqlite
- Follow existing patterns in src/models/ if any exist
- All dates as ISO 8601 strings

Run tests after implementation to verify.
```

### Step 2: Delegate via Codex CLI

```bash
codex exec --full-auto --json -C "$(pwd)" - <<'PROMPT'
{your prepared prompt here}
PROMPT
```

**Flags explained:**
- `--full-auto` — unattended execution with workspace-write sandbox
- `--json` — structured JSONL output for parsing results
- `-C "$(pwd)"` — run in the current project directory
- `-` — read prompt from stdin (avoids ARG_MAX limits for long prompts)

**For read-only tasks (reviews, analysis):**
```bash
codex exec --sandbox read-only --json -C "$(pwd)" - <<'PROMPT'
{review prompt}
PROMPT
```

### Step 3: Capture Results

After Codex completes, review what changed:

1. **Parse the JSONL output** for Codex's summary message (the last `message` event)
2. **Run `git diff`** to see exactly what files were created/modified
3. **Run tests** if Codex didn't already
4. **Read key files** to verify the implementation matches the spec

### Step 4: Evaluate and Iterate

Review the changes against the original acceptance criteria:
- Do the changes implement what was asked?
- Are tests passing?
- Does the code follow project conventions?

If issues found, prepare a follow-up prompt with specific fixes and delegate again. This is the Generator-Evaluator loop.

**Circuit breaker:** If 3 consecutive delegations fail (tests don't pass, wrong approach, errors), stop delegating and either fix inline or flag to the user. Don't let Codex iterate endlessly on a broken approach.

### Step 5: Commit with Attribution

When the implementation is accepted:
```bash
git add <files>
git commit -m "feat(scope): description

Implemented by: Codex (GPT Pro)
Planned by: Claude (Opus)
Co-Authored-By: Codex <noreply@openai.com>"
```

## When to Delegate vs Do Inline

**Delegate to Codex when:**
- The task is well-specified implementation (clear inputs → outputs)
- The design/spec is already written
- It's mostly code generation, not architectural reasoning
- You want to preserve Claude context for planning/review

**Keep in Claude when:**
- The task requires architectural reasoning or design decisions
- It's a small change (< 20 lines) — overhead isn't worth it
- The task needs Claude-specific tools (MCP servers, browser, etc.)
- You're iterating on approach, not just implementing

## Important Notes

- **Codex reads AGENTS.md** — project conventions are inherited automatically
- **Codex uses GPT Pro subscription** — zero marginal API cost
- **Codex has its own sandbox** — `--full-auto` gives workspace-write access
- **Environment guard** — if `CODEX_SANDBOX` or `CODEX_SESSION_ID` env vars are set, you're already inside Codex. Don't nest.
- **Long prompts go via stdin** — use the heredoc pattern (`- <<'PROMPT'`) to avoid shell argument limits

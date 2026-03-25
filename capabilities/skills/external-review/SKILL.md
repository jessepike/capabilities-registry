---
name: external-review
description: This skill runs multi-model external reviews by delegating to Codex CLI and Claude -p for independent perspectives. It should be used when the user wants an external review, multi-model review, independent code review, or fresh-eyes perspective on their work. Trigger on phrases like "external review", "get a second opinion", "have codex review this", "multi-model review", "independent review", "fresh perspective on this code", or when adf-review flags that external review is warranted by project complexity.
---

# External Review

Run independent reviews using external models (Codex, Claude -p) for fresh perspectives that the current session can't provide. Uses existing subscriptions — zero additional API cost.

## Why External Review Matters

Self-evaluation bias is real. The agent that wrote the code reliably overpraises it. The Anthropic harness design pattern shows that separating Generator from Evaluator produces dramatically better results. This skill implements that separation using your multi-model subscriptions.

## Review Modes

### Mode 1: Codex Review (GPT Pro perspective)

Best for: implementation quality, code patterns, testing gaps, alternative approaches.

```bash
codex exec review --full-auto --json -C "$(pwd)"
```

Codex's built-in `review` subcommand runs a code review against the current repo. It reads AGENTS.md for context and reviews recent changes.

**For a targeted review of specific files or a specific concern:**
```bash
codex exec --sandbox read-only --json -C "$(pwd)" - <<'PROMPT'
Review the following files for {specific concern}:
- {file1}
- {file2}

Focus on:
- {review dimension 1}
- {review dimension 2}

Report issues with severity (Critical/High/Low) and specific file:line references.
Do NOT suggest features or scope expansion. Only flag problems.
PROMPT
```

### Mode 2: Claude Fresh Review (independent Claude perspective)

Best for: architectural review, spec compliance, design quality, documentation accuracy.

Uses `claude -p` which starts a completely fresh context — no memory of the current session. This is a genuinely independent perspective from the same model family.

```bash
claude -p --output-format json --allowedTools "Read,Grep,Glob" - <<'PROMPT'
You are reviewing a project for {specific concern}. Read the following files and evaluate:

1. Read AGENTS.md for project context
2. Read {artifact to review}
3. Evaluate against these criteria:
   {criteria list}

Report issues with severity (Critical/High/Low) and specific locations.
Do NOT suggest features or scope expansion. Only find problems.
PROMPT
```

### Mode 3: Full Multi-Model Review (both perspectives)

Run Codex and Claude reviews in parallel, then synthesize:

1. **Launch both reviews** — Codex for implementation quality, Claude -p for architectural/spec compliance
2. **Collect results** — parse JSON output from both
3. **Synthesize** — identify agreements (high confidence issues), disagreements (need human judgment), and unique findings from each model
4. **Report** — unified issue list with source attribution

## Running a Review

### Step 1: Determine Scope

What's being reviewed and why?
- **Stage gate review** — reviewing artifacts before stage transition (use adf-review dimensions)
- **Code review** — reviewing implementation quality after a build phase
- **Design review** — reviewing design docs for feasibility, completeness, consistency
- **Ad-hoc review** — user wants a second opinion on something specific

### Step 2: Prepare Review Prompt

The review prompt must be self-contained. The external model has no conversational context. Include:
- What to review (specific files, artifacts)
- What criteria to evaluate against
- What format to report in (severity, location, description)
- YAGNI enforcement: "Do NOT suggest features or scope expansion. Only find problems."

### Step 3: Execute

For the chosen mode, run the review command. Parse the output.

### Step 4: Process Results

Map external findings to the adf-review Issue Log format:

| # | Issue | Source | Severity | Complexity | Status | Resolution |
|---|-------|--------|----------|------------|--------|------------|

**Source values:** `External-Codex`, `External-Claude`, `External-Gemini`

### Step 5: Act on Findings

Apply the adf-review action-taking matrix:
- Critical/High + Low/Medium complexity → fix automatically
- Critical/High + High complexity → flag for user
- Low → log only, do not fix

## Iteration Loop

For thorough reviews, run multiple rounds:

1. **Round 1:** External review identifies issues
2. **Fix:** Address Critical/High issues
3. **Round 2:** Re-run external review on fixed code
4. **Stop when:** No Critical/High issues found, or 3 rounds completed

This is the Generator-Evaluator loop from the harness design pattern. Typically 2-3 rounds is sufficient for most changes.

## When to Use Which Mode

| Scenario | Mode | Why |
|----------|------|-----|
| Post-implementation code review | Codex Review | GPT excels at code pattern analysis |
| Pre-stage-transition artifact review | Claude Fresh | Architectural/spec compliance |
| High-stakes feature or major refactor | Full Multi-Model | Maximum coverage, cross-validated findings |
| Quick sanity check | Codex Review | Fastest, built-in `review` command |

## Important Notes

- **Both models use existing subscriptions** — Codex via GPT Pro, Claude -p via Claude Max. Zero marginal cost.
- **YAGNI enforcement** — always include "do not suggest features" in review prompts. External models love to expand scope.
- **Fresh context is the point** — don't try to pass the full conversation history. The value is the independent perspective.
- **Environment guard** — check for `CODEX_SANDBOX` env var before calling Codex. If set, you're already inside Codex.
- **Claude -p inherits global CLAUDE.md** but starts a fresh conversation. It will read project AGENTS.md if pointed to the right directory.

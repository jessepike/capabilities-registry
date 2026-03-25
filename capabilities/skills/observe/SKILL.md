---
name: observe
description: Quick-capture an observation for a living system's Operate cycle. Appends a signal to docs/active/observations.md with minimal friction. Use when the user says "observe", "log observation", "signal", "note friction", "log error", "capture pattern", or wants to quickly record something they noticed during usage.
---

# Observe

One-command signal capture for living systems. Append, don't analyze — synthesis happens later.

## Usage

```
/observe {description}
/observe {description} --type friction --severity med
/observe   (interactive — prompts for details)
```

## Pipeline

### Step 1: Parse Input

Extract from the user's message:

| Field | Source | Default |
|-------|--------|---------|
| **Signal** | The observation text | *(required)* |
| **Type** | `--type` flag or infer from content | Auto-detect |
| **Severity** | `--severity` flag or infer from content | `Med` |
| **Context** | Current project, file, or workflow | Auto from `pwd` project name |

**Type detection heuristics** (if not explicitly provided):
- Words like "workaround", "confusing", "unexpected", "annoying" → **Friction**
- Words like "error", "fail", "crash", "exception", "broken" → **Error**
- Words like "missing", "need", "wish", "no way to", "can't" → **Gap**
- Words like "diverge", "drift", "changed", "used to" → **Drift**
- Words like "great", "love", "better than expected", "smooth" → **Delight**
- Words like "recurring", "pattern", "every time", "always" → **Pattern**
- Ambiguous → ask the user

**Severity detection heuristics** (if not explicitly provided):
- Unusable, data loss, blocked intent → **High**
- Recurring with workaround → **Med**
- One-off, cosmetic → **Low**

### Step 2: Ensure Observation Log Exists

Check for `docs/active/observations.md` in the current project.

If it doesn't exist, create it:

```markdown
# Observations

| Date | Signal | Type | Severity | Context |
|------|--------|------|----------|---------|
```

### Step 3: Append Observation

Add a row to the table in `docs/active/observations.md`:

```markdown
| {YYYY-MM-DD} | {signal description} | {type} | {severity} | {context} |
```

Rules:
- **Append only** — never modify or reorder existing rows
- **One signal per row** — split compound observations into multiple rows
- **Keep descriptions concise** — one sentence, actionable language
- **Context is lightweight** — project name, feature area, or file reference. Not a full reproduction.

### Step 4: Confirm

Output a one-line confirmation:

```
Logged: {type} ({severity}) — {truncated signal}
```

No summary, no analysis, no suggestions. Just confirm and done.

## Batch Mode

If the user provides multiple observations at once:

```
/observe
- auth flow confused 2 users (friction, high)
- dashboard loads slowly on mobile (friction, med)
- no way to export data as CSV (gap, med)
```

Process each as a separate row. Confirm with count: `Logged 3 observations.`

## Important Notes

- **Speed over precision** — it's better to capture an imperfect observation than to lose it while debating type/severity. These get refined during synthesis.
- **Don't analyze** — this skill captures, it doesn't synthesize. That's what `operate-synthesis` is for.
- **Don't suggest actions** — no "you should fix this" or "consider adding X." Just log it.
- **Respect the running log** — observations.md is append-only during the Operate cycle. Synthesis archives processed entries.
- **Works outside Operate too** — you can log observations during Develop or Deliver. They'll be there when Operate activates.

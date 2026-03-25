# ADF Init — Artifact Templates

Use these templates when scaffolding a new project. Replace `{placeholders}` with actual values.

---

## AGENTS.md

```markdown
# {Project Name}

{One-line description of the project.}

**Type:** {Type} + {modifiers}

## Orientation

1. Read this file (shared instructions for all runtimes)
2. Read `status.md` for current state and next steps
3. Read `BACKLOG.md` for tracked work items
4. Check `.claude/rules/` for hard constraints

## Key Locations

- `intent.md` — North Star (immutable without human permission)
- `BACKLOG.md` — work queue
- `status.md` — current state and session log
- `decisions.md` — decision log
- `docs/active/` — current working documents
- `docs/reference/` — settled docs, lookup only
- `.ctx/` — ephemeral scratch (gitignored)

## Build & Run

<!-- Fill in as the project takes shape -->
```bash
# Build
# Test
# Lint
# Run
```

## Conventions

<!-- Add coding conventions, naming patterns, architecture notes as they emerge -->

## Deployment

<!-- Fill in when deployment target is known -->
<!-- Example for Vercel:
Target: Vercel
Plugin: `claude plugin install vercel@claude-plugins-official --scope project`
-->

## ADF Workflow

This project follows the ADF stage model: Discover → Design → Develop → Deliver → Operate.

- **Current stage** is tracked in `status.md`
- **Work items** are tracked in `BACKLOG.md`
- **Decisions** are logged in `decisions.md`
- **Reviews** happen at stage gates (internal review is mandatory)
- **intent.md** is the governing document — decisions should trace back to it
```

---

## CLAUDE.md

```markdown
@AGENTS.md

## Claude-Specific

### Context Map

**Always loaded:** Root artifacts (intent.md, BACKLOG.md, status.md, decisions.md)
**Default working zone:** docs/active/
**Load on demand:**
- Architecture/design → docs/active/ or docs/reference/
- Constraints → .claude/rules/
**Never load automatically:** docs/archive/ (explicit instruction only)

### Notes

- Use `.ctx/scratch/` for working notes and intermediate reasoning
- Promote anything load-bearing from `.ctx/` to `docs/active/`
```

---

## intent.md

```markdown
---
type: "intent"
description: "Project intent statement"
version: "1.0.0"
updated: "{today}"
---

# Intent: {Project Name}

## Problem/Opportunity

<!-- What situation prompted this project? 1-3 sentences. -->

## Desired Outcome

<!-- What does success look like at the highest level? 1-3 sentences. -->

## Why It Matters

<!-- Why is this worth doing? 1-3 sentences. -->
```

---

## BACKLOG.md

```markdown
---
type: "tracking"
project: "{Project Name}"
updated: "{today}"
---

# Backlog

## Queue

| ID | Item | Type | Pri | Size | Status | Why |
|----|------|------|-----|------|--------|-----|

## Archive

| ID | Item | Completed | Realized? |
|----|------|-----------|-----------|
```

---

## status.md

```markdown
---
project: "{Project Name}"
stage: "Discover"
updated: "{today}"
---

# Status

## Current State
- **Phase:** Initialization complete — entering Discover
- **Focus:** Define intent and begin discovery

## Session Log

| Date | Summary |
|------|---------|
| {today} | Project scaffolded — ADF init complete. Ready for Discover. |

## Next Steps
- [ ] Define intent in `intent.md`
- [ ] Begin Discover — create `docs/active/brief.md`
- [ ] Populate BACKLOG.md with initial work items

## Pending Decisions
- None

## Blockers
- None
```

---

## decisions.md

```markdown
---
type: "tracking"
project: "{Project Name}"
updated: "{today}"
---

# Decisions

| Date | Decision | Rationale | Who |
|------|----------|-----------|-----|
| {today} | Project type: {Type} + {modifiers} | {Brief rationale for type selection} | Human |
```

---

## README.md

```markdown
# {Project Name}

{One-line description.}

## Status

See `status.md` for current project state.

---

*Scaffolded with ADF (Agentic Development Framework)*
```

---

## .claude/rules/constraints.md

```markdown
---
type: "rule"
description: "Project-level constraints"
---

# Constraints

- Never commit secrets, credentials, or API keys
- Never modify `intent.md` without explicit human approval
- Confirm before destructive operations (delete, drop, overwrite, force-push)
- Update `status.md` before ending any session that modified files
- Ask when uncertain — do not assume
```

---

## .gitignore (append)

```
.ctx/
```

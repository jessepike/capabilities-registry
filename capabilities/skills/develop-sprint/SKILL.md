---
name: develop-sprint
description: This skill runs the entire Develop stage autonomously — breaks design into tasks, delegates implementation to Codex, reviews each chunk, runs health checks, tests, and iterates until the build matches the design. One command, fully automated with human checkpoints at milestones. It should be used when the user says "run develop", "develop sprint", "start building", "implement the design", "build this", or wants the Develop stage to run with minimal human intervention.
---

# Develop Sprint

Run the Develop stage as an autonomous pipeline. Plan → Implement (via Codex) → Review → Test → Iterate. One command, the agent orchestrates everything, human approves at milestones.

## Why This Exists

The Develop stage has 8 phases with multiple steps each. Manually orchestrating Claude planning → Codex implementing → review → test → fix → repeat for every task is the friction this eliminates. The agent handles the loop; the human handles judgment calls.

## Modes

### Full Sprint (with checkpoints)
```
run develop sprint
```
Works through all tasks. Pauses at task breakdown, milestone reviews, and end for human approval.

### Full Auto (no stops)
```
run develop sprint --full-auto
```
Runs the entire pipeline without pausing. Task breakdown, implementation, reviews, tests, commits — all autonomous. Only stops for Critical + High-complexity issues that need a human decision, or if the circuit breaker triggers (3 consecutive Codex failures). Report at the end.

### Single Task
```
develop sprint on B-015 (API endpoints)
```
Implements one specific backlog item.

### Resume
```
resume develop sprint
resume develop sprint --full-auto
```
Reads BACKLOG.md for task status, picks up from the next pending item.

## The Pipeline

### Phase 1: Planning (one-time setup)

Runs once at sprint start, not per task.

1. **Read design docs** — `docs/active/design.md` and any `design-*.md` children
2. **Read the Develop Handoff** section for build order, implementation guidance, capabilities needed
3. **Break into tasks** — decompose the design into atomic implementable units in BACKLOG.md
   - Each task: one agent, one session, verifiable done criteria
   - Include acceptance criteria from the design
   - Sequence by dependencies
4. **Capability check** — verify tools, runtimes, and dependencies are available
   - If something needs installing, flag it (installs go in OrbStack per three-tier rules)
5. **Environment setup** — ensure dev environment is ready (run in OrbStack if build/test needed)

**Human checkpoint (skip in --full-auto):** Review the task breakdown before implementation starts. In full-auto mode, proceed immediately with the generated breakdown.

### Phase 2: Implementation Loop (per task)

For each task in BACKLOG.md priority order:

#### Step 1: Prepare Codex Prompt

Claude writes a self-contained implementation prompt. Include:
- What to implement (specific, not vague)
- Acceptance criteria (how to know it's done)
- Key files to read and modify
- Design constraints and patterns to follow
- Tests to write or run
- Reference to design doc section

The prompt must be standalone — Codex starts fresh with no conversational context. AGENTS.md provides project conventions automatically.

#### Step 2: Delegate to Codex

```bash
codex exec --full-auto --json -C "$(pwd)" - <<'PROMPT'
{prepared implementation prompt}
PROMPT
```

Codex implements using GPT Pro subscription. Zero API cost.

#### Step 3: Review Results

After Codex completes:

1. **Parse output** — read Codex's summary, files changed, any errors
2. **Git diff** — review exactly what was created/modified
3. **Run tests** — execute the test suite relevant to this task
4. **Verify acceptance criteria** — check each criterion from the task

#### Step 4: Fix or Iterate

If issues found:
- **Minor issues** (style, naming, small bugs) — Claude fixes inline
- **Significant issues** (wrong approach, missing requirements) — prepare a follow-up Codex prompt with specific corrections, delegate again
- **Architectural issues** (design doesn't work as specified) — pause, flag to human

**Circuit breaker:** 3 consecutive failed delegations for the same task → stop, flag to human. Don't let Codex iterate endlessly on a broken approach.

#### Step 5: Internal Review

Quick internal review of the implemented task:
- Does it match the design spec?
- Are tests passing?
- Code follows project conventions?
- No secrets, no debug prints, no placeholder implementations?

#### Step 6: Commit

```bash
git add {files}
git commit -m "feat({scope}): {description}

Implemented by: Codex (GPT Pro)
Planned by: Claude (Opus)"
```

Atomic commit per task. Not one big commit at the end.

#### Step 7: Update State

1. Mark task as complete in BACKLOG.md
2. Update status.md with progress
3. Move to next task (back to Step 1)

### Phase 3: Milestone Reviews

After every 3-5 completed tasks (or after a logical group of related tasks):

#### External Review

Run the review-loop on the accumulated changes:

1. **Codex review** — `codex exec review` for implementation patterns perspective
2. **Claude fresh review** — `claude -p` for architectural coherence
3. Incorporate feedback, fix issues
4. Verification pass

#### Health Check

```
project-health --scope tests,hygiene,design-drift
```

Catches: test coverage gaps, stale TODOs, design drift, code hygiene issues.

#### Human Checkpoint (skip in --full-auto)

In checkpoint mode:
```
✅ Milestone: {tasks completed}

Tasks done: B-015, B-016, B-017
Tests passing: {count}/{total}
Design drift: {none / flagged items}
Health: {PASS / WARN / FAIL}

Continue to next milestone? Or review the implementation?
```

In full-auto mode: log the milestone summary and continue immediately.

### Phase 4: Build-to-Design Verification

After all tasks complete:

1. Re-read design.md
2. For each major design requirement, identify where it's implemented
3. Checklist: Design Requirement → Implementation file/function
4. Flag gaps: fix small ones, flag significant ones for human

### Phase 5: Three-Tier Testing

1. **Tier 1: Automated** — run full test suite. Target: 95%+ pass rate.
2. **Tier 2: Browser/Real-world** — if the project has a UI, interactive testing via Claude in Chrome.
3. **Tier 3: Manual** — human acceptance testing. Flag specific scenarios to test.

Tiers are progressive — Tier 1 must pass before Tier 2, Tier 2 before Tier 3. Issues in later tiers trigger fixes and re-testing from Tier 1.

### Phase 6: Closeout

1. **Cleanup** — .gitignore current, no transients, no secrets, no debug code
2. **Success criteria gate** — map each criterion from brief.md to evidence
3. **Documentation** — README updated, API docs if applicable
4. **Final commit** — `chore(develop): stage complete — {summary}`
5. **Update status.md** — stage seal (the LAST step)

### Final Report

```
## Develop Sprint Complete

Tasks implemented: {count}
Codex delegations: {count} ({success} succeeded, {failed} failed)
Review cycles: {count} (internal: {n}, external: {n})
Health checks: {count}
Test pass rate: {percentage}
Design drift: {none / items}
Commits: {count}

Success criteria:
- {criterion 1}: ✅ / ⏸️ / ❌
- {criterion 2}: ✅ / ⏸️ / ❌

Ready for Deliver: {Yes / No — blocked by {specific items}}
```

## Codex Delegation Patterns

### Standard Implementation
```bash
codex exec --full-auto --json -C "$(pwd)" - <<'PROMPT'
Implement {feature}. Read design at docs/active/design.md section {X}.
Acceptance criteria:
- {criterion 1}
- {criterion 2}
Write tests in tests/{test_file}.
Run tests after implementation.
PROMPT
```

### Bug Fix After Review
```bash
codex exec --full-auto --json -C "$(pwd)" - <<'PROMPT'
Fix the following issues found in review:
1. {issue 1 with file:line}
2. {issue 2 with file:line}
Run tests after fixing.
PROMPT
```

### Independent Mode (Codex drives)
For well-specified tasks where Codex can work completely independently:
```bash
codex exec --full-auto --json -C "$(pwd)" - <<'PROMPT'
Read the design at docs/active/design.md. Implement all items marked
as pending in BACKLOG.md that relate to {component}. Follow the patterns
in existing code. Write tests. Commit each task separately.
PROMPT
```

Use sparingly — Claude loses visibility into what Codex decided. Best for mechanical, well-patterned work.

## Important Notes

- **Codex implements, Claude orchestrates** — Claude writes specs, reviews results, manages state. Codex writes code. Don't blur the roles.
- **Atomic commits per task** — not one commit at the end. Each task gets its own commit with attribution.
- **Circuit breaker is real** — 3 failures = stop and flag. Don't waste cycles on a broken approach.
- **OrbStack for builds/tests** — if the project needs build tools or test runners, those run in the dev VM. Claude orchestrates from the host.
- **Milestone reviews catch drift early** — don't wait until all tasks are done to discover the implementation went sideways.
- **Human checkpoints are not optional** — the sprint pauses at milestones and at the end. Fully autonomous within tasks, human-gated between milestones.

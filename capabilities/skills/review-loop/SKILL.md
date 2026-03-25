---
name: review-loop
description: This skill runs a full autonomous review cycle — internal self-review iterations, then external multi-model reviews via Codex CLI and Claude -p, incorporating feedback and re-validating until clean. One command, fully automated. It should be used whenever the user says "run review", "do review", "review this", "full review cycle", "review loop", or wants autonomous review iterations on any artifact before a stage transition. This is the primary review entry point — it orchestrates adf-review (internal) and external-review (multi-model) into a single automated pipeline.
---

# Review Loop

One command. Full autonomous review cycle. Internal iterations, external multi-model reviews, feedback incorporation, re-validation. Come back when it's done.

## What Happens When You Say "Run Review"

```
Internal Review (2-10 cycles)
  ↓ issues found → fix → re-review → repeat until clean
External Review (Codex + Claude -p)
  ↓ fresh perspectives from different models
Incorporate Feedback
  ↓ fix external findings
Verification Pass
  ↓ confirm all fixes hold
Report: Ready / Not Ready
```

The entire pipeline runs autonomously. Human intervention only if a Critical + High-complexity issue is found that needs a decision.

## The Loop

### Phase 1: Internal Review (adf-review logic)

Read the artifact fresh. Evaluate against stage-specific review dimensions.

**Cycle rules:**
- Minimum 2 cycles
- Maximum 10 cycles
- Stop when: no Critical/High issues found AND minimum met
- Stop early if: same issue persists 3+ iterations (flag to user — structural problem)
- Stop early if: 4+ cycles with Critical issues (flag to user)

**Per cycle:**
1. Read the artifact (re-read every cycle — don't rely on stale context)
2. Evaluate against review dimensions for the current stage
3. Assign severity (Critical/High/Low) and complexity (Low/Medium/High) to each issue
4. Apply the action matrix:
   - Critical/High + Low/Medium complexity → fix immediately
   - Critical/High + High complexity → flag for user, pause loop
   - Low → log only, don't fix
5. If fixes were made, increment cycle and re-review
6. If clean (no Critical/High), exit Phase 1

**Log everything** in the artifact's Issue Log section using the standard format:

| # | Issue | Source | Severity | Complexity | Status | Resolution |
|---|-------|--------|----------|------------|--------|------------|

### Phase 2: External Review

Only runs after Phase 1 exits clean. Why: no point getting external perspectives on known-broken work.

**Step 1: Codex review (implementation/patterns perspective)**

```bash
codex exec --sandbox read-only --json -C "$(pwd)" - <<'PROMPT'
Review the file at {artifact_path} for this project.

Context: This is a {artifact_type} in the {current_stage} stage of an ADF project.
Read AGENTS.md for project context first.

Evaluate against these dimensions:
{stage-specific review dimensions}

Report each issue as:
- Severity: Critical, High, or Low
- Location: specific section or line
- Description: what's wrong
- Suggestion: how to fix (if obvious)

IMPORTANT: Do NOT suggest new features, scope expansion, or "nice to haves."
Only flag issues that block or significantly harm the next stage.
PROMPT
```

**Step 2: Claude fresh review (architectural/spec perspective)**

```bash
claude -p --output-format json --allowedTools "Read,Grep,Glob" - <<'PROMPT'
You are an independent reviewer. You have NO prior context about this project.

1. Read AGENTS.md for project overview
2. Read intent.md for the project's North Star
3. Read {artifact_path}

Evaluate the artifact against these criteria:
{stage-specific review dimensions}

For each issue found:
- Severity: Critical, High, or Low
- Location: specific section reference
- Description: what's wrong and why it matters
- Suggestion: how to fix

Do NOT suggest features, additions, or scope changes. Only find problems.
PROMPT
```

**Step 3: Parse external results**

Extract issues from both Codex and Claude -p outputs. Map to the Issue Log format with source attribution (`External-Codex`, `External-Claude`).

### Phase 3: Incorporate Feedback

For each external finding:
1. Apply the action matrix (same as internal — severity x complexity → action)
2. Fix Critical/High + Low/Medium complexity issues
3. Flag Critical/High + High complexity for user
4. Log Low severity issues without fixing

### Phase 4: Verification Pass

After incorporating external feedback, run one more internal review cycle to verify:
- Fixes didn't introduce new issues
- External findings are properly addressed
- Artifact is consistent after all changes

If new Critical/High issues emerge, loop back to Phase 1 (but this is rare — usually 1 verification pass suffices).

### Phase 5: Report

Output the full review report:

```markdown
## Review Complete

**Artifact:** {name}
**Stage:** {current_stage}
**Verdict:** Ready for {next_stage} / Blocked by {issues}

### Internal Review
- Cycles: {N}
- Issues found: {count by severity}
- Issues fixed: {count}
- Stop reason: {clean / max cycles / flagged}

### External Review — Codex
- Issues found: {count by severity}
- Unique findings (not caught internally): {count}

### External Review — Claude
- Issues found: {count by severity}
- Unique findings: {count}

### Verification
- Pass: {clean / issues remaining}

### Full Issue Log
{consolidated issue log table with all sources}

### Recommendation
{ready to proceed / specific blockers to resolve / needs human decision on flagged items}
```

## Stage-Specific Review Dimensions

The review dimensions come from the adf-stage references. Load the appropriate ones:

| Stage | Dimensions Source |
|-------|-----------------|
| Discover | references in adf-stage: completeness, clarity, measurability, scope, intent alignment, feasibility (10 dimensions) |
| Design | references in adf-stage: brief alignment, completeness, feasibility, consistency, capability coverage (9 dimensions) |
| Develop | references in adf-stage: plan coverage, task atomicity, dependencies, testing strategy (6 dimensions) |
| Deliver | references in adf-stage: deployment coverage, testing, rollback, access clarity (7 dimensions) |

## YAGNI — Enforced at Every Level

Internal and external — every review applies this:
- Only flag issues that block or significantly harm the next stage
- Do NOT suggest features, additions, or "nice to haves"
- Reviewers are validators, not consultants
- If something is explicitly out of scope, respect it

## Important Notes

- **This is the primary review entry point.** Users say "run review" and this skill handles everything.
- **adf-review and external-review are building blocks** that this skill orchestrates. They don't need to be invoked separately.
- **External reviews use subscriptions** — Codex via GPT Pro, Claude -p via Claude Max. Zero marginal cost.
- **The sound hook fires when done** — user hears the notification and comes back to the report.
- **Human only needed for** Critical + High-complexity issues where a decision is required.

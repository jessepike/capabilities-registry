---
name: adf-review
description: This skill runs ADF internal or external reviews on project artifacts — mandatory self-review with severity/complexity matrix, YAGNI enforcement, and issue logging. It should be used whenever the user asks to review an artifact, run a review, check quality, validate stage output, do a phase review, or wants feedback on their work. Trigger on phrases like "review this", "run a review", "internal review", "external review", "quality check", "is this ready", "review the brief", "review the design", or "check for issues". Also use before stage transitions to ensure exit criteria quality.
---

# ADF Review

Run structured reviews on project artifacts. Internal review is mandatory at every stage gate. External review is optional and risk-driven — the user decides.

## Review Types

### Internal Review (Mandatory)

Self-review cycle embedded in every stage exit. Read the artifact, identify issues by severity, fix what can be fixed, re-review until clean.

**Cycle rules:**
- Minimum 2 cycles, always
- Maximum 10 cycles per stage
- Stop when: no Critical/High issues AND minimum cycles met

### External Review (Optional)

Fresh-perspective review by external models or agents. User-triggered based on complexity and risk.

**When to suggest it:**
- Complex or multi-component projects
- High stakes for missed issues
- User explicitly requests it

**When to skip:**
- Simple or low-complexity projects
- User decides it's not needed

## Running an Internal Review

### Step 1: Identify what to review

Determine the artifact and its stage context. Read the appropriate stage reference (from adf-stage skill) for **review dimensions** — the specific angles to evaluate from. Common sources:

| Stage | Review Dimensions Source |
|-------|------------------------|
| Discover | Brief completeness, clarity, measurability, scope, intent alignment, feasibility (10 dimensions) |
| Design | Brief alignment, completeness, feasibility, consistency, capability coverage, interface clarity (9 dimensions) |
| Develop | Plan coverage, task atomicity, dependency completeness, testing strategy, risks (6 dimensions) |
| Deliver | Deployment coverage, testing strategy, rollback viability, access clarity (7 dimensions) |

### Step 2: Review cycle

For each cycle:

1. **Read** the artifact fresh (important: re-read each cycle, don't rely on memory)
2. **Evaluate** against each review dimension
3. **Identify issues** and assign severity + complexity
4. **Apply the action matrix** (fix, flag, or log)
5. **Log** all issues in the Issue Log
6. **Check stop conditions**

### Step 3: Stop conditions

Review is complete when:

1. Minimum cycles met (2) AND no Critical/High issues in last cycle

OR any of:
- Hard maximum reached (10 cycles)
- Same issue persists 3+ iterations → stop and flag to user (stuck)
- Past 4 cycles with Critical issues → stop and flag (structural problem)

## Severity Definitions

| Severity | Definition | Test |
|----------|------------|------|
| **Critical** | Must resolve. Blocks next stage or is fundamentally flawed. | "If unfixed, will the project fail?" → Yes |
| **High** | Should resolve. Significant gap or weakness. | "If unfixed, will the project be significantly worse?" → Yes |
| **Low** | Minor. Polish, cosmetic, implementation detail. | Neither of the above → Low |

## Complexity Assessment

Assess effort required for Critical/High issues only.

| Complexity | Definition | Examples |
|-----------|------------|----------|
| **Low** | Direct edit, clear fix | Change ID, add missing field, fix typo |
| **Medium** | Requires design thinking | Redesign logic, restructure section, add columns |
| **High** | Needs research or rethinking | Evaluate alternatives, spike unknown APIs, resolve conflicts |

## Action-Taking Matrix

| Severity | Complexity | Action |
|----------|-----------|--------|
| Critical/High | Low | **Fix automatically** — direct edit |
| Critical/High | Medium | **Fix automatically** — apply design thinking |
| Critical/High | High | **Flag for user** — needs research/investigation |
| Low | Any | **Log only** — do not fix |

### When fixing automatically:
- Apply the minimal fix that resolves the issue
- Update related sections for consistency
- Do not expand scope beyond the identified issue
- Log resolution in the Issue Log

### When flagging for user:
- State the issue and why it blocks
- Identify what investigation is needed
- Propose 2-3 potential approaches if possible
- Wait for user decision before proceeding

## YAGNI Enforcement

Every review applies this rigorously:

- Only flag issues that **block or significantly harm** the next stage
- Do NOT suggest features, additions, or "nice to haves"
- Do NOT ask "what about X?" unless X is critical to stated goals
- If something is explicitly out of scope, respect it
- Do NOT backdoor scope expansion as "questions to consider"

**Reviewers are validators, not consultants.** Find problems, not opportunities.

## Issue Log Format

Log all issues in the artifact's Issue Log section:

| # | Issue | Source | Severity | Complexity | Status | Resolution |
|---|-------|--------|----------|------------|--------|------------|
| 1 | [description] | Internal | Critical | Low | Resolved | [what was done] |
| 2 | [description] | Internal | High | High | Open | Flagged for user |
| 3 | [description] | Internal | Low | N/A | Logged | — |

**Source values:** `Internal`, `External-{Model}`, `Human`
**Complexity:** Low/Medium/High for Critical/High; N/A for Low severity

## Review Report

After completing review cycles, report to the user:

1. **Cycles completed** — how many, why stopped
2. **Issues found** — count by severity
3. **Issues fixed** — what was auto-fixed
4. **Issues flagged** — Critical/High + High complexity (needs user decision)
5. **Issues logged** — Low severity (informational only)
6. **Verdict** — ready for next stage, or blocked by [specific issues]

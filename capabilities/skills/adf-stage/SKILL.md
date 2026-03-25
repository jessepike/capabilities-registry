---
name: adf-stage
description: This skill manages ADF stage workflow — detecting current stage, loading stage-specific guidance, validating exit criteria, and executing stage transitions with handoff protocol. It should be used whenever the user asks about project stages, wants to check stage status, start or enter a stage, validate exit criteria, transition between stages, or do a stage handoff. Trigger on phrases like "what stage am I in", "start discover", "enter design", "stage check", "are we ready for develop", "transition to deliver", "stage gate", "exit criteria", or "handoff". Also use when the user is working within a stage and needs guidance on what to do next.
---

# ADF Stage Manager

Manage the five-stage ADF workflow: Discover → Design → Develop → Deliver → Operate & Learn. Detect current stage, provide stage-specific guidance, validate exit criteria, and execute transitions.

## Stage Model

```
Discover → Design → Develop → Deliver → Operate & Learn
   ↑                                         │
   └──── evidence seeds next cycle ───────────┘
```

**Assumption Mode** (Discover → Deliver): building on what we think is true.
**Evidence Mode** (Operate & Learn): refining based on observed reality. Only for living systems.

### Stage Summary

| Stage | Question | Key Outputs |
|-------|----------|-------------|
| **Discover** | What are we trying to accomplish? | `intent.md`, `docs/active/brief.md` |
| **Design** | How will we approach it? | `docs/active/design.md` (splits to `design-*.md` at 500+ lines), decisions |
| **Develop** | Are we building it correctly? | The deliverable, tests, documentation |
| **Deliver** | Is this increment done and usable? | Deployed/distributed artifact, access docs |
| **Operate** | Is this working well? What should change? | Observation log, synthesis reports, cycle decision |

## Operations

### 1. Detect Current Stage

Read `status.md` frontmatter `stage:` field. If missing or unclear, check:
- Does `intent.md` have content? → past Discover
- Does `docs/active/design.md` exist? → past Design
- Is there built output (src/, output/, etc.)? → in or past Develop
- Is the artifact deployed/accessible? → in or past Deliver

Report the current stage, phase, and focus from status.md.

### 2. Load Stage Guidance

Read the appropriate reference file for the current (or requested) stage:
- `references/discover.md` — phases, review dimensions, exit criteria
- `references/design.md` — phases, type-specific requirements, HARD GATE, handoff section
- `references/develop.md` — 8-phase model, testing tiers, closeout checklist
- `references/deliver.md` — deployment phases, validation tiers, milestone closeout
- `references/operate.md` — living system gate, observation/synthesis/cycle decision

Present a concise summary of where the user is within the stage and what the next action should be.

### 3. Validate Exit Criteria

When the user wants to check if a stage is complete, evaluate two sets:

**Universal Exit Criteria (every stage):**
- [ ] Primary deliverable(s) exist with required content
- [ ] No Critical or High issues open (post-review)
- [ ] Alignment verified with intent.md and brief.md
- [ ] All work committed (atomic commits, no uncommitted changes)
- [ ] Documentation current — run `project-health --scope freshness` to verify docs with `covers:` frontmatter are not stale against code changes
- [ ] Workspace cleanup complete (no transients, .gitignore current)
- [ ] status.md updated with stage completion
- [ ] Human sign-off obtained

**Stage-specific criteria:** Load from the appropriate reference file.

Report pass/fail for each criterion. If any Critical items fail, the stage is not ready for transition.

### 4. Execute Stage Transition

When all exit criteria pass and the user approves the transition:

**Stage Boundary Handoff Protocol:**

1. Verify all stage-specific exit criteria are met
2. **Archive working artifacts** — move to `docs/archive/YYYY-MM-DD-{name}.md`
3. Verify only deliverables and reference artifacts remain in `docs/active/`
4. Update `status.md` with the handoff block (use template below)
5. Commit: `chore({stage}): stage complete — {summary}`
6. Suggest clearing context for fresh start in next stage (in Claude Code: `/clear`)

**Handoff Block Template (for status.md):**

```markdown
## Stage Handoff: {Stage} → {Next Stage}

**Date:** YYYY-MM-DD

### Deliverables Produced
- [Artifact with path] — [Brief description]

### Archived Artifacts
- [Name] → `docs/archive/YYYY-MM-DD-{name}.md` — [Why]

### Success Criteria Status
- [Criterion]: ✅ Complete / ⏸️ Deferred / ❌ Not met

### Known Limitations
- [Constraints, deferred features, open questions]

### Read Order for Next Stage
1. `intent.md` — North Star
2. [Primary deliverable] — [Why]
3. `status.md` — Current state
```

### 5. Stage Setup (entering a new stage)

When entering a stage after transition, the setup varies:

| Transition | Setup |
|------------|-------|
| Init → Discover | Project scaffolded (via adf-init), load validation prompts |
| Discover → Design | Verify intent clarity, prepare decision frameworks |
| Design → Develop | Environment ready, tools installed, plan created |
| Develop → Deliver | Deployment config, documentation ready |
| Deliver → Operate | Create `docs/active/observations.md`, run activation phase |

## Cross-Stage Artifacts

These persist across all stages:

| Artifact | Behavior |
|----------|----------|
| `intent.md` | Created in Discover, immutable thereafter |
| `status.md` | Updated every session |
| `BACKLOG.md` | Minimal in Discover/Design, detailed in Develop/Deliver |
| `decisions.md` | Logged as decisions are made |
| `AGENTS.md` / `CLAUDE.md` | Evolve with project |

## Artifact Lifecycle at Transitions

| Category | At Stage Transition |
|----------|---------------------|
| **Deliverables** | Keep active — carry forward |
| **Working artifacts** | Archive to `docs/archive/` |
| **Reference docs** | Keep in `docs/reference/` |

## Important Notes

- **intent.md is the North Star.** Every stage validates alignment against it.
- **Reviews happen at stage gates.** Internal review is mandatory (see adf-review skill). External review is user's call.
- **Status.md is THE handoff mechanism.** The next stage agent reads status.md to understand where to pick up.
- **Operate & Learn only applies to living systems.** One-shot artifacts (reports, presentations) complete at Deliver.
- **Stages are clarity gates, not bureaucracy.** The exit criteria ensure quality without being heavy-handed.

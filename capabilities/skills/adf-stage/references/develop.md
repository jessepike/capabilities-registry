# Develop Stage Reference

> "Are we building it correctly?"

## Phase Model

### Planning (Phases 1-3)

| Phase | Description | Exit Gate | Artifacts |
|-------|-------------|-----------|-----------|
| **1. Intake & Validation** | Ensure understanding, close loose ends | Human confirms understanding | — |
| **2. Capability Assessment** | Identify dependencies and capabilities | Human approves manifest + capabilities | `docs/active/manifest.md`, `docs/active/capabilities.md` |
| **3. Planning** | Implementation plan and task breakdown | Agent approves plan + tasks | `docs/active/plan.md`, `BACKLOG.md` |

### Review + Hard Gate (Phase 4)

| Phase | Description | Exit Gate |
|-------|-------------|-----------|
| **4. Review Loop & Approval** | Internal/external review, human sign-off | No Critical/High issues + human approval |

### Execution (Phases 5-8)

| Phase | Description | Exit Gate |
|-------|-------------|-----------|
| **5. Environment Setup** | Install dependencies, configure capabilities | Environment verified |
| **6. Build** | Implementation with testing + build-to-design verification | 95%+ tests pass |
| **7. Documentation** | README, API docs, usage guides | Docs exist and accurate |
| **8. Closeout** | Cleanup, verification, archive, seal | All criteria met, status.md sealed |

## Phase Boundary Protocol

At every phase transition:
1. Update handoff block in BACKLOG.md
2. Update status.md
3. Commit all changes
4. Update current_phase
5. Move completed tasks
6. Clear context (Claude Code: `/clear`)
7. Re-read artifacts fresh
8. Confirm start of next phase

## Key Deliverables (in sequence)

| # | Artifact | Location |
|---|----------|----------|
| 1 | `manifest.md` (software deps) | `docs/active/manifest.md` |
| 2 | `capabilities.md` (MCP, skills, tools) | `docs/active/capabilities.md` |
| 3 | `plan.md` (implementation plan) | `docs/active/plan.md` |
| 4 | `BACKLOG.md` (atomic task list) | Root |
| 5 | The deliverable | Type-specific |
| 6 | Documentation | Root / docs/ |

## Three-Tier Testing

| Tier | What | Pass Criteria |
|------|------|---------------|
| **1. Automated** | Unit, integration, E2E | 95%+ pass rate |
| **2. Browser/Real-world** | Interactive testing | Key flows complete |
| **3. Manual** | User acceptance, edge cases | Human confirms |

Progressive: Tier 1 before Tier 2 before Tier 3. Issues in later tiers re-trigger from Tier 1.

## Build-to-Design Verification

After all tasks complete, before documentation:
1. Re-read design.md
2. For each design requirement, identify where implemented
3. Checklist: Design Requirement → Implementation
4. Flag gaps: fix small ones, flag significant ones for human

## Review Dimensions (Phase 4)

1. Does plan cover all design requirements?
2. Are tasks atomic enough for single-agent execution?
3. Are dependencies complete?
4. Is testing strategy sufficient?
5. Parallelization opportunities captured?
6. Risks addressed?

## Develop-Specific Exit Criteria

- [ ] All three testing tiers complete
- [ ] Tier 1: 95%+ automated pass rate
- [ ] Tier 2: Browser/real-world testing complete
- [ ] Tier 3: Manual validation with human acceptance
- [ ] Build-to-design verification complete
- [ ] Success criteria from brief mapped to evidence

## Closeout Checklist

1. **Cleanup** — .gitignore updated, transients deleted, no secrets, no commented-out code
2. **Success Criteria Gate** — map each criterion to evidence (met / partial / not met)
3. **Artifact Lifecycle** — keep: intent, brief, design. Archive: plan, manifest, capabilities
4. **Commit Verification** — no uncommitted changes, atomic history
5. **status.md Seal** — mark stage complete, structured handoff (LAST step)

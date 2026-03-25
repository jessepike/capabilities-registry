# Deliver Stage Reference

> "Is this increment done and usable?"

## Phase Model

### Planning (Phases 1-3)

| Phase | Description | Exit Gate | Artifacts |
|-------|-------------|-----------|-----------|
| **1. Intake & Readiness** | Verify Develop outputs, understand delivery scope, check deployment tooling | Agent confirms readiness | — |
| **2. Delivery Capability Assessment** | Identify deployment target and required capabilities | Agent approves manifest + capabilities | `docs/active/manifest.md`, `docs/active/capabilities.md` |
| **3. Delivery Planning** | Deployment plan and task breakdown | Agent approves plan + tasks | `docs/active/plan.md`, `BACKLOG.md` |

### Review + Hard Gate (Phase 4)

| Phase | Description | Exit Gate |
|-------|-------------|-----------|
| **4. Review Loop & Approval** | Internal/external review, human sign-off | No Critical/High issues + human approval |

### Execution (Phases 5-8)

| Phase | Description | Exit Gate |
|-------|-------------|-----------|
| **5. Infrastructure Setup** | Prepare deployment target | Infrastructure ready |
| **6. Deployment Execution** | Deploy/distribute to target | Successfully deployed |
| **7. Validation & Testing** | 3-tier validation in production | Confirmed usable |
| **8. Milestone Closeout** | Cleanup, seal, mark complete | All criteria met |

## Phase 1: Deployment Tooling Check

Before planning delivery, verify the deployment tooling specified in AGENTS.md is available:
- Check the Deployment section in AGENTS.md for the target platform
- If a plugin or MCP server is listed but not installed, prompt the user to install it
- Common: `claude plugin install vercel@claude-plugins-official --scope project` for Vercel projects
- If no deployment target is specified, ask the user before proceeding

## Delivery Scope by Type

| Type | Scope |
|------|-------|
| **Artifact** | Simple export/distribution |
| **App (feature)** | Deploy to existing production |
| **App (MVP)** | First-time infrastructure + deployment |
| **Workflow** | Installation/activation in target environment |

## Key Deliverables (in sequence)

| # | Artifact | Location |
|---|----------|----------|
| 1 | `manifest.md` (deployment deps) | `docs/active/manifest.md` |
| 2 | `capabilities.md` (deployment tools) | `docs/active/capabilities.md` |
| 3 | `plan.md` (deployment plan) | `docs/active/plan.md` |
| 4 | `BACKLOG.md` (delivery tasks) | Root |
| 5 | Deployed artifact | Target-specific |
| 6 | Access documentation | README or `docs/active/access.md` |

## Three-Tier Validation (in production)

| Tier | What | Pass Criteria |
|------|------|---------------|
| **1. Automated** | Tests in production/target | 95%+ pass rate |
| **2. Browser/Agent** | Interactive testing, user flows | Key flows complete, no critical bugs |
| **3. Manual** | User acceptance, edge cases | Human confirms: "This works" |

## Review Dimensions (Phase 4)

1. Does plan cover all deployment requirements?
2. Are tasks atomic?
3. Dependencies complete?
4. Testing strategy sufficient (3-tier)?
5. Rollback plan viable?
6. Deployment risks addressed?
7. User access clearly defined?

## Deliver-Specific Exit Criteria

- [ ] Artifact deployed/distributed to target
- [ ] Three-tier testing complete
- [ ] Access documentation exists (URLs, credentials, instructions)
- [ ] Success criteria from brief mapped to evidence
- [ ] Rollback plan tested or documented

## Type-Specific Criteria

| Type | Additional |
|------|-----------|
| **App (MVP)** | Production URL accessible, database configured, CI/CD working |
| **App (feature)** | Feature live, integrated with existing app |
| **Workflow** | Installed, activated, triggers working |
| **Artifact** | Exported, distributed, format validated |

## Milestone Closeout

1. **Cleanup** — .gitignore updated, transients deleted, no secrets
2. **Success Criteria Gate** — map each to evidence
3. **Access Documentation** — URLs, instructions, credentials
4. **Artifact Lifecycle** — keep: intent, brief, design. Archive: plan, manifest, capabilities
5. **Commit Verification** — no uncommitted changes
6. **status.md Seal** — mark milestone complete, structured handoff (LAST step)

**The usability test:** Human can access and use the artifact without assistance. If this fails, Deliver is not done.

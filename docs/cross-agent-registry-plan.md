---
type: "plan"
project: "Capabilities Registry Cross-Agent Alignment"
version: "0.1"
status: "draft-for-review"
created: "2026-02-11"
updated: "2026-02-11"
owner: "Capabilities Registry Team"
reviewers: ["Team", "External Agent Reviewer"]
---

# Plan: Cross-Agent Capabilities Registry (Claude Code, Codex, Gemini)

## Goal

Evolve this repository into a client-agnostic capabilities registry that works consistently across Claude Code, Codex, and Gemini, while remaining extensible for future agents.

## Outcomes

By end state, the registry will provide:

1. A unified capability model for skills, tools (MCP), agents, and packaging.
2. Reliable, reproducible install/config workflows per client.
3. A clear policy for always-on MCP servers and required configuration scope (user/global vs project).
4. Validation gates that prevent incomplete or client-incompatible registrations from being promoted.
5. Review-ready artifacts for human and agent audits.

## Non-Goals

1. Building new MCP servers.
2. Replacing each client's native plugin ecosystem.
3. Automating every install path immediately (manual fallback is acceptable in Phase 1).

## Current State (as of 2026-02-11)

1. Cross-client MCP installers exist for Claude Code, Codex, Gemini.
2. Standalone MCP install metadata is incomplete for some tools (notably `stitch-mcp`).
3. Registry scripts (`sync`, `generate-inventory`, `check-freshness`) have environment fragility due to YAML parser dependency assumptions.
4. Agents are modeled in manifests but do not yet have definition artifacts wired.
5. Plugin metadata is primarily Claude-oriented, creating portability ambiguity.
6. Skill corpus includes client-specific wording in multiple SKILL files.

## Design Principles

1. Capability-first model: describe what the capability is before how any one client installs it.
2. Explicit compatibility: no implicit assumptions about client support.
3. Safe defaults: always-on resources must be scoped conservatively and auditable.
4. Progressive portability: support Claude/Codex/Gemini first; make adding future clients schema-driven.
5. Human override: installer automation must permit dry-run and manual approval paths.

## Target Operating Model

### Capability Model

Every capability must declare:

1. Identity: `name`, `type`, `description`, `source`, lifecycle fields.
2. Runtime relationship: standalone vs bundled.
3. Client compatibility: which clients can consume it and by what install vector.
4. Scope recommendation: `user` or `project` with rationale.

### MCP Model

All MCP tool entries must support one of these modes:

1. Standalone MCP registration with complete launcher metadata.
2. Bundled via plugin/package with explicit parent mapping and client applicability.

### Always-On MCP Model

Always-on means MCP server is configured at user/global scope and expected to be present across sessions.

Policy:

1. Always-on is opt-in by explicit registry policy, not default for all servers.
2. Always-on servers must pass security, stability, and cross-project utility checks.
3. Default scope rules:
   - `project`: default for project-specific data access, repo-coupled servers, or high blast radius.
   - `user/global`: only for cross-project utility and low-risk infrastructure servers.
4. Every always-on designation must include a rollback/removal procedure.

## Scope Policy Matrix (Initial)

| Class | Default Scope | Always-On Eligible | Notes |
|------|---------------|--------------------|-------|
| Local project MCP (repo/data specific) | project | No (default) | Avoid cross-project leakage |
| Cross-project utility MCP (read-mostly infra) | user/global | Yes (case-by-case) | Require explicit review sign-off |
| External SaaS MCP with privileged tokens | project | Rarely | Prefer least-privilege per project |
| Experimental/community MCP | project | No | Trial only until validated |

## Plan Phases

## Phase 0: Alignment and Review Packet (1-2 days)

Deliverables:

1. This plan finalized and reviewed.
2. Decision log for unresolved policy choices.
3. Review checklist for team + external agent review.

Acceptance Criteria:

1. Team agrees on always-on definition and scope matrix.
2. Team agrees on required schema additions and validation gates.

## Phase 1: Registry Foundation Hardening (3-5 days)

Work:

1. Make `sync`, `generate-inventory`, and `check-freshness` deterministic in a clean environment.
2. Add a single registry validator command that checks:
   - Required fields by type.
   - File existence for referenced artifacts.
   - Launcher completeness for standalone MCP tools.
   - Parent reference validity for bundled MCP entries.
   - Client compatibility declarations.
3. Add CI/local check script to enforce validator before merge.

Deliverables:

1. `scripts/validate-registry.(sh|py|rb)` (single source of truth validator).
2. Updated script docs in `README.md`.
3. Validation report format that can be consumed by another agent.

Acceptance Criteria:

1. Validator runs successfully on a clean machine with documented prerequisites.
2. Broken MCP entries fail fast with actionable messages.

## Phase 2: Schema and Metadata Upgrade (3-5 days)

Work:

1. Update `REGISTRY-SPEC.md` to include client compatibility block (extensible for future clients).
2. Add required MCP policy fields for tools:
   - scope recommendation and rationale.
   - always-on eligibility.
   - installability status per client.
3. Normalize tool manifests to new schema (including `stitch-mcp` launcher completion or explicit blocked state).
4. Decide and encode packaging layer semantics (plugin as distribution layer, not competing capability semantics).

Deliverables:

1. `REGISTRY-SPEC.md` vNext.
2. Migrated `capability.yaml` entries for all tools.
3. Migration notes in `docs/` for future client onboarding.

Acceptance Criteria:

1. 100% tool manifests validate under new schema.
2. Scope and always-on status are explicit for every MCP tool.

## Phase 3: Always-On Baseline and Installer Policy (2-4 days)

Work:

1. Create canonical "always-on baseline" artifact in this repo (`data/always-on-baseline.yaml`).
2. Classify each MCP server:
   - required always-on
   - optional always-on
   - project-only
   - disallowed
3. Map baseline to installer behavior for each client:
   - Claude Code scope mapping
   - Codex scope mapping
   - Gemini scope mapping
4. Document rollback and drift detection process.

Deliverables:

1. Baseline file + policy doc (`docs/mcp-scope-policy.md`).
2. Installer compatibility table with dry-run examples.
3. Drift check command output spec.

Acceptance Criteria:

1. Team can answer: "Should this MCP be global or project?" deterministically.
2. Installers produce expected commands for each baseline category.

## Phase 4: Content Portability and Agent Readiness (4-7 days)

Work:

1. Reduce client-specific wording in SKILL corpus where unnecessary.
2. Add client-specific notes only in explicit compatibility sections.
3. Complete agent capability wiring (`agent_definition` artifacts and schema compliance).
4. Add cross-reference metadata among skills/tools/agents/packages.

Deliverables:

1. Portability edits across SKILL and manifest content.
2. Agent definition artifacts for all registered agents.
3. Cross-reference index in inventory output.

Acceptance Criteria:

1. Skills remain usable in Claude Code while becoming neutral for Codex/Gemini.
2. Every agent manifest points to an existing definition artifact.

## Phase 5: Review, Audit, and Release (2-3 days)

Work:

1. Run full validation and inventory regeneration.
2. Produce review bundle for team and external agent.
3. Resolve findings and issue release tag.

Deliverables:

1. `docs/review-bundle-cross-agent.md` summarizing:
   - schema changes
   - baseline policy
   - compatibility matrix
   - open risks
2. Final inventory + validation evidence.

Acceptance Criteria:

1. No Critical/High findings in review.
2. Team sign-off for Claude Code + Codex + Gemini readiness.

## Workstreams and Owners

| Workstream | Primary Owner | Support |
|-----------|----------------|---------|
| Schema + Validator | Registry Maintainer | Reviewer Agent |
| Installers + Scope Policy | Tooling Owner | Security Reviewer |
| Content Portability | Skills Owner | External Agent Reviewer |
| Agents Wiring | Agent Maintainer | Validator Agent |
| Final Audit | Team Lead | Cross-functional reviewers |

## Risks and Mitigations

1. Risk: Client CLI behavior changes.
   - Mitigation: keep installers dry-run-first and version-check CLI behavior.
2. Risk: Over-indexing on Claude plugin model.
   - Mitigation: separate packaging metadata from capability semantics.
3. Risk: Always-on servers create credential/scope risk.
   - Mitigation: require explicit justification + least privilege + rollback doc.
4. Risk: Migration churn across many manifests.
   - Mitigation: automate lint/validation and phase changes with migration notes.

## Review Checklist (Team + External Agent)

1. Does the schema cleanly support adding a fourth/fifth client without schema rewrite?
2. Is always-on policy explicit, enforceable, and least-privilege by default?
3. Can every standalone MCP tool be installed from manifest metadata alone?
4. Are bundled MCP tools clearly marked and non-ambiguous for non-Claude clients?
5. Do validators catch missing launcher metadata and missing agent definitions?
6. Are project vs user/global scope decisions documented with rationale?
7. Is the review bundle sufficient for independent reproduction?

## Open Decisions Needed Before Execution

1. Canonical compatibility field shape in `capability.yaml` (simple booleans vs per-client objects).
2. Minimum required metadata for agents (just `agent_definition` vs richer execution metadata).
3. Whether Gemini HTTP MCP install support should be automated now or documented as manual fallback.
4. Whether always-on baseline should be enforced automatically or advisory-only in Phase 1.

## Suggested Execution Order

1. Approve this plan.
2. Execute Phase 1 and Phase 2 first (foundation + schema).
3. Freeze schema and run metadata migration.
4. Execute Phase 3 policy baseline.
5. Execute Phase 4 portability and agent readiness.
6. Run Phase 5 review and release.

## Definition of Done

1. Registry validates with zero blocking errors.
2. Claude Code, Codex, and Gemini install flows are documented and reproducible from manifests.
3. Always-on and scope policies are explicit and auditable.
4. Review bundle passes team and external agent review with no unresolved high-severity findings.
5. Process supports adding future clients by configuration, not redesign.


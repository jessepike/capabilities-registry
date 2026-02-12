---
project: "Capabilities Registry"
stage: "Develop"
updated: "2026-02-12"
last_session: "2026-02-12"
---

# Status

## Current State

- **Stage:** Develop
- **Focus:** Scoping project-docs plugin — diagram-forge MCP + unified doc tooling

## What's Complete

- [x] Registry extracted from ACM (21 initial capabilities)
- [x] REGISTRY-SPEC.md (v1.2.0) — 4 capability types, MCP-specific fields, community sources
- [x] 71 capabilities registered (22 skills, 9 tools, 23 plugins, 17 agents)
- [x] 68 entries in declined.yaml
- [x] CR-1: Agent deep dive — 11 new agents registered, 19 staged, 41 declined
- [x] Scripts: sync, promote, generate-inventory, check-freshness
- [x] B34 MCP Server Registry — plugin-bundled MCPs, community scanning, triage workflow
- [x] First MCP triage report (500+ servers scanned, 0 high-relevance)

## What's Next

- [ ] CR-5: Add `clients` compatibility block to schema (P1) — unblocks client tracking
- [ ] CR-4 + CR-5: Schema updates (packaging layer + client compatibility) — do together
- [ ] CR-6: Audit all 60 capabilities for per-client enablement (P1)
- [x] CR-1: Deep dive — agents capability type (P1) ✓
- [ ] CR-2: Deep dive — skills catalog leverage (P1)
- [ ] CR-7/CR-8: Prune low-use skills, resolve quality=0 tool stubs (P2)

## Blockers

- None

## Session Log

| Date | Summary |
|------|---------|
| 2026-01-29 | Registry created. 21 capabilities migrated from agent-harness. Pushed to GitHub. |
| 2026-01-30 | Registered 19 plugins (21→39 caps). Added install levels. Created declined.yaml (15 entries). Fixed 4 scripts. |
| 2026-01-30 | B34 Discover+Design complete. Brief and design docs for MCP server registry. |
| 2026-01-31 | B34 Develop complete (all 7 WPs). REGISTRY-SPEC v1.2.0. 4 plugin-bundled MCPs. baseline v2.1.0. First triage. |
| 2026-01-31 | Environment cleanup — 6 unwanted plugins declined (27 total). |
| 2026-01-31 | Project bootstrapping — created own BACKLOG.md, status.md, .claude/CLAUDE.md. Migrated CR-1/2/3 from ACM backlog. Archived processed B34 inbox docs. |
| 2026-02-10 | Updated adf-env project-init agent: auto-detect brief files by name, move (not copy) brief to docs/inbox/, create initial intent.md from brief content, add BACKLOG.md creation, fix README template. |
| 2026-02-10 | Registered stitch-mcp tool (Google Stitch MCP Server for AI UI design generation). 57→58 capabilities. |
| 2026-02-10 | stitch-mcp registration needs correction: used community npm wrapper (@_davideast/stitch-mcp, stdio) instead of official Google remote MCP server (HTTP transport, API key auth). KB has official setup info but URL truncated. Awaiting full server URL to fix capability.yaml. |
| 2026-02-10 | Blocked on stitch-mcp fix — official Google docs (stitch.withgoogle.com) are JS-rendered SPAs, can't fetch. User to paste content from setup/guide/reference pages. Will then fix capability.yaml and update KB with complete info. |
| 2026-02-10 | Fixed stitch-mcp: corrected to official Google remote HTTP MCP server (was community npm/stdio). Updated description, transport, upstream, install_id. Archived truncated KB entry, replaced with complete reference (5 tools, usage patterns, auth details). Still need setup page content for full server URL. |
| 2026-02-11 | Reviewed cross-agent registry plan (docs/cross-agent-registry-plan.md). Disposition: Approve with changes. Key findings: Open Decision #1 (compatibility field shape) must be resolved before Phase 2, need concrete schema examples, content_fingerprint never populated, agent_definition in use but not in spec. |
| 2026-02-11 | Updated stitch-mcp to 6 tools (was 5, missing create_project). KB entry replaced with complete reference from official guide+reference pages. Removed accidental database files from tracking, added data/ to .gitignore. Committed cross-agent hardening work (launcher metadata, installer scripts, memory-layer + work-management-mcp tools). |
| 2026-02-11 | Completed stitch-mcp registration with full server URL (stitch.googleapis.com/mcp), launcher block with auth methods (API key + OAuth), and install commands for 5 clients (Claude Code, Cursor, VSCode, Gemini CLI, Antigravity). KB consolidated to single complete entry covering setup/guide/reference pages. 3 prior incomplete KB entries archived. |
| 2026-02-11 | Pushed all commits to origin. Identified gap in cross-agent plan: MCP runtime management. |
| 2026-02-11 | Researched MCP runtime management. Key finding: Codex is stdio-only (no HTTP/SSE). All 3 clients support stdio, so each can spawn its own process — no shared daemon needed for Phase 1. Updated cross-agent plan to v0.2: added transport compatibility matrix, runtime strategy, scope policy row for remote HTTP MCPs, 2 new risks, 2 new open decisions, 1 resolved decision. KB learning entry captured. Prior KB idea entry promoted to active. |
| 2026-02-10 | Session start — reviewed status, no work items actioned. |
| 2026-02-11 | Registry gap analysis session. Reviewed inventory (60 caps), backlog, cross-agent plan. Identified 5 gaps: no per-client enablement tracking, thin agent coverage, low-use skill noise, quality=0 tool stubs, no usage/activation data. Proposed CR-5 through CR-9 for backlog. Recommended top 3 priorities: CR-5+CR-4 (schema), CR-6 (client audit), CR-1 (agent deep dive). Proposed `clients` compatibility block schema resolving cross-agent plan Decision #1. Backlog updates pending user approval. |
| 2026-02-10 | Reviewed backlog, confirmed CR-1 (agents deep dive) still open. Parallel session on CR-5/CR-6 in progress. Ready to start CR-1 next. |
| 2026-02-11 | CR-1 complete. Phase 1: registered 11 new agents (5 ADF plugin, 6 Anthropic official), fixed 5 existing entries (removed broken agent_definition refs, noted external paths). 60→71 capabilities, 6→17 agents. Phase 2: triaged 3 external sources — 19 agents staged (8 Anthropic uninstalled, 10 VoltAgent, 1 hesreallyhim), 41 declined (unused languages, frontend, business roles, duplicates). declined.yaml: 27→68. Pushed to origin. |
| 2026-02-12 | Scoped diagram-forge MCP registration + broader doc tooling. Explored diagram-forge project (7 MCP tools, 3 providers, 7 templates, stdio transport, bundled plugin). Audited existing doc capabilities (doc-mgr agent, doc-coauthoring skill, adr skill, claude-md-management plugin, project-health skill, context7). Identified gap: no unified orchestration for keeping project docs updated. Proposed `project-docs` plugin design — bundles diagram-forge MCP, adds /docs:audit /docs:generate /docs:update /docs:diagram commands, doc-intelligence skill, doc-analyst agent, post-implement hooks. Awaiting user decision to proceed with build. |

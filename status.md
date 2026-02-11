---
project: "Capabilities Registry"
stage: "Develop"
updated: "2026-02-11"
last_session: "2026-02-11"
---

# Status

## Current State

- **Stage:** Develop
- **Focus:** Project bootstrapping — own backlog, status, and CLAUDE.md established

## What's Complete

- [x] Registry extracted from ACM (21 initial capabilities)
- [x] REGISTRY-SPEC.md (v1.2.0) — 4 capability types, MCP-specific fields, community sources
- [x] 39 capabilities registered (16 skills, 4 tools, 19 plugins)
- [x] 27 entries in declined.yaml
- [x] Scripts: sync, promote, generate-inventory, check-freshness
- [x] B34 MCP Server Registry — plugin-bundled MCPs, community scanning, triage workflow
- [x] First MCP triage report (500+ servers scanned, 0 high-relevance)

## What's Next

- [ ] CR-1: Deep dive — agents capability type (P1)
- [ ] CR-2: Deep dive — skills catalog leverage (P1)
- [ ] CR-3: Add community sources to sync (P3)

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
| 2026-02-11 | Pushed all commits to origin. Identified gap in cross-agent plan: MCP runtime management — local standalone stdio servers (adf-server, knowledge-base, memory-layer, work-management-mcp) need process supervision for Codex/Gemini access. Claude Code spawns on demand but other clients expect servers already running. Options: launchd, pm2, Docker Compose, MCP gateway. Needs Phase 0.5 in plan. |

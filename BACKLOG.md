---
type: "tracking"
description: "Capabilities Registry backlog — prioritized queue of work items"
version: "1.1.0"
updated: "2026-01-31"
scope: "capabilities-registry"
---

# Capabilities Registry Backlog

## Registry Model

Three capability types, one packaging layer:

- **Plugin** — packaging/distribution layer (bundles skills, tools, agents)
- **Skills** — expertise + procedures
- **Tools** — MCP connectivity
- **Agents** — isolated workers with own context window

Cross-references: skills can reference agents they delegate to, agents reference tools they need, plugins list everything they bundle.

## Queue

| ID | Item | Type | Pri | Size | Status |
|----|------|------|-----|------|--------|
| CR-1 | Populate `capabilities/agents/` — sync from 3 sources: `anthropics/claude-plugins-official` (official), `VoltAgent/awesome-claude-code-subagents` (curated, 100+), `hesreallyhim/a-list-of-claude-code-agents` (community). Include personal agents from `~/.claude/agents/` | Research | P1 | L | Pending |
| CR-2 | Deep dive: skills catalog — review registered skills, sync from `anthropics/skills` + community collections, identify leverage opportunities for ACM workflows | Research | P1 | L | Pending |
| CR-3 | Extend community source sync to skills and agents (MCP sync complete) | Enhancement | P2 | M | Pending |
| CR-4 | Update `REGISTRY-SPEC.md` — make plugins a packaging layer (not peer type), add cross-reference fields (`bundled_in`, `delegates_to`, `requires_tools`) | Spec | P2 | S | Pending |

---

## Archive

| ID | Item | Completed | Notes |
|----|------|-----------|-------|
| — | (Migrated from ACM backlog B35, B36, B13 on 2026-01-31) | — | — |
| CR-3 (original) | Add 2-3 community sources to registry sync | 2026-01-31 | MCP sources done; remaining work split into new CR-3 (skills/agents) and CR-4 (spec update) |

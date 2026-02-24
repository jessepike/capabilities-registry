---
project: "Capabilities Registry"
stage: "Develop"
updated: "2026-02-24"
last_session: "2026-02-24"
---

# Status

## Current State

- **Stage:** Develop
- **Capabilities:** 71 (17 agents, 23 plugins, 22 skills, 9 tools)
- **Declined:** 68 entries in declined.yaml

## What's Complete

- [x] Registry extracted from ACM (21 initial capabilities)
- [x] REGISTRY-SPEC.md (v1.3.0) — 4 capability types, MCP-specific fields, community sources, clients block
- [x] 71 capabilities registered (17 agents, 23 plugins, 22 skills, 9 tools)
- [x] 68 entries in declined.yaml
- [x] CR-1: Agent deep dive — 11 new agents registered, 19 staged, 41 declined
- [x] CR-5 + CR-6: `clients` compatibility block added to schema and all 71 capabilities audited
- [x] CR-10: Memory MCP registered in Codex and Gemini
- [x] Scripts: sync, promote, generate-inventory, check-freshness
- [x] B34 MCP Server Registry — plugin-bundled MCPs, community scanning, triage workflow
- [x] project-docs plugin v0.1 — 4 commands, 1 agent (4 modes), 1 skill, doc-expectations reference

## What's Next

- [ ] CR-2: Deep dive — skills catalog leverage (P1)
- [ ] CR-3: Extend community source sync to skills and agents (P2)
- [ ] CR-4: REGISTRY-SPEC update — plugins as packaging layer, cross-ref fields (P2)
- [ ] CR-7: Prune low-use Anthropic skills (P2)
- [ ] CR-8: Resolve quality=0 tool stubs — github-mcp, stripe-mcp, supabase-mcp, vercel-mcp (P2)
- [ ] CR-9: Add usage/activation tracking (P2)

## Accuracy Mechanism

**Refresh cadence:** Regenerate INVENTORY.md whenever capabilities are added, removed, or materially changed:

```bash
cd ~/code/_shared/capabilities-registry
bash scripts/generate-inventory.sh
```

**Trigger:** Run after any of these events:
- New capability registered (`capabilities/*/`)
- Capability moved to `declined.yaml`
- `clients` block updated on any capability
- `REGISTRY-SPEC.md` version bump

**Last regenerated:** 2026-02-24 (71 capabilities)

## Session Log

| Date | Summary |
|------|---------|
| 2026-01-29 | Registry created. 21 capabilities migrated from agent-harness. |
| 2026-01-30 | Registered 19 plugins (21→39 caps). Added install levels. declined.yaml created. |
| 2026-01-31 | B34 complete. REGISTRY-SPEC v1.2.0. 4 plugin-bundled MCPs. First triage. |
| 2026-02-10 | stitch-mcp registered (57→58). Fixed community npm vs official HTTP transport. |
| 2026-02-11 | CR-1 complete. 60→71 capabilities, 6→17 agents. CR-5/CR-6 done. REGISTRY-SPEC v1.3.0. |
| 2026-02-12 | project-docs plugin v0.1 built and registered. |
| 2026-02-24 | Accuracy mechanism defined. INVENTORY.md regenerated (72→71, one tool removed in prior commit). Status.md brought current. |

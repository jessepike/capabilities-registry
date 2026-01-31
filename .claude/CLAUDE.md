# Capabilities Registry Project Context

## What This Is

Curated personal catalog of skills, tools, agents, and plugins for agentic development. Part of the ACM ecosystem but maintained as its own repo.

## Orientation

1. `.claude/CLAUDE.md` — This file (project context)
2. `BACKLOG.md` — Tracked work items
3. `status.md` — Current state and session log
4. `REGISTRY-SPEC.md` — Governing specification
5. `INVENTORY.md` — Derived capability inventory (do not hand-edit)

## Context Map

| Artifact | Purpose |
|----------|---------|
| `capabilities/` | Active capabilities (skills, tools, agents, plugins) |
| `staging/` | Candidates awaiting promotion |
| `archive/` | Deprecated or processed artifacts |
| `inbox/` | Triage zone (MCP scan results, etc.) |
| `declined.yaml` | Evaluated and rejected capabilities |
| `inventory.json` | Machine-readable inventory (derived) |
| `INVENTORY.md` | Human-readable inventory (derived) |
| `scripts/` | Automation (sync, promote, generate-inventory, check-freshness) |

## Data Flow

```
capability.yaml → generate-inventory.sh → inventory.json → INVENTORY.md
```

Never hand-edit `inventory.json` or `INVENTORY.md` — they are derived.

## Related Repos

| Repo | Location | Relationship |
|------|----------|-------------|
| ACM | `~/code/_shared/acm/` | Parent framework — specs, stages, prompts |
| acm-env plugin | `~/.claude/plugins/acm-plugins/plugins/acm-env/` | Consumes registry via refresh/capabilities commands |
| link-triage-pipeline | `~/code/_shared/link-triage-pipeline/` | Sibling project |

## Working Norms

- `capability.yaml` is source of truth for each capability
- Derived files are regenerated, not edited
- New capabilities enter via `staging/` or `inbox/`, never directly to `capabilities/`
- Declined capabilities go to `declined.yaml` with rationale

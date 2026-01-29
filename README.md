# Capability Registry

Curated personal catalog of skills, tools, agents, and plugins for agentic development.

## Quick Start

```bash
# See what's available
cat INVENTORY.md

# Check for stale capabilities
./scripts/check-freshness.sh

# Fetch latest from upstream
./scripts/sync.sh

# Promote from staging to active
./scripts/promote.sh <name>

# Regenerate inventory after changes
./scripts/generate-inventory.sh
```

## Structure

```
capabilities/
├── skills/      # SKILL.md-based procedural knowledge
├── tools/       # MCP servers, deterministic scripts
├── agents/      # Sub-agent definitions
└── plugins/     # Composite packages (skills + hooks + commands)
```

Each capability has a `capability.yaml` manifest (source of truth).

## Data Flow

```
capability.yaml → generate-inventory.sh → inventory.json → INVENTORY.md
```

Never hand-edit `inventory.json` or `INVENTORY.md` — they are derived.

## Lifecycle

`staging/` → `capabilities/<type>/` (active) → `archive/` (deprecated)

## Sources

| Source | Types |
|--------|-------|
| Anthropic | Skills |
| Model Context Protocol | Tools |
| Internal | Plugins, Agents |

See `REGISTRY-SPEC.md` for full specification.

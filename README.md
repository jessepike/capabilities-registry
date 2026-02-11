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


## MCP Installers (Cross-Client)

For standalone MCP tool capabilities that include `launcher` metadata in `capability.yaml`, use:

```bash
# Codex (dry-run by default)
./scripts/install-mcp-codex.sh adf-server
./scripts/install-mcp-codex.sh adf-server --apply

# Claude Code
./scripts/install-mcp-claude.sh adf-server --scope project
./scripts/install-mcp-claude.sh adf-server --scope user --apply

# Gemini CLI
./scripts/install-mcp-gemini.sh adf-server --scope user
./scripts/install-mcp-gemini.sh adf-server --scope user --apply
```

Notes:
- Installers default to dry-run so you can inspect generated commands first.
- Plugin-bundled MCP entries (`install_vector: plugin`) are intentionally skipped by these installers.

## Structure

```
capabilities/
├── skills/      # SKILL.md-based procedural knowledge
├── tools/       # MCP servers, deterministic scripts
├── agents/      # Sub-agent definitions
└── plugins/     # Composite packages (skills + hooks + commands)
declined.yaml    # Evaluated and rejected capabilities
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
| Anthropic | Skills, Plugins |
| Model Context Protocol | Tools |
| Internal | Plugins, Agents |

See `REGISTRY-SPEC.md` for full specification.

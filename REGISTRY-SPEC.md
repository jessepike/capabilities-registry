---
type: "specification"
description: "Defines the capability registry — structure, types, lifecycle, and data flow"
version: "1.2.0"
updated: "2026-01-30"
lifecycle: "reference"
---

# Capability Registry Specification

## Purpose

Define the structure and rules for the capability registry — a curated personal catalog of skills, tools, agents, and plugins available for agentic development across all project stages.

## Scope

The registry is standalone. It is consumed by ACM stages but not coupled to ACM. Any agent, any stage, any project can query the registry to discover available capabilities.

---

## Capability Types

| Type | Definition | Primary Artifact | Example |
|------|------------|-----------------|---------|
| **Skill** | Procedural knowledge — instructions and supporting files | `SKILL.md` | frontend-design, pdf, webapp-testing |
| **Tool** | MCP servers or deterministic scripts providing functional extensions | `README.md` or server config | memory-mcp, filesystem-mcp |
| **Agent** | Sub-agent definitions with specialized domain expertise | Agent definition file | ui-reviewer, supabase-expert |
| **Plugin** | Composite packages bundling skills, hooks, and commands | `plugin.json` | acm-env |

---

## Directory Structure

```
capabilities-registry/
├── capabilities/
│   ├── skills/
│   │   └── <name>/
│   │       ├── capability.yaml    # Source of truth
│   │       ├── SKILL.md           # The skill itself
│   │       └── [supporting files]
│   ├── tools/
│   │   └── <name>/
│   │       ├── capability.yaml
│   │       └── [tool files]
│   ├── agents/
│   │   └── <name>/
│   │       ├── capability.yaml
│   │       └── [agent files]
│   └── plugins/
│       └── <name>/
│           ├── capability.yaml
│           └── [plugin files]
├── staging/                       # Not yet promoted
├── archive/                       # Deprecated versions
├── scripts/
│   ├── generate-inventory.sh
│   ├── check-freshness.sh
│   ├── sync.sh
│   └── promote.sh
├── declined.yaml                  # Evaluated and rejected capabilities
├── inventory.json                 # Derived index
├── INVENTORY.md                   # Derived human-readable
└── REGISTRY-SPEC.md              # This file
```

---

## capability.yaml Schema

Each capability directory contains a `capability.yaml` — the source of truth for that capability.

### Required Fields

```yaml
name: frontend-design
type: skill                          # skill | tool | agent | plugin
description: "One-line description"
source: anthropic                    # Origin: anthropic, modelcontextprotocol, internal, community
status: active                       # staging | active | archive
tags: [ui, frontend, design]
added: "2026-01-29"
updated: "2026-01-29"
```

### Optional Fields

```yaml
upstream: "https://github.com/..."   # Upstream source URL
version: "20260123.1"                # Version identifier
quality: 100                         # 0-100 quality score (subjective; see quality note below)
content_fingerprint: "sha256:..."    # Content hash for change detection
install_id: "name@registry"          # Plugin/MCP install identifier (e.g., "commit-commands@claude-plugins-official")
install_level: project               # Recommended install level: user | project

# MCP-specific fields (type: tool only)
install_vector: standalone           # standalone | plugin — how the MCP server is installed
parent_plugin: null                  # Plugin name when install_vector: plugin
transport: stdio                     # stdio | http | sse — MCP transport protocol
launcher:                            # Optional concrete launch metadata for cross-client installers
  type: stdio                        # stdio | http | sse
  command: node                      # For stdio servers
  args: ["/abs/path/to/server.js"]  # For stdio servers
  env: { ADF_ROOT: "/abs/path" }    # Optional env vars for stdio
  url: "https://example.com/mcp"    # For http/sse servers
  headers: { Authorization: "Bearer ${TOKEN}" } # Optional request headers
  bearer_token_env: MCP_TOKEN        # Optional env var name (Codex streamable-http)
```

---

## Tags

Tags enable agent queryability. Agents search by need ("Do I have database capabilities?").

### Common Tags

| Category | Tags |
|----------|------|
| Frontend | `ui`, `css`, `components`, `frontend`, `design` |
| Backend | `backend`, `api`, `server`, `database` |
| Documents | `pdf`, `docx`, `pptx`, `xlsx`, `documents` |
| Testing | `testing`, `qa`, `automation` |
| DevOps | `deployment`, `ci-cd`, `infrastructure` |
| AI/ML | `mcp`, `agents`, `skills`, `ai` |
| Communication | `slack`, `email`, `messaging` |

Tags are a loose convention. New tags can be added freely. Common tags should be documented here.

---

## Lifecycle

```
  staging/              capabilities/<type>/         archive/
  (testing)      →      (active)              →     (deprecated)
                promote.sh                    manual move
```

| Status | Location | Meaning |
|--------|----------|---------|
| `staging` | `staging/` | Under evaluation, not yet promoted |
| `active` | `capabilities/<type>/` | Available for use |
| `archive` | `archive/` | Deprecated, kept for reference/rollback |

---

## Data Flow

```
capability.yaml (per capability, source of truth)
        ↓
generate-inventory.sh (scans all capability.yaml files)
        ↓
inventory.json (derived, machine-readable index)
        ↓
INVENTORY.md (derived, human/agent-readable catalog)
```

- **Never hand-edit** `inventory.json` or `INVENTORY.md`
- Edit `capability.yaml` in the capability directory, then regenerate
- `generate-inventory.sh` is idempotent — safe to run anytime

---

## Freshness

`check-freshness.sh` compares local capabilities against upstream sources.

- Reports what's stale (upstream has newer content)
- **Does not auto-update** — human decides when to pull
- Uses `content_fingerprint` in `capability.yaml` for change detection
- For git-based upstreams, compares local vs remote HEAD

---

## Sync Pipeline

`sync.sh` fetches from upstream sources:

1. **Fetch** — clone/pull from upstream git repos
2. **Validate** — check quality score, security scan
3. **Stage** — place in `staging/` with `capability.yaml`

Promotion from staging to active is a separate manual step via `promote.sh`.

### Sources

Community sources are scanned weekly via `/acm-env:refresh`. New discoveries land in `inbox/mcp-triage.md` for human review.

| Source | URL | Types |
|--------|-----|-------|
| anthropic | `https://github.com/anthropics/skills` | Skills, Plugins |
| modelcontextprotocol | `https://github.com/modelcontextprotocol/servers` | Tools |
| mcp-registry | `registry.modelcontextprotocol.io` | Tools |
| awesome-mcp | `github.com/wong2/awesome-mcp-servers` | Tools |
| mcp-market | `mcpmarket.com` | Tools |

---

## Organization

Capabilities are organized by **name**, not by vendor.

- `skills/frontend-design/` not `skills/@anthropic/frontend-design/`
- Vendor/source is metadata in `capability.yaml`, not folder structure
- Agents query by need: "Do I have Supabase capabilities?"

---

## Relationship to ACM

- The registry is **consumed by** ACM stages, not coupled to ACM
- Any stage can query the registry (Discover, Design, Develop, Deliver)
- ACM's Develop Phase 2 (Capability Assessment) reads the inventory
- The registry does not know about ACM — it is self-contained
- acm-env may audit the registry as part of environment health checks

---

## Declined Capabilities

`declined.yaml` tracks upstream capabilities that have been evaluated and rejected.

- Sync skips declined capabilities (won't re-stage them)
- Remove an entry to re-evaluate on next refresh
- Each entry records: name, source, reason for declining

---

## MCP Installer Scripts

The registry provides per-client installers for standalone MCP tools:

- `scripts/install-mcp-codex.sh`
- `scripts/install-mcp-claude.sh`
- `scripts/install-mcp-gemini.sh`

Behavior:
- Reads `capabilities/tools/<name>/capability.yaml`
- Requires `launcher` metadata for standalone entries
- Defaults to dry-run; pass `--apply` to execute install commands
- Skips plugin-bundled entries (`install_vector: plugin`)

## References

- ACM-ENVIRONMENT-SPEC.md (Capabilities primitive)

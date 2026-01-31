---
type: "design"
project: "B34 — MCP Server Registry and Environment Support"
version: "0.4"
status: "internal-review-complete"
created: "2026-01-30"
updated: "2026-01-31"
brief_ref: "./brief-b34-mcp-servers.md"
intent_ref: null  # No standalone intent.md — brief serves as primary reference
---

# Design: MCP Server Registry and Environment Support

## Summary

This design extends the existing capabilities registry and acm-env plugin to treat MCP servers as first-class capabilities. Three systems change: (1) the registry gains MCP-specific schema and community sources, (2) baseline.yaml gains MCP server governance, and (3) two existing acm-env commands (`refresh` and `setup`) extend to handle MCP servers alongside plugins.

No new commands. No new repos. Minimal new artifacts. We extend what exists.

---

## Orchestration

### Dependency Graph

```
1. REGISTRY-SPEC.md schema changes
   ├──→ 2a. Extract plugin-bundled MCPs (new tools/ entries)
   ├──→ 2b. Decline 4 standalone MCPs (update declined.yaml)
   ├──→ 2c. Extend baseline.yaml (add mcp_servers section)
   │         └──→ 4. Extend /acm-env:setup (reads new baseline section)
   └──→ 3. Add community sources to REGISTRY-SPEC.md
         └──→ 5. Extend /acm-env:refresh (scan MCP sources)
                  └──→ 6. Create inbox/ in capabilities-registry
                           └──→ 7. Produce first triage report

8. Regenerate inventory (after 2a, 2b complete)
```

Steps 2a, 2b, 2c, and 3 can run in parallel after step 1.

### Work Packages

| # | Package | Repo | Depends On |
|---|---------|------|------------|
| WP1 | Registry schema + sources | capabilities-registry | — |
| WP2 | Registry entries (extract + decline) | capabilities-registry | WP1 |
| WP3 | Baseline extension | acm-env | WP1 |
| WP4 | Extend refresh command | acm-env | WP1, WP3 |
| WP5 | Extend setup command | acm-env | WP3 |
| WP6 | First triage report | capabilities-registry | WP4 |
| WP7 | Regenerate inventory | capabilities-registry | WP2 |

---

## Integration Points

### Repos Touched

| Repo | Location | Changes |
|------|----------|---------|
| capabilities-registry | `~/code/_shared/capabilities-registry/` | REGISTRY-SPEC.md, declined.yaml, tools/ entries, inbox/, inventory pipeline |
| acm-env plugin | `~/.claude/plugins/acm-plugins/plugins/acm-env/` | baseline.yaml, refresh.md, setup.md |

### External Sources

| Source | URL | Access Method | Data Retrieved |
|--------|-----|---------------|----------------|
| Official MCP Registry | registry.modelcontextprotocol.io | HTTPS API (JSON) | Server names, descriptions, versions, repo URLs |
| Awesome MCP Servers | github.com/wong2/awesome-mcp-servers | GitHub raw README | Server names, descriptions, categories, repo links |
| MCP Market | mcpmarket.com | HTTPS (HTML) | Server listings, descriptions |

---

## Data Flow

### Registration Flow (new MCP server enters registry)

```
Community source scan
        ↓
Triage report (inbox/mcp-triage.md)
        ↓
Human reviews → Accept or Decline
        ↓
Accept:                          Decline:
  Create tools/<name>/             Add to declined.yaml
    capability.yaml                  (name, source, reason)
        ↓
  generate-inventory.sh
        ↓
  inventory.json + INVENTORY.md updated
```

### Plugin-Bundled MCP Extraction Flow (one-time)

```
Existing plugin entry (plugins/<name>/capability.yaml)
        ↓
Identify bundled MCP server (from plugin .mcp.json or docs)
        ↓
Create tools/<mcp-name>/capability.yaml
  install_vector: plugin
  parent_plugin: <plugin-name>
        ↓
generate-inventory.sh
```

### Install Flow (via /acm-env:setup)

```
baseline.yaml (mcp_servers section)
        ↓
/acm-env:setup detects mode
        ↓
For each required MCP server:
  Check if already configured in Claude Code
  If missing → report to user, offer to configure
        ↓
For each "remove" MCP server:
  Check if configured
  If present → report to user, offer to remove
```

---

## Detailed Changes

### WP1: Registry Schema + Sources

**File: REGISTRY-SPEC.md**

Add to `capability.yaml Schema > Optional Fields`:

```yaml
# MCP-specific fields (type: tool only)
install_vector: standalone       # standalone | plugin
parent_plugin: null              # Plugin name when install_vector: plugin
transport: stdio                 # stdio | streamable-http | sse (legacy)
quality: null                    # null = inherited from plugin; scored for standalone
```

- `install_vector` — how this MCP server is installed. `standalone` means direct MCP configuration; `plugin` means installed via a parent plugin.
- `parent_plugin` — when `install_vector: plugin`, references the plugin that bundles this MCP server.
- `transport` — MCP transport protocol. Informational; helps setup know how to configure.
- `quality` — quality assessment. `null` for plugin-bundled MCPs (quality inherited from parent plugin); scored independently for standalone MCPs.

Add to `Sources` table:

| Source | URL | Types |
|--------|-----|-------|
| mcp-registry | registry.modelcontextprotocol.io | Tools |
| awesome-mcp | github.com/wong2/awesome-mcp-servers | Tools |
| mcp-market | mcpmarket.com | Tools |

Update `Sources` section note: "Community sources are scanned weekly via `/acm-env:refresh`. New discoveries land in `inbox/mcp-triage.md` for human review."

**File: Add `inbox/` directory**

Create `capabilities-registry/inbox/` with a `.gitkeep` and `inbox/mcp-triage.md` stub:

```markdown
# MCP Server Triage

Last scanned: (not yet scanned)

## Sources

| Source | Last Checked | Status |
|--------|-------------|--------|
| registry.modelcontextprotocol.io | — | Pending |
| github.com/wong2/awesome-mcp-servers | — | Pending |
| mcpmarket.com | — | Pending |

## New Discoveries

(None yet — run /acm-env:refresh to scan)

## Scan Summary

(Updated after each scan)
```

---

### WP2: Registry Entries

**Remove legacy tool entries** — delete any existing `capabilities/tools/` directories for the following (carried over from previous work, starting fresh):

- `memory-mcp`
- `filesystem-mcp`
- `everything-mcp`
- `sequentialthinking-mcp`

**Create fresh `tools/` entries** for plugin-bundled MCPs:

| MCP Server | Parent Plugin | Source | Transport |
|------------|---------------|--------|-----------|
| github-mcp | github | anthropic | streamable-http |
| supabase-mcp | supabase | anthropic | stdio |
| stripe-mcp | stripe | anthropic | stdio |
| vercel-mcp | vercel | anthropic | stdio |

Each gets a `capability.yaml` like:

```yaml
name: github-mcp
type: tool
description: "GitHub MCP server — repo management, issues, PRs, code search"
source: anthropic
status: active
tags: [mcp, github, vcs, code]
install_vector: plugin
parent_plugin: github
transport: streamable-http
upstream: "https://github.com/anthropics/claude-code-plugins"
added: "2026-01-30"
updated: "2026-01-30"
```

No README or supporting files needed — the plugin owns the docs. The tools/ entry is for tracking and discovery only.

**Decline 4 standalone MCPs** — add to `declined.yaml`:

| Name | Reason |
|------|--------|
| memory-mcp | Deferred to B18 (memory layer). Not needed for current workflows. |
| filesystem-mcp | Redundant with Claude Code built-in file tools (Read, Write, Edit, Glob, Grep). |
| everything-mcp | Test/reference implementation only. No production use case. |
| sequentialthinking-mcp | Redundant with Claude's built-in extended thinking. |

---

### WP3: Baseline Extension

**File: `skills/env-auditor/references/baseline.yaml`** (in acm-env plugin)

Add `mcp_servers` section under `user_level.checks` (new key — does not exist yet at user level):

```yaml
    mcp_servers:
      scope: "cross-project only"
      note: "MCP servers needed across all projects"
      required: []
        # None required at MVP — all current MCP servers are plugin-bundled
      available:
        # Standalone MCP servers available for project-level install
        # (none currently — plugin-bundled MCPs install via their parent plugin)
      remove:
        # Known unnecessary — should not be configured
        - "memory-mcp"
        - "filesystem-mcp"
        - "everything-mcp"
        - "sequentialthinking-mcp"
```

Update existing `project_level.checks.mcp_servers` (already exists with `scope` and `note` only) to add `required`/`available`/`remove` keys:

```yaml
    mcp_servers:
      scope: "project-specific only"
      note: "MCP servers for this project. Plugin-bundled MCPs install via their parent plugin."
      required: []
      available: []
      remove: []
```

Bump baseline version to `2.1.0` (additive change, not breaking).

---

### WP4: Extend Refresh Command

**File: `commands/refresh.md`** (in acm-env plugin)

The existing step 3 ("Sync from Upstream") already syncs MCP servers from `modelcontextprotocol/servers` via `sync.sh`. That covers the **upstream** source. The community scan below covers **additional community sources** not included in the upstream sync script.

Add after the existing "Sync from Upstream" step (as new step 3b, before step 4 "Read Declined List"):

```markdown
### 3b. Scan MCP Community Sources

Scan the 3 registered MCP community sources for new servers:

1. **Official MCP Registry** (registry.modelcontextprotocol.io)
   - Fetch server list via API
   - Compare against existing tools/ entries and declined.yaml
   - Note any new or updated servers

2. **Awesome MCP Servers** (github.com/wong2/awesome-mcp-servers)
   - Fetch README content
   - Parse server listings
   - Compare against existing and declined

3. **MCP Market** (mcpmarket.com)
   - Fetch listings
   - Compare against existing and declined

For each source, identify:
- **New:** Not in registry and not in declined.yaml
- **Updated:** In registry but upstream has newer version
- **Known:** Already registered or declined (skip)

### 3c. Produce MCP Triage

Update `~/code/_shared/capabilities-registry/inbox/mcp-triage.md`:

- Update "Last Checked" dates per source
- Add new discoveries to "New Discoveries" section with:
  - Date found
  - Name
  - Source
  - One-line description
  - Agent relevance note (project fit, overlap with existing capabilities)
- Update "Scan Summary" with:
  - Total servers scanned per source
  - New discoveries count
  - Already known/declined count
  - Top recommendations (agent's curated picks with rationale)
```

Update the summary template to include MCP:

```
UPSTREAM SYNC
  Anthropic skills: [fetched|error] — N new, N active (skipped), N declined (skipped)
  MCP servers (upstream): [fetched|error] — N new, N active (skipped), N declined (skipped)

MCP COMMUNITY SCAN
  Official Registry: N total scanned, N new, N known
  Awesome MCP Servers: N total scanned, N new, N known
  MCP Market: N total scanned, N new, N known
  Top Recommendations: [curated list with relevance notes]
  Full triage: ~/code/_shared/capabilities-registry/inbox/mcp-triage.md
```

---

### WP5: Extend Setup Command

**File: setup.md**

In "Mode: Existing Project", add after the plugin checks:

```markdown
### MCP Server Checks

Read `baseline.yaml` mcp_servers section.

For each `required` MCP server:
  - Check if configured in Claude Code MCP settings (.mcp.json)
  - If missing: report to user and request approval to install
  - On approval: write the MCP server config to .mcp.json
  - Log what was added

For each `remove` MCP server:
  - Check if configured in .mcp.json
  - If present: report to user and request approval to remove
  - On approval: remove the entry from .mcp.json
  - Log what was removed

For each `available` MCP server:
  - Note as available but not required
  - Only mention if relevant to current project type

### Post-Setup Notice

After making any MCP server changes, report:
  - What was added/removed
  - Instruct user: "Restart your Claude Code session to activate MCP server changes."

MCP servers cannot be hot-reloaded into a running session.
The agent writes configuration after user approval; the user only needs to restart.
```

---

### WP6: First Triage Report

After WP4 is implemented, run `/acm-env:refresh` to:
- Scan all 3 community sources
- Produce the first `inbox/mcp-triage.md` with actual data
- Validates the end-to-end workflow

---

### WP7: Regenerate Inventory

After WP2 entries are created:
- Run `generate-inventory.sh`
- Verify new MCP tool entries appear in `inventory.json` and `INVENTORY.md`
- Verify declined MCPs no longer appear in active inventory

---

## Error Handling

| Failure | Impact | Response |
|---------|--------|----------|
| Community source unreachable | Scan incomplete for that source | Log error in triage file, continue with other sources. Next scan catches anything missed. |
| API rate limiting (e.g., mcpmarket.com) | Cannot scan that source | Log and skip. Next scan catches it. |
| Plugin .mcp.json not accessible | Can't extract transport info | Use "unknown" transport. Note in capability.yaml. |
| generate-inventory.sh fails | Inventory stale | Report error. Fix manually. |

**Philosophy:** Best-effort scanning. No degraded mode or retry complexity. If a source fails, log it and move on. Missing an MCP server is acceptable — the next weekly scan catches it.

---

## Triggers

| Trigger | Action | Frequency |
|---------|--------|-----------|
| User runs `/acm-env:refresh` | Full sync + MCP community scan | Weekly (manual) |
| User runs `/acm-env:setup` | Check MCP baseline compliance | On demand |
| New MCP server accepted from triage | Create tools/ entry, regenerate inventory | As needed |
| MCP server declined from triage | Add to declined.yaml, remove from triage | As needed |

---

## Capabilities

No new tools or external capabilities needed. All work uses:
- Existing acm-env plugin commands (refresh, setup)
- Existing registry scripts (generate-inventory.sh, check-freshness.sh, sync.sh)
- Claude Code built-in tools (Read, Write, Edit, WebFetch, Bash)

---

## Decision Log

| # | Decision | Rationale | Alternatives Considered |
|---|----------|-----------|------------------------|
| D1 | Extend existing commands, no new commands | Minimizes surface area. MCP servers are just another capability type. | New `/acm-env:mcp` command — rejected (YAGNI) |
| D2 | Plugin-bundled MCPs get separate tools/ entries | Enables independent tracking, discovery, and cross-referencing. Plugin remains install vector. | Metadata-only in plugin entry — rejected (less visible) |
| D3 | Triage file in capabilities-registry inbox/ | Registry is the MCP home. ACM inbox is for ACM-specific items. | ACM docs/inbox/ — rejected (wrong repo) |
| D4 | Best-effort scan, curated output | Agent scans everything but surfaces top recommendations. If a source fails, log and move on — next scan catches it. No degraded mode complexity. | Filtered scan — rejected (might miss things). Full list — rejected (noisy). Retry/degraded mode — rejected (unnecessary complexity). |
| D5 | `transport` field in capability.yaml | Setup needs to know how to configure the MCP server (stdio vs http). Informational but useful. | Omit — rejected (setup would have to guess) |
| D6 | Baseline v2.1.0 with empty required list | No standalone MCPs are required at MVP. Structure is ready for when they are. Additive change, not breaking. | v3.0.0 — rejected (not a breaking change). Pre-populate with candidates — rejected (YAGNI). |
| D7 | Agent writes .mcp.json after user approval, user restarts session | High agent utilization with explicit consent. MCP servers can't hot-reload, so restart is the only manual step. | Fully automatic (no approval) — rejected (user should approve installs). Fully manual (user configures) — rejected (unnecessary friction). |
| D8 | Remove legacy tool entries, create fresh | Previous entries were carried over from earlier work. Clean slate avoids confusion about provenance. | Verify and update existing — rejected (unnecessary). |

---

## Backlog (Deferred)

| Item | Rationale for Deferral |
|------|----------------------|
| Automated scan via cron | Manual weekly scan is sufficient for MVP. Automate when volume warrants. |
| Unified capabilities scan (skills, agents) | Skills and agents don't have community sources yet. Refresh already skips gracefully. |
| MCP server quality scoring | Need more data points before defining a scoring rubric. Use qualitative assessment for now. |
| Memory layer MCP integration (B18) | Separate project. memory-mcp declined pending B18 design. |

---

## Open Questions

- (None — all resolved during intake)

---

## Issue Log

| # | Issue | Source | Severity | Status | Resolution |
|---|-------|--------|----------|--------|------------|
| 1 | WP3 doesn't specify actual baseline.yaml path — implementer would look in wrong place | Ralph-Design | High | Resolved | Added full path: `skills/env-auditor/references/baseline.yaml` |
| 2 | WP3 doesn't acknowledge existing `project_level.checks.mcp_servers` — design proposes adding but it already exists without required/available/remove keys | Ralph-Design | High | Resolved | Clarified: update existing key to add missing sub-keys |
| 3 | Brief schema includes `quality` field; design WP1 schema omits it — inconsistency | Ralph-Design | High | Resolved | Added `quality` field to WP1 schema with description |
| 4 | WP4 adds community scanning but doesn't clarify relationship to existing upstream MCP sync in step 3 | Ralph-Design | High | Resolved | Added clarification that step 3 covers upstream, 3b covers community sources |
| 5 | Frontmatter `intent_ref` points to nonexistent file | Ralph-Design | Low | Resolved | Set to null with note |
| — | Phase 1 internal review complete — 2 cycles, 4 High resolved, 1 Low resolved | Ralph-Design | — | Complete | — |

---

## Revision History

| Version | Date | Changes |
|---------|------|---------|
| 0.1 | 2026-01-30 | Initial draft from Design intake |
| 0.2 | 2026-01-31 | Aligned with brief: baseline v2.1.0, setup requires user approval before writing .mcp.json, transport values use upstream terminology (streamable-http) |
| 0.3 | 2026-01-31 | Review cycle 1: addressed 4 High issues (baseline path, existing mcp_servers key, quality field, upstream vs community scan clarity), 1 Low (intent_ref) |
| 0.4 | 2026-01-31 | Review cycle 2: zero Critical/High. Phase 1 internal review complete. |

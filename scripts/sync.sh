#!/usr/bin/env bash
# sync.sh — Fetch capabilities from upstream sources into staging
# Usage: ./scripts/sync.sh [--source anthropic|mcp|all]

set -euo pipefail

REGISTRY_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
STAGING_DIR="$REGISTRY_ROOT/staging"
CACHE_DIR="$REGISTRY_ROOT/.cache"
SOURCE="${1:---source}"
SOURCE_FILTER="${2:-all}"

mkdir -p "$CACHE_DIR" "$STAGING_DIR"

echo "=== Capability Sync ==="
echo ""

# Source definitions
ANTHROPIC_REPO="https://github.com/anthropics/skills.git"
ANTHROPIC_CACHE="$CACHE_DIR/anthropic-skills"

MCP_REPO="https://github.com/modelcontextprotocol/servers.git"
MCP_CACHE="$CACHE_DIR/mcp-servers"

fetch_anthropic() {
  echo "Fetching Anthropic skills..."
  if [ -d "$ANTHROPIC_CACHE" ]; then
    git -C "$ANTHROPIC_CACHE" pull --quiet 2>/dev/null || echo "  WARN: Could not pull (network?)"
  else
    git clone --quiet "$ANTHROPIC_REPO" "$ANTHROPIC_CACHE" 2>/dev/null || {
      echo "  ERROR: Could not clone $ANTHROPIC_REPO"
      return 1
    }
  fi

  # Copy skills to staging
  local count=0
  for skill_dir in "$ANTHROPIC_CACHE"/skills/*/; do
    [ ! -d "$skill_dir" ] && continue
    local name
    name=$(basename "$skill_dir")
    local dest="$STAGING_DIR/skills/$name"

    mkdir -p "$dest"
    cp -R "$skill_dir"/* "$dest/" 2>/dev/null || true

    # Create capability.yaml if not present
    if [ ! -f "$dest/capability.yaml" ]; then
      local desc=""
      if [ -f "$dest/SKILL.md" ]; then
        desc=$(head -5 "$dest/SKILL.md" | grep -i "description\|purpose\|#" | head -1 | sed 's/^#* *//' | cut -c1-100)
      fi
      cat > "$dest/capability.yaml" << EOF
name: $name
type: skill
description: "$desc"
source: anthropic
upstream: https://github.com/anthropics/skills/tree/main/skills/$name
version: ""
quality: 100
tags: []
status: staging
added: "$(date +%Y-%m-%d)"
updated: "$(date +%Y-%m-%d)"
EOF
    fi

    count=$((count + 1))
  done
  echo "  Staged $count Anthropic skills"
}

fetch_mcp() {
  echo "Fetching MCP servers..."
  if [ -d "$MCP_CACHE" ]; then
    git -C "$MCP_CACHE" pull --quiet 2>/dev/null || echo "  WARN: Could not pull (network?)"
  else
    git clone --quiet "$MCP_REPO" "$MCP_CACHE" 2>/dev/null || {
      echo "  ERROR: Could not clone $MCP_REPO"
      return 1
    }
  fi

  # Copy MCP servers to staging
  local count=0
  for server_dir in "$MCP_CACHE"/src/*/; do
    [ ! -d "$server_dir" ] && continue
    local name
    name=$(basename "$server_dir")
    # Add -mcp suffix if not present
    local reg_name="$name"
    echo "$name" | grep -q "mcp" || reg_name="${name}-mcp"
    local dest="$STAGING_DIR/tools/$reg_name"

    mkdir -p "$dest"
    # Copy README and key files only (not full source)
    [ -f "$server_dir/README.md" ] && cp "$server_dir/README.md" "$dest/"
    [ -f "$server_dir/package.json" ] && cp "$server_dir/package.json" "$dest/"

    if [ ! -f "$dest/capability.yaml" ]; then
      local desc=""
      if [ -f "$dest/README.md" ]; then
        desc=$(head -5 "$dest/README.md" | grep -v "^$" | head -1 | sed 's/^#* *//' | cut -c1-100)
      fi
      cat > "$dest/capability.yaml" << EOF
name: $reg_name
type: tool
description: "$desc"
source: modelcontextprotocol
upstream: https://github.com/modelcontextprotocol/servers/tree/main/src/$name
version: ""
quality: 90
tags: [mcp]
status: staging
added: "$(date +%Y-%m-%d)"
updated: "$(date +%Y-%m-%d)"
EOF
    fi

    count=$((count + 1))
  done
  echo "  Staged $count MCP tools"
}

case "$SOURCE_FILTER" in
  anthropic) fetch_anthropic ;;
  mcp) fetch_mcp ;;
  all|*)
    fetch_anthropic
    fetch_mcp
    ;;
esac

echo ""
echo "Sync complete. Review staging/ then run ./scripts/promote.sh <name> to activate."

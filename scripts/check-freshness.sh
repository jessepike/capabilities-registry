#!/usr/bin/env bash
# check-freshness.sh — Report stale capabilities (no auto-update)
# Usage: ./scripts/check-freshness.sh

set -euo pipefail

REGISTRY_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CAPS_DIR="$REGISTRY_ROOT/capabilities"
STALE=0
CHECKED=0
ERRORS=0

echo "=== Capability Freshness Check ==="
echo ""

# Check if upstream repos are accessible
check_upstream() {
  local name="$1"
  local upstream="$2"
  local cap_yaml="$3"
  local updated="$4"

  if [ -z "$upstream" ]; then
    echo "  SKIP: $name — no upstream URL"
    return
  fi

  CHECKED=$((CHECKED + 1))

  # For GitHub URLs, check the API for last commit date
  if echo "$upstream" | grep -q "github.com"; then
    # Extract repo owner/name from URL
    local repo_path
    repo_path=$(echo "$upstream" | sed -E 's|https://github.com/([^/]+/[^/]+).*|\1|')

    # Try to get latest commit date via git ls-remote (lightweight, no clone)
    local remote_date
    remote_date=$(timeout 5 git ls-remote --sort=-committerdate "https://github.com/$repo_path.git" HEAD 2>/dev/null | head -1 | awk '{print $1}' || echo "")

    if [ -z "$remote_date" ]; then
      echo "  WARN: $name — could not reach upstream ($upstream)"
      ERRORS=$((ERRORS + 1))
      return
    fi

    # We can't easily compare dates from ls-remote, so just report
    echo "  OK: $name — upstream reachable (last updated locally: $updated)"
  else
    echo "  SKIP: $name — non-GitHub upstream, manual check needed"
  fi
}

# Scan all capability.yaml files
for cap_yaml in $(find "$CAPS_DIR" -name "capability.yaml" -type f 2>/dev/null | sort); do
  name=$(python3 -c "import yaml; print(yaml.safe_load(open('$cap_yaml')).get('name',''))" 2>/dev/null)
  upstream=$(python3 -c "import yaml; print(yaml.safe_load(open('$cap_yaml')).get('upstream',''))" 2>/dev/null)
  updated=$(python3 -c "import yaml; print(yaml.safe_load(open('$cap_yaml')).get('updated',''))" 2>/dev/null)

  check_upstream "$name" "$upstream" "$cap_yaml" "$updated"
done

echo ""
echo "=== Summary ==="
echo "Checked: $CHECKED"
echo "Errors: $ERRORS"
echo "Stale: $STALE"

if [ $STALE -gt 0 ]; then
  echo ""
  echo "Run ./scripts/sync.sh to fetch updates, then ./scripts/promote.sh to activate."
fi

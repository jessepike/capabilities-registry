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
    # Extract repo owner/name from URL — handles both:
    #   https://github.com/org/repo
    #   https://github.com/org/repo/tree/main/some/path
    local repo_path
    repo_path=$(echo "$upstream" | sed -E 's|https://github.com/([^/]+/[^/]+)(/.*)?|\1|')

    # Extract subpath within repo (for commit checking)
    local sub_path
    sub_path=$(echo "$upstream" | sed -E 's|https://github.com/[^/]+/[^/]+(/tree/[^/]+)?(/.*)?|\2|' | sed 's|^/||')

    # Try to get latest commit hash via git ls-remote (lightweight, no clone)
    local remote_hash
    # Use perl alarm for timeout on macOS (no coreutils timeout)
    remote_hash=$(perl -e 'alarm 10; exec @ARGV' git ls-remote "https://github.com/$repo_path.git" HEAD 2>/dev/null | head -1 | awk '{print $1}' || echo "")

    if [ -z "$remote_hash" ]; then
      echo "  WARN: $name — could not reach upstream (repo: $repo_path)"
      ERRORS=$((ERRORS + 1))
      return
    fi

    # Compare local updated date against a staleness threshold (30 days)
    if [ -n "$updated" ]; then
      local days_old
      days_old=$(python3 -c "
from datetime import datetime, date
try:
    d = datetime.strptime('$updated', '%Y-%m-%d').date()
    print((date.today() - d).days)
except:
    print(-1)
" 2>/dev/null)
      if [ "$days_old" -gt 30 ]; then
        echo "  STALE: $name — last updated $updated ($days_old days ago), upstream reachable"
        STALE=$((STALE + 1))
        return
      fi
    fi

    echo "  OK: $name — upstream reachable, updated $updated"
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

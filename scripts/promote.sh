#!/usr/bin/env bash
# promote.sh — Move capabilities from staging to active
# Usage: ./scripts/promote.sh <name> [--type skill|tool|agent|plugin]
#        ./scripts/promote.sh --all
#        ./scripts/promote.sh --list (show what's in staging)

set -euo pipefail

REGISTRY_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
STAGING_DIR="$REGISTRY_ROOT/staging"
CAPS_DIR="$REGISTRY_ROOT/capabilities"
ARCHIVE_DIR="$REGISTRY_ROOT/archive"

list_staging() {
  echo "=== Staging Capabilities ==="
  echo ""
  local count=0
  local cap_files
  cap_files=$(find "$STAGING_DIR" -name "capability.yaml" -type f 2>/dev/null | sort) || true
  if [ -z "$cap_files" ]; then
    echo "  (none)"
    echo ""
    echo "0 capabilities in staging"
    return 0
  fi
  while IFS= read -r cap_yaml; do
    local name type
    name=$(python3 -c "import yaml; print(yaml.safe_load(open('$cap_yaml')).get('name',''))" 2>/dev/null || echo "unknown")
    type=$(python3 -c "import yaml; print(yaml.safe_load(open('$cap_yaml')).get('type',''))" 2>/dev/null || echo "unknown")
    echo "  $type/$name"
    count=$((count + 1))
  done <<< "$cap_files"
  echo ""
  echo "$count capabilities in staging"
}

promote_one() {
  local name="$1"
  local forced_type="${2:-}"

  # Find in staging
  local found=""
  for cap_yaml in $(find "$STAGING_DIR" -name "capability.yaml" -type f 2>/dev/null); do
    local cap_name
    cap_name=$(python3 -c "import yaml; print(yaml.safe_load(open('$cap_yaml')).get('name',''))" 2>/dev/null)
    if [ "$cap_name" = "$name" ]; then
      found="$(dirname "$cap_yaml")"
      break
    fi
  done

  if [ -z "$found" ]; then
    echo "ERROR: '$name' not found in staging/"
    return 1
  fi

  local type
  type=$(python3 -c "import yaml; print(yaml.safe_load(open('$found/capability.yaml')).get('type',''))" 2>/dev/null)
  [ -n "$forced_type" ] && type="$forced_type"

  local dest="$CAPS_DIR/${type}s/$name"

  # Archive existing if present
  if [ -d "$dest" ]; then
    local archive_dest="$ARCHIVE_DIR/${type}s/$name.$(date +%Y%m%d%H%M%S)"
    mkdir -p "$(dirname "$archive_dest")"
    mv "$dest" "$archive_dest"
    echo "  Archived previous version to $archive_dest"
  fi

  # Move from staging to active
  mkdir -p "$(dirname "$dest")"
  cp -R "$found" "$dest"

  # Update status in capability.yaml
  python3 -c "
import yaml
path = '$dest/capability.yaml'
with open(path) as f:
    data = yaml.safe_load(f)
data['status'] = 'active'
with open(path, 'w') as f:
    yaml.dump(data, f, default_flow_style=False, sort_keys=False)
" 2>/dev/null

  # Remove from staging
  rm -rf "$found"

  echo "  Promoted: $type/$name → capabilities/${type}s/$name"
}

case "${1:-}" in
  --list)
    list_staging
    exit 0
    ;;
  --all)
    echo "=== Promoting All Staging Capabilities ==="
    echo ""
    for cap_yaml in $(find "$STAGING_DIR" -name "capability.yaml" -type f 2>/dev/null | sort); do
      name=$(python3 -c "import yaml; print(yaml.safe_load(open('$cap_yaml')).get('name',''))" 2>/dev/null)
      promote_one "$name"
    done
    echo ""
    echo "Running inventory generation..."
    "$REGISTRY_ROOT/scripts/generate-inventory.sh"
    ;;
  "")
    echo "Usage: ./scripts/promote.sh <name> | --all | --list"
    exit 1
    ;;
  *)
    promote_one "$1" "${3:-}"
    echo ""
    echo "Running inventory generation..."
    "$REGISTRY_ROOT/scripts/generate-inventory.sh"
    ;;
esac

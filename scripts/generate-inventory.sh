#!/usr/bin/env bash
# generate-inventory.sh — Scan all capability.yaml files → inventory.json → INVENTORY.md
# Usage: ./scripts/generate-inventory.sh

set -euo pipefail

REGISTRY_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CAPS_DIR="$REGISTRY_ROOT/capabilities"
JSON_OUT="$REGISTRY_ROOT/inventory.json"
MD_OUT="$REGISTRY_ROOT/INVENTORY.md"

# Require yq or python3 for YAML parsing
if command -v python3 &>/dev/null; then
  PARSER="python3"
elif command -v yq &>/dev/null; then
  PARSER="yq"
else
  echo "ERROR: Need python3 or yq to parse YAML"
  exit 1
fi

# Parse a capability.yaml field using python3
parse_yaml_field() {
  local file="$1"
  local field="$2"
  python3 -c "
import yaml, sys, json
with open('$file') as f:
    data = yaml.safe_load(f)
val = data.get('$field', '')
if isinstance(val, list):
    print(json.dumps(val))
else:
    print(val if val else '')
" 2>/dev/null
}

echo "Scanning capabilities..."

# Build JSON
CAPABILITIES="[]"
COUNT=0

for cap_yaml in $(find "$CAPS_DIR" -name "capability.yaml" -type f 2>/dev/null | sort); do
  dir="$(dirname "$cap_yaml")"
  rel_path="${dir#$REGISTRY_ROOT/}"

  name=$(parse_yaml_field "$cap_yaml" "name")
  type=$(parse_yaml_field "$cap_yaml" "type")
  description=$(parse_yaml_field "$cap_yaml" "description")
  source=$(parse_yaml_field "$cap_yaml" "source")
  status=$(parse_yaml_field "$cap_yaml" "status")
  version=$(parse_yaml_field "$cap_yaml" "version")
  tags=$(parse_yaml_field "$cap_yaml" "tags")
  quality=$(parse_yaml_field "$cap_yaml" "quality")
  upstream=$(parse_yaml_field "$cap_yaml" "upstream")
  added=$(parse_yaml_field "$cap_yaml" "added")
  updated=$(parse_yaml_field "$cap_yaml" "updated")

  COUNT=$((COUNT + 1))
  echo "  [$COUNT] $type/$name ($status)"
done

# Generate full JSON using python3
python3 << 'PYEOF'
import yaml, json, os, glob
from datetime import datetime

registry_root = os.environ.get("REGISTRY_ROOT", ".")
caps_dir = os.path.join(registry_root, "capabilities")
json_out = os.path.join(registry_root, "inventory.json")
md_out = os.path.join(registry_root, "INVENTORY.md")

capabilities = []
by_type = {}
by_source = {}
by_tag = {}

for cap_yaml in sorted(glob.glob(os.path.join(caps_dir, "**", "capability.yaml"), recursive=True)):
    with open(cap_yaml) as f:
        data = yaml.safe_load(f)

    rel_path = os.path.relpath(os.path.dirname(cap_yaml), registry_root)
    cap = {
        "name": data.get("name", ""),
        "type": data.get("type", ""),
        "description": data.get("description", ""),
        "source": data.get("source", ""),
        "status": data.get("status", "active"),
        "version": data.get("version", ""),
        "quality": data.get("quality", 0),
        "tags": data.get("tags", []),
        "upstream": data.get("upstream", ""),
        "path": rel_path,
        "added": data.get("added", ""),
        "updated": data.get("updated", ""),
    }
    if data.get("clients"):
        cap["clients"] = data["clients"]
    capabilities.append(cap)

    t = cap["type"]
    by_type[t] = by_type.get(t, 0) + 1

    s = cap["source"]
    by_source[s] = by_source.get(s, 0) + 1

    for tag in cap["tags"]:
        by_tag.setdefault(tag, []).append(cap["name"])

# Build by_client summary: count enabled capabilities per client
by_client = {}
for cap in capabilities:
    clients = cap.get("clients", {})
    for client_name, client_info in clients.items():
        if client_name not in by_client:
            by_client[client_name] = {"enabled": 0, "disabled": 0}
        if client_info.get("enabled"):
            by_client[client_name]["enabled"] += 1
        else:
            by_client[client_name]["disabled"] += 1

# Write JSON
inventory = {
    "version": "1.0",
    "generated_at": datetime.now().isoformat(),
    "summary": {
        "total": len(capabilities),
        "by_type": by_type,
        "by_source": by_source,
        "by_client": by_client,
    },
    "capabilities": capabilities,
}

with open(json_out, "w") as f:
    json.dump(inventory, f, indent=2)
print(f"Wrote {json_out} ({len(capabilities)} capabilities)")

# Write Markdown
lines = []
lines.append("# Capability Registry Inventory")
lines.append("")
lines.append(f"*Generated: {datetime.now().strftime('%Y-%m-%d %H:%M')}*")
lines.append("")
lines.append("## Summary")
lines.append("")
lines.append(f"**Total capabilities:** {len(capabilities)}")
lines.append("")
lines.append("| Type | Count |")
lines.append("|------|-------|")
for t, c in sorted(by_type.items()):
    lines.append(f"| {t} | {c} |")
lines.append("")
lines.append("| Source | Count |")
lines.append("|--------|-------|")
for s, c in sorted(by_source.items()):
    lines.append(f"| {s} | {c} |")
lines.append("")

if by_client:
    lines.append("## Client Enablement")
    lines.append("")
    lines.append("| Client | Enabled | Disabled |")
    lines.append("|--------|---------|----------|")
    for client in sorted(by_client.keys()):
        e = by_client[client]["enabled"]
        d = by_client[client]["disabled"]
        lines.append(f"| {client} | {e} | {d} |")
    lines.append("")

# Group by type
for cap_type in sorted(set(c["type"] for c in capabilities)):
    type_caps = [c for c in capabilities if c["type"] == cap_type]
    lines.append(f"## {cap_type.title()}s")
    lines.append("")
    lines.append("| Name | Source | Quality | Tags | Description |")
    lines.append("|------|--------|---------|------|-------------|")
    for c in sorted(type_caps, key=lambda x: x["name"]):
        tags = ", ".join(c["tags"]) if c["tags"] else ""
        q = c.get("quality", "")
        lines.append(f"| {c['name']} | {c['source']} | {q} | {tags} | {c['description']} |")
    lines.append("")

# Tags index
lines.append("## Tags Index")
lines.append("")
for tag in sorted(by_tag.keys()):
    names = ", ".join(sorted(by_tag[tag]))
    lines.append(f"- **{tag}**: {names}")
lines.append("")

with open(md_out, "w") as f:
    f.write("\n".join(lines))
print(f"Wrote {md_out}")

PYEOF

echo "Done."

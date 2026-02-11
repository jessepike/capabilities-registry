#!/usr/bin/env bash
# install-mcp-gemini.sh — Install a registry MCP tool into Gemini CLI MCP config
# Usage: ./scripts/install-mcp-gemini.sh <tool-name> [--scope project|user] [--apply]
# Default mode is dry-run (prints the gemini command).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REGISTRY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
export REGISTRY_ROOT

python3 - "$@" <<'PY'
import argparse
import os
import json
import pathlib
import shlex
import subprocess
import sys


def expand(value):
    if isinstance(value, str):
        return os.path.expanduser(os.path.expandvars(value))
    return value


def quote_cmd(cmd):
    return " ".join(shlex.quote(part) for part in cmd)


parser = argparse.ArgumentParser()
parser.add_argument("tool_name")
parser.add_argument("--scope", default="user", choices=["project", "user"])
parser.add_argument("--apply", action="store_true", help="Execute install command")
args = parser.parse_args()

registry_root = pathlib.Path(os.environ["REGISTRY_ROOT"]).resolve()
cap_path = registry_root / "capabilities" / "tools" / args.tool_name / "capability.yaml"

if not cap_path.exists():
    print(f"ERROR: capability not found: {cap_path}")
    sys.exit(1)

capability = json.loads(subprocess.check_output([
    "ruby",
    "-e",
    "require \"yaml\"; require \"json\"; puts JSON.generate(YAML.safe_load(File.read(ARGV[0])))",
    str(cap_path),
], text=True))

if capability.get("type") != "tool":
    print(f"ERROR: {args.tool_name} is not a tool capability")
    sys.exit(1)

if capability.get("install_vector") == "plugin":
    plugin_name = capability.get("parent_plugin", "<unknown>")
    print(f"SKIP: {args.tool_name} is plugin-bundled (parent plugin: {plugin_name}).")
    print("Install/enable the parent plugin in Gemini if supported by your Gemini setup.")
    sys.exit(0)

launcher = capability.get("launcher") or {}
transport = launcher.get("type") or capability.get("transport")
install_name = capability.get("install_id") or capability.get("name") or args.tool_name

if transport != "stdio":
    print(f"ERROR: this installer currently supports stdio only for Gemini, got: {transport}")
    print("Use Gemini-native HTTP/SSE setup manually if required by this server.")
    sys.exit(1)

command = expand(launcher.get("command", ""))
if not command:
    print(f"ERROR: missing launcher.command for stdio transport in {cap_path}")
    sys.exit(1)

launch_args = [expand(item) for item in (launcher.get("args") or [])]
env_map = {k: expand(v) for k, v in (launcher.get("env") or {}).items()}

# Gemini MCP add takes executable + args; use /usr/bin/env wrapper to inject env vars.
exec_parts = [command, *launch_args]
if env_map:
    env_pairs = [f"{key}={val}" for key, val in sorted(env_map.items())]
    exec_parts = ["/usr/bin/env", *env_pairs, *exec_parts]

cmd = ["gemini", "mcp", "add", "-s", args.scope, install_name, *exec_parts]

print(f"Capability: {args.tool_name}")
print(f"Command: {quote_cmd(cmd)}")

if args.apply:
    subprocess.run(cmd, check=True)
    print("Installed in Gemini MCP config.")
else:
    print("Dry-run only. Re-run with --apply to execute.")
PY

#!/usr/bin/env bash
# Read-only Storage Box retention preview. Does not delete remote files.
set -Eeuo pipefail
host="${KNIFE_STORAGE_HOST:-}"
user="${KNIFE_STORAGE_USER:-}"
port="${KNIFE_STORAGE_PORT:-23}"
remote="${KNIFE_STORAGE_PATH:-}"
keep="${KNIFE_KEEP:-2}"
[[ -n "$host" && -n "$user" && -n "$remote" ]] || { echo "Set KNIFE_STORAGE_HOST, KNIFE_STORAGE_USER, KNIFE_STORAGE_PATH" >&2; exit 2; }
[[ "$port" =~ ^[0-9]+$ && "$keep" =~ ^[1-9][0-9]*$ ]] || exit 2
# Reject newline and control characters; quote remote path for remote shell.
[[ "$remote" != *$'\n'* && "$remote" != *$'\r'* && "$remote" != *"'"* ]] || exit 2
echo "READ-ONLY inventory: $user@$host:$remote (keep=$keep)"
ssh -o BatchMode=yes -o StrictHostKeyChecking=yes -o ConnectTimeout=10 -p "$port" -- "$user@$host" \
  "find '$remote' -type f \\( -name 'web_*.tar' -o -name 'web_*.tar.gz' -o -name 'web_*.tar.zst' \\) -print" |
  sort
echo "No remote files changed. Retention execution intentionally unavailable until verified."

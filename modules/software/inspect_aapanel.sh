#!/usr/bin/env bash
set -Eeuo pipefail
echo "aaPanel / web stack (read-only)"
if [[ -d /www/server/panel ]]; then echo "aaPanel directory present"; else echo "aaPanel not detected"; fi
for cmd in nginx php mysql mariadb redis-server psql; do
  if command -v "$cmd" >/dev/null 2>&1; then
    printf '%-16s %s\n' "$cmd" "$(command -v "$cmd")"
  fi
done
echo "No installer downloaded or executed."

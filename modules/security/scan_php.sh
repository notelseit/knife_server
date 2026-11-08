#!/usr/bin/env bash
set -Eeuo pipefail
root="${KNIFE_WEBROOT:-/www/wwwroot}"
[[ -d "$root" ]] || { echo "Directory inesistente: $root"; exit 2; }
echo "Scansione indicativa PHP in $root (nessuna cancellazione)"
find "$root" -type f -name '*.php' -print0 |
  xargs -0 -r grep -nHE 'base64_decode[[:space:]]*\(|gzinflate[[:space:]]*\(|shell_exec[[:space:]]*\(|eval[[:space:]]*\(' || true
echo "I risultati richiedono revisione manuale: possibili falsi positivi."

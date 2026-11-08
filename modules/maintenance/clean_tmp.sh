#!/usr/bin/env bash
set -Eeuo pipefail
root="${KNIFE_WEBROOT:-/www/wwwroot}"
[[ -d "$root" ]] || { echo "Directory inesistente: $root"; exit 2; }
echo "ANTEPRIMA: directory tmp sotto $root (nessuna cancellazione)"
find "$root" -type d -name tmp -print
echo "Per sicurezza, la cancellazione automatica non è implementata in questa versione."

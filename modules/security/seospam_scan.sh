#!/usr/bin/env bash
set -Eeuo pipefail
root="${KNIFE_WEBROOT:-/www/wwwroot}"
[[ -d "$root" ]] || { echo "Missing directory: $root" >&2; exit 2; }
echo "SEO spam indicators (report only): $root"
find "$root" -type f -iname '*ByPaShall*.php' -print
find "$root" -type d -name 'SEOBARBAR_DATA' -print
find "$root" -type f \( -name 'Bylitle.php' -o -name 'tinyssss.php' -o -name 'nanokash.php' \) -print
echo "Do not remove without forensic review and verified backups."

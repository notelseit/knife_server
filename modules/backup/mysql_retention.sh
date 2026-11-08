#!/usr/bin/env bash
set -Eeuo pipefail
root="${KNIFE_MYSQL_BACKUP_DIR:-/www/backup/database/mysql}"
keep="${KNIFE_KEEP:-7}"
[[ "$keep" =~ ^[1-9][0-9]*$ ]] || { echo "KNIFE_KEEP deve essere >= 1"; exit 2; }
[[ -d "$root" ]] || { echo "Directory inesistente: $root"; exit 2; }
echo "ANTEPRIMA backup MySQL in $root; retention proposta: $keep per directory"
while IFS= read -r -d '' dir; do
  mapfile -d '' -t files < <(find "$dir" -maxdepth 1 -type f -name '*.sql.gz' -printf '%T@ %p\0' | sort -zrn)
  count=0
  for item in "${files[@]}"; do
    file="${item#* }"
    ((count+=1))
    if (( count <= keep )); then printf 'KEEP   %s\n' "$file"; else printf 'REVIEW %s\n' "$file"; fi
  done
done < <(find "$root" -type d -print0)
echo "Nessun backup è stato cancellato."

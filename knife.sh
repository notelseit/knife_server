#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$ROOT/core/common.sh"
while :; do
  printf '\n=== NOTELSEIT KNIFE SERVER 2.0 ===\n'
  printf '1) Utility legacy (ATTENZIONE: operazioni distruttive)\n2) Stato RAID\n3) Scanner PHP (read-only)\n4) Directory tmp (read-only)\n5) Retention MySQL (read-only)\n6) Scanner SEO spam (read-only)\n7) Retention WebDAV (inventario read-only)\n8) DNS: anteprima migrazione CSV\n9) Inventario aaPanel\n0) Esci\n'
  read -r -p 'Scelta: ' choice || exit 0
  case "$choice" in
    1) echo "Il menu legacy può modificare o cancellare dati."; if knife_confirm; then bash "$ROOT/knife-script.sh"; fi ;;
    2) bash "$ROOT/modules/monitoring/check_raid.sh" ;;
    3) bash "$ROOT/modules/security/scan_php.sh" ;;
    4) bash "$ROOT/modules/maintenance/clean_tmp.sh" ;;
    5) bash "$ROOT/modules/backup/mysql_retention.sh" ;;
    6) bash "$ROOT/modules/security/seospam_scan.sh" ;;
    7) bash "$ROOT/modules/backup/webdav_retention.sh" ;;
    8) read -r -p 'CSV path: ' csv; read -r -p 'Old IPv4: ' old; read -r -p 'New IPv4: ' new; python3 "$ROOT/modules/dns/dns_inventory.py" --input "$csv" --old-ip "$old" --new-ip "$new" ;;
    9) bash "$ROOT/modules/software/inspect_aapanel.sh" ;;
    0) exit 0 ;;
    *) echo "Scelta non valida" ;;
  esac
done

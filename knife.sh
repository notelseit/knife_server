#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$ROOT/core/common.sh"
while :; do
  printf '\n=== NOTELSEIT KNIFE SERVER 2.0 (preview) ===\n'
  printf '1) Utility originali (18 comandi)\n2) Stato RAID md3\n3) Scansione PHP sospetti (solo report)\n4) Anteprima pulizia tmp\n5) Anteprima retention backup MySQL\n0) Esci\n'
  read -r -p 'Scelta: ' choice || exit 0
  case "$choice" in
    1) bash "$ROOT/knife-script.sh" ;;
    2) bash "$ROOT/modules/monitoring/check_raid.sh" ;;
    3) bash "$ROOT/modules/security/scan_php.sh" ;;
    4) bash "$ROOT/modules/maintenance/clean_tmp.sh" ;;
    5) bash "$ROOT/modules/backup/mysql_retention.sh" ;;
    0) exit 0 ;;
    *) echo "Scelta non valida" ;;
  esac
done

#!/usr/bin/env bash
set -Eeuo pipefail
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
for file in "$root/knife.sh" "$root/core/common.sh" "$root/modules/monitoring/check_raid.sh" \
  "$root/modules/security/scan_php.sh" "$root/modules/security/seospam_scan.sh" \
  "$root/modules/maintenance/clean_tmp.sh" "$root/modules/backup/mysql_retention.sh" \
  "$root/modules/backup/webdav_retention.sh" "$root/modules/software/inspect_aapanel.sh"; do
  bash -n "$file"
done
python3 -m py_compile "$root/modules/dns/dns_inventory.py"
tmp="$(mktemp -d)"
trap 'rm -rf -- "$tmp"' EXIT
printf 'domain,name,type,value\nexample.com,@,A,192.0.2.1\nexample.com,mail,A,192.0.2.1\n' > "$tmp/records.csv"
python3 "$root/modules/dns/dns_inventory.py" --input "$tmp/records.csv" --old-ip 192.0.2.1 --new-ip 198.51.100.2 --output "$tmp/plan.json" >/dev/null
python3 - "$tmp/plan.json" <<'PY'
import json,sys
plan=json.load(open(sys.argv[1]))
assert plan["mode"]=="DRY_RUN"
assert plan["count"]==1
assert plan["changes"][0]["name"]=="@"
PY
echo "Smoke tests passed"

#!/usr/bin/env bash
set -Eeuo pipefail
device="${KNIFE_RAID_DEVICE:-/dev/md3}"
echo "== Stato RAID: $device =="
if ! command -v mdadm >/dev/null; then echo "mdadm non installato"; exit 2; fi
mdadm --detail "$device" || exit 1
if findmnt -rn -S "$device" >/dev/null; then
  echo "Filesystem montato da $device"
else
  echo "ATTENZIONE: $device non risulta montato direttamente (verificare UUID/LVM)"
fi
[[ -r /proc/mdstat ]] && cat /proc/mdstat

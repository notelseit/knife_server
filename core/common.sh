#!/usr/bin/env bash
# Shared safe helpers: never execute deletion without an explicit opt-in.
knife_log() { printf '[%s] %s\n' "$(date '+%F %T')" "$*" >&2; }
knife_confirm() {
  local response
  read -r -p "Digitare CONFERMO per procedere: " response
  [[ "$response" == "CONFERMO" ]]
}

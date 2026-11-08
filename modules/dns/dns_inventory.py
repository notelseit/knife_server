#!/usr/bin/env python3
"""Safe DNS record inventory/CSV comparison. No provider API mutations."""
import argparse
import csv
import ipaddress
import json
import os
import sys
from pathlib import Path

def main():
    p = argparse.ArgumentParser(description="Knife DNS A-record migration preview")
    p.add_argument("--input", required=True, help="CSV: domain,name,type,value")
    p.add_argument("--old-ip", required=True)
    p.add_argument("--new-ip", required=True)
    p.add_argument("--scope", choices=["all", "apex-www", "apex-www-wildcard"], default="apex-www")
    p.add_argument("--output", help="Optional JSON plan output")
    a = p.parse_args()
    old, new = str(ipaddress.IPv4Address(a.old_ip)), str(ipaddress.IPv4Address(a.new_ip))
    changes = []
    with Path(a.input).open(newline="", encoding="utf-8-sig") as handle:
        reader = csv.DictReader(handle)
        required = {"domain", "name", "type", "value"}
        if not required.issubset(reader.fieldnames or []):
            p.error("CSV must contain domain,name,type,value")
        for row in reader:
            if row["type"].strip().upper() != "A" or row["value"].strip() != old:
                continue
            name = row["name"].strip().lower().rstrip(".")
            domain = row["domain"].strip().lower().rstrip(".")
            if not domain:
                continue
            apex = name in ("@", "", domain)
            www = name in ("www", "www." + domain)
            wildcard = name in ("*", "*." + domain)
            if a.scope == "apex-www" and not (apex or www):
                continue
            if a.scope == "apex-www-wildcard" and not (apex or www or wildcard):
                continue
            changes.append({"domain": domain, "name": name, "type": "A", "from": old, "to": new})
    plan = {"mode": "DRY_RUN", "scope": a.scope, "changes": changes, "count": len(changes)}
    data = json.dumps(plan, indent=2, ensure_ascii=False)
    if a.output:
        Path(a.output).write_text(data + "\n", encoding="utf-8")
    print(data)
    print("No DNS records changed.", file=sys.stderr)

if __name__ == "__main__":
    main()

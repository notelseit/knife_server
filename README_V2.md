# Knife Server 2.0 — modular preview

The original `knife-script.sh` remains unchanged and is available as menu option 1.

Start with `bash knife.sh`. New modules are read-only / preview-only:
- RAID status and mdadm detail
- PHP suspicious-pattern report (false positives possible)
- tmp directory discovery (no deletion)
- MySQL backup retention preview (no deletion)

The existing original script includes destructive functions. Running menu option 1 is **not** automatically safe. Review actions before use.

## Configuration
Use environment variables listed in `.env.example`; never commit credentials.
All modules are local Bash scripts. No production server changes or scheduled jobs are made.

## Roadmap
- Quarantine-based malware cleanup with audit and rollback
- Safe and tested remote backup retention for Storage Box
- InternetBS / Shellrent API adapters using runtime credentials
- Tests, ShellCheck, documentation, explicit confirmations
- aaPanel installer only via a verified upstream source, not copied installer code

## Safety
Do not add uploaded scripts containing API credentials to this public repository. Rotate any credentials previously exposed.

# Knife Server 2.0 — candidate release

## Usage
```bash
bash knife.sh
bash tests/smoke.sh
```
The original `knife-script.sh` is preserved and requires a separate explicit confirmation from the new menu. **Legacy operations remain potentially destructive**.

## Integrated modules
| Menu | Capability | Mode |
| --- | --- | --- |
| 2 | RAID mdadm status | Read-only |
| 3 | Suspicious PHP signatures | Read-only |
| 4 | Locate tmp directories | Read-only |
| 5 | MySQL .sql.gz retention preview | Read-only |
| 6 | SEO spam / known filename indicators | Read-only |
| 7 | SSH Storage Box file inventory | Read-only |
| 8 | DNS IPv4 migration preview from CSV | Read-only |
| 9 | aaPanel and software discovery | Read-only |

## Configuration
See `.env.example`. Export variables in the shell before launching, e.g. `export KNIFE_WEBROOT=/www/wwwroot`. **Do not source untrusted .env files or commit credentials.**

Remote backup inventory requires `KNIFE_STORAGE_HOST`, `KNIFE_STORAGE_USER`, `KNIFE_STORAGE_PATH` and SSH key authentication. `KNIFE_STORAGE_PORT` defaults to 23. Host keys must already be trusted.

DNS CSV requires headers `domain,name,type,value`. The default scope only considers apex and www A records with exactly matching old IPv4. No provider APIs are invoked and no DNS changes are made.

## Important exclusions
The original uploaded aaPanel installer and Lua CJSON installer are **not bundled**: executing copied or unverified installation scripts as root is unsafe. The uploaded InternetBS and Shellrent API scripts are **not copied** because they contained embedded credentials. Real provider integration requires separately verified API contracts and runtime secret management. Remote deletion and cleanup are not enabled until a staging environment and verified recovery procedure are available.

## Security and release gate
- Rotate any exposed InternetBS/Shellrent credentials immediately.
- Review the legacy script before using its delete/replace commands.
- Run `bash tests/smoke.sh` and ShellCheck on a test host.
- Validate behavior against real aaPanel installations, RAID setups, SSH Storage Box, and DNS exports.
- Never merge or deploy this candidate solely based on static review.

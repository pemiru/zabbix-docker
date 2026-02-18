# Repository Cleanup Summary

## What Was Removed

### Docker Compose Files (14 removed)
- All Alpine Linux variants (4 files)
- All CentOS variants (4 files)
- All Oracle Linux variants (4 files)
- Ubuntu MySQL variants (2 files)

### Environment Variable Files (14 removed)
- MySQL credentials (4 files): `.MYSQL_USER`, `.MYSQL_PASSWORD`, `.MYSQL_ROOT_USER`, `.MYSQL_ROOT_PASSWORD`
- MySQL configurations (2 files): `.env_db_mysql`, `.env_db_mysql_proxy`
- Proxy configurations (3 files): `.env_prx`, `.env_prx_mysql`, `.env_prx_sqlite3`
- Additional services (3 files): `.env_java`, `.env_snmptraps`, `.env_web_service`
- Web service security (1 file): `chrome_dp.json`
- MySQL initialization (1 directory): `mysql_init/`

### Config Templates (23 removed)
- Proxy config templates (22 files in `config_templates/proxy/`)
- Web service config template (1 file in `config_templates/web_service/`)

## What Remains

### Docker Compose Files (7 kept)
- `compose.yaml` → symlink to `docker-compose_test.yaml`
- `docker-compose_test.yaml` → **NEW minimal testing setup**
- `docker-compose_v3_ubuntu_pgsql_latest.yaml` → full Ubuntu + PostgreSQL setup
- `docker-compose_v3_ubuntu_pgsql_local.yaml` → local build variant
- `compose_zabbix_components.yaml` → service definitions
- `compose_databases.yaml` → database services
- `compose_additional_components.yaml` → selenium (for UI testing)

### Environment Variable Files (6 kept)
- `.POSTGRES_USER`, `.POSTGRES_PASSWORD` → PostgreSQL credentials
- `.env_db_pgsql` → PostgreSQL connection settings
- `.env_srv` → Zabbix server configuration
- `.env_web` → Web UI configuration
- `.env_agent` → Agent configuration (optional)

### Config Templates (50 kept)
- `config_templates/server/` → 22 files
- `config_templates/agent/` → 11 files
- `config_templates/agent2/` → 17 files

## Files Changed Summary
- **55 files changed** total
- **170 insertions** (new minimal setup + docs)
- **6,577 deletions** (removed bloat)

## New Files Created
- `docker-compose_test.yaml` → Minimal testing compose file
- `TESTING.md` → Testing documentation
- `CLEANUP_SUMMARY.md` → This file

## Benefits
- **Cleaner repository** focused on Ubuntu + PostgreSQL testing
- **Faster navigation** with fewer files
- **Clear testing path** with documented minimal setup
- **Easy customization** with UI volume mount at `./zbx_env/usr/share/zabbix/ui`
- **Optional agent** via compose profiles

# Minimal Zabbix Testing Setup

This repository has been streamlined for easy testing of Zabbix with Docker Compose.

## Quick Start

### Option 1: Minimal Testing Setup (Recommended)

Use the minimal `docker-compose_test.yaml` file for the leanest setup:

```bash
# Start PostgreSQL, Zabbix Server, and Web UI
docker compose -f docker-compose_test.yaml up

# Start with optional Zabbix Agent
docker compose -f docker-compose_test.yaml --profile agent up
```

This will start:
- PostgreSQL database
- Zabbix Server
- Zabbix Web UI (Nginx) with `/usr/share/zabbix/ui` mounted for customization
- Optionally: Zabbix Agent (with `--profile agent`)

### Option 2: Full Ubuntu PostgreSQL Setup

Use the full `docker-compose_v3_ubuntu_pgsql_latest.yaml` if you need additional services:

```bash
docker compose -f docker-compose_v3_ubuntu_pgsql_latest.yaml up
```

This includes all services (proxies, java-gateway, snmptraps, web-service, etc.)

## UI Customization

The Zabbix web UI is mounted as a volume at `./zbx_env/usr/share/zabbix/ui`, allowing you to:
- Customize templates
- Modify frontend files
- Test UI changes without rebuilding images

## Configuration

Essential configuration files are in `env_vars/`:
- `.POSTGRES_USER` / `.POSTGRES_PASSWORD` - Database credentials
- `.env_db_pgsql` - PostgreSQL connection settings
- `.env_srv` - Zabbix Server configuration
- `.env_web` - Web UI configuration
- `.env_agent` - Agent configuration (optional)

## Accessing Zabbix

- **Web UI**: http://localhost (port 80)
- **Default credentials**: Admin / zabbix
- **Server port**: 10051
- **Agent port**: 10050 (if using agent profile)

## Clean Removed Files

This testing branch has removed unnecessary files for a cleaner testing experience:
- MySQL-related configurations (MySQL variant docker-compose files)
- Proxy-related configurations
- Other OS variants (Alpine, CentOS, Oracle Linux)
- Java Gateway, SNMP traps, and web-service configurations
- Selenium/WebDriver testing components

Only Ubuntu + PostgreSQL essentials remain for streamlined testing.

## Stopping and Cleanup

```bash
# Stop containers
docker compose -f docker-compose_test.yaml down

# Remove volumes and data
docker compose -f docker-compose_test.yaml down -v
rm -rf ./zbx_env
```

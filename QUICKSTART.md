# Quick Start Guide

## 🚀 TL;DR - Get Started in 30 Seconds

```bash
# Option 1: Minimal setup (just server + web UI)
docker compose up

# Option 2: With Zabbix Agent
docker compose --profile agent up

# Option 3: Full setup (all services)
docker compose -f docker-compose_v3_ubuntu_pgsql_latest.yaml up
```

Access Zabbix at **http://localhost** (default credentials: `Admin` / `zabbix`)

## 📋 What's Available

### Minimal Setup (Default)
File: `docker-compose_test.yaml` (symlinked as `compose.yaml`)

**Services included:**
- PostgreSQL database
- Zabbix Server
- Zabbix Web UI (Nginx)
- Optional: Zabbix Agent (with `--profile agent`)

**Use when:**
- Testing Zabbix configurations
- Developing custom dashboards
- Learning Zabbix
- Minimal resource usage needed

### Full Setup
File: `docker-compose_v3_ubuntu_pgsql_latest.yaml`

**Additional services (with --profile all):**
- MySQL database (alternative)
- Zabbix Proxy (SQLite3 and MySQL variants)
- Java Gateway (for Java monitoring)
- SNMP Traps receiver
- Web Service (for reporting)
- Apache web server (alternative to Nginx)

**Use when:**
- Testing proxy configurations
- Java application monitoring
- SNMP trap collection
- Report generation testing
- Full production-like environment

## 🎨 UI Customization

Both setups include a volume mount for UI customization:

```bash
# UI files are mounted at:
./zbx_env/usr/share/zabbix/ui
```

**How to customize:**
1. Start Zabbix: `docker compose up`
2. Wait for initialization (first start creates files)
3. Edit files in `./zbx_env/usr/share/zabbix/ui/`
4. Refresh browser to see changes

**Examples:**
- Modify templates: `./zbx_env/usr/share/zabbix/ui/templates/`
- Customize styles: `./zbx_env/usr/share/zabbix/ui/assets/styles/`
- Add custom pages: `./zbx_env/usr/share/zabbix/ui/`

## 🔧 Common Commands

```bash
# Start in background
docker compose up -d

# View logs
docker compose logs -f

# Stop services
docker compose down

# Stop and remove volumes (clean slate)
docker compose down -v
rm -rf ./zbx_env

# Restart a specific service
docker compose restart zabbix-server

# Check service status
docker compose ps

# Execute commands in container
docker compose exec zabbix-server /bin/bash
```

## 🛠️ Configuration

Configuration files are in `env_vars/`:

| File | Purpose | When to modify |
|------|---------|----------------|
| `.env_srv` | Server settings | Adjust cache, pollers, timeouts |
| `.env_web` | Web UI settings | Change timezone, PHP limits |
| `.env_db_pgsql` | Database connection | Modify DB host, port, name |
| `.env_agent` | Agent settings | Configure agent communication |
| `.POSTGRES_USER` | DB username | Change default user |
| `.POSTGRES_PASSWORD` | DB password | Change default password |

## 📊 Ports

| Service | Port | Access |
|---------|------|--------|
| Web UI (Nginx) | 80 | http://localhost |
| Web UI (Apache) | 8081 | http://localhost:8081 |
| Zabbix Server | 10051 | TCP for agent connections |
| Zabbix Agent | 10050 | TCP for passive checks |
| PostgreSQL | 5432 | Internal only (no host binding) |

## 🐛 Troubleshooting

### Services won't start
```bash
# Check what's wrong
docker compose ps
docker compose logs

# Verify configuration
./verify-setup.sh
```

### Permission errors
```bash
# Fix volume permissions
sudo chown -R $USER:$USER ./zbx_env
```

### Database initialization failed
```bash
# Clean start
docker compose down -v
rm -rf ./zbx_env
docker compose up
```

### Port already in use
```bash
# Check what's using port 80
sudo lsof -i :80

# Or change port in docker-compose file
# Change published: "80" to published: "8080"
```

## 📚 Additional Documentation

- `TESTING.md` - Detailed testing guide
- `CLEANUP_SUMMARY.md` - What was removed from this branch
- `verify-setup.sh` - Automated verification script
- [Official Zabbix Documentation](https://www.zabbix.com/documentation/current/)

## 🎯 Workflow Examples

### Daily Testing Workflow
```bash
# Start minimal setup
docker compose up -d

# Make changes to UI
vim ./zbx_env/usr/share/zabbix/ui/index.php

# Check logs
docker compose logs -f zabbix-server

# When done
docker compose down
```

### Testing with Agent
```bash
# Start with agent
docker compose --profile agent up -d

# Add agent to monitoring
# In Web UI: Configuration → Hosts → Create host
# Set agent interface to: zabbix-agent:10050

# Stop
docker compose --profile agent down
```

### Clean Testing Environment
```bash
# Remove everything and start fresh
docker compose down -v
rm -rf ./zbx_env
docker compose up
```

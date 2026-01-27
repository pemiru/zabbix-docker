# Repository Changes Summary

## What Was Changed

This repository has been simplified to include only:
- **Zabbix Proxy with MySQL** (Ubuntu-based)
- **Zabbix Agent2** (Ubuntu-based)
- **MySQL Server** for the proxy database

## Files Added

1. **docker-compose.yaml** - New simplified compose file with only 4 services:
   - mysql-server
   - proxy-db-init
   - zabbix-proxy-mysql
   - zabbix-agent2

2. **ansible-example.yaml** - Complete Ansible playbook example for deployment

3. **test-setup.sh** - Validation script to verify setup correctness

## Files Modified

1. **.env** - Simplified to only include Ubuntu image tags and MySQL configuration

2. **README.md** - Rewritten to reflect the simplified setup with Ansible deployment instructions

## Files/Directories Removed

### Docker Compose Files
- All `docker-compose_v3_*.yaml` files (alpine, centos, ol variants)
- compose.yaml (symlink)
- compose_zabbix_components.yaml
- compose_databases.yaml
- compose_additional_components.yaml
- kubernetes.yaml

### Dockerfiles
- All non-Ubuntu OS variants (alpine, centos, ol, rhel)
- All component types except proxy-mysql and agent2:
  - agent (v1)
  - server-mysql
  - server-pgsql
  - web-apache-mysql
  - web-apache-pgsql
  - web-nginx-mysql
  - web-nginx-pgsql
  - java-gateway
  - web-service
  - snmptraps
  - proxy-sqlite3
  - build-base
  - build-mysql
  - build-pgsql
  - build-sqlite3

### Configuration
- config_templates/ directory
- sources/ directory
- All PostgreSQL-related files
- All server and web interface env files

### Build & CI
- .github/ directory (all workflows)
- .pre-commit-config.yaml
- build.json
- build.sh
- sonar-project.properties

### Environment Variables Removed
- .POSTGRES_USER
- .POSTGRES_PASSWORD
- .env_db_pgsql
- .env_java
- .env_prx_sqlite3
- .env_snmptraps
- .env_srv (server)
- .env_web
- .env_web_service
- chrome_dp.json

## Remaining Structure

```
zabbix-docker/
├── docker-compose.yaml          # Main compose file
├── .env                          # Environment variables
├── README.md                     # Usage documentation
├── ansible-example.yaml          # Ansible deployment example
├── test-setup.sh                 # Setup validation script
├── LICENSE                       # License file
├── SECURITY.md                   # Security policy
├── Dockerfiles/
│   ├── proxy-mysql/ubuntu/      # Proxy Dockerfile
│   └── agent2/ubuntu/           # Agent2 Dockerfile
└── env_vars/
    ├── .MYSQL_USER              # MySQL credentials (secret)
    ├── .MYSQL_PASSWORD          # MySQL credentials (secret)
    ├── .MYSQL_ROOT_PASSWORD     # MySQL credentials (secret)
    ├── .env_agent               # Agent2 configuration
    ├── .env_prx                 # Proxy configuration
    ├── .env_prx_mysql           # Proxy MySQL settings
    ├── .env_db_mysql            # MySQL database settings
    ├── .env_db_mysql_proxy      # Proxy database settings
    └── mysql_init/
        └── init_proxy_db.sql    # Database initialization script
```

## Benefits

1. **Simplicity** - Only 2 services needed (proxy + agent2) instead of 10+ components
2. **Single OS** - Ubuntu only, no need to maintain multiple OS variants
3. **Single DB** - MySQL only, simplified database management
4. **Ansible-Ready** - Designed for easy Ansible deployment with example playbook
5. **Lightweight** - Reduced from ~2000 files to ~50 essential files
6. **Clear Purpose** - Repository now has a single, focused use case

## Usage

### Quick Start
```bash
docker compose up -d
```

### With Ansible
```bash
ansible-playbook -i inventory ansible-example.yaml
```

### Validation
```bash
./test-setup.sh
```

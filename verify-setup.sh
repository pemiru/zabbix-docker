#!/bin/bash
# Verification script for minimal Zabbix Docker Compose setup

set -e

echo "=========================================="
echo "Zabbix Minimal Setup Verification Script"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $2"
    else
        echo -e "${RED}✗${NC} $2"
        exit 1
    fi
}

print_info() {
    echo -e "${YELLOW}ℹ${NC} $1"
}

# Check Docker
echo "1. Checking Docker installation..."
docker --version > /dev/null 2>&1
print_status $? "Docker is installed"

docker compose version > /dev/null 2>&1
print_status $? "Docker Compose is installed"

echo ""

# Check required files
echo "2. Checking required files..."
files=(
    ".env"
    "docker-compose_test.yaml"
    "docker-compose_v3_ubuntu_pgsql_latest.yaml"
    "compose_zabbix_components.yaml"
    "compose_databases.yaml"
    "env_vars/.POSTGRES_USER"
    "env_vars/.POSTGRES_PASSWORD"
    "env_vars/.env_db_pgsql"
    "env_vars/.env_srv"
    "env_vars/.env_web"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        print_status 0 "Found $file"
    else
        print_status 1 "Missing $file"
    fi
done

echo ""

# Validate compose files
echo "3. Validating Docker Compose configurations..."
docker compose -f docker-compose_test.yaml config > /dev/null 2>&1
print_status $? "docker-compose_test.yaml is valid"

docker compose -f docker-compose_v3_ubuntu_pgsql_latest.yaml config > /dev/null 2>&1
print_status $? "docker-compose_v3_ubuntu_pgsql_latest.yaml is valid"

echo ""

# Check volume mount configuration
echo "4. Checking UI volume mount configuration..."
if docker compose -f docker-compose_test.yaml config | grep -q "usr/share/zabbix/ui"; then
    print_status 0 "UI volume mount is configured"
else
    print_status 1 "UI volume mount is NOT configured"
fi

echo ""

# Verify removed files
echo "5. Verifying unnecessary files were removed..."
removed_files_should_not_exist=(
    "docker-compose_v3_alpine_mysql_latest.yaml"
    "docker-compose_v3_centos_pgsql_latest.yaml"
    "docker-compose_v3_ol_mysql_latest.yaml"
    "env_vars/.MYSQL_USER"
    "env_vars/.env_db_mysql"
    "env_vars/.env_prx"
    "env_vars/.env_java"
    "config_templates/proxy"
    "config_templates/web_service"
)

all_removed=true
for file in "${removed_files_should_not_exist[@]}"; do
    if [ -e "$file" ]; then
        echo -e "${RED}✗${NC} $file should be removed but still exists"
        all_removed=false
    fi
done

if $all_removed; then
    print_status 0 "All unnecessary files have been removed"
fi

echo ""

# Summary
echo "=========================================="
echo -e "${GREEN}All checks passed!${NC}"
echo "=========================================="
echo ""
print_info "To start the minimal setup:"
echo "  docker compose -f docker-compose_test.yaml up"
echo ""
print_info "To start with agent profile:"
echo "  docker compose -f docker-compose_test.yaml --profile agent up"
echo ""
print_info "To start the full Ubuntu+PostgreSQL setup:"
echo "  docker compose -f docker-compose_v3_ubuntu_pgsql_latest.yaml up"
echo ""
print_info "Access Zabbix Web UI at: http://localhost"
print_info "Default credentials: Admin / zabbix"
echo ""

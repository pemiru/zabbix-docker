#!/bin/bash
# Test script to verify docker-compose configuration

set -e

echo "=== Testing Zabbix Docker Setup ==="
echo ""

# Check if docker-compose is available
echo "1. Checking docker compose availability..."
if command -v docker &> /dev/null && docker compose version &> /dev/null; then
    echo "   ✓ Docker Compose is available"
else
    echo "   ✗ Docker Compose is not available"
    exit 1
fi

# Validate docker-compose.yaml syntax
echo ""
echo "2. Validating docker-compose.yaml syntax..."
if docker compose config > /dev/null 2>&1; then
    echo "   ✓ docker-compose.yaml syntax is valid"
else
    echo "   ✗ docker-compose.yaml syntax is invalid"
    exit 1
fi

# Check required files exist
echo ""
echo "3. Checking required files..."
FILES=(
    "docker-compose.yaml"
    ".env"
    "env_vars/.env_agent"
    "env_vars/.env_prx"
    "env_vars/.env_prx_mysql"
    "env_vars/.env_db_mysql"
    "env_vars/.env_db_mysql_proxy"
    "env_vars/.MYSQL_USER"
    "env_vars/.MYSQL_PASSWORD"
    "env_vars/.MYSQL_ROOT_PASSWORD"
    "env_vars/mysql_init/init_proxy_db.sql"
)

for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "   ✓ $file exists"
    else
        echo "   ✗ $file is missing"
        exit 1
    fi
done

# Check that only necessary Dockerfiles remain
echo ""
echo "4. Checking Dockerfile structure..."
if [ -d "Dockerfiles/proxy-mysql/ubuntu" ] && [ -d "Dockerfiles/agent2/ubuntu" ]; then
    echo "   ✓ Ubuntu Dockerfiles present for proxy-mysql and agent2"
else
    echo "   ✗ Required Dockerfiles are missing"
    exit 1
fi

# Verify no unnecessary OS variants remain
if [ ! -d "Dockerfiles/proxy-mysql/alpine" ] && \
   [ ! -d "Dockerfiles/proxy-mysql/centos" ] && \
   [ ! -d "Dockerfiles/agent2/alpine" ] && \
   [ ! -d "Dockerfiles/agent2/centos" ]; then
    echo "   ✓ Unnecessary OS variants removed"
else
    echo "   ✗ Unnecessary OS variants still present"
    exit 1
fi

# Check services in docker-compose.yaml
echo ""
echo "5. Checking services in docker-compose.yaml..."
SERVICES=$(docker compose config --services 2>/dev/null)
EXPECTED_SERVICES=("mysql-server" "proxy-db-init" "zabbix-proxy-mysql" "zabbix-agent2")

for service in "${EXPECTED_SERVICES[@]}"; do
    if echo "$SERVICES" | grep -q "^${service}$"; then
        echo "   ✓ Service $service is defined"
    else
        echo "   ✗ Service $service is missing"
        exit 1
    fi
done

# Count services (should be exactly 4)
SERVICE_COUNT=$(echo "$SERVICES" | wc -l)
if [ "$SERVICE_COUNT" -eq 4 ]; then
    echo "   ✓ Correct number of services (4)"
else
    echo "   ✗ Unexpected number of services: $SERVICE_COUNT (expected 4)"
    exit 1
fi

echo ""
echo "=== All tests passed! ==="
echo ""
echo "To start the services, run:"
echo "  docker compose up -d"
echo ""
echo "For Ansible deployment, use:"
echo "  community.docker.docker_compose_v2:"
echo "    project_src: /path/to/zabbix-docker"
echo "    state: present"

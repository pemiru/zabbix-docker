# Zabbix Docker - Proxy + Agent2 (Ubuntu)

This is a simplified Zabbix Docker setup that includes only:
- **Zabbix Proxy** with MySQL database support
- **Zabbix Agent2**
- **MySQL Server** for the proxy database

All images are based on **Ubuntu**.

## Quick Start

1. Clone this repository
2. Run `docker compose up -d`
3. Wait for the services to start

The following services will be available:
- Zabbix Proxy on port `10071`
- Zabbix Agent2 on port `10060` (agent) and `31999` (status)

## Configuration

Configuration is managed through environment files in the `env_vars` directory:
- `.env_agent` - Agent2 configuration
- `.env_prx` - Proxy configuration
- `.env_prx_mysql` - Proxy MySQL-specific settings
- `.env_db_mysql_proxy` - Proxy database configuration

Database credentials are stored in secret files:
- `.MYSQL_USER`
- `.MYSQL_PASSWORD`
- `.MYSQL_ROOT_PASSWORD`

## For Ansible Deployment

This setup is designed to be deployed via Ansible. The `docker-compose.yaml` file uses default values where possible, making it easy to override via environment variables in your Ansible playbook.

A complete example playbook is provided in `ansible-example.yaml`. Basic usage:

```yaml
- name: Deploy Zabbix Proxy and Agent2
  community.docker.docker_compose_v2:
    project_src: /path/to/zabbix-docker
    state: present
  environment:
    ZABBIX_PROXY_MYSQL_PORT: "10071"
    ZABBIX_AGENT2_PORT: "10060"
```

See `ansible-example.yaml` for a complete example with service verification and configuration management.

## Directory Structure

- `docker-compose.yaml` - Main compose file with all services
- `.env` - Environment variables for image tags and ports
- `env_vars/` - Service configuration files
- `zbx_env/` - Persistent data (created automatically)
- `Dockerfiles/` - Dockerfiles for building images (Ubuntu only)

## Zabbix Documentation

For more information about Zabbix:
- [Zabbix Documentation](https://www.zabbix.com/documentation/current/manual)
- [Zabbix Docker Hub](https://hub.docker.com/u/zabbix/)
- [Zabbix Proxy Documentation](https://www.zabbix.com/documentation/current/manual/concepts/proxy)
- [Zabbix Agent2 Documentation](https://www.zabbix.com/documentation/current/manual/concepts/agent#agent-2)

## License

Starting from Zabbix version 7.0, all subsequent Zabbix versions will be released under the GNU Affero General Public License version 3 (AGPLv3).

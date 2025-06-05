# WordPress Server Ansible Playbook

This Ansible project provides a comprehensive set of playbooks and roles for deploying and configuring a WordPress server, with most development done targeting an Ubuntu system.

## Requirements

- Ansible 2.9+
- Target servers running Debian/Ubuntu (preferred)or RHEL/CentOS
- SSH access to target servers
- Role dependencies installed via requirements.yml

## Installation

1. Clone this repository:
   ```
   git clone https://github.com/yourusername/wp-ansible.git
   cd wp-ansible
   ```

2. Install required Ansible roles:
   ```
   ansible-galaxy install -r requirements.yml
   ```

   This will install all dependencies including PHP roles required by wp_cli.

3. Update inventory and variables:
   ```
   # Edit inventory/hosts to add your servers
   # Customize group_vars/all.yml for global settings
   # Create host_vars/your-server.yml for host-specific settings
   - User-specific configurations will respect the ansible_user you connect with
   - Automated WP-CLI updates via cron
   ```

## Usage

Run the complete playbook:

```
ansible-playbook -i inventory/hosts site.yml
```

Target specific hosts:

```
ansible-playbook -i inventory/hosts site.yml -e "target_host=webservers"
```

Run specific tasks with tags:

```
ansible-playbook -i inventory/hosts site.yml --tags "nginx,php"
```

## Secrets

Secrets are provided via environment variables on the system where ansible-playbook is run.  Here are the environment variables that are needed:

```
# Used for certbot and WordPress installations:
export ADMIN_EMAIL="your-email@example.com"

# Used for WordPress admin username:
export ADMIN_USER="username"

# WordPress admin user password:
export ADMIN_PASSWORD="your-random-password-here"

# WordPress database password. Append the site domain name to the
# variable to apply to specific site. Replace the "." with an
# underscore as seen in the example:
export WP_DB_PASSWORD_EXAMPLE1_COM="your-random-password-here"
export WP_DB_PASSWORD_DEV_EXAMPLE_COM="unique-random-password"




```

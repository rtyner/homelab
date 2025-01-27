#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}Creating homelab repository structure...${NC}"

# Create main directories
directories=(
  "docker/compose/monitoring/prometheus"
  "docker/compose/monitoring/grafana"
  "docker/compose/dns/bind/config"
  "docker/compose/dns/pihole"
  "docker/compose/services/gitlab"
  "docker/compose/services/jenkins"
  "docker/compose/services/nocodb"
  "docker/compose/services/argocd"
  "docker/compose/media/plex"
  "docker/compose/media/diskover"
  "docker/configs/nginx"
  "docker/configs/caddy"
  "docker/configs/cloudflare"
  "docker/scripts/maintenance"
  "docker/scripts/backup"
  ".gitlab/issue_templates"
  ".gitlab/merge_request_templates"
  "ansible/inventory/group_vars"
  "ansible/inventory/host_vars"
  "ansible/playbooks/infrastructure"
  "ansible/playbooks/kubernetes"
  "ansible/playbooks/monitoring"
  "ansible/playbooks/security"
  "ansible/roles"
  "docs/architecture"
  "docs/runbooks"
  "docs/troubleshooting"
  "kubernetes/clusters/prod"
  "kubernetes/clusters/dev"
  "kubernetes/apps"
  "kubernetes/platform"
  "terraform/modules/proxmox-vm"
  "terraform/modules/server-roles/postgres"
  "terraform/modules/server-roles/docker-host"
  "terraform/modules/server-roles/kubernetes-node"
  "terraform/modules/server-roles/dns-server"
  "terraform/environments/prod/database"
  "terraform/environments/prod/kubernetes"
  "terraform/environments/prod/docker"
  "terraform/environments/prod/dns"
  "terraform/environments/dev"
  "terraform/global"
  "scripts/backup"
  "scripts/maintenance"
  "monitoring/grafana/dashboards"
  "monitoring/grafana/datasources"
  "monitoring/prometheus/rules"
  "monitoring/alertmanager"
)

for dir in "${directories[@]}"; do
  mkdir -p "$dir"
  echo -e "${GREEN}Created directory: ${NC}$dir"
done

# Create base template files
# GitLab CI
cat >.gitlab-ci.yml <<'EOF'
stages:
  - validate
  - plan
  - apply
  - test
  - deploy

terraform-validate:
  stage: validate
  script:
    - terraform init
    - terraform validate

ansible-lint:
  stage: validate
  script:
    - ansible-lint playbooks/*
EOF

# Ansible inventory
cat >ansible/inventory/hosts <<'EOF'
[proxmox]
prod-pve-01 ansible_host=10.1.1.2
prod-pve-02 ansible_host=10.1.1.4
prod-pve-03 ansible_host=10.1.1.5

[postgres]
prod-pg-01 ansible_host=10.1.1.15
prod-pg-02 ansible_host=10.1.1.18
prod-pg-03 ansible_host=10.1.1.23

[docker]
prod-docker-01 ansible_host=10.1.1.16
prod-docker-02 ansible_host=10.1.1.17

[kubernetes_master]
prod-k3s-cls01-master-01 ansible_host=10.1.1.50
prod-k3s-cls01-master-02 ansible_host=10.1.1.51
prod-k3s-cls01-master-03 ansible_host=10.1.1.52

[kubernetes_worker]
prod-k3s-cls01-worker-01 ansible_host=10.1.1.53
prod-k3s-cls01-worker-02 ansible_host=10.1.1.54
prod-k3s-cls01-worker-03 ansible_host=10.1.1.55
prod-k3s-cls01-worker-04 ansible_host=10.1.1.56
prod-k3s-cls01-worker-05 ansible_host=10.1.1.57

[dns]
prod-dns-01 ansible_host=10.1.1.98
prod-dns-02 ansible_host=10.1.1.99
EOF

# Base Terraform module files
cat >terraform/modules/proxmox-vm/main.tf <<'EOF'
variable "vm_name" {}
variable "target_node" {}
variable "ip_address" {}

resource "proxmox_vm_qemu" "vm" {
  name        = var.vm_name
  target_node = var.target_node
  # Add your common VM configuration here
}

output "vm_id" {
  value = proxmox_vm_qemu.vm.id
}
EOF

cat >terraform/modules/proxmox-vm/variables.tf <<'EOF'
variable "vm_name" {
  description = "Name of the VM"
  type        = string
}

variable "target_node" {
  description = "Target Proxmox node"
  type        = string
}

variable "ip_address" {
  description = "IP address for the VM"
  type        = string
}
EOF

# Create a sample production postgres configuration
cat >terraform/environments/prod/database/main.tf <<'EOF'
module "postgres_01" {
  source      = "../../../modules/server-roles/postgres"
  vm_name     = "prod-pg-01"
  target_node = "pve-01"
  ip_address  = "10.1.1.15"
}

module "postgres_02" {
  source      = "../../../modules/server-roles/postgres"
  vm_name     = "prod-pg-02"
  target_node = "pve-02"
  ip_address  = "10.1.1.18"
}
EOF

# Create README files for key directories
cat >terraform/modules/README.md <<'EOF'
# Terraform Modules

This directory contains reusable Terraform modules for the homelab infrastructure.

## Modules

- proxmox-vm: Base module for VM creation
- server-roles: Specific server type configurations
EOF

cat >ansible/README.md <<'EOF'
# Ansible Configuration

This directory contains Ansible playbooks and roles for configuring the homelab infrastructure.

## Structure

- inventory/: Host and group configurations
- playbooks/: Task playbooks organized by function
- roles/: Reusable Ansible roles
EOF

# Create gitignore
cat >.gitignore <<'EOF'
# Terraform
*.tfstate
*.tfstate.*
.terraform/
*.tfvars
.terraform.lock.hcl

# Ansible
*.retry
ansible/*.cfg

# Environment
.env
.envrc

# OS
.DS_Store
Thumbs.db
EOF

echo -e "${GREEN}Repository structure created successfully!${NC}"
echo -e "${GREEN}Don't forget to initialize git repository with: git init${NC}"

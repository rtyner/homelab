# Infrastructure Architecture

## Overview

This document outlines the architecture of my homelab infrastructure, including network topology, server configurations, and service deployments.

## Physical Infrastructure

### Hypervisors

I'm using Proxmox VE 8.x as the hypervisor platform across three nodes:

| Hostname    | Resources           | Primary Role              |
| ----------- | ------------------- | ------------------------- |
| prod-pve-01 | 192GB RAM, 24 cores | VM host                   |
| prod-pve-02 | 64GB RAM, 16 cores  | VM Host, GPU workloads    |
| prod-pve-03 | 16GB RAM, 4 cores   | VM Host, backup workloads |
| prod-pve-04 | 384GB RAM, 32 cores | VM Host                   |

### Storage

| Hostname         | prod-pve-01 | prod-pve-02 | prod-pve-03   | prod-pve-04 | prod-nas-01 | prod-nas-02 |
| ---------------- | ----------- | ----------- | ------------- | ----------- | ----------- | ----------- |
| Physical Disks 1 | 2x 1TB SSD  | 2x 2TB NVMe | 1x 512GB NVMe | 9x 1TB SSD  | 2x 10TB HDD | 2x 14TB HDD |
| Physical Disks 2 | 5x 5TB HDD  | 6x 8TB HDD  | N/A           | 7x 2TB SSHD | 4x 8TB HDD  | 2x 8TB HDD  |
| Pools            |             |             |               |             |             |             |
| Shares           |             |             |               |             |             | bdp, red    |

### Networking

- Subnet: 10.1.1.0/24
- Primary Network Equipment:
  - Protectli FWB4
  - Cisco WS-C3560G-24PS POE 24x 1Gbe
  - Cisco Nexux 3060-X 48x 10Gbe Switch, 4x 40Gbe
  - Brocade ICX7250-48P 48x 1Gbe, 8x 10Gbe

## Logical Infrastructure

### DNS Architecture

I run a redundant DNS setup using BIND9:

- Primary DNS (prod-dns-01): 10.1.1.96
- Secondary DNS (prod-dns-02): 10.1.1.97
- Zones:
  - local.rtyner.com
  - rtyner.com

### Database Layer

PostgreSQL cluster deployed across multiple nodes for redundancy:

- prod-pg-01 (10.1.1.15) - prod-pve-01
- prod-pg-02 (10.1.1.18) - prod-pve-02
- prod-pg-03 (10.1.1.23) - prod-pve-04

### Container Infrastructure

Docker hosts for running containerized services:

- prod-docker-01 (10.1.1.16): Primary container host
- prod-docker-02 (10.1.1.17): Secondary container host

### Kubernetes Cluster

K3s cluster configuration:

Masters:

- prod-k3s-cls01-master-01 (10.1.1.50)
- prod-k3s-cls01-master-02 (10.1.1.51)
- prod-k3s-cls01-master-03 (10.1.1.52)

Workers:

- prod-k3s-cls01-worker-01 (10.1.1.53)
- prod-k3s-cls01-worker-02 (10.1.1.54)
- prod-k3s-cls01-worker-03 (10.1.1.55)
- prod-k3s-cls01-worker-04 (10.1.1.56)
- prod-k3s-cls01-worker-05 (10.1.1.57)

## Service Architecture

### Core Services

1. DNS (BIND9)
   - Primary and secondary DNS servers
   - Internal zone management
   - Split-horizon DNS configuration

2. Storage Services
   - NFS shares for VM storage over 10Gbe
   - SMB shares for media and backups
   - Central file server (prod-file-01)

3. Monitoring Stack
   - Prometheus for metrics collection
   - Grafana for visualization
   - Node Exporter on all hosts
   - Container monitoring via cAdvisor

### Application Services

1. Development Tools
   - GitLab
   - Jenkins
   - Docker Registry

2. Network Services
   - Cloudflare Tunnel
   - Caddy Reverse Proxy

## Backup Architecture

- Proxmox Backup Server (prod-backup-01)
- Daily VM backups
- Weekly configuration backups
- Monthly full system backups
- Backups are stored locally and replicated to Backblaze B2

## Network Security

1. Network Segmentation
   - Management VLAN
   - Storage VLAN
   - Data VLAN

2. Access Control
   - Internal DNS resolution
   - Restricted management access
   - VPN access for remote management

## Automation and IaC

1. Infrastructure Provisioning
   - Terraform for VM provisioning
   - Ansible for configuration management
   - GitLab CI/CD for automation

2. Configuration Management
   - Version controlled configurations
   - Automated deployments
   - Configuration drift detection

## Monitoring and Alerting
1. Metrics Collection
   - System metrics via Node Exporter
   - Container metrics via cAdvisor
   - Custom application metrics

2. Visualization
   - Grafana dashboards
   - Performance metrics
   - Capacity planning

3. Alerting
   - Prometheus Alertmanager
   - Email notifications
   - Critical system alerts

## Hardware

### Servers

| Description   | Model                    | CPU               | RAM   | Storage                 | NIC               | OS               |
| ------------- | ------------------------ | ----------------- | ----- | ----------------------- | ----------------- | ---------------- |
| VM Host 1     | Dell R720                | 2x Xeon E5-2640   | 192GB | 2x1TB SSD ,5x5TB HDD    | 4X 1Gbe 1x 10Gbe  | Proxmox 8.x      |
| VM Host 2     | Whitebox Server          | 1x AMD 5700X3D    | 64GB  | 1x 2TB NVMe 1x 1TB SSD  | 1x 1Gbe           | Proxmox 8.x      |
| VM Host 3     | Lenovo ThinkCentre M92p  | 1x Intel i5-3470T | 16GB  | 1x 512GB NVMe           | 1x 1Gbe           | Proxmox 8.x      |
| VM Host 4     | Dell R720                | 2x Xeon E5-2670   | 384GB | 9x 1TB SSD, 7x 2TB SSHD | 8x 1Gbe, 4x 10Gbe | Proxmox 8.x      |
| NAS           | HP Proliant ML310E       | 1x Xeon E3-1230   | 32GB  | 2x 8TB 2x 14TB          | 1x 1Gbe 1x 10Gbe  | Truenas Core 13  |
| NAS           | Dell R710                | 2x Xeon E3-1230   | 128GB | 2x 8TB 2x 14TB          | 4x 1Gbe 2x 10Gbe  | Truenas Scale 24 |
| Temp Sensor   | ESP8266 + DHT22          |                   |       |                         |                   |                  |

### Network 

| Description        | Model                | Ports               | Description           | Functions         |
| ------------------ | -------------------- | ------------------- | --------------------- | ----------------- |
| Primary Firewall   | Protectli FW4B       | 4x 1Gbe             | Primary Firewall      | Routing, firewall |
| Secondary Firewall | OPNSense VM          | 4x 1Gbe             | Secondary Firewall    |                   |
| Core Switch        | Cisco Nexux 3060-X   | 48x 10Gbe, 4x 40Gbe | Core Server Switch    |                   |
| Access Switch      | Brocade ICX7250-48P  | 48x 1Gbe, 8x 10Gbe  | Primary Access Switch |                   |
| Access Switch      | Cisco WS-C3560G-24PS | 24x 1Gbe            |                       | PoE               |

## Physical Infrastructure

| hostname                    | ip                  | function                          |
| --------------------------- | ------------------- | --------------------------------- |
| prod-fw-01                  | 10.1.1.1            | primary firewall                  |
| prod-pve-01                 | 10.1.1.2,10.12.1.1  | proxmox hypervisor                |
| prod-pve-02                 | 10.1.1.4            | proxmox hypervisor                |
| prod-pve-03                 | 10.1.1.5            | proxmox hypervisor                |
| prod-pve-04                 | 10.1.1.7            | proxmox hypervisor                |
| prod-nas-01                 | 10.1.1.8, 10.12.1.2 | truenas storage server smb, nfs   |
| prod-nas-02                 | 10.1.1.6, 10.12.1.4 | truenas backup server smb, nfs    |
| EAP660 HD-6C-5A-B0-A2-7C-78 | 10.1.1.253          | TP Link Omada AP                  |
| acc-sw-01                   | 10.1.1.254          | Cisco 24p switch                  |
| acc-sw-02                   | 10.1.1.251          | Brocade 48x 1Gbe, 8x 10Gbe switch |
| core-sw-01                  | 10.1.1.252          | Cisco 48x 1Gbe, 4x 40Gbe switch   |
| rack01-temp-01              | 10.1.1.30           | Rack temperature monitoring       |

## VMs

| hostname                 | ip                    | host        | function                                            |
| ------------------------ | --------------------- | ----------- | --------------------------------------------------- |
| prod-backup-01           | 10.1.1.14             | prod-pve-03 | proxmox backup server                               |
| prod-pg-01               | 10.1.1.15             | pve-01      | postgres server                                     |
| prod-docker-01           | 10.1.1.16             | pve-01      | docker server 01                                    |
| prod-docker-02           | 10.1.1.17, 10.12.1.10 | pve-01      | docker server 02                                    |
| prod-pg-02               | 10.1.1.18             | pve-02      | postgres server                                     |
| dev-ollama-01            | 10.1.1.19             | pve-02      | ollama                                              |
| dev-arch-01              | 10.1.1.20             | pve-02      | linux jump/dev box                                  |
| prod-file-01             | 10.1.1.21             | pve-01      | nfs file server                                     |
| prod-monitor-01          | 10.1.1.22             | pve-02      | monitoring server, prometheus, grafana, uptime kuma |
| prod-pg-03               | 10.1.1.23             | pve-01      | postgres server                                     |
| prod-jenkins-01          | 10.1.1.24             | pve-01      | jenkins server                                      |
| prod-nocodb-01           | 10.1.1.25             | pve-02      | nocodb                                              |
| prod-caddy-01            | 10.1.1.26             | pve-02      | caddy reverse proxy                                 |
| prod-gitlab-01           | 10.1.1.27             | pve-02      | gitlab                                              |
| prod-gitea-01            | 10.1.1.29             | pve-04      | gitea                                               |
| docker-master-01         | 10.1.1.30             | pve-04      | master node docker                                  |
| prod-k3s-cls01-master-01 | 10.1.1.50             | pve-01      | k3s master                                          |
| prod-k3s-cls01-master-02 | 10.1.1.51             | pve-02      | k3s master                                          |
| prod-k3s-cls01-master-03 | 10.1.1.52             | pve-03      | k3s master                                          |
| prod-k3s-cls01-worker-01 | 10.1.1.53             | prod-pve-01 | k3s worker                                          |
| prod-k3s-cls01-worker-02 | 10.1.1.54             | prod-pve-01 | k3s worker                                          |
| prod-k3s-cls01-worker-03 | 10.1.1.55             | prod-pve-02 | k3s worker                                          |
| prod-k3s-cls01-worker-04 | 10.1.1.56             | prod-pve-03 | k3s worker                                          |
| prod-k3s-cls01-worker-05 | 10.1.1.57             | prod-pve-03 | k3s worker                                          |
| prod-bind-01             | 10.1.1.96             | prod-pve-01 | bind master                                         |
| prod-bind-02             | 10.1.1.97             | prod-pve-03 | bind slave                                          |
| prod-dns-01              | 10.1.1.98             | pve-01      | primary pihole                                      |
| prod-dns-02              | 10.1.1.99             | pve-02      | secondary pihole                                    |

## Docker Containers

| container name            | hostname                   | host            | function             | ports          |
| ------------------------- | -------------------------- | --------------- | -------------------- | -------------- |
| plex                      | plex.local.rtyner.com      | prod-docker-02  | primary plex server  |                |
| homepage                  | dash.local.rtyner.com      | prod-docker-01  | homepage dashboard   | 3091           |
| phpipam-phpipam-web-1     | ipam.local.rtyner.com      | prod-docker-01  | phpipam web          | 8013           |
| phpipam-phpipam-cron-1    |                            | prod-docker-01  | phpipam cron         | 80             |
| phpipam-phpipam-mariadb-1 |                            | prod-docker-01  | phpipam db           | 3306           |
| nginx-proxy-manager       |                            | prod-docker-01  | nginx proxy manager  | 80, 443        |
| watchtower-watchtower-1   |                            | prod-docker-01  | container updates    | 8080           |
| minio-minio-1             |                            | prod-docker-02  | minio s3 storage     | 9098,9099      |
| cloudflare-tunnel         | cloudflared                | prod-docker-02  | cloudflare tunnel    | 8081           |
| dashy                     | dash.local.rtyner.com      | prod-docker-01  | dashboard            | 4000           |
| portainer                 | portainer.local.rtyner.com | prod-docker-01  | container management | 8000,9000,9443 |
| monitoring-grafana-1      | grafana.local.rtyner.com   | prod-monitor-02 | grafana              | 3000           |
| monitoring-prometheus-1   | prom.local.rtyner.com      | prod-monitor-02 | prometheus           | 9090           |

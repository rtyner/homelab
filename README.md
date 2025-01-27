# Infrastructure Architecture

## Overview

This document outlines the architecture of my homelab infrastructure, including network topology, server configurations, and service deployments.

## Physical Infrastructure

### Hypervisors

I'm using Proxmox VE 8.x as the hypervisor platform across four nodes:

| Hostname | Resources           | Primary Role              |
| -------- | ------------------- | ------------------------- |
| pve01    | 384GB RAM, 32 cores | VM Host                   |
| pve02    | 192GB RAM, 24 cores | VM host                   |
| pve03    | 16GB RAM, 4 cores   | VM Host, backup workloads |


### Storage

| Hostname         | pve01      | pve02      | pve03        | nas-01      | nas-02       |
| ---------------- | ---------- | ---------- | ------------ | ----------- | ------------ |
| Physical Disks 1 | 7x 1TB SSD | 6x 1TB SSD | 1x 512GB SSD | 2x 10TB HDD | 3x 14TB HDD  |
| Physical Disks 2 | 5x 2TB HDD | 2x 2TB HDD |              | 10x 8TB HDD | 1x 250GB SSD |
| Physical Disks 2 |            | 4x 5TB HDD |              | 2x 1TB SSD  |              |
| Pools            |            |            |              |             |              |
| Shares           |            |            |              |             |              |

### Networking

- Subnet: 10.X.1.0/24
- VLANS
  - 5 - User 
  - 10 - Data 
  - 20 - Storage 
  - 30 - Cluster
  - 40 - Management
  - 50 - IoT
  - 60 - DMZ
  - 70 - Jump
  - 80 - Guest
- Network Equipment:
  - Protectli FWB4
  - Cisco WS-C3560G-24PS POE 24x 1Gbe
  - Cisco Nexux 3060-X 48x 10Gbe Switch, 4x 40Gbe
  - Brocade ICX7250-48P 48x 1Gbe, 8x 10Gbe

## Logical Infrastructure

### DNS Architecture

I run a redundant DNS setup using BIND9:

- Primary DNS (dns-prod-01): 10.10.1.10
- Secondary DNS (dns-prod-02): 10.10.1.11
- Zones:
  - local.rtyner.com
  - rtyner.com

### Database Layer

PostgreSQL cluster deployed across multiple nodes for redundancy:

- pg-prod-01 (10.10.1.15) - pve01
- pg-prod-02 (10.10.1.18) - pve02
- pg-prod-03 (10.10.1.23) - pve04

### Container Infrastructure

#### Kubernetes Cluster

Production k3s cluster configuration:

Masters:

- k3s-prod-master-01 (10.10.1.50)
- k3s-prod-master-02 (10.10.1.51)
- k3s-prod-master-03 (10.10.1.52)

Workers:

- k3s-prod-worker-01 (10.10.1.53)
- k3s-prod-worker-02 (10.10.1.54)
- k3s-prod-worker-03 (10.10.1.55)
- k3s-prod-worker-04 (10.10.1.56)
- k3s-prod-worker-05 (10.10.1.57)
- k3s-prod-worker-05 (10.10.1.58)

Development k3s cluster configuration:

Masters:

- k3s-dev-master-01 (10.10.1.59)

Workers:

- k3s-dev-worker-01 (10.10.1.60)
- k3s-dev-worker-02 (10.10.1.61)
  
Docker hosts for running containerized services:

- docker-prod-01 (10.10.1.16): Primary container host
- docker-prod-02 (10.10.1.17): Secondary container host

## Service Architecture

### Core Services

1. DNS (BIND)
   - Primary and secondary DNS servers
     - Authoritative and Recursive
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

| Description | Model                   | CPU               | RAM   | Storage                            | NIC               | OS               |
| ----------- | ----------------------- | ----------------- | ----- | ---------------------------------- | ----------------- | ---------------- |
| VM Host 1   | Dell R720               | 2x Xeon E5-2670   | 384GB | 11x 1TB SSD, 5x 2TB SSHD           | 8x 1Gbe, 4x 10Gbe | Proxmox 8.x      |
| VM Host 2   | Dell R720               | 2x Xeon E5-2640   | 192GB | 1x 1TB SSD, 2x 2TB HDD, 4x 5TB HDD | 4x 1Gbe 2x 10Gbe  | Proxmox 8.x      |
| VM Host 3   | Lenovo ThinkCentre M92p | 1x Intel i5-3470T | 16GB  | 1x 512GB SSD                       | 3x 1Gbe           | Proxmox 8.x      |
| NAS         | HP Proliant ML310E      | 1x Xeon E3-1230   | 32GB  | 2x 8TB HDD 2x 10TB                 | 1x 1Gbe 1x 10Gbe  | Truenas Core 13  |
| NAS         | Dell R730XD             | 2x Xeon E3-1230   | 64GB  | 2x 14TB HDD 10x 8TB HDD            | 4x 1Gbe 2x 10Gbe  | Truenas Scale 24 |
| Temp Sensor | ESP8266 + DHT22         |                   |       |                                    |                   |                  |

### Network

| Description        | Model                | Ports               | Description             | Functions             |
| ------------------ | -------------------- | ------------------- | ----------------------- | --------------------- |
| Primary Firewall   | Protectli FW4B       | 4x 1Gbe             | Primary Firewall        | Routing, Firewall     |
| Secondary Firewall | OPNSense VM          | 4x 1Gbe             | Secondary Firewall      |                       |
| Core Switch        | Cisco Nexux 3060-X   | 48x 10Gbe, 4x 40Gbe | Core Aggregation Switch |                       |
| Access Switch      | Brocade ICX7250-48P  | 48x 1Gbe, 8x 10Gbe  | Core Access Switch      | L3, InterVLAN Routing |
| Access Switch      | Cisco WS-C3560G-24PS | 24x 1Gbe            | Secondary Access Switch | PoE                   |

## Physical Infrastructure

| hostname                    | ip                   | function                          |
| --------------------------- | -------------------- | --------------------------------- |
| fw01                        | 10.10.1.1            | primary firewall                  |
| pve01                       | 10.30.1.2, 10.20.1.2 | proxmox hypervisor                |
| pve02                       | 10.30.1.3, 10.20.1.3 | proxmox hypervisor                |
| pve03                       | 10.30.1.3            | proxmox hypervisor                |
| nas01                       | 10.10.1.8, 10.20.1.5 | truenas storage server smb, nfs   |
| nas-02                      | 10.10.1.6, 10.20.1.4 | truenas backup server smb, nfs    |
| EAP660 HD-6C-5A-B0-A2-7C-78 | 10.10.1.253          | TP Link Omada AP                  |
| acc-sw01                    | 10.10.1.254          | Cisco 24p switch                  |
| core-sw01                   | 10.10.1.251          | Brocade 48x 1Gbe, 8x 10Gbe switch |
| agg-sw01                    | 10.10.1.252          | Cisco 48x 1Gbe, 4x 40Gbe switch   |
| rack01-temp-01              | 10.10.1.30           | Rack temperature monitoring       |

## VMs

| hostname           | ip                     | host   | function                                            |
| ------------------ | ---------------------- | ------ | --------------------------------------------------- |
| nas-03             | 10.10.1.9              | pve02  | truenas vm                                          |
| prod-backup-01     | 10.10.1.14             | pve03  | proxmox backup server                               |
| pg-prod-01         | 10.10.1.15             | pve-01 | postgres server                                     |
| docker-prod-01     | 10.10.1.16             | pve-01 | docker server 01                                    |
| docker-prod-02     | 10.10.1.17, 10.12.1.10 | pve-01 | docker server 02                                    |
| pg-prod-02         | 10.10.1.18             | pve-02 | postgres server                                     |
| dev-ollama-01      | 10.10.1.19             | pve-02 | ollama                                              |
| dev-arch-01        | 10.10.1.20             | pve-02 | linux jump/dev box                                  |
| prod-file-01       | 10.10.1.21             | pve-01 | nfs file server                                     |
| prod-monitor-01    | 10.10.1.22             | pve-02 | monitoring server, prometheus, grafana, uptime kuma |
| pg-prod-03         | 10.10.1.23             | pve-01 | postgres server                                     |
| prod-jenkins-01    | 10.10.1.24             | pve-01 | jenkins server                                      |
| prod-nocodb-01     | 10.10.1.25             | pve-02 | nocodb                                              |
| prod-caddy-01      | 10.10.1.26             | pve-02 | caddy reverse proxy                                 |
| prod-gitlab-01     | 10.10.1.27             | pve-02 | gitlab                                              |
| prod-gitea-01      | 10.10.1.29             | pve-04 | gitea                                               |
| prod-haproxy-01    | 10.10.1.30, 10.1.133   | pve-01 | haproxy node 1                                      |
| prod-haproxy-02    | 10.10.1.31, 10.10.1.33 | pve-04 | haproxy node 2                                      |
| nextcloud-prod-01  | 10.10.1.32             | pve-04 | nextcloud                                           |
| arch-dev-02        | 10.10.1.34             | pve-04 | secondary arch server                               |
| k3s-prod-master-01 | 10.10.1.50             | pve-01 | production k3s master                               |
| k3s-prod-master-02 | 10.10.1.51             | pve-02 | production k3s master                               |
| k3s-prod-master-03 | 10.10.1.52             | pve-03 | production k3s master                               |
| k3s-prod-worker-01 | 10.10.1.53             | pve01  | production k3s worker                               |
| k3s-prod-worker-02 | 10.10.1.54             | pve01  | production k3s worker                               |
| k3s-prod-worker-03 | 10.10.1.55             | pve02  | production k3s worker                               |
| k3s-prod-worker-04 | 10.10.1.56             | pve04  | production k3s worker                               |
| k3s-prod-worker-05 | 10.10.1.57             | pve04  | production k3s worker                               |
| k3s-prod-worker-06 | 10.10.1.58             | pve05  | production k3s worker                               |
| k3s-dev-master-01  | 10.10.1.59             | pve04  | development k3s master                              |
| k3s-dev-worker-01  | 10.10.1.60             | pve04  | development k3s worker                              |
| k3s-dev-worker-01  | 10.10.1.61             | pve04  | development k3s worker                              |
| dns-prod-01        | 10.10.1.96             | pve01  | powerdns master                                     |
| dns-prod-02        | 10.10.1.97             | pve03  | powerdns slave                                      |

## Docker Containers

| container name            | hostname                   | host            | function             | ports          |
| ------------------------- | -------------------------- | --------------- | -------------------- | -------------- |
| plex                      | plex.local.rtyner.com      | docker-prod-02  | primary plex server  |                |
| homepage                  | dash.local.rtyner.com      | docker-prod-01  | homepage dashboard   | 3091           |
| phpipam-phpipam-web-1     | ipam.local.rtyner.com      | docker-prod-01  | phpipam web          | 8013           |
| phpipam-phpipam-cron-1    |                            | docker-prod-01  | phpipam cron         | 80             |
| phpipam-phpipam-mariadb-1 |                            | docker-prod-01  | phpipam db           | 3306           |
| nginx-proxy-manager       |                            | docker-prod-01  | nginx proxy manager  | 80, 443        |
| watchtower-watchtower-1   |                            | docker-prod-01  | container updates    | 8080           |
| minio-minio-1             |                            | docker-prod-02  | minio s3 storage     | 9098,9099      |
| cloudflare-tunnel         | cloudflared                | docker-prod-02  | cloudflare tunnel    | 8081           |
| dashy                     | dash.local.rtyner.com      | docker-prod-01  | dashboard            | 4000           |
| portainer                 | portainer.local.rtyner.com | docker-prod-01  | container management | 8000,9000,9443 |
| monitoring-grafana-1      | grafana.local.rtyner.com   | prod-monitor-02 | grafana              | 3000           |
| monitoring-prometheus-1   | prom.local.rtyner.com      | prod-monitor-02 | prometheus           | 9090           |

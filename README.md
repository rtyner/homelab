# Homelab Scripts and Documentation

This repo is a collection of scripts and documentation for my virtualizaton/container/automation homelab.

## Scripts

- [Setup Local Ubuntu Host](https://github.com/rtyner/homelab/blob/main/scripts/ubuntu-local-setup.sh)
- [Setup Proxmox Server](https://github.com/rtyner/homelab/blob/main/proxmox/pve-setup.sh)
- [Proxmox Backup Script](https://github.com/rtyner/homelab/blob/main/proxmox/backup.sh)
- [Create Docker Hosts](https://github.com/rtyner/homelab/blob/main/proxmox/create-docker-hosts.sh)
- [Create Monitoring Stack](https://github.com/rtyner/homelab/blob/main/proxmox/create-monitoring-stack.sh)
- [Create VM Template](https://github.com/rtyner/homelab/blob/main/proxmox/create-template.sh)

## Documentation

- [Proxmox](https://github.com/rtyner/homelab/blob/main/documentation/proxmox.md)
- [Network](https://github.com/rtyner/homelab/blob/main/documentation/network-documentation.md)
- [Hardware](https://github.com/rtyner/homelab/blob/main/documentation/hardware.md)
- [Perc H310 Mini](https://github.com/rtyner/homelab/blob/main/documentation/h310%20mini.md)
- [Docker](https://github.com/rtyner/homelab/blob/main/documentation/docker.md)
- [Ansible](https://github.com/rtyner/homelab/blob/main/documentation/ansible.md)

## Hardware

- Servers
  - Primary Proxmox Host: pve-1
    - Dell PowerEdge R720
    - 2x Intel Xeon E5-2640 3.0GHz
    - 192GB RAM
    - Perc H310 Mini
    - 2x Samsunsg 870 EVO RAID 1
    - 5x ST5000LM000 RAID 5
  
  - Secondary Proxmox Host: pve-2
    - Lenovo ThinkCentre M92P
    - 1x Intel i5-2520M 2.5GHz
    - 16GB RAM
    - 1x Transcend 250GB SSD
  
  - Tertiary Proxmox Host: pve-3
    - Lenovo ThinkCentre M92P
    - 1x Intel i5-2520M 2.5GHz
    - 16GB RAM
    - 1x Samsung 850 EVO 500GB SSD
  
  - Truenas Host
    - HP Proliant ML310e Gen 8
    - 1x Intel Xeon E3
    - 1x Samsumg 850 EVO 500GB SSD
    - 2x Western Digital WD80EFAX 8TB ZRAID 1
    - 2x Western Digital WD141KFGX 14TB ZRAID 1
  
- Networking
  - Opnsense VM running on Dell host (secondary planned)
  - Cisco WS-C3560G-24PS-S
  - UniFi AP-AC Lite flashed with OpenWRT

## Network Information

### Network

| **Hostname**                      | **IP**           | **Description**                         |
| --------------------------------- | ---------------- | --------------------------------------- |
| opnsense.local.rtynerlabs.io      | 10.1.1.1         | opnsense VM                             |
| OpenWRT-1.local.rtynerlabs.io     | 10.1.1.70        | UniFi AP-AC Lite OpenWRT                |
| IDRAC-CZGNMV1.local.rtynerlabs.io | 10.1.1.222       | Dell iDRAC CZGNMV1                      |
| core-sw-1.local.rtynerlabs.io     | 10.1.1.254       | Cisco WS-C3560G-24PS-S                  |

### Physical Hosts

| **Hostname**                      | **IP**           | **Description**                         |
| --------------------------------- | ---------------- | --------------------------------------- |
| pve-1.local.rtynerlabs.io         | 10.1.1.2         | primary proxmox host                    |
| pve-2.local.rtynerlabs.io         | 10.1.1.3         | secondary proxmox host                  |
| pve-2.local.rtynerlabs.io         | 10.1.1.4         | tertiary proxmox host                   |
| truenas.local.rtynerlabs.io       | 10.1.1.6         | truenas host                            |

### Virtual Machines

| **Hostname**                                | **IP**           | **Host** | **Description**             |
| ------------------------------------------- | ---------------- | -------- | ----------------------------|
| traefik.local.rtynerlabs.io                 | 10.1.1.9         | pve-1    | traefik reverse proxy       |
| prod-docker-1.local.rtynerlabs.io           | 10.1.1.10        | pve-1    | docker host 1 - standalone  |
| prod-docker-2.local.rtynerlabs.io           | 10.1.1.11        | pve-1    | docker host 2 - standalone  |
| influx-1.local.rtynerlabs.io                | 10.1.1.205       | pve-1    | influxdb                    |
| prometheus-1.local.rtynerlabs.io            | 10.1.1.206       | pve-1    | prometheus                  |
| grafana-1.local.rtynerlabs.io               | 10.1.1.207       | pve-1    | grafana                     |
| rt-prod-docker-manager1.local.rtynerlabs.io | 10.1.1.208       | pve-1    | docker swarm manager 1      |
| rt-prod-docker-node1.local.rtynerlabs.io    | 10.1.1.209       | pve-1    | docker swarm node 1         |
| rt-prod-docker-node2.local.rtynerlabs.io    | 10.1.1.210       | pve-2    | docker swarm node 2         |
| rt-prod-docker-node3.local.rtynerlabs.io    | 10.1.1.211       | pve-1    | docker swarm node 3         |

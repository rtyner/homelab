# Hardware

- UniFi USG
- Cisco WS-C3560G-24PS POE Gigabit Switch
- Dell R720 SFF
  - Proxmox 8.X
  - 2x Xeon E5-2640
  - 192GB RAM
  - Perc H310 Mini IT Mode
  - 2x1TB Samsung 870 EVO
  - 5x4TB Seagate Ironwolf
- HP Proliant ML310e
  - TrueNAS
  - 32GB RAM
  - 2x14TB WD Red
  - 2x8TB WD Red
- Whitebox Server
  - Proxmox 8.X
  - 1x AMD Ryzen 7 5700X3D
  - 32GB RAM
  - 1x NVIDIA RTX 3060
  - 1x 2TB Samsung 970 EVO NVMe
  - 1x 1TB Samsung 850 EVO Sata
- Lenovo ThinkCentre M92p
  - Proxmox 8.X
  - 1x Intel i5-3470T
  - 16GB RAM
  - 1x 512GB Samsung 850 EVO NVMe

# Physical Hosts

| hostname                         | ip                | function                        |
| -------------------------------- | ----------------- | ------------------------------- |
| prod-usg-01.local.rtyner.com     | 10.1.1.1          | primary firewall                |
| prod-pve-01.local.rtyner.com     | 10.1.1.2,10.1.1.3 | proxmox hypervisor              |
| prod-pve-03.local.rtyner.com     | 10.1.1.5          | proxmox hypervisor              |
| prod-truenas-01.local.rtyner.com | 10.1.1.6          | truenas storage server smb, nfs |

# VMs

| hostname                 | ip        | host        | function                                            |
| ------------------------ | --------- | ----------- | --------------------------------------------------- |
| prod-backup-01           | 10.1.1.14 | prod-pve-03 | proxmox backup server                               |
| prod-pg-01               | 10.1.1.15 | prod-pve-01      | postgres server                                     |
| prod-docker-01           | 10.1.1.16 | prod-pve-01      | docker server 01                                    |
| prod-docker-02           | 10.1.1.17 | prod-pve-01      | docker server 02                                    |
| prod-pg-02               | 10.1.1.18 | prod-pve-01      | postgres server                                     |
| dev-ollama-01            | 10.1.1.19 | prod-pve-01      | ollama                                              |
| dev-arch-01              | 10.1.1.20 | prod-pve-01      | linux jump/dev box                                  |
| prod-file-01             | 10.1.1.21 | prod-pve-01      | nfs file server                                     |
| prod-monitor-01          | 10.1.1.22 | prod-pve-01      | monitoring server, prometheus, grafana, uptime kuma |
| prod-k3s-cls01-master-01 | 10.1.1.50 | prod-pve-01      | k3s master                                          |
| prod-k3s-cls01-master-02 | 10.1.1.51 | prod-pve-01      | k3s master                                          |
| prod-k3s-cls01-master-03 | 10.1.1.52 | prod-pve-03      | k3s master                                          |
| prod-k3s-cls01-worker-01 | 10.1.1.53 | prod-pve-01 | k3s worker                                          |
| prod-k3s-cls01-worker-02 | 10.1.1.54 | prod-pve-01 | k3s worker                                          |
| prod-k3s-cls01-worker-03 | 10.1.1.55 | prod-pve-01 | k3s worker                                          |
| prod-k3s-cls01-worker-04 | 10.1.1.56 | prod-pve-03 | k3s worker                                          |
| prod-k3s-cls01-worker-05 | 10.1.1.57 | prod-pve-03 | k3s worker                                          |
| prod-dns-01              | 10.1.1.98 | prod-pve-01      | primary dns                                         |
| prod-dns-02              | 10.1.1.99 | prod-pve-01      | secondary dns                                       |

# Containers

| container name      | hostname                   | host           | function               | ports          |
| ------------------- | -------------------------- | -------------- | ---------------------- | -------------- |
| plex                | plex.local.rtyner.com      | prod-docker-02 | primary plex server    |                |
|                     | unif-01.local.rtyner.com   | prod-docker-01 | unifi controller       |                |
| cloudflare-tunnel   | cloudflared                | prod-docker-01 | cloudflare tunnel      | 8081           |
| nginx-proxy-manager | npm-01.local.rtyner.com    | prod-docker-01 | nginx proxy manager    | 80,81,443      |
| dashy               | dash.local.rtyner.com      | prod-docker-01 | dashboard              | 4000           |
| portainer           | portainer.local.rtyner.com | prod-docker-01 | container management   | 8000,9000,9443 |
| prod-bind-01        | ns1.local.rtyner.com       | prod-docker-01 | bind9 primary server   | 53             |
| prod-bind-02        | ns2.local.rtyner.com       | prod-docker-02 | bind9 secondary server | 53             |


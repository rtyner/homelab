# Hardware

- UniFi USG
- Cisco WS-C3560G-24PS POE Gigabit Switch
- Dell R720 SFF
  - Proxmox 8.X
  - 2x Xeon E5-2640
  - 192GB RAM
  - Perc H310 Mini IT Mode
  - 2x1TB Sasmsung 870 EVO
  - 5x4TB Seagate Ironwold
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

# Physical Hosts
| hostname                         | ip                | function                        |
| -------------------------------- | ----------------- | ------------------------------- |
| prod-usg-01.local.rtyner.com     | 10.1.1.1          | primary firewall                |
| prod-pve-01.local.rtyner.com     | 10.1.1.2,10.1.1.3 | proxmox hypervisor              |
| prod-pve-02.local.rtyner.com     | 10.1.1.4          | proxmox hypervisor              |
| prod-arch-kvm-01                 | 10.1.1.5          | arch linux kvm hypervisor       |
| prod-truenas-01.local.rtyner.com | 10.1.1.6          | truenas storage server smb, nfs |

# VMs

| hostname                 | ip        | host   | function         |
| ------------------------ | --------- | ------ | ---------------- |
| prod-dns-01              | 10.1.1.10 | pve-01 | primary dns      |
| prod-dns-02              | 10.1.1.11 | pve-02 | secondary dns    |
| prod-pg-01               | 10.1.1.15 | pve-01 | postgres server  |
| prod-docker-01           | 10.1.1.16 | pve-01 | docker server 01 |
| prod-docker-02           | 10.1.1.17 | pve-01 | docker server 02 |
| prod-k3s-cls01-master-01 | 10.1.1.50 | pve-01 | k3s master       |
| prod-k3s-cls01-worker-01 | 10.1.1.51 | pve-01 | k3s worker       |
| prod-k3s-cls01-worker-02 | 10.1.1.52 | pve-01 | k3s worker       |
| prod-k3s-cls01-worker-03 | 10.1.1.53 | pve-01 | k3s worker       |

# Containers
| container name          | hostname                    | host           | function            | ports     |
| ----------------------- | --------------------------- | -------------- | ------------------- | --------- |
| plex                    | plex.local.rtyner.com       | prod-docker-02 | primary plex server |           |
|                         | unif-01.local.rtyner.com    | prod-docker-01 | unifi controller    |           |
| cloudflare-tunnel       | cloudflared                 | prod-docker-01 | cloudflare tunnel   | 8081      |
| linkwarden-linkwarden-1 | linkwarden.local.rtyner.com | prod-docker-01 | bookmarks manager   | 3000      |
| linkwarden-postgres-1   |                             | prod-docker-01 | linkwarden db       | 5432      |
| nginx-proxy-manager     | npm-01.local.rtyner.com     | prod-docker-01 | nginx proxy manager | 80,81,443 |
|                         |                             |                |                     |           |
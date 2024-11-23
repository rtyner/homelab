# Hardware

- UniFi USG
- Cisco WS-C3560G-24PS POE Gigabit Switch
- Dell R720
  - Proxmox 8.X
  - 2x Xeon E5-2640
  - 192GB RAM
  - Perc H310 Mini IT Mode
  - RAID1 SSD 1TBx2
  - RAID5 HDD 5TBx4
- HP Proliant ML310e
  - TrueNAS
  - 32GB RAM
  - 2x WD Red 14TB
  - 2x WD Red 8TB

# Hosts

| hostname       | ip                 | function           |
| -------------- | ------------------ | ------------------ |
| usg            | 10.1.1.1           | primary firewall   |
| prod-pve-01    | 10.1.1.2, 10.1.1.3 | proxmox hypervisor |
| prod-pg-01     | 10.1.1.15          | postgres server    |
| prod-docker-01 | 10.1.1.16          | docker server 01   |
| prod-docker-02 | 10.1.1.17          | docker server 02   |
| prod-pg-01     |                    |                    |

| prod-k3s-cls01-master-01 | 10.1.1.50          | k3s master         |
| prod-k3s-cls01-worker-01 | 10.1.1.51          | k3s worker         |
| prod-k3s-cls01-worker-02 | 10.1.1.52          | k3s worker         |
| prod-k3s-cls01-worker-03 | 10.1.1.53          | k3s worker         |

# Containers
| hostname                        | ip  | function            |
| ------------------------------- | --- | ------------------- |
| plex-docker-01.local.rtyner.com |     | primary plex server |
| unif-01.local.rtyner.com        |     | unifi controller    |

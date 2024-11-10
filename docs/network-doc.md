# Hardware

- UniFi USG
- Cisco WS-C3560G-24PS POE Gigabit Switch
- Dell R720
  - Arch Linux w/ KVM/QEMU
  - 2x Xeon E5-2640
  - 192GB RAM
  - Perc H310 Mini
  - RAID1 SSD 1TBx2
  - RAID5 HDD 5TBx4
- HP Proliant ML310e
  - TrueNAS
  - 32GB RAM
  - 2x WD Red 14TB
  - 2x WD Red 8TB

# Hosts

| hostname                        | ip                 | function                            |
| ------------------------------- | ------------------ | ----------------------------------- |
| usg.local.rtyner.com            | 10.1.1.1           | primary firewall                    |
| arch-hv-01.local.rtyner.com     | 10.1.1.2, 10.1.1.3 | kvm hypervisor                      |
| dev-dc-01.local.rtyner.com      | 10.1.1.4           | server 2022 domain controller       |
| dev-dc-02.local.rtyner.com      | 10.1.1.5           | server 2022 domain controller       |
| truenas.local.rtyner.com        | 10.1.1.6           | truenas storage                     |
| prod-docker-01.local.rtyner.com | 10.1.1.7           | docker host 1                       |
| prod-docker-02.local.rtyner.com | 10.1.1.8           | docker host 2                       |
| prod-docker-03.local.rtyner.com | 10.1.1.9           | docker host 3                       |
| prod-dns-01.local.rtyner.com    | 10.1.1.10          | prod dns server                     |
| prod-dns-02.local.rtyner.com    | 10.1.1.11          | prod dns server                     |
| prod-util-02.local.rtyner.com   | 10.1.1.12          | utility server, windows rsat, veeam |
| prod-syslog-01.local.rtyner.com | 10.1.1.13          | syslog                              |
| prod-file-01.local.rtyner.com   | 10.1.1.14          | nfs file server                     |
|                                 |                    |                                     |

# Containers
| hostname | ip  | function |
| -------- | --- | -------- |
|          |     |          |

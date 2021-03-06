# Network Information

## **Local**

### Network

| **Hostname**                      | **IP**           | **Description**                         |
| --------------------------------- | ---------------- | --------------------------------------- |
| opnsense-1.local.rtynerlabs.io    | 10.1.1.1         | opnsense VM                             |
| ap1.local.rtynerlabs.io           | 10.1.1.100       | UniFi AP-AC Lite                        |
| IDRAC-CZGNMV1.local.rtynerlabs.io | 10.1.1.222       | Dell iDRAC CZGNMV1                      |
| core-sw-1.local.rtynerlabs.io     | 10.1.1.254       | Cisco WS-C3560G-24PS-S                  |

#### Physical Hosts

| **Hostname**                      | **IP**           | **Description**                         |
| --------------------------------- | ---------------- | --------------------------------------- |
| pve-1.local.rtynerlabs.io         | 10.1.1.2         | primary proxmox host                    |
| pve-2.local.rtynerlabs.io         | 10.1.1.3         | secondary proxmox host                  |
| pve-2.local.rtynerlabs.io         | 10.1.1.4         | tertiary proxmox host                   |
| truenas.local.rtynerlabs.io       | 10.1.1.5         | truenas host                            |

### Virtual Machines

| **Hostname**                            | **IP**           | **Description**                      |
| --------------------------------------- | ---------------- | -------------------------------------|
| prod-docker-1.local.rtynerlabs.io       | 10.1.1.5         | docker host 1                        |
| prod-docker-2.local.rtynerlabs.io       | 10.1.1.6         | docker host 2                        |
| prod-docker-3.local.rtynerlabs.io       | 10.1.1.7         | docker host 3                        |
| prod-graf-01.local.rtynerlabs.io        | 10.1.1.8         | grafana node 1                       |
| prod-prom-01.local.rtynerlabs.io        | 10.1.1.9         | prometheus node 1                    |
| prod-syslog-01.local.rtynerlabs.io      | 10.1.1.10        | graylog syslog                       |
| prod-docker-mgr1.local.rtynerlabs.io    | 10.1.1.25        | docker swarm manager                 |
| prod-docker-node1.local.rtynerlabs.io   | 10.1.1.26        | docker swarm node 1                  |
| prod-docker-node2.local.rtynerlabs.io   | 10.1.1.27        | docker swarm node 1                  |

#### Containers

| **Hostname**                      | **Host**         | **Exposed Port**    | **Description**                       |
| --------------------------------- | ---------------- | ------------------- | --------------------------------------|
| unifi.local.rtynerlabs.io                | lxc       | 8443                | UniFi Controller                |
| portainer.local.rtynerlabs.io            | docker-1  | 9000                | Portainer container management  |
| heimdall.local.rtynerlabs.io             | docker-1  | 3001                | kuma status page                |
| start.local.rtynerlabs.io                | docker-1  | 80                  | heimdall start page             |
| dns-1.local.rtynerlabs.io                | lxc       | 8081                | primary pihole dns              |
| dns-2.local.rtynerlabs.io                | lxc       | 8081                | secondary pihole dns            |

#### Planned

| **Hostname**                      | **Host**         | **Exposed Port**    | **Description**                 |
| --------------------------------- | ---------------- | ------------------- | --------------------------------|
| bastion.local.rtynerlabs.io       | docker1          |                     | bastillion                      |
| proxy.local.rtynerlabs.io         | docker1          |                     | local reverse proxy             |
| ipam.local.rtynerlabs.io          | docker1          |                     | netbox ipam                     |

## Remote Hosts

| **rt-docker**                                                                                              | **rt-docs**                                                                                          |
|----------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| <ul><li>Vultr High Frequency</li><li>Debian 10</li><li>4GB RAM</li><li>2 vCPU</li><li>128GB NVME</li></ul> | <ul><li>Vultr Compute</li><li>Ubuntu 20.04</li><li>1GB RAM</li><li>1 vCPU</li><li>25GB SSD</li></ul> |

| **Hostname**                            | **IP**           | **Description**     |
| --------------------------------------- | ---------------- | ------------------- |
| rt-docker.rtyner.com.beta.tailscale.net | 100.76.177.121   | Vultr Docker host   |
| rt-docs.rtyner.com.beta.tailscale.net   | 100.94.41.32     | MkDocs server       |

### Remote Containers

| **Hostname**                           | **Host**         | **Exposed Port**    | **Description**                 |
| ---------------------------------------| ---------------- | ------------------- | --------------------------------|
| factorio.rtyner.com.beta.tailscale.net | rt-docker        | 34197               | Factorio server                 |
| proxy.rtyner.com.beta.tailscale.net    | rt-docker        | 81                  | NGINX reverse proxy             |

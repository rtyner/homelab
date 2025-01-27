# TODO

- change all cron jobs to enable logging
- dns query monitoring
- set timezone on all servers
- configure brocade switch
- research a new dns solution
- split authoritative and recursor powerdns servers
- local docker container registry
- apt cache
- configure vault
- reconfigure noco to run with ssl
- pgadmin
- fix proxmox backups
- deploy services to k3s
  - freshrss
  - vikunja
  - paperless-ngx
  - immich
  - loki
  - alertmanager
  - prometheus
  - grafana
  - pinchflat
  - nocodb
  - plex
  - excalidraw

## Done
- ~~setup new truenas server~~
- ~~gpu passthrough on Proxmox~~
- ~~reconfigure terraform to update dns~~
- ~~Configure Mellanox 10Gbe NICs~~
- ~~Deploy Hashicorp Vault~~
- ~~Deploy Gitlab~~
- ~~deploy MinIO~~
- ~~Automate SSL certificate application~~
- ~~deploy phpipam~~
- ~~terraform dns update~~
- ~~Complete Prometheus deployment to all ubuntu nodes~~

## Infra

- Move all container workloads to Kubernetes cluster
- Shared storage for Proxmox (ceph?)
- Host upgrades for 40Gbe networking

## Monitoring/Alerting

- Proxmox monitoring
- Truenas monitoring
- Cisco monitoring
- Create Grafana dashboards for:
  - CPU usage
  - RAM usage
  - Disk usage
  - Network latency
  - Disk IOPS
  - WAN uptime

## Services

- ArgoCD
- DroneCI
- Gotify
- Ansible Tower

## Networking

- Configure VLANs on switch and firewall

## Automation

- Automate updating configs
  - When new host is provisioned
    - Update Prometheus
    - add line in prometheus.yml with hostname and port
- Research Github actions or other local solution (GitlabCI, Jenkins, ArgoCD, Travis)
- Research Prometheus DNS service discovery
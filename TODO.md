# TODO

- local docker container registry
- apt cache
- configure vault
- deploy Alertmanager
- deploy Loki
- reconfigure noco to run with ssl



## Done
- ~~gpu passthrough on Proxmox~~
- ~~reconfigure terraform to update dns~~
- ~~Configure Mellanox 10Gbe NICs~~
- ~~Deploy Hashicorp Vault~~
- ~~Deploy Gitlab~~
- ~~deploy MinIO~~
- ~~Automate SSL certificate application~~
- ~~deploy phpipam~~
- ~~terraform dns update~~

## Infra

- Move all container workloads to Kubernetes cluster
- Shared storage for Proxmox (ceph?)
- Host upgrades for 40Gbe networking

## Monitoring/Alerting

~~Complete Prometheus deployment to all ubuntu nodes~~

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
# TODO

## Infra

- GPU passthrough on Proxmox
- Move all container workloads to Kubernetes cluster
- Shared storage for Proxmox (ceph?)

## Monitoring/Alerting

- Complete Prometheus deployment to all nodes
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
- Deploy Alertmanager
- Deploy Loki

## Services

- MinIO
- ArgoCD
- DroneCI
- Gitlab
- Hashicorp Vault
- Jenkins
- PHPIPAM
- Ansible Tower
## Networking

- Configure VLANs on switch and firewall

## Automation

- Automate updating configs
  - When new host is provisioned
    - Update BIND
    - Update Prometheus
- Research Github actions or other local solution (GitlabCI, Jenkins, ArgoCD, Travis)

## Development

## Hardware

- 3x hosts
  - 192GB RAM
  - 2x 16c CPU
  - 1TB OS SSD
  - 4TB Data SSD
  - 40Gbe networking

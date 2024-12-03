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

## Networking

- New router
- VLANs

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
  - 2x 2TB OS SSD
  - 5x 2TB data SSD
  - 40Gbe networking

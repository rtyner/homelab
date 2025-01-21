; File: /var/lib/coredns/zones/local.rtyner.com
$ORIGIN local.rtyner.com.
$TTL 604800
@       IN SOA  dns-prod-01.local.rtyner.com. dns.rtyner.com. (
                2025010502 ; serial
                43200      ; refresh (12h)
                900       ; retry (15m)
                1814400   ; expire (3w)
                7200      ; minimum (2h)
)
                IN NS   dns-prod-01.local.rtyner.com.
                IN NS   dns-prod-02.local.rtyner.com.

; Infrastructure
core-sw01               IN A    10.1.1.253
prod-fw-01              IN A    10.1.1.1
prod-pve-01             IN A    10.1.1.2
prod-pve-02             IN A    10.1.1.4
prod-pve-03             IN A    10.1.1.5
prod-pve-04             IN A    10.1.1.7
truenas                 IN A    10.1.1.6
pve01-idrac             IN A    10.1.1.222

; Services
prod-backup-01          IN A    10.1.1.14
prod-pg-01              IN A    10.1.1.15
prod-docker-01          IN A    10.1.1.16
prod-docker-02          IN A    10.1.1.17
prod-pg-02              IN A    10.1.1.18
dev-ollama-01           IN A    10.1.1.19
dev-arch-01             IN A    10.1.1.20
prod-file-01            IN A    10.1.1.21
prod-monitor-01         IN A    10.1.1.22
prod-pg-03              IN A    10.1.1.23
prod-nocodb-01          IN A    10.1.1.25
prod-caddy-01           IN A    10.1.1.26
prod-gitlab-01          IN A    10.1.1.27
prod-localstack-01      IN A    10.1.1.28
prod-gitea-01           IN A    10.1.1.29
prod-haproxy-01         IN A    10.1.1.30
prod-haproxy-02         IN A    10.1.1.31

; K3s Cluster
prod-k3s-cls01-master-01 IN A    10.1.1.50
prod-k3s-cls01-master-02 IN A    10.1.1.51
prod-k3s-cls01-master-03 IN A    10.1.1.52
prod-k3s-cls01-worker-01 IN A    10.1.1.53
prod-k3s-cls01-worker-02 IN A    10.1.1.54
prod-k3s-cls01-worker-03 IN A    10.1.1.55
prod-k3s-cls01-worker-04 IN A    10.1.1.56
prod-k3s-cls01-worker-05 IN A    10.1.1.57

; DNS Servers
dns-prod-01             IN A    10.1.1.96
dns-prod-02             IN A    10.1.1.97
prod-dns-01             IN A    10.1.1.98
prod-dns-02             IN A    10.1.1.99

; Service Records
ipam                    IN A    10.1.1.16
port                    IN A    10.1.1.16
minio                   IN A    10.1.1.17
rancher                 IN A    10.1.1.100
home                    IN A    10.1.1.100

; CNAME Records
backup                  IN CNAME    prod-backup-01
caddy                   IN CNAME    prod-caddy-01
grafana                 IN CNAME    prod-monitor-01
noco                    IN CNAME    prod-nocodb-01
ns1                     IN CNAME    dns-prod-01
ns2                     IN CNAME    dns-prod-02

; Wildcard Records
*.prod-docker-01        IN A    10.1.1.16
*.prod-docker-02        IN A    10.1.1.17
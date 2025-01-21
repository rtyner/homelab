$ORIGIN .
$TTL 604800     ; 1 week
local.rtyner.com        IN SOA  prod-bind-01.local.rtyner.com. dns\@rtyner.com.local.rtyner.com. (
                                2025010502 ; serial
                                43200      ; refresh (12 hours)
                                900        ; retry (15 minutes)
                                1814400    ; expire (3 weeks)
                                7200       ; minimum (2 hours)
                                )
                        NS      prod-bind-01.local.rtyner.com.
                        NS      prod-bind-02.local.rtyner.com.
$ORIGIN local.rtyner.com.
backup                  CNAME   prod-backup-01
caddy                   CNAME   prod-caddy-01
core-sw01               A       10.1.1.253
dev-arch-01             A       10.1.1.20
dev-ollama-01           A       10.1.1.19
$TTL 300        ; 5 minutes
docker-master-01        A       10.1.1.30
$TTL 604800     ; 1 week
grafana                 CNAME   prod-monitor-01
ipam                    A       10.1.1.16
$TTL 300        ; 5 minutes
k3s-dev-master-01       A       10.1.1.59
k3s-dev-worker-01       A       10.1.1.60
k3s-dev-worker-02       A       10.1.1.61
k3s-prod-master-01      A       10.1.1.50
k3s-prod-master-02      A       10.1.1.51
k3s-prod-master-03      A       10.1.1.52
k3s-prod-worker-01      A       10.1.1.53
k3s-prod-worker-02      A       10.1.1.54
k3s-prod-worker-03      A       10.1.1.55
k3s-prod-worker-04      A       10.1.1.56
k3s-prod-worker-05      A       10.1.1.57
k3s-prod-worker-06      A       10.1.1.58
$TTL 604800     ; 1 week
minio                   A       10.1.1.17
noco                    CNAME   prod-nocodb-01
ns1                     CNAME   prod-bind-01
ns2                     CNAME   prod-bind-02
port                    A       10.1.1.16
prod-backup-01          A       10.1.1.14
prod-bind-01            A       10.1.1.96
prod-bind-02            A       10.1.1.97
$TTL 300        ; 5 minutes
prod-caddy-01           A       10.1.1.26
$TTL 604800     ; 1 week
prod-dns-01             A       10.1.1.98
prod-dns-02             A       10.1.1.99
prod-docker-01          A       10.1.1.16
$ORIGIN prod-docker-01.local.rtyner.com.
*                       A       10.1.1.16
$ORIGIN local.rtyner.com.
prod-docker-02          A       10.1.1.17
$ORIGIN prod-docker-02.local.rtyner.com.
*                       A       10.1.1.17
$ORIGIN local.rtyner.com.
prod-file-01            A       10.1.1.21
prod-fw-01              A       10.1.1.1
$TTL 300        ; 5 minutes
prod-gitea-01           A       10.1.1.29
prod-gitlab-01          A       10.1.1.27
prod-haproxy-01         A       10.1.1.30
prod-haproxy-02         A       10.1.1.31
$TTL 604800     ; 1 week
prod-k3s-cls01-master-01 A      10.1.1.50
prod-k3s-cls01-master-02 A      10.1.1.51
prod-k3s-cls01-master-03 A      10.1.1.52
prod-k3s-cls01-worker-01 A      10.1.1.53
prod-k3s-cls01-worker-02 A      10.1.1.54
prod-k3s-cls01-worker-03 A      10.1.1.55
prod-k3s-cls01-worker-04 A      10.1.1.56
prod-k3s-cls01-worker-05 A      10.1.1.57
$TTL 300        ; 5 minutes
prod-localstack-01      A       10.1.1.28
$TTL 604800     ; 1 week
prod-monitor-01         A       10.1.1.22
prod-nocodb-01          A       10.1.1.25
prod-pg-01              A       10.1.1.15
prod-pg-02              A       10.1.1.18
prod-pg-03              A       10.1.1.23
prod-pve-01             A       10.1.1.2
prod-pve-02             A       10.1.1.4
prod-pve-03             A       10.1.1.5
prod-pve-04             A       10.1.1.7
pve01-idrac             A       10.1.1.222
rancher                 A       10.1.1.100
truenas                 A       10.1.1.6
home                    A       10.1.1.100
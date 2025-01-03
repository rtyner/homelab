;
; BIND data file for local loopback interface
;@      IN      NS      localhost.
;@      IN      A       127.0.0.1
;@      IN      AAAA    ::1

$TTL 604800
$ORIGIN local.rtyner.com.
@                                   IN      SOA     prod-bind-01.local.rtyner.com. dns@rtyner.com (
                                                    2024123122      ; serial
                                                    12h         ; refresh
                                                    15m         ; retry
                                                    3w          ; expire
                                                    2h          ; min ttl
)

                                    IN      NS      prod-bind-01.local.rtyner.com.
                                    IN      NS      prod-bind-02.local.rtyner.com.

prod-bind-01.local.rtyner.com.              IN      A       10.1.1.96
prod-bind-02.local.rtyner.com.              IN      A       10.1.1.97
prod-fw-01.local.rtyner.com.                IN      A       10.1.1.1
prod-pve-01.local.rtyner.com.               IN      A       10.1.1.2
prod-pve-02.local.rtyner.com.               IN      A       10.1.1.4
prod-pve-03.local.rtyner.com.               IN      A       10.1.1.5
prod-pve-04.local.rtyner.com.               IN      A       10.1.1.7
truenas.local.rtyner.com.                   IN      A       10.1.1.6
prod-backup-01.local.rtyner.com.            IN      A       10.1.1.14
prod-pg-01.local.rtyner.com.                IN      A       10.1.1.15
prod-docker-01.local.rtyner.com.            IN      A       10.1.1.16
prod-docker-02.local.rtyner.com.            IN      A       10.1.1.17
prod-pg-02.local.rtyner.com.                IN      A       10.1.1.18
dev-ollama-01.local.rtyner.com.             IN      A       10.1.1.19
dev-arch-01.local.rtyner.com.               IN      A       10.1.1.20
prod-file-01.local.rtyner.com.              IN      A       10.1.1.21
prod-monitor-01.local.rtyner.com.           IN      A       10.1.1.22
prod-pg-03.local.rtyner.com.                IN      A       10.1.1.23
prod-k3s-cls01-master-01.local.rtyner.com.  IN      A       10.1.1.50
prod-k3s-cls01-master-02.local.rtyner.com.  IN      A       10.1.1.51
prod-k3s-cls01-master-03.local.rtyner.com.  IN      A       10.1.1.52
prod-k3s-cls01-worker-01.local.rtyner.com.  IN      A       10.1.1.53
prod-k3s-cls01-worker-02.local.rtyner.com.  IN      A       10.1.1.54
prod-k3s-cls01-worker-03.local.rtyner.com.  IN      A       10.1.1.55
prod-k3s-cls01-worker-04.local.rtyner.com.  IN      A       10.1.1.56
prod-k3s-cls01-worker-05.local.rtyner.com.  IN      A       10.1.1.57
prod-bind-01.local.rtyner.com.              IN      A       10.1.1.96
prod-bind-02.local.rtyner.com.              IN      A       10.1.1.97
prod-dns-01.local.rtyner.com.               IN      A       10.1.1.98
prod-dns-02.local.rtyner.com.               IN      A       10.1.1.99
pve01-idrac.local.rtyner.com.               IN      A       10.1.1.222
core-sw01.local.rtyner.com.                 IN      A       10.1.1.253

*.prod-docker-01.local.rtyner.com.          IN      A       10.1.1.16
*.prod-docker-02.local.rtyner.com.          IN      A       10.1.1.17

backup.local.rtyner.com.                    IN      CNAME   prod-backup-01.local.rtyner.com.
grafana.local.rtyner.com.                   IN      CNAME   prod-monitor-01.local.rtyner.com.
ns1.local.rtyner.com.                       IN      CNAME   prod-bind-01.local.rtyner.com.
ns2.local.rtyner.com.                       IN      CNAME   prod-bind-02.local.rtyner.com.
prod-nocodb-01.local.rtyner.com.    IN    A    10.1.1.25
noco.local.rtyner.com.    IN    CNAME    prod-nocodb-01.local.rtyner.com.
rancher.local.rtyner.com.    IN    A    10.1.1.100
minio.local.rtyner.com.    IN    A    10.1.1.17
prod-caddy-01.local.rtyner.com.    IN    A    10.1.1.26
caddy.local.rtyner.com.    IN    CNAME    prod-caddy-01.local.rtyner.com.
ipam.local.rtyner.com.    IN    A    10.1.1.16
port.local.rtyner.com.    IN    A    10.1.1.16
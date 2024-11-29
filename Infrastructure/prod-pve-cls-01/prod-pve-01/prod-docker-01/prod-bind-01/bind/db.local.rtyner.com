$TTL 2d
$ORIGIN local.rtyner.com.
@                                   IN      SOA     prod-bind-01.local.rtyner.com. dns@rtyner.com (
                                                    2024112900  ; serial
                                                    12h         ; refresh
                                                    15m         ; retry
                                                    3w          ; expire
                                                    2h          ; min ttl
)           

                                    IN      NS      prod-bind-01.local.rtyner.com.

prod-bind-01                        IN      A       10.1.1.97
usg                                 IN      A       10.1.1.1
prod-pve-01                         IN      A       10.1.1.2
prod-pve-02                         IN      A       10.1.1.4
prod-pve-03                         IN      A       10.1.1.5
truenas                             IN      A       10.1.1.6
prod-backup-01                      IN      A       10.1.1.14
prod-pg-01                          IN      A       10.1.1.15
prod-docker-01                      IN      A       10.1.1.16
prod-docker-02                      IN      A       10.1.1.17
prod-pg-02                          IN      A       10.1.1.18
dev-ollama-01                       IN      A       10.1.1.19
dev-arch-01                         IN      A       10.1.1.20
prod-file-01                        IN      A       10.1.1.21
prod-prom-01                        IN      A       10.1.1.22
prod-prom-02                        IN      A       10.1.1.23
prod-unifi-01                       IN      A       10.1.1.24
prod-k3s-cls01-master-01            IN      A       10.1.1.50
prod-k3s-cls01-worker-01            IN      A       10.1.1.51
prod-k3s-cls01-worker-02            IN      A       10.1.1.52
prod-k3s-cls01-worker-03            IN      A       10.1.1.53
prod-k3s-cls01-master-02            IN      A       10.1.1.54
prod-dns-01                         IN      A       10.1.1.98
prod-dns-02                         IN      A       10.1.1.99
pve01-idrac                         IN      A       10.1.1.222
core-sw01                           IN      A       10.1.1.253

*.prod-docker-01                    IN      A       10.1.1.16
*.prod-docker-02                    IN      A       10.1.1.17
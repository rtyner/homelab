; File: /var/lib/coredns/external/rtyner.com
$ORIGIN rtyner.com.
$TTL 604800
@       IN SOA  dns-prod-01.local.rtyner.com. dns.rtyner.com. (
                2025010521 ; serial
                43200      ; refresh (12h)
                900       ; retry (15m)
                1814400   ; expire (3w)
                7200      ; minimum (2h)
)

; Root domain nameservers
@               IN NS   dns-prod-01.local.rtyner.com.
@               IN NS   dns-prod-02.local.rtyner.com.

; GLUE records for nameservers
dns-prod-01.local       IN A    10.1.1.96
dns-prod-02.local       IN A    10.1.1.97

; Service records
gitlab                  IN A    10.1.1.26
vault                   IN A    10.1.1.26
port                    IN A    10.1.1.26
pve1                    IN A    10.1.1.26
pve2                    IN A    10.1.1.26
pve3                    IN A    10.1.1.26
npm                     IN A    10.1.1.26
grafana                 IN A    10.1.1.26
prom                    IN A    10.1.1.26
s3                      IN A    10.1.1.26
nas                     IN A    10.1.1.26
noco                    IN A    10.1.1.26
paper                   IN A    10.1.1.26
todo                    IN A    10.1.1.26
photos                  IN A    10.1.1.26
ntfy                    IN A    10.1.1.26
uptime                  IN A    10.1.1.26
prometheus              IN A    10.1.1.26
rancher                 IN A    10.1.1.26
longhorn                IN A    10.1.1.26

; Local subdomain delegation
local                   IN NS   dns-prod-01.local.rtyner.com.
local                   IN NS   dns-prod-02.local.rtyner.com.
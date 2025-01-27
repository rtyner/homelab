$ORIGIN local.rtyner.com.
$TTL 604800     ; 1 week
@       IN SOA  dns-prod-01.local.rtyner.com. dns.rtyner.com. (
                                2025012102 ; serial
                                43200      ; refresh (12 hours)
                                900        ; retry (15 minutes)
                                1814400    ; expire (3 weeks)
                                7200       ; minimum (2 hours)
                                )

@       IN      NS      dns-prod-01.local.rtyner.com.
@       IN      NS      dns-prod-02.local.rtyner.com.

dns-prod-01     IN      A       10.10.1.10
dns-prod-02     IN      A       10.10.1.11
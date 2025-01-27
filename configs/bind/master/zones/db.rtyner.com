$TTL 86400
$ORIGIN rtyner.com.
@       IN SOA  dns-prod-01.local.rtyner.com. admin.rtyner.com. (
                  202501221 ; Serial
                  3600       ; Refresh
                  1800       ; Retry
                  604800     ; Expire
                  86400      ; Minimum TTL
              )

; Nameservers for rtyner.com (subdomain delegation)
@       IN NS   dns-prod-01.local.rtyner.com.
@       IN NS   dns-prod-02.local.rtyner.com.

; Glue records for the subdomain's nameservers
dns-prod-01.local IN A 10.10.1.10
dns-prod-02.local IN A 10.10.1.11
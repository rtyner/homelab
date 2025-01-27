-- SOA Records
INSERT INTO records (domain_id, name, type, content, ttl) 
VALUES 
    (1, 'local.rtyner.com', 'SOA', 'dns-prod-01.local.rtyner.com dns@rtyner.com 2025010502 43200 900 1814400 7200', 604800),
    (2, 'rtyner.com', 'SOA', 'dns-prod-01.local.rtyner.com dns@rtyner.com 2025010521 43200 900 1814400 7200', 604800);

-- NS Records for both domains
INSERT INTO records (domain_id, name, type, content, ttl)
VALUES 
    (1, 'local.rtyner.com', 'NS', 'dns-prod-01.local.rtyner.com', 604800),
    (1, 'local.rtyner.com', 'NS', 'dns-prod-02.local.rtyner.com', 604800),
    (2, 'rtyner.com', 'NS', 'dns-prod-01.local.rtyner.com', 604800),
    (2, 'rtyner.com', 'NS', 'dns-prod-02.local.rtyner.com', 604800);

-- Local domain records (domain_id = 1)
INSERT INTO records (domain_id, name, type, content, ttl)
VALUES
    -- Core Infrastructure
    (1, 'dns-prod-01.local.rtyner.com', 'A', '10.1.1.96', 604800),
    (1, 'dns-prod-02.local.rtyner.com', 'A', '10.1.1.97', 604800),
    (1, 'prod-pve-01.local.rtyner.com', 'A', '10.1.1.2', 604800),
    (1, 'prod-pve-02.local.rtyner.com', 'A', '10.1.1.4', 604800),
    (1, 'prod-pve-03.local.rtyner.com', 'A', '10.1.1.5', 604800),
    (1, 'prod-pve-04.local.rtyner.com', 'A', '10.1.1.7', 604800),
    (1, 'nas01.local.rtyner.com', 'A', '10.1.1.8', 604800),
    (1, 'nas02.local.rtyner.com', 'A', '10.1.1.6', 604800),
    (1, 'acc-sw01.local.rtyner.com', 'A', '10.1.1.253', 604800),
    (1, 'core-sw01.local.rtyner.com', 'A', '10.1.1.252', 604800),    
    (1, 'fw01.local.rtyner.com', 'A', '10.1.1.1', 604800),
    (1, 'pve01-idrac.local.rtyner.com', 'A', '10.1.1.222', 604800),
    (1, 'pve04-idrac.local.rtyner.com', 'A', '10.1.1.223', 604800),
    (1, 'nas01-idrac.local.rtyner.com', 'A', '10.1.1.224', 604800),        

    -- Development Servers
    (1, 'dev-arch-01.local.rtyner.com', 'A', '10.1.1.20', 604800),
    (1, 'dev-ollama-01.local.rtyner.com', 'A', '10.1.1.19', 300),

    -- Docker Hosts
    (1, 'prod-docker-01.local.rtyner.com', 'A', '10.1.1.16', 604800),
    (1, 'prod-docker-02.local.rtyner.com', 'A', '10.1.1.17', 604800),

    -- Kubernetes Cluster
    (1, 'k3s-prod-master-01.local.rtyner.com', 'A', '10.1.1.50', 604800),
    (1, 'k3s-prod-master-02.local.rtyner.com', 'A', '10.1.1.51', 604800),
    (1, 'k3s-prod-master-03.local.rtyner.com', 'A', '10.1.1.52', 604800),
    (1, 'k3s-prod-worker-01.local.rtyner.com', 'A', '10.1.1.53', 604800),
    (1, 'k3s-prod-worker-02.local.rtyner.com', 'A', '10.1.1.54', 604800),
    (1, 'k3s-prod-worker-03.local.rtyner.com', 'A', '10.1.1.55', 604800),
    (1, 'k3s-prod-worker-04.local.rtyner.com', 'A', '10.1.1.56', 604800),
    (1, 'k3s-prod-worker-05.local.rtyner.com', 'A', '10.1.1.57', 604800),
    (1, 'k3s-prod-worker-06.local.rtyner.com', 'A', '10.1.1.57', 604800),

    -- PostgreSQL Cluster
    (1, 'prod-pg-01.local.rtyner.com', 'A', '10.1.1.15', 604800),
    (1, 'prod-pg-02.local.rtyner.com', 'A', '10.1.1.18', 604800),
    (1, 'prod-pg-03.local.rtyner.com', 'A', '10.1.1.23', 604800),

    -- Service Records
    (1, 'prod-monitor-01.local.rtyner.com', 'A', '10.1.1.22', 604800),
    (1, 'prod-backup-01.local.rtyner.com', 'A', '10.1.1.14', 604800),
    (1, 'prod-file-01.local.rtyner.com', 'A', '10.1.1.21', 604800),
    (1, 'prod-gitlab-01.local.rtyner.com', 'A', '10.1.1.27', 300),
    (1, 'gitlab.local.rtyner.com', 'A', '10.1.1.27', 300),    
    (1, 'prod-nocodb-01.local.rtyner.com', 'A', '10.1.1.25', 604800),
    (1, 'prod-caddy-01.local.rtyner.com', 'A', '10.1.1.26', 300),
    (1, 'rancher.local.rtyner.com', 'A', '10.1.1.100', 604800),
    (1, 'home.local.rtyner.com', 'A', '10.1.1.100', 604800),

    -- CNAME Records
    (1, 'backup.local.rtyner.com', 'CNAME', 'prod-backup-01.local.rtyner.com', 604800),
    (1, 'caddy.local.rtyner.com', 'CNAME', 'prod-caddy-01.local.rtyner.com', 604800),
    (1, 'grafana.local.rtyner.com', 'CNAME', 'prod-monitor-01.local.rtyner.com', 604800),
    (1, 'noco.local.rtyner.com', 'CNAME', 'prod-nocodb-01.local.rtyner.com', 604800),
    (1, 'ns1.local.rtyner.com', 'CNAME', 'dns-prod-01.local.rtyner.com', 604800),
    (1, 'ns2.local.rtyner.com', 'CNAME', 'dns-prod-02.local.rtyner.com', 604800);

-- rtyner.com domain records (domain_id = 2)
INSERT INTO records (domain_id, name, type, content, ttl)
VALUES
    -- Service Records
    (2, 'gitlab.rtyner.com', 'A', '10.1.1.26', 604800),
    (2, 'vault.rtyner.com', 'A', '10.1.1.26', 604800),
    (2, 'port.rtyner.com', 'A', '10.1.1.26', 604800),
    (2, 'pve1.rtyner.com', 'A', '10.1.1.26', 604800),
    (2, 'pve2.rtyner.com', 'A', '10.1.1.26', 604800),
    (2, 'pve3.rtyner.com', 'A', '10.1.1.26', 604800),
    (2, 'npm.rtyner.com', 'A', '10.1.1.26', 604800),
    (2, 'grafana.rtyner.com', 'A', '10.1.1.26', 604800),
    (2, 'prom.rtyner.com', 'A', '10.1.1.26', 604800),
    (2, 's3.rtyner.com', 'A', '10.1.1.26', 604800),
    (2, 'nas.rtyner.com', 'A', '10.1.1.26', 604800),
    (2, 'noco.rtyner.com', 'A', '10.1.1.26', 604800),
    (2, 'paper.rtyner.com', 'A', '10.1.1.26', 604800),
    (2, 'todo.rtyner.com', 'A', '10.1.1.26', 604800),
    (2, 'photos.rtyner.com', 'A', '10.1.1.26', 604800),
    (2, 'ntfy.rtyner.com', 'A', '10.1.1.26', 604800),
    (2, 'uptime.rtyner.com', 'A', '10.1.1.26', 604800),
    (2, 'prometheus.rtyner.com', 'A', '10.1.1.26', 604800),
    (2, 'rancher.rtyner.com', 'A', '10.1.1.26', 604800),
    (2, 'longhorn.rtyner.com', 'A', '10.1.1.26', 604800),
    (2, 'gitlab.rtyner.com', 'A', '10.1.1.27', 604800);
# Proxmox Node Exporter

## create api user and permissions on the first host

```bash
pveum role add prometheus -privs "Sys.Audit"
pveum user add prometheus@pam --comment "Prometheus monitoring"
pveum user token add prometheus@pam prometheus --privsep=0
pveum aclmod / -user prometheus@pam -role prometheus
```

## install pve-node-exporter

```bash
python3 -m pip install prometheus-pve-exporter --break-system-packages
```

## create pve.yml

```bash
# /etc/prometheus/pve.yml
default:
  user: prometheus@pam
  token_name: "prometheus"
  token_value: 
  verify_ssl: false
```
## create env file

```bash
# /etc/default/pve_exporter
CONFIG_FILE=/etc/prometheus/pve.yml
LISTEN_ADDR=10.1.1.2
LISTEN_PORT=9221
```

## create user for service

```bash
useradd -s /bin/false pve-exporter
```

## create systemd service

```bash
# /etc/systemd/system/pve_exporter.service
[Unit]
Description=PVE Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=pve-exporter
Type=simple
EnvironmentFile=/etc/default/pve_exporter
ExecStart=/usr/local/bin/pve_exporter --config.file=/etc/prometheus/pve.yml --web.listen-address=10.1.1.2:9221

[Install]
WantedBy=multi-user.target
```

## systemd reload

```bash
systemctl daemon-reload
systemctl enable --now pve_exporter
systemctl status pve_exporter
```
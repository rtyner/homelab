# Troubleshooting Guide

## Common Issues and Solutions

### VM Issues

#### VM Won't Start

1. Check Proxmox Logs:
```bash
tail -f /var/log/pve/qemu-server/<vmid>.log
```

2. Verify Resources:
```bash
# Check storage
df -h

# Check memory
free -m

# Check CPU usage
top
```

3. Common Solutions:
- Clear lock files in /var/lock/qemu-server/
- Check VM configuration file
- Verify storage availability

#### VM Network Issues

1. Check Network Configuration:
```bash
# View VM network config
qm config <vmid> | grep net

# Check bridge status
brctl show vmbr0
```

2. Verify VLAN Configuration:
```bash
# Check switch port configuration
ssh admin@cisco-switch
show running-config interface GiX/X
```

### Container Issues

#### Docker Container Won't Start

1. Check Container Status:
```bash
docker ps -a
docker logs <container-name>
```

2. Verify Resources:
```bash
docker stats
df -h
```

3. Common Solutions:
- Remove and recreate container
- Check container dependencies
- Verify network connectivity

#### Container Network Issues

1. Check Network Configuration:
```bash
# List networks
docker network ls

# Inspect network
docker network inspect <network-name>
```

2. Verify DNS Resolution:
```bash
# From within container
docker exec <container> ping dns.local.rtyner.com
```

### Kubernetes Issues

#### Pod Won't Start

1. Check Pod Status:
```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

2. Verify Node Status:
```bash
kubectl get nodes
kubectl describe node <node-name>
```

3. Common Solutions:
- Check resource limits
- Verify image availability
- Check node capacity

#### Kubernetes Networking Issues

1. Test Pod Connectivity:
```bash
kubectl exec -it <pod-name> -- ping <target>
```

2. Check Service Resolution:
```bash
kubectl get svc
kubectl describe svc <service-name>
```

### Database Issues

#### PostgreSQL Problems

1. Check Database Logs:
```bash
tail -f /var/log/postgresql/postgresql-<version>-main.log
```

2. Verify Database Status:
```bash
systemctl status postgresql
pg_isready
```

3. Common Solutions:
- Check disk space
- Verify permissions
- Review connection limits

### Monitoring Issues

#### Prometheus Not Collecting Metrics

1. Check Target Status:
```bash
curl http://prometheus:9090/targets
```

2. Verify Node Exporter:
```bash
curl http://node:9100/metrics
```

3. Common Solutions:
- Check firewall rules
- Verify service discovery
- Review configuration

#### Grafana Dashboard Issues

1. Check Data Source:
```bash
# Test Prometheus connection
curl http://prometheus:9090/api/v1/query?query=up
```

2. Verify Dashboard Permissions:
```bash
# Check user permissions
grafana-cli admin reset-admin-password
```

### Network Issues

#### DNS Resolution Problems

1. Check DNS Server Status:
```bash
systemctl status bind9
```

2. Test Resolution:
```bash
dig @10.1.1.98 hostname.local.rtyner.com
nslookup hostname.local.rtyner.com 10.1.1.98
```

3. Common Solutions:
- Check zone files
- Verify DNS configuration
- Test zone transfers

#### Network Connectivity Issues

1. Check Physical Connection:
```bash
ethtool <interface>
mtr target-host
```

2. Verify Switch Configuration:
```bash
ssh admin@cisco-switch
show interface status
show mac address-table
```

## Advanced Troubleshooting

### Performance Issues

1. Check System Resources:
```bash
top
iostat -x 1
vmstat 1
```

2. Network Performance:
```bash
iperf3 -c target-host
tcpdump -i any port <port>
```

### Security Issues

1. Check Authentication Logs:
```bash
tail -f /var/log/auth.log
```

2. Review Firewall Rules:
```bash
iptables -L
ufw status verbose
```

### Backup Recovery

1. Verify Backup Integrity:
```bash
cd /var/lib/vz/dump/
vzdump-verify <backup-file>
```

2. Test Restore:
```bash
# Create test VM
qmrestore <backup-file> <new-vmid>
```

## Emergency Procedures

### Service Recovery Priority

1. Critical Services:
   - DNS
   - Core networking
   - Authentication

2. Important Services:
   - Databases
   - Container platforms
   - Monitoring

3. Non-Critical Services:
   - Media services
   - Development tools

### Emergency Contacts

1. Infrastructure:
   - Primary: [Your Contact]
   - Secondary: [Backup Contact]

2. Network:
   - Primary: [Network Contact]
   - Secondary: [Backup Contact]

### Recovery Time Objectives

| Service Type | RTO | RPO |
|--------------|-----|-----|
|
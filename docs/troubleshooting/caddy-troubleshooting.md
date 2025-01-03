# Caddy Reverse Proxy Troubleshooting Guide

## 1. Configuration Validation

Validates Caddyfile syntax and configuration before applying changes.

```bash
caddy validate
```

## 2. Service Status Checks

Verifies service status and monitors logs for errors or issues.

```bash
# Check if Caddy service is running
systemctl status caddy

# View real-time Caddy logs
journalctl -u caddy -f
```

## 3. Network Port Verification

Confirms Caddy is listening on correct ports (typically 80, 443, and 2019 for admin).

```bash
# Check which ports Caddy is listening on
sudo ss -tlnp | grep caddy
```

## 4. Firewall Configuration

Verifies firewall rules aren't blocking required ports.

```bash
# Check UFW status
sudo ufw status

# View iptables rules
sudo iptables -L
```

## 5. Local Connection Testing

Tests local SSL/TLS configuration and certificate handling.

```bash
# Test local connection
curl -v https://localhost

# Test with specific domain resolution
curl -v --resolve yourdomain.com:443:127.0.0.1 https://yourdomain.com
```

## 6. DNS Resolution

Verifies DNS records point to correct IP address.

```bash
# Check domain resolution
dig yourdomain.com

# Quick IP resolution check
dig +short yourdomain.com

# Detailed DNS query
nslookup yourdomain.com
```

## 7. SSL Certificate Verification

Checks SSL certificate validity and configuration.

```bash
# Test SSL connection and certificate
curl -vI https://yourdomain.com
```

## Common Issues and Solutions

### 1. Connection Refused
- Verify Caddy is running
- Check correct IP binding in Caddyfile
- Confirm firewall rules

### 2. DNS Resolution
- Ensure A record points to Caddy proxy server
- Allow DNS propagation time
- Verify local DNS resolution

### 3. SSL Certificate Issues
- Check Caddyfile TLS configuration
- Verify domain ownership
- Confirm proper DNS provider settings

### 4. Proxy Connection Issues
- Verify backend service is running
- Check backend service IP and port
- Confirm network connectivity between proxy and backend

## File Locations

- Caddyfile: `~/caddy/Caddyfile`
- Certificates: `/var/lib/caddy/.local/share/caddy/certificates/`
- Logs: `journalctl -u caddy`

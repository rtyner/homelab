# Infrastructure/prod-pve-cls-01/scripts/dns-management/cloudflare_dns_setup.py

import os
import requests
from typing import Dict, List

class CloudflareAPI:
    def __init__(self, token: str):
        self.token = token
        self.base_url = "https://api.cloudflare.com/client/v4"
        self.headers = {
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json"
        }

    def get_zone_id(self, domain: str) -> str:
        """Get Zone ID for a domain"""
        response = requests.get(
            f"{self.base_url}/zones",
            headers=self.headers,
            params={"name": domain}
        )
        response.raise_for_status()
        return response.json()["result"][0]["id"]

    def create_dns_record(self, zone_id: str, record: Dict) -> None:
        """Create a DNS record"""
        response = requests.post(
            f"{self.base_url}/zones/{zone_id}/dns_records",
            headers=self.headers,
            json=record
        )
        if response.status_code == 200:
            print(f"Successfully created record for {record['name']}")
        else:
            print(f"Failed to create record for {record['name']}: {response.text}")

def main():
    # Get Cloudflare API token from environment
    cf_token = os.getenv("CF_API_TOKEN")
    if not cf_token:
        raise ValueError("Please set CF_API_TOKEN environment variable")

    cf = CloudflareAPI(cf_token)
    zone_id = cf.get_zone_id("rtyner.com")

    # Base DNS record for local.rtyner.com
    cf.create_dns_record(zone_id, {
        "type": "A",
        "name": "local",
        "content": "10.1.1.16",  # Caddy server IP
        "proxied": False
    })

    # Services from your infrastructure
    services = [
        # Proxmox hosts
        {"name": "prod-pve-01.local", "content": "10.1.1.2"},
        {"name": "prod-pve-02.local", "content": "10.1.1.4"},
        {"name": "prod-pve-03.local", "content": "10.1.1.5"},
        
        # Infrastructure services
        {"name": "truenas.local", "content": "10.1.1.6"},
        {"name": "backup.local", "content": "10.1.1.14"},
        {"name": "ipam.local", "content": "10.1.1.16"},
        
        # Monitoring stack
        {"name": "grafana.local", "content": "10.1.1.22"},
        {"name": "prom.local", "content": "10.1.1.22"},
        
        # Docker services
        {"name": "dash.local", "content": "10.1.1.16"},
        {"name": "noco.local", "content": "10.1.1.25"},
        {"name": "port.local", "content": "10.1.1.16"},
        {"name": "fw.local", "content": "10.1.1.1"}
    ]

    # Create CNAME records for all services
    for service in services:
        cf.create_dns_record(zone_id, {
            "type": "A",
            "name": service["name"],
            "content": service["content"],
            "proxied": False
        })

if __name__ == "__main__":
    main()
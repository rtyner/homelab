terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc6"
    }
    dns = {
      source  = "hashicorp/dns"
      version = "~> 3.0"
    }
  }
}

provider "proxmox" {
  pm_api_url          = "https://10.30.1.2:8006/api2/json"
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure     = true
}

provider "dns" {
  update {
    server        = "10.1.1.96"
    key_name      = "tsig-key.local.rtyner.com."
    key_algorithm = "hmac-sha256"
    key_secret    = var.dns_key
  }
}
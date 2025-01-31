terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.49.1"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

provider "dns" {
  update {
    server        = "10.10.1.10"
    key_name      = "tsig-key.local.rtyner.com."
    key_algorithm = "hmac-sha256"
    key_secret    = var.dns_key
  }
}
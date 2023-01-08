terraform {
    required_version = ">=0.13.0"
    required_providers {
      proxmox = {
        source = "telmate/proxmox"
        version = "2.9.11"
      }
    }
}

provider "proxmox" {
  # url is the hostname (FQDN if you have one) for the proxmox host you'd like to connect to to issue the commands. my proxmox host is 'prox-1u'. Add /api2/json at the end for the API
  pm_api_url = var.api_url

  # api token id is in the form of: <username>@pam!<tokenId>
  pm_api_token_id = var.token_id

  # this is the full secret wrapped in quotes. don't worry, I've already deleted this from my proxmox cluster by the time you read this post
  pm_api_token_secret = var.token_secret

  # leave tls_insecure set to true unless you have your proxmox SSL certificate situation fully sorted out (if you do, you will know)
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "nextcloud" {
    name = "nextcloud"
    desc = "nextcloud"
    count = 1
    target_node = var.proxmox_host
    
    agent = 1

    clone = var.template_name
    cores = 4
    sockets = 2
    cpu = "host"
    memory = 16384

    network {
      bridge = "vmbr0"
      model = "virtio"
    }

    disk {
      storage = "local"
      type = "scsi"
      size = "196G"
      ssd = 1
      discard = "on"
    }
    
    sshkeys = <<EOF
    ${var.ssh_key}
    EOF

    os_type = "cloud-init"
    ipconfig0 = "ip=10.1.1.1${count.index + 1}/24,gw=10.1.1.1"
    nameserver = "10.1.1.53, 10.1.1.54"
}
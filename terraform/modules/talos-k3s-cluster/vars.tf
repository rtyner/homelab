variable "ciuser" {
  description = "Cloud-init user"
  type        = string
  sensitive   = true
}

variable "cipassword" {
  description = "Cloud-init password for the VM user"
  type        = string
  sensitive   = true
}

variable "pm_api_token_id" {
  type        = string
  sensitive   = true
  description = "Proxmox API token ID"
}

variable "pm_api_token_secret" {
  type        = string
  sensitive   = true
  description = "Proxmox API token secret"
}

variable "dns_key" {
  type        = string
  sensitive   = true
  description = "TSIG key secret for DNS updates"
}

variable "vms" {
  type = map(object({
    name          = string
    ip_address    = string
    cores         = number
    sockets       = number
    vmid          = number # set to 0 to use next available
    memory        = number #mb
    disk_space    = number #gb 
    nameserver    = string
    onboot        = bool
    agent         = number # 1 for enabled, 0 for disabled
    target_node   = string
    tags          = string
    searchdomain  = string
  }))

  default = {
    k3s-prod-talos-master-01 = {
      name          = "k3s-prod-talos-master-01"
      ip_address    = "10.1.1.62"
      cores         = 4
      sockets       = 1
      memory        = 8192
      disk_space    = 50
      vmid          = 412
      onboot        = true
      agent         = 1
      tags          = "k3s"
      target_node   = "prod-pve-01"       
      nameserver    = "10.1.1.96 10.1.1.97"
      searchdomain  = "local.rtyner.com"
    }         

    k3s-prod-worker-01 = {
      name          = "k3s-prod-talos-worker-01"
      ip_address    = "10.1.1.63"
      cores         = 8
      sockets       = 1
      memory        = 16384
      disk_space    = 125
      vmid          = 413
      onboot        = true
      agent         = 1
      tags          = "k3s"
      target_node   = "prod-pve-01"       
      nameserver    = "10.1.1.96 10.1.1.97"
      searchdomain  = "local.rtyner.com"
    }        
  }
}


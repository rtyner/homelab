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
    caddy = {
      name          = "caddy-prod-01"
      ip_address    = "10.10.1.24"
      cores         = 2
      sockets       = 1
      memory        = 2048
      disk_space    = 16
      vmid          = 0
      onboot        = true
      agent         = 1
      tags          = "critical"
      target_node   = "pve02"       
      nameserver    = "10.10.1.10 10.10.1.11"
      searchdomain  = "local.rtyner.com"
    }    
  }
}


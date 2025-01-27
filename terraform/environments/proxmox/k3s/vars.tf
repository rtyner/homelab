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
    k3s-master-01 = {
      name          = "k3s-prod-master-01"
      ip_address    = "10.10.1.30"
      cores         = 4
      sockets       = 1
      memory        = 4096
      disk_space    = 50
      vmid          = 200
      onboot        = true
      agent         = 1
      tags          = "critical,k3s"
      target_node   = "pve01"       
      nameserver    = "10.10.1.10 10.10.1.11"
      searchdomain  = "local.rtyner.com"
    }
    k3s-master-02 = {
      name          = "k3s-prod-master-02"
      ip_address    = "10.10.1.31"
      cores         = 4
      sockets       = 1
      memory        = 4096
      disk_space    = 50
      vmid          = 201
      onboot        = true
      agent         = 1
      tags          = "k3s"
      target_node   = "pve01"       
      nameserver    = "10.10.1.10 10.10.1.11"
      searchdomain  = "local.rtyner.com"
    }  
    k3s-master-03 = {
      name          = "k3s-prod-master-03"
      ip_address    = "10.10.1.32"
      cores         = 4
      sockets       = 1
      memory        = 4096
      disk_space    = 50
      vmid          = 202
      onboot        = true
      agent         = 1
      tags          = "k3s"
      target_node   = "pve02"       
      nameserver    = "10.10.1.10 10.10.1.11"
      searchdomain  = "local.rtyner.com"
    }
    k3s-worker-01 = {
      name          = "k3s-prod-worker-01"
      ip_address    = "10.10.1.33"
      cores         = 8
      sockets       = 1
      memory        = 8192
      disk_space    = 100
      vmid          = 203
      onboot        = true
      agent         = 1
      tags          = "critical,k3s"
      target_node   = "pve01"       
      nameserver    = "10.10.1.10 10.10.1.11"
      searchdomain  = "local.rtyner.com"
    }
    k3s-worker-02 = {
      name          = "k3s-prod-worker-02"
      ip_address    = "10.10.1.34"
      cores         = 8
      sockets       = 1
      memory        = 8192
      disk_space    = 100
      vmid          = 204
      onboot        = true
      agent         = 1
      tags          = "critical,k3s"
      target_node   = "pve01"       
      nameserver    = "10.10.1.10 10.10.1.11"
      searchdomain  = "local.rtyner.com"
    }  
    k3s-worker-03 = {
      name          = "k3s-prod-worker-03"
      ip_address    = "10.10.1.35"
      cores         = 8
      sockets       = 1
      memory        = 8192
      disk_space    = 100
      vmid          = 205
      onboot        = true
      agent         = 1
      tags          = "k3s"
      target_node   = "pve01"       
      nameserver    = "10.10.1.10 10.10.1.11"
      searchdomain  = "local.rtyner.com"
    }  
    k3s-worker-04 = {
      name          = "k3s-prod-worker-04"
      ip_address    = "10.10.1.36"
      cores         = 8
      sockets       = 1
      memory        = 8192
      disk_space    = 100
      vmid          = 206
      onboot        = true
      agent         = 1
      tags          = "critical,k3s"
      target_node   = "pve02"       
      nameserver    = "10.10.1.10 10.10.1.11"
      searchdomain  = "local.rtyner.com"
    }  
    k3s-worker-05 = {
      name          = "k3s-prod-worker-05"
      ip_address    = "10.10.1.37"
      cores         = 8
      sockets       = 1
      memory        = 8192
      disk_space    = 100
      vmid          = 207
      onboot        = true
      agent         = 1
      tags          = "k3s"
      target_node   = "pve02"       
      nameserver    = "10.10.1.10 10.10.1.11"
      searchdomain  = "local.rtyner.com"
    }
    k3s-worker-06 = {
      name          = "k3s-prod-worker-06"
      ip_address    = "10.10.1.38"
      cores         = 8
      sockets       = 1
      memory        = 8192
      disk_space    = 100
      vmid          = 208
      onboot        = true
      agent         = 1
      tags          = "k3s"
      target_node   = "pve02"       
      nameserver    = "10.10.1.10 10.10.1.11"
      searchdomain  = "local.rtyner.com"
    }                                                
  }
}


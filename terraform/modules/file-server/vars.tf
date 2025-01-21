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
  type = string
  sensitive = true
  description = "Proxmox API token ID"
}

variable "pm_api_token_secret" {
  type = string
  sensitive = true
  description = "Proxmox API token secret"
}

variable "vms" {
    type = map(object({
      name       = string
      ip_address = string
      cores      = number 
      sockets    = number
      vmid       = number
      memory     = number #mb
      disk_space = number #gb 
      start_on_boot = bool
      qemu_guest_agent = bool
      target_node = string
    }))
  
  default = {
    prod-file-01 = {
        name = "prod-file-01"
        ip_address = "10.1.1.21"
        cores = 2
        sockets = 1
        memory = 4096
        disk_space = 24
        vmid = 100
        start_on_boot = true
        qemu_guest_agent = true
        target_node = "prod-pve-01"
    }       
  }
}
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
    }))
  
  default = {    
    k3s-worker-03 = {
        name = "prod-k3s-cls01-worker-03"
        ip_address = "10.1.1.55"
        cores = 4
        sockets = 1
        memory = 4096
        disk_space = 32
        vmid = 405
        start_on_boot = true
        qemu_guest_agent = true
    }                      
  }
}
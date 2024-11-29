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
      name          = string
      ip_address    = string
      cores         = number 
      sockets       = number
      vmid          = number
      memory        = number #mb
      disk_space    = number #gb 
      start_at_boot = bool
    }))
  
  default = {
    dev-ollama-01 = {
        name          = "dev-ollama-01"
        ip_address    = "10.1.1.19"
        cores         = 8
        sockets       = 1
        memory        = 16384
        disk_space    = 64
        vmid          = 110
        start_at_boot = true
    }  
  }
}
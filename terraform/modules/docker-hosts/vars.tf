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
    }))
  
  default = {
    prod-docker-01 = {
        name = "prod-docker-01"
        ip_address = "10.1.1.16"
        cores = 4
        sockets = 1
        memory = 8192
        disk_space = 24
        vmid = 105
    }
    
    prod-docker-02 = {
        name = "prod-docker-02"
        ip_address = "10.1.1.17"
        cores = 4
        sockets = 1
        memory = 8192
        disk_space = 24
        vmid = 106
    }    
  }
}
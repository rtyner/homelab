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
}
  default = {
    prod-bind-01 = {
      name          = "prod-bind-01"
      ip_address    = "10.1.1.96"
      cores         = 2
      sockets       = 1
      memory        = 2048
      disk_space    = 24
      vmid          = 115
      start_at_boot = true
    }
    prod-bind-02 = {
      name          = "prod-bind-02"
      ip_address    = "10.1.1.97"
      cores         = 2
      sockets       = 1
      memory        = 2048
      disk_space    = 24
      vmid          = 116
      start_at_boot = true    
  }
}


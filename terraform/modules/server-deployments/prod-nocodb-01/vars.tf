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
    nameserver    = string  # Add this line for DNS servers
  }))

  default = {
    prod-nocodb-01 = {
      name          = "prod-nocodb-01"
      ip_address    = "10.1.1.25"
      cores         = 2
      sockets       = 1
      memory        = 4096
      disk_space    = 128
      vmid          = 114
      start_at_boot = true
      nameserver    = "10.1.1.96 10.1.1.97"  # Add this line with your preferred DNS servers
    }
  }
}


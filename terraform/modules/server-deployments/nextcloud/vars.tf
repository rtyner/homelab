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
    vmid          = number
    memory        = number #mb
    disk_space    = number #gb 
    nameserver    = string
    start_at_boot = bool
    qemu_guest_agent = bool
    target_node = string
  }))

  default = {
    prod-nextcloud-01 = {
      name          = "prod-nextcloud-01"
      ip_address    = "10.1.1.28"
      cores         = 4
      sockets       = 1
      memory        = 2048
      disk_space    = 32
      vmid          = 102
      start_at_boot = true
      qemu_guest_agent = true      
      target_node = "prod-pve-04"        
      nameserver    = "10.1.1.96 10.1.1.97"  # Add this line with your preferred DNS servers
    }
  }
}

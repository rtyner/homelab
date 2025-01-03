# variables/common.tf
variable "proxmox_hosts" {
  type = map(object({
    address = string
    zone    = string
    pool    = string
  }))
  
  default = {
    "pve-01" = {
      address = "10.1.1.2"
      zone    = "primary"
      pool    = "production"
    }
    # ... other hosts
  }
}
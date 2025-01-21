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

    "pve-02" = {
      address = "10.1.1.4"
      zone    = "primary"
      pool    = "production"
    }

    "pve-03" = {
      address = "10.1.1.5"
      zone    = "primary"
      pool    = "production"
    }

    "pve-04" = {
      address = "10.1.1.7"
      zone    = "primary"
      pool    = "production"
    }
  }
}
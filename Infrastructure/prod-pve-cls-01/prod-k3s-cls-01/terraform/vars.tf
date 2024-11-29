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
    k3s-master-01 = {
        name = "prod-k3s-cls01-master-01"
        ip_address = "10.1.1.50"
        cores = 8
        sockets = 1
        memory = 8192
        disk_space = 48
        vmid = 400
        start_on_boot = true
        qemu_guest_agent = true
    }

    k3s-master-02 = {
        name = "prod-k3s-cls01-master-02"
        ip_address = "10.1.1.51"
        cores = 8
        sockets = 1
        memory = 8192
        disk_space = 48
        vmid = 401
        start_on_boot = true
        qemu_guest_agent = true
    }

    k3s-master-03 = {
        name = "prod-k3s-cls01-master-03"
        ip_address = "10.1.1.52"
        cores = 8
        sockets = 1
        memory = 8192
        disk_space = 48
        vmid = 402
        start_on_boot = true
        qemu_guest_agent = true
    }        
    
    k3s-worker-01 = {
        name = "prod-k3s-cls01-worker-01"
        ip_address = "10.1.1.53"
        cores = 4
        sockets = 1
        memory = 4096
        disk_space = 32
        vmid = 403
        start_on_boot = true
        qemu_guest_agent = true
    }    
    
    k3s-worker-02 = {
        name = "prod-k3s-cls01-worker-02"
        ip_address = "10.1.1.54"
        cores = 4
        sockets = 1
        memory = 4096
        disk_space = 32
        vmid = 404
        start_on_boot = true
        qemu_guest_agent = true
    }    
    
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
    k3s-worker-04 = {
        name = "prod-k3s-cls01-worker-04"
        ip_address = "10.1.1.56"
        cores = 4
        sockets = 1
        memory = 4096
        disk_space = 32
        vmid = 406
        start_on_boot = true
        qemu_guest_agent = true
    } 
    k3s-worker-05 = {
        name = "prod-k3s-cls01-worker-05"
        ip_address = "10.1.1.57"
        cores = 4
        sockets = 1
        memory = 4096
        disk_space = 32
        vmid = 407
        start_on_boot = true
        qemu_guest_agent = true
    }         
  }
}
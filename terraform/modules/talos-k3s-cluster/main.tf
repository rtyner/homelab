resource "proxmox_vm_qemu" "master-deployment" {
    clone = "talos-cloud"
    os_type = "cloudinit"
    scsihw = "virtio-scsi-pci"
    bootdisk = "scsi0"

    for_each     = var.vms
    vmid         = each.value.vmid
    name         = each.value.name
    cores        = each.value.cores
    sockets      = each.value.sockets
    memory       = each.value.memory
    target_node  = each.value.target_node
    onboot       = each.value.onboot
    tags         = each.value.tags
    searchdomain = each.value.searchdomain

    disks {
        scsi {
            scsi0 {
                disk {
                    storage = "local-zfs"
                    size = each.value.disk_space
                }
            }
        }
        ide {
            ide2 {
                cloudinit {
                    storage = "local-zfs"
                }
            }
        }
    }

    # Network configuration
    network {
        id     = 0
        model  = "virtio"
        bridge = "vmbr0"
    }
    network {
        id         = 1
        model      = "virtio"
        bridge     = "vmbr1" # 10Gbe NIC
        mtu        = 9000
        queues     = 4
    }    

# setting std for vga to allow console access, spice isn't working
    serial {
      id = 0
      type = "socket"
    }
    vga {
      type = "std"
    }

    # Cloud-Init Settings
    ipconfig0 = "ip=${each.value.ip_address}/24,gw=10.1.1.1"
    nameserver = each.value.nameserver
    ciuser = var.ciuser
    cipassword = var.cipassword
    sshkeys = file("~/.ssh/id_ed25519.pub")
    agent = 1

    provisioner "remote-exec" {
        inline = [
            "echo 'SSH ready!'"
        ]

        connection {
            host        = each.value.ip_address
            type        = "ssh"
            user        = var.ciuser
            private_key = file("~/.ssh/id_ed25519")
            timeout     = "2m"
        }
    }             
}

# DNS Records for VMs
resource "dns_a_record_set" "vm_records" {
    for_each = {
        for k, v in var.vms : k => v
        if lookup(v, "dns_record", true) # Default to true if not specified
    }
    
    zone      = "local.rtyner.com."
    name      = each.value.name
    addresses = [each.value.ip_address]
    ttl       = 300

    depends_on = [proxmox_vm_qemu.master-deployment]
}    
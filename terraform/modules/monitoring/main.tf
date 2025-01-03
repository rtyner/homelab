resource "proxmox_vm_qemu" "master-deployment" {
    target_node = "prod-pve-02"
    clone = "ubuntu-cloud"
    os_type = "cloudinit"
    scsihw = "virtio-scsi-pci"
    bootdisk = "scsi0"

    for_each = var.vms
    vmid = each.value.vmid
    name = each.value.name
    cores = each.value.cores
    sockets = each.value.sockets
    memory = each.value.memory

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

    ipconfig0 = "ip=${each.value.ip_address}/24,gw=10.1.1.1"
    ciuser = var.ciuser
    sshkeys = file("~/.ssh/id_ed25519.pub")
    
    provisioner "remote-exec" {
      inline = ["echo 'SSH ready!'"]

      connection {
        host = each.value.ip_address
        type = "ssh"
        user = "rt"
        private_key = file("~/.ssh/id_ed25519")
  }
}
    provisioner "local-exec" {
        command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${each.value.ip_address}, ../ansible/playbooks/docker-os-setup.yml"
    }        
}
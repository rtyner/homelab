# main.tf

# Download Debian cloud image
resource "libvirt_volume" "debian_base" {
  name   = "debian12_base"
  pool   = "images"
  source = var.debian_image_url
  format = "qcow2"
}

# Create VM volume based on Debian image
resource "libvirt_volume" "vm_disk" {
  name           = "${var.vm_name}.qcow2"
  base_volume_id = libvirt_volume.debian_base.id
  pool           = "images"
  size           = var.disk_size
}

# Create cloud-init files and ISO on remote host
resource "null_resource" "cloud_init_iso" {
  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = var.remote_user
      host = var.remote_host
    }

    inline = [
      "sudo rm -rf /tmp/cloud-init-${var.vm_name}",
      "mkdir -p /tmp/cloud-init-${var.vm_name}",
      "echo '#cloud-config' > /tmp/cloud-init-${var.vm_name}/user-data",
      "echo 'hostname: ${var.vm_name}' >> /tmp/cloud-init-${var.vm_name}/user-data",
      "echo 'fqdn: ${var.vm_name}.${var.domain}' >> /tmp/cloud-init-${var.vm_name}/user-data",
      "echo 'users:' >> /tmp/cloud-init-${var.vm_name}/user-data",
      "echo '  - name: rt' >> /tmp/cloud-init-${var.vm_name}/user-data",
      "echo '    sudo: ALL=(ALL) NOPASSWD:ALL' >> /tmp/cloud-init-${var.vm_name}/user-data",
      "echo '    groups: users, admin' >> /tmp/cloud-init-${var.vm_name}/user-data",
      "echo '    home: /home/debian' >> /tmp/cloud-init-${var.vm_name}/user-data",
      "echo '    shell: /bin/bash' >> /tmp/cloud-init-${var.vm_name}/user-data",
      "echo '    ssh_authorized_keys:' >> /tmp/cloud-init-${var.vm_name}/user-data",
      "echo '      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIITrPYcULQ4WTZs65pFDiSFS1hdsjVRo4DK+02pnRlYc' >> /tmp/cloud-init-${var.vm_name}/user-data",
      "echo 'package_update: true' >> /tmp/cloud-init-${var.vm_name}/user-data",
      "echo 'package_upgrade: true' >> /tmp/cloud-init-${var.vm_name}/user-data",
      "echo 'packages:' >> /tmp/cloud-init-${var.vm_name}/user-data",
      "echo '  - qemu-guest-agent' >> /tmp/cloud-init-${var.vm_name}/user-data",
      "echo '  - vim' >> /tmp/cloud-init-${var.vm_name}/user-data",
      "echo '  - curl' >> /tmp/cloud-init-${var.vm_name}/user-data",
      "echo '  - wget' >> /tmp/cloud-init-${var.vm_name}/user-data",
      "echo '  - net-tools' >> /tmp/cloud-init-${var.vm_name}/user-data",
      "echo 'runcmd:' >> /tmp/cloud-init-${var.vm_name}/user-data",
      "echo '  - systemctl daemon-reload' >> /tmp/cloud-init-${var.vm_name}/user-data",
      "echo '  - systemctl enable qemu-guest-agent' >> /tmp/cloud-init-${var.vm_name}/user-data",
      "echo '  - systemctl start qemu-guest-agent' >> /tmp/cloud-init-${var.vm_name}/user-data",
      "echo 'instance-id: ${var.vm_name}' > /tmp/cloud-init-${var.vm_name}/meta-data",
      "echo 'local-hostname: ${var.vm_name}' >> /tmp/cloud-init-${var.vm_name}/meta-data",
      "cd /tmp/cloud-init-${var.vm_name}",
      "genisoimage -output cloud-init.iso -volid cidata -joliet -rock user-data meta-data",
      "sudo mv cloud-init.iso /var/lib/libvirt/images/${var.vm_name}-cloud-init.iso",
      "sudo chown root:root /var/lib/libvirt/images/${var.vm_name}-cloud-init.iso",
      "sudo chmod 644 /var/lib/libvirt/images/${var.vm_name}-cloud-init.iso",
      "cd /tmp",
      "rm -rf /tmp/cloud-init-${var.vm_name}"
    ]
  }
}

# Define the VM domain
resource "libvirt_domain" "vm" {
  depends_on = [null_resource.cloud_init_iso]
  name      = var.vm_name
  memory    = var.memory
  vcpu      = var.vcpu
  running   = true
  autostart = true

  disk {
    volume_id = libvirt_volume.vm_disk.id
  }

  disk {
    file = "/var/lib/libvirt/images/${var.vm_name}-cloud-init.iso"
  }

  cpu {
    mode = "host-passthrough"
  }

  network_interface {
    bridge = "br0"
    wait_for_lease = true
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  qemu_agent = true
}

# Outputs
output "vm_info" {
  value = {
    name        = libvirt_domain.vm.name
    mac_address = libvirt_domain.vm.network_interface[0].mac
    ip_address  = try(libvirt_domain.vm.network_interface[0].addresses[0], "waiting for IP...")
  }
  description = "VM network information"
}
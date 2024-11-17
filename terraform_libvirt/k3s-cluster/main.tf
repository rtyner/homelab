# main.tf

# Download Debian cloud image
resource "libvirt_volume" "debian_base" {
  name   = "debian12_base"
  pool   = "images"
  source = var.debian_image_url
  format = "qcow2"
}

# Create master node volumes
resource "libvirt_volume" "master_disk" {
  count          = var.master_count
  name           = "k3s-master-${count.index + 1}.qcow2"
  base_volume_id = libvirt_volume.debian_base.id
  pool           = "images"
  size           = var.master_disk_size
}

# Create worker node volumes
resource "libvirt_volume" "worker_disk" {
  count          = var.worker_count
  name           = "k3s-worker-${count.index + 1}.qcow2"
  base_volume_id = libvirt_volume.debian_base.id
  pool           = "images"
  size           = var.worker_disk_size
}

# Create cloud-init for master nodes
resource "null_resource" "master_cloud_init" {
  count = var.master_count

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = var.remote_user
      host = var.remote_host
    }

    inline = [
      "sudo rm -rf /tmp/cloud-init-k3s-master-${count.index + 1}",
      "mkdir -p /tmp/cloud-init-k3s-master-${count.index + 1}",
      "cat > /tmp/cloud-init-k3s-master-${count.index + 1}/user-data << 'EOF'",
      "#cloud-config",
      "hostname: k3s-master-${count.index + 1}",
      "fqdn: k3s-master-${count.index + 1}.${var.domain}",
      "users:",
      "  - name: rt",
      "    sudo: ALL=(ALL) NOPASSWD:ALL",
      "    groups: users, admin",
      "    home: /home/rt",
      "    shell: /bin/bash",
      "    ssh_authorized_keys:",
      "      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIITrPYcULQ4WTZs65pFDiSFS1hdsjVRo4DK+02pnRlYc",
      "package_update: true",
      "package_upgrade: true",
      "packages:",
      "  - qemu-guest-agent",
      "  - curl",
      "  - wget",
      "  - net-tools",
      "write_files:",
      "  - path: /etc/netplan/01-netcfg.yaml",
      "    content: |",
      "      network:",
      "        version: 2",
      "        ethernets:",
      "          ens3:",
      "            dhcp4: no",
      "            addresses: [10.1.1.20/24]",
      "            gateway4: 10.1.1.1",
      "            nameservers:",
      "              addresses: [10.1.1.1]",
      "runcmd:",
      "  - netplan apply",
      "  - systemctl daemon-reload",
      "  - systemctl enable qemu-guest-agent",
      "  - systemctl start qemu-guest-agent",
      "  - curl -sfL https://get.k3s.io | sh -s - server --cluster-init --node-ip=10.1.1.20",
      "EOF",
      "echo 'instance-id: k3s-master-${count.index + 1}' > /tmp/cloud-init-k3s-master-${count.index + 1}/meta-data",
      "echo 'local-hostname: k3s-master-${count.index + 1}' >> /tmp/cloud-init-k3s-master-${count.index + 1}/meta-data",
      "cd /tmp/cloud-init-k3s-master-${count.index + 1}",
      "genisoimage -output cloud-init.iso -volid cidata -joliet -rock user-data meta-data",
      "sudo mv cloud-init.iso /var/lib/libvirt/images/k3s-master-${count.index + 1}-cloud-init.iso",
      "sudo chown root:root /var/lib/libvirt/images/k3s-master-${count.index + 1}-cloud-init.iso",
      "sudo chmod 644 /var/lib/libvirt/images/k3s-master-${count.index + 1}-cloud-init.iso",
      "cd /tmp",
      "rm -rf /tmp/cloud-init-k3s-master-${count.index + 1}"
    ]
  }
}

# Create cloud-init for worker nodes
resource "null_resource" "worker_cloud_init" {
  count = var.worker_count
  depends_on = [libvirt_domain.master]

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = var.remote_user
      host = var.remote_host
    }

    inline = [
      "sudo rm -rf /tmp/cloud-init-k3s-worker-${count.index + 1}",
      "mkdir -p /tmp/cloud-init-k3s-worker-${count.index + 1}",
      "cat > /tmp/cloud-init-k3s-worker-${count.index + 1}/user-data << 'EOF'",
      "#cloud-config",
      "hostname: k3s-worker-${count.index + 1}",
      "fqdn: k3s-worker-${count.index + 1}.${var.domain}",
      "users:",
      "  - name: rt",
      "    sudo: ALL=(ALL) NOPASSWD:ALL",
      "    groups: users, admin",
      "    home: /home/rt",
      "    shell: /bin/bash",
      "    ssh_authorized_keys:",
      "      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIITrPYcULQ4WTZs65pFDiSFS1hdsjVRo4DK+02pnRlYc",
      "package_update: true",
      "package_upgrade: true",
      "packages:",
      "  - qemu-guest-agent",
      "  - curl",
      "  - wget",
      "  - net-tools",
      "write_files:",
      "  - path: /etc/netplan/01-netcfg.yaml",
      "    content: |",
      "      network:",
      "        version: 2",
      "        ethernets:",
      "          ens3:",
      "            dhcp4: no",
      "            addresses: [10.1.1.${21 + count.index}/24]",
      "            gateway4: 10.1.1.1",
      "            nameservers:",
      "              addresses: [10.1.1.1]",
      "runcmd:",
      "  - netplan apply",
      "  - systemctl daemon-reload",
      "  - systemctl enable qemu-guest-agent",
      "  - systemctl start qemu-guest-agent",
      "  - 'TOKEN=$(ssh rt@10.1.1.20 sudo cat /var/lib/rancher/k3s/server/node-token)'",
      "  - curl -sfL https://get.k3s.io | K3S_URL=https://10.1.1.20:6443 K3S_TOKEN=$TOKEN sh - --node-ip=10.1.1.${21 + count.index}",
      "EOF",
      "echo 'instance-id: k3s-worker-${count.index + 1}' > /tmp/cloud-init-k3s-worker-${count.index + 1}/meta-data",
      "echo 'local-hostname: k3s-worker-${count.index + 1}' >> /tmp/cloud-init-k3s-worker-${count.index + 1}/meta-data",
      "cd /tmp/cloud-init-k3s-worker-${count.index + 1}",
      "genisoimage -output cloud-init.iso -volid cidata -joliet -rock user-data meta-data",
      "sudo mv cloud-init.iso /var/lib/libvirt/images/k3s-worker-${count.index + 1}-cloud-init.iso",
      "sudo chown root:root /var/lib/libvirt/images/k3s-worker-${count.index + 1}-cloud-init.iso",
      "sudo chmod 644 /var/lib/libvirt/images/k3s-worker-${count.index + 1}-cloud-init.iso",
      "cd /tmp",
      "rm -rf /tmp/cloud-init-k3s-worker-${count.index + 1}"
    ]
  }
}

# Define master node domains
resource "libvirt_domain" "master" {
  count     = var.master_count
  depends_on = [null_resource.master_cloud_init]
  name      = "k3s-master-${count.index + 1}"
  memory    = var.master_memory
  vcpu      = var.master_vcpu
  running   = true
  autostart = true

  disk {
    volume_id = libvirt_volume.master_disk[count.index].id
  }

  disk {
    file = "/var/lib/libvirt/images/k3s-master-${count.index + 1}-cloud-init.iso"
  }

  cpu {
    mode = "host-passthrough"
  }

  network_interface {
    bridge = "br0"
    wait_for_lease = false
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

# Define worker node domains
resource "libvirt_domain" "worker" {
  count      = var.worker_count
  depends_on = [null_resource.worker_cloud_init]
  name       = "k3s-worker-${count.index + 1}"
  memory     = var.worker_memory
  vcpu       = var.worker_vcpu
  running    = true
  autostart  = true

  disk {
    volume_id = libvirt_volume.worker_disk[count.index].id
  }

  disk {
    file = "/var/lib/libvirt/images/k3s-worker-${count.index + 1}-cloud-init.iso"
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
output "cluster_info" {
  value = {
    master_nodes = [
      for node in libvirt_domain.master : {
        name        = node.name
        mac_address = node.network_interface[0].mac
        ip_address  = try(node.network_interface[0].addresses[0], "waiting for IP...")
      }
    ]
    worker_nodes = [
      for node in libvirt_domain.worker : {
        name        = node.name
        mac_address = node.network_interface[0].mac
        ip_address  = try(node.network_interface[0].addresses[0], "waiting for IP...")
      }
    ]
  }
  description = "K3s cluster network information"
}
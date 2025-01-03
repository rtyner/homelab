#!/bin/bash
mkdir -p cloud-images
cd cloud-images/

# Download the latest Debian cloud image
wget https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2

# Create the VM
sudo qm create 9004 --memory 2048 --cores 2 --name debian12-cloud --net0 virtio,bridge=vmbr0

# Import the disk
sudo qm disk import 9004 debian-12-genericcloud-amd64.qcow2 local-zfs

# Configure the VM
sudo qm set 9004 --scsihw virtio-scsi-pci --scsi0 local-zfs:vm-9004-disk-0
sudo qm set 9004 --ide2 local-zfs:cloudinit

# Modified boot settings
sudo qm set 9004 --boot order=scsi0
sudo qm set 9004 --bootdisk scsi0

# Console settings
sudo qm set 9004 --serial0 socket
sudo qm set 9004 --vga qxl

# Important changes to prevent kernel panic
sudo qm set 9004 --ostype l26
sudo qm set 9004 --cpu host
sudo qm set 9004 --machine q35
sudo qm set 9004 --bios ovmf
sudo qm set 9004 --agent enabled=1

# Finally, convert to template
sudo qm template 9004

# Clean up
rm debian-12-genericcloud-amd64.qcow2
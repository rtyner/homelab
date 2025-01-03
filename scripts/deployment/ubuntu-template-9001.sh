#!/bin/bash
mkdir cloud-images
cd cloud-images/
wget https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.img
sudo qm create 9001 --memory 2048 --core 2 --name ubuntu-cloud --net0 virtio,bridge=vmbr0
sudo qm disk import 9001 ubuntu-24.04-server-cloudimg-amd64.img local-zfs
sudo qm set 9001 --scsihw virtio-scsi-pci --scsi0 local-zfs:vm-9001-disk-0
sudo qm set 9001 --ide2 local-zfs:cloudinit
sudo qm set 9001 --boot c --bootdisk scsi0
sudo qm set 9001 --serial0 socket --vga serial0
sudo qm template 9001
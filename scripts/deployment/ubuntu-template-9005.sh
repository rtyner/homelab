#!/bin/bash
mkdir cloud-images
cd cloud-images/
wget https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.img
sudo qm create 9005 --memory 2048 --core 2 --name ubuntu-cloud --net0 virtio,bridge=vmbr0
sudo qm disk import 9005 ubuntu-24.04-server-cloudimg-amd64.img local-zfs
sudo qm set 9005 --scsihw virtio-scsi-pci --scsi0 local-zfs:vm-9005-disk-0
sudo qm set 9005 --ide2 local-zfs:cloudinit
sudo qm set 9005 --boot c --bootdisk scsi0
sudo qm set 9005 --serial0 socket --vga serial0
sudo qm template 9005
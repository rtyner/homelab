#!/bin/bash
mkdir cloud-images
cd cloud-images/
wget https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.img
qm create 9002 --memory 2048 --core 2 --name ubuntu-cloud --net0 virtio,bridge=vmbr0
qm disk import 9002 ubuntu-24.04-server-cloudimg-amd64.img local-lvm
qm set 9002 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-9002-disk-0
qm set 9002 --ide2 local-lvm:cloudinit
qm set 9002 --boot c --bootdisk scsi0
qm set 9002 --serial0 socket --vga serial0
qm template 9002
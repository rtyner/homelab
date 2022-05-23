#!/bin/bash
wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img
sudo virt-customize -a focal-server-cloudimg-amd64.img --install qemu-guest-agent

qm create 1000 --memory 4096 --sockets 2 --cores 4 --net0 virtio,bridge=vmbr0 && qm importdisk 1000 focal-server-cloudimg-amd64.img ssd-pool && qm set 1000 --scsihw virtio-scsi-pci --scsi0 ssd-pool:vm-1000-disk-0 --ide2 local-zfs:cloudinit,size=32G --boot c --bootdisk scsi0 --serial0 socket --vga serial0

qm template 1000
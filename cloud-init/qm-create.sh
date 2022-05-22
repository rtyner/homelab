#!/bin/bash

qm create 1000 --memory 4096 --sockets 2 --cores 4 --net0 virtio,bridge=vmbr0 && qm importdisk 1000 ubuntu-20.04-minimal-cloudimg-amd64.img local-zfs && qm set 1000 --scsihw virtio-scsi-pci --scsi0 local-zfs:vm-1000-disk-0 --ide2 local-zfs:cloudinit,size=32G --boot c --bootdisk scsi0 --serial0 socket --vga serial0
virt-customize -a ubuntu-20.04-minimal-cloudimg-amd64.img -run-command 'apt-get update && apt-get install qemu-guest-agent -y'
qm template 1000
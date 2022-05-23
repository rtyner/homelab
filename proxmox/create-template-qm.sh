#!/bin/bash

wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img

virt-customize -a /home/rt/images/focal-server-cloudimg-amd64.img --install qemu-guest-agent
virt-customize -a /home/rt/images/focal-server-cloudimg-amd64.img --root-password password:

# creates a vm with the provided image with 2 sockets, 4 cores each
qm create 1000 --name "ubuntu-2004-cloud-template" --memory 4096 --sockets 2 --cores 4 --net0 virtio,bridge=vmbr0
qm importdisk 1000 /home/rt/images/focal-server-cloudimg-amd64.img local-zfs
qm set 1000 --scsihw virtio-scsi-pci --scsi0 local-zfs:vm-1000-disk-0 --ide2 local-zfs:cloudinit,size=32G --boot c --bootdisk scsi0 --serial0 socket --vga serial0 --agent enabled=1
qm template 1000


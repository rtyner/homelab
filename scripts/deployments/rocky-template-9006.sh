#!/bin/bash
mkdir cloud-images
cd cloud-images/
wget https://download.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2
qm create 9006 --memory 2048 --core 2 --name rocky-cloud --net0 virtio,bridge=vmbr0
qm disk import 9006 Rocky-9-GenericCloud-Base.latest.x86_64.qcow2 local-zfs
qm set 9006 --scsihw virtio-scsi-pci --scsi0 local-zfs:vm-9006-disk-0
qm set 9006 --ide2 local-zfs:cloudinit
qm set 9006 --boot c --bootdisk scsi0
qm set 9006 --serial0 socket --vga serial0
qm template 9006
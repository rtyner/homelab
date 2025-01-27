#!/bin/bash
mkdir cloud-images
cd cloud-images/
wget https://geo.mirror.pkgbuild.com/images/latest/Arch-Linux-x86_64-cloudimg.qcow2
qm create 9007 --memory 2048 --core 2 --name arch-cloud --net0 virtio,bridge=vmbr0
qm disk import 9007 Arch-Linux-x86_64-cloudimg.qcow2 ceph-vmstore-01
qm set 9007 --scsihw virtio-scsi-pci --scsi0 ceph-vmstore-01:vm-9007-disk-0
qm set 9007 --ide2 ceph-vmstore-01:cloudinit
qm set 9007 --boot c --bootdisk scsi0
qm set 9007 --serial0 socket --vga serial0
qm template 9007
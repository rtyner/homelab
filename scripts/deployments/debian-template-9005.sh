#!/bin/bash
qm create 9005 --name "debian12-cloud" --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0
qm disk import 9005 debian-12-genericcloud-amd64.qcow2 ceph-vmstore-01
qm set 9005 --shsihw virtio-scsi-pci --scsi0 ceph-vmstore-01:vm-9005-disk-0
qm set 9005 --boot c --bootdisk scsi0
qm set 9005 --ide1 ceph-vmstore-01:cloudinit
qm set 9005 --serial0 socket --vga serial0
qm set 9005 --agent enabled=1
qm template 9005

#!/bin/bash

VMID=119
NAME="win11-desktop"
MEMORY=16384
CORES=8

qm create $VMID --name $NAME --memory $MEMORY --cores $CORES --sockets 1 --numa 1
qm set $VMID --scsihw virtio-scsi-single
qm set $VMID --machine q35
qm set $VMID --bios ovmf
qm set $VMID --ostype win11
qm set $VMID --hostpci0 09:00.0,pcie=1
qm set $VMID --scsi0 local-zfs:vm-$VMID-disk-0,size=256G,ssd=1,format=raw
qm set $VMID --cpu host,hidden=1,flags=+pcid
qm set $VMID --machine pc-q35-7.1
qm set $VMID --net0 virtio,bridge=vmbr0
qm set $VMID --tablet 0
qm set $VMID --audio0 device=ich9-intel-hda,driver=spice
qm set $VMID --args "-spice port=5900,disable-ticketing=on"
qm set $VMID --args '-cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx'
qm set $VMID --ide2 local:iso/Win11_23H2_English_x64v2.iso,media=cdrom
qm set $VMID --ide3 local:iso/virtio-win.iso,media=cdrom
qm set $VMID --efidisk0 local-zfs:1,format=raw
qm set $VMID --tpmstate0 local-zfs:1,version=v2.0
qm set $VMID --tpmstate0 local-zfs:1,version=v2.0
qm set $VMID --tpmstate0 local-zfs:1,version=v2.0
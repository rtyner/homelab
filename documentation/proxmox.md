# Proxmox Notes

## qm commands

### create vm with cloudinit

```bash
#!/bin/bash

wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img

sudo virt-customize -a focal-server-cloudimg-amd64.img --install qemu-guest-agent

# creates a vm with the provided image with 2 sockets, 4 cores each
qm create 1000 --memory 4096 --sockets 2 --cores 4 --net0 virtio,bridge=vmbr0 && qm importdisk 1000 focal-server-cloudimg-amd64.img ssd-pool && qm set 1000 --scsihw virtio-scsi-pci --scsi0 ssd-pool:vm-1000-disk-0 --ide2 local-zfs:cloudinit,size=32G --boot c --bootdisk scsi0 --serial0 socket --vga serial0

qm template 1000
```

#### clone, set keys and ip, and start vm

```bash
qm clone 1000 200 --name rt-prod-docker-1
qm set 200 --sshkeys id_ed25519.pub
qm set 200 --ipconfig0 ip=10.1.1.200,gw=10.1.1.1
qm set 200 --ipconfig0 ip=10.1.1.200/24,gw=10.1.1.1
qm start 200
 ```

#### add qemu guest agent to cloudinit image

```bash
apt-get install Libguestfs
virt-customize -a /path/to/cloud.img --run-command 'apt-get update && apt-get upgrade -y && apt-get install qemu-guest-agent -y'
```

#### restore vm to different storage

```bash
qmrestore vzdump-qemu-100-2022_05_24-12_17_21.vma.zst 100 --storage local
```

## scripts/setup

### backup script

```bash
#!/bin/bash

date=$(date +%m-%d-%y) 

find /root/backups/dump-*.tar.gz -type d -ctime +10 -exec rm -rf {} \;

tar czvf /home/root/backups/dump-${date}.tar.gz /var/lib/vz/dump

scp dump-${date}.tar.gz rt@207.246.116.69:/home/rt/pve1-backups/
```

### initial setup

```bash
bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/post-install-v3.sh)"
```

### dark mode

```bash
bash <(curl -s https://raw.githubusercontent.com/Weilbyte/PVEDiscordDark/master/PVEDiscordDark.sh ) install
```

### remove node from broken cluster

```bash
pvecm status
pvecm expected 1

pvecm delnode pve-2
```

## zfs

### error when creating pool in gui

```bash
command '/sbin/zpool create -o 'ashift=12' big-dick-pool raidz /dev/disk/by-id/ata-ST5000LM000-2AN170_WCJ4L9DN /dev/disk/by-id/ata-ST5000LM000-2AN170_WCJ516BK /dev/disk/by-id/ata-ST5000LM000-2AN170_WCJ49YBN /dev/disk/by-id/ata-ST5000LM000-2AN170_WCJ44ZA7' failed: exit code 1
```

need to create the pool from cli with -f flag

```bash
zpool create -o -f 'ashift=12' big-dick-pool raidz /dev/disk/by-id/ata-ST5000LM000-2AN170_WCJ4L9DN /dev/disk/by-id/ata-ST5000LM000-2AN170_WCJ516BK /dev/disk/by-id/ata-ST5000LM000-2AN170_WCJ49YBN /dev/disk/by-id/ata-ST5000LM000-2AN170_WCJ44ZA7
```

### import zfs pool from other system

```bash
root@pve-1:~# zpool import
   pool: boot-pool
     id: 1932467786112423802
  state: ONLINE
status: One or more devices are configured to use a non-native block size.
        Expect reduced performance.
 action: The pool can be imported using its name or numeric identifier.
 config:

        boot-pool   ONLINE
          zd128     ONLINE

   pool: ssd-mirror
     id: 3575452547201133070
  state: ONLINE
status: The pool was last accessed by another system.
 action: The pool can be imported using its name or numeric identifier and
        the '-f' flag.
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-EY
 config:

        ssd-mirror  ONLINE
          mirror-0  ONLINE
            sdd2    ONLINE
            sde2    ONLINE

   pool: big-dick-pool
     id: 9453892965676340550
  state: ONLINE
status: The pool was last accessed by another system.
 action: The pool can be imported using its name or numeric identifier and
        the '-f' flag.
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-EY
 config:

        big-dick-pool  ONLINE
          raidz1-0     ONLINE
            sdb2       ONLINE
            sdc2       ONLINE
            sdf2       ONLINE
            sda2       ONLINE
root@pve-1:~# zpool import ssd-mirror
cannot import 'ssd-mirror': pool was previously in use from another system.
Last accessed by  (hostid=bf77e045) at Mon May 23 20:42:32 2022
The pool can be imported, use 'zpool import -f' to import the pool.
root@pve-1:~# zpool import -f ssd-mirror
root@pve-1:~# zpool import -f big-dick-pool
```

## pci passthrough

### remove pci device from vm cli

```bash
cd /etc/pve/qemu-server
ls #look for the VMID name here *.conf
cat VMID.conf #in here you will see a line with hostpci
qm set $VMID --delete hostpci#
```

### blacklist pci device on proxmox

```bash
# https://old.reddit.com/r/homelab/comments/4t8p4j/freenas_in_proxmox_vm/

lscpi #find your device in here, copy the ID
find /sys | grep drivers.*03:00.0
$ /sys/bus/pci/drivers/mpt3sas/0000:03:00.0

# edit /etc/modprobe.d/pve-blacklist.conf and add your device
root@pve-1:/etc/modprobe.d# cat pve-blacklist.conf

# This file contains a list of modules which are not supported by Proxmox VE

# nidiafb see bugreport https://bugzilla.proxmox.com/show_bug.cgi?id=701
blacklist mpt3sas
blacklist nvidiafb

# update initramfs
update-initramfs -k all -u
```

### vm booting to passed through hba

- <https://old.reddit.com/r/homelab/comments/4t8p4j/freenas_in_proxmox_vm/>

## nfs

### nfs mount error pve < truenas

`mount system call failed: 500`

- creds are wrong in nfs on truenas
  - set mapall to root and wheel
    - <https://www.truenas.com/community/threads/am-i-too-dumb-to-understand-nfs-permissions.86524/>

### nfs mount error `nfs create storage failed: cfs-lock 'file-storage_cfg' error: got lock request timeout (500)`

- this happens if the share is still attached on another ip, changed ip of truenas and couldn't add new shares
- <https://askubuntu.com/questions/292043/how-to-unmount-nfs-when-server-is-gone>

```bash
mount | grep nfs

10.1.1.138:/mnt/big-dick-pool/big-dick-pool/pve on /mnt/pve/big-dick-pool type nfs (rw,relatime,vers=3,rsize=131072,wsize=131072,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=10.1.1.138,mountvers=3,mountport=908,mountproto=udp,local_lock=none,addr=10.1.1.138)
10.1.1.138:/mnt/ssd-mirror/ssd-pool on /mnt/pve/ssd-pool type nfs (rw,relatime,vers=3,rsize=131072,wsize=131072,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=10.1.1.138,mountvers=3,mountport=908,mountproto=udp,local_lock=none,addr=10.1.1.138)

umount -f -l /mnt/pve/big-dick-pool
umount -f -l /mnt/pve/ssd-pool
```

### nfs mounts

- /mnt/ssd-mirror/ssd-pool
- /mnt/ssd-mirror/ssd-pool

## opnsense

### setting up opnsense on pve

<https://docs.netgate.com/pfsense/en/latest/recipes/virtualize-proxmox-ve.html#virtualizing-with-proxmox-ve>

- give opnsense two bridged nics that are separate from what proxmox is using
- i used vmbr1 (eno1) and vmbr0 (eno2)

### disk testing

- nfs share

```bash
fio Disk Speed Tests (Mixed R/W 50/50):
---------------------------------
Block Size | 4k            (IOPS) | 64k           (IOPS)
  ------   | ---            ----  | ----           ----
Read       | 7.25 MB/s     (1.8k) | 94.72 MB/s    (1.4k)
Write      | 7.27 MB/s     (1.8k) | 95.22 MB/s    (1.4k)
Total      | 14.52 MB/s    (3.6k) | 189.95 MB/s   (2.9k)
           |                      |
Block Size | 512k          (IOPS) | 1m            (IOPS)
  ------   | ---            ----  | ----           ----
Read       | 80.93 MB/s     (158) | 100.83 MB/s     (98)
Write      | 85.23 MB/s     (166) | 107.54 MB/s    (105)
Total      | 166.17 MB/s    (324) | 208.38 MB/s    (203)
```

- local

```bash
fio Disk Speed Tests (Mixed R/W 50/50):
---------------------------------
Block Size | 4k            (IOPS) | 64k           (IOPS)
  ------   | ---            ----  | ----           ----
Read       | 45.77 MB/s   (11.4k) | 478.09 MB/s   (7.4k)
Write      | 45.86 MB/s   (11.4k) | 480.60 MB/s   (7.5k)
Total      | 91.63 MB/s   (22.9k) | 958.69 MB/s  (14.9k)
           |                      |
Block Size | 512k          (IOPS) | 1m            (IOPS)
  ------   | ---            ----  | ----           ----
Read       | 1.88 GB/s     (3.6k) | 2.51 GB/s     (2.4k)
Write      | 1.98 GB/s     (3.8k) | 2.67 GB/s     (2.6k)
Total      | 3.87 GB/s     (7.5k) | 5.19 GB/s     (5.0k)
```

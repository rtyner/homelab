#!/bin/bash

qm clone 1001 105 --name nfs-file-1
qm set 105 --sockets 2 --cores 4 --memory 8096 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.22/24,gw=10.1.1.1 --autostart 1
qm resize 105 scsi0 +60G
qm start 105
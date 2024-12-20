#!/bin/bash

qm clone 1001 110 --name linux-dev-1
qm set 110 --sockets 2 --cores 4 --memory 8192 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.25/24,gw=10.1.1.1 --autostart 1
qm resize 110 scsi0 +60G
qm start 110
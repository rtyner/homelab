#!/bin/bash

qm clone 1001 109 --name gitlab-1
qm set 109 --sockets 1 --cores 2 --memory 2048 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.17/24,gw=10.1.1.1 --autostart 1
qm resize 109 scsi0 +12G
qm start 109
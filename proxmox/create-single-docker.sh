#!/bin/bash

qm clone 1001 333 --name bl-docker-1
qm set 333 --sockets 2 --cores 4 --memory 16384 --sshkeys /root/.ssh/id_ed25519.pub --ciuser bl --ipconfig0 ip=10.1.1.233/24,gw=10.1.1.1 --autostart 1
qm resize 333 scsi0 +30G
qm start 333
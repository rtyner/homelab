#!/bin/bash

qm clone 1001 213 --name rt-prod-docker-manager1
qm set 213 --sockets 2 --cores 8 --memory 32768 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.11/24,gw=10.1.1.1 --autostart 1
qm resize 213 scsi0 +30G
qm start 213
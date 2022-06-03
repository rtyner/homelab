#!/bin/bash

qm clone 1001 212 --name rt-prod-docker-manager1
qm set 212 --sockets 2 --cores 8 --memory 32768 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.204/24,gw=10.1.1.1 --autostart 1
qm resize 212 scsi0 +30G
qm start 212
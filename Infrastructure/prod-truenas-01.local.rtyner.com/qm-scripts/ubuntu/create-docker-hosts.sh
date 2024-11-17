#!/bin/bash

qm clone 1001 208 --name rt-prod-docker-manager1
qm set 208 --sockets 2 --cores 4 --memory 4096 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.208/24,gw=10.1.1.1 --autostart 1
qm resize 208 scsi0 +22G
qm start 208

qm clone 1001 209 --name rt-prod-docker-node1
qm set 209 --sockets 2 --cores 4 --memory 4096 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.209/24,gw=10.1.1.1 --autostart 1
qm resize 209 scsi0 +22G
qm start 209

qm clone 1001 210 --name rt-prod-docker-node2
qm set 210 --sockets 2 --cores 4 --memory 4096 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.210/24,gw=10.1.1.1 --autostart 1
qm resize 210 scsi0 +22G
qm start 210

qm clone 1001 211 --name rt-prod-docker-node3
qm set 211 --sockets 2 --cores 4 --memory 4096 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.211/24,gw=10.1.1.1 --autostart 1
qm resize 211 scsi0 +22G
qm start 211
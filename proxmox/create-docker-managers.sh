#!/bin/bash

qm clone 1001 214 --name prod-docker-mgr-1
qm set 214 --sockets 2 --cores 8 --memory 8096 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.214/24,gw=10.1.1.1 --autostart 1
qm resize 214 scsi0 +42G
qm start 214

qm clone 1001 215 --name prod-docker-mgr-2
qm set 215 --sockets 2 --cores 8 --memory 8096 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.215/24,gw=10.1.1.1 --autostart 1
qm resize 215 scsi0 +42G
qm start 215

qm clone 1001 216 --name prod-docker-mgr-3
qm set 216 --sockets 2 --cores 8 --memory 8096 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.216/24,gw=10.1.1.1 --autostart 1
qm resize 216 scsi0 +42G
qm start 216

qm clone 1001 217 --name prod-docker-node-1
qm set 217 --sockets 2 --cores 8 --memory 8096 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.217/24,gw=10.1.1.1 --autostart 1
qm resize 217 scsi0 +42G
qm start 217

qm clone 1001 218 --name prod-docker-node-2
qm set 218 --sockets 2 --cores 8 --memory 8096 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.218/24,gw=10.1.1.1 --autostart 1
qm resize 218 scsi0 +42G
qm start 218

qm clone 1001 219 --name prod-docker-node-3
qm set 219 --sockets 2 --cores 8 --memory 8096 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.219/24,gw=10.1.1.1 --autostart 1
qm resize 219 scsi0 +42G
qm start 219
#!/bin/bash

qm clone 1001 300 --name rt-prod-k8s-master1
qm set 300 --sockets 2 --cores 4 --memory 4096 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.20/24,gw=10.1.1.1 --autostart 1
qm resize 300 scsi0 +22G
qm start 300

qm clone 1001 301 --name rt-prod-k8s-node1
qm set 301 --sockets 2 --cores 4 --memory 4096 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.21/24,gw=10.1.1.1 --autostart 1
qm resize 301 scsi0 +22G
qm start 301

qm clone 1001 302 --name rt-prod-k8s-node2
qm set 302 --sockets 2 --cores 4 --memory 4096 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.22/24,gw=10.1.1.1 --autostart 1
qm resize 302 scsi0 +22G
qm start 302

qm clone 1001 303 --name rt-prod-k8s-node3
qm set 303 --sockets 2 --cores 4 --memory 4096 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.23/24,gw=10.1.1.1 --autostart 1
qm resize 303 scsi0 +22G
qm start 303
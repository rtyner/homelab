#!/bin/bash

qm clone 1000 205 --name influx-1 --full true
qm set 205 --sockets 1 --cores 4 --memory 2048 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.205/24,gw=10.1.1.1 --autostart 1
qm resize 205 scsi0 +62G
qm start 205

qm clone 1000 206 --name prometheus-1 --full true
qm set 206 --sockets 1 --cores 4 --memory 2048 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.206/24,gw=10.1.1.1 --autostart 1
qm resize 206 scsi0 +62G
qm start 206

qm clone 1001 207 --name grafana-1
qm set 207 --sockets 2 --cores 4 --memory 8192 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.207/24,gw=10.1.1.1 --autostart 1
qm resize 207 scsi0 +20G
qm start 207
#!/bin/bash

qm clone 1000 205 --name influx-1 --full true
qm set 205 --sshkeys /root/.ssh/id_ed25519.pub
qm set 205 --ipconfig0 ip=10.1.1.205/24,gw=10.1.1.1
qm resize 205 scsi0 +62G

qm clone 1000 206 --name prometheus-1 --full true
qm set 206 --sshkeys /root/.ssh/id_ed25519.pub
qm set 206 --ipconfig0 ip=10.1.1.206/24,gw=10.1.1.1
qm resize 206 scsi0 +62G

qm clone 1001 207 --name grafana-1
qm set 207 --sshkeys /root/.ssh/id_ed25519.pub
qm set 207 --ipconfig0 ip=10.1.1.207/24,gw=10.1.1.1
qm resize 207 scsi0 +20G

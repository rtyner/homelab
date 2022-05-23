#!/bin/bash

qm clone 1000 200 --name rt-prod-docker-1
qm set 200 --sshkeys /root/.ssh/id_ed25519.pub
qm set 200 --ipconfig0 ip=10.1.1.200/24,gw=10.1.1.1
qm resize 200 scsi0 +20G
qm start 200

qm clone 1000 201 --name rt-prod-docker-2
qm set 201 --sshkeys /root/.ssh/id_ed25519.pub
qm set 201 --ipconfig0 ip=10.1.1.201/24,gw=10.1.1.1
qm resize 201 scsi0 +20G
qm start 201

qm clone 1000 202 --name rt-prod-docker-3
qm set 202 --sshkeys /root/.ssh/id_ed25519.pub
qm set 202 --ipconfig0 ip=10.1.1.202/24,gw=10.1.1.1
qm resize 202 scsi0 +20G
qm start 202
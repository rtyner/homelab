#!/bin/bash

qm clone 1001 106 --name dns-1
qm set 106 --sockets 1 --cores 2 --memory 1024 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.53/24,gw=10.1.1.1 --autostart 1
qm resize 106 scsi0 +22G
qm start 106

qm clone 1001 107 --name dns-2
qm set 107 --sockets 1 --cores 2 --memory 1024 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.54/24,gw=10.1.1.1 --autostart 1
qm resize 107 scsi0 +22G
qm start 107
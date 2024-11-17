qm clone 999 115 --name prod-docker-local-mgr-01
qm set 115 --sockets 2 --cores 2 --memory 4096 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.10/24,gw=10.1.1.1 --autostart 1
qm resize 115 scsi0 +10G
qm start 115

qm clone 999 116 --name prod-docker-local-node-01
qm set 116 --sockets 2 --cores 4 --memory 4096 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.11/24,gw=10.1.1.1 --autostart 1
qm resize 116 scsi0 +20G
qm start 21

qm clone 999 117 --name prod-docker-local-node-02
qm set 117 --sockets 2 --cores 4 --memory 4096 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.12/24,gw=10.1.1.1 --autostart 1
qm resize 117 scsi0 +20G
qm start 117

qm clone 999 118 --name prod-docker-local-node-03
qm set 118 --sockets 2 --cores 4 --memory 4096 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.13/24,gw=10.1.1.1 --autostart 1
qm resize 118 scsi0 +20G
qm start 118
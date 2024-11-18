qm clone 999 201 --name prod-k3s-local-master-01
qm set 201 --sockets 2 --cores 2 --memory 4096 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.30/24,gw=10.1.1.1 --autostart 1
qm resize 201 scsi0 +10G
qm start 201

qm clone 999 202 --name prod-k3s-local-node-01
qm set 202 --sockets 2 --cores 4 --memory 4096 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.31/24,gw=10.1.1.1 --autostart 1
qm resize 202 scsi0 +20G
qm start 202

qm clone 999 203 --name prod-k3s-local-node-02
qm set 203 --sockets 2 --cores 4 --memory 4096 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.32/24,gw=10.1.1.1 --autostart 1
qm resize 203 scsi0 +20G
qm start 203

qm clone 999 204 --name prod-k3s-local-node-03
qm set 204 --sockets 2 --cores 4 --memory 4096 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.33/24,gw=10.1.1.1 --autostart 1
qm resize 204 scsi0 +20G
qm start 204
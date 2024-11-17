qm clone 1001 214 --name prod-docker-3
qm set 214 --sockets 2 --cores 4 --memory 8096 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.12/24,gw=10.1.1.1 --autostart 1
qm resize 214 scsi0 +22G
qm start 216
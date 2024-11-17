qm clone 1001 114 --name linux-dev-1
qm set 114 --sockets 1 --cores 2 --memory 1024 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.14/24,gw=10.1.1.1 --autostart 1
qm resize 114 scsi0 +10G
qm start 114
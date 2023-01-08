qm clone 999 199 --name dev-deb-test-01
qm set 199 --sockets 1 --cores 2 --memory 2048 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.45/24,gw=10.1.1.1 --autostart 1
qm resize 199 scsi0 +20G
qm start 199
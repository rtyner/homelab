qm clone 1001 113 --name prometheus-01
qm set 113 --sockets 1 --cores 2 --memory 1024 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.5/24,gw=10.1.1.1 --autostart 1
qm resize 113 scsi0 +120G
qm start 113
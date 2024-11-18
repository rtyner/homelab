qm clone 1001 112 --name grafana-01
qm set 112 --sockets 1 --cores 2 --memory 1024 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.4/24,gw=10.1.1.1 --autostart 1
qm resize 112 scsi0 +120G
qm start 112
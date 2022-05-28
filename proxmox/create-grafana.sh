qm clone 1001 208 --name grafana-2
qm set 208 --sockets 2 --cores 4 --memory 8192 --sshkeys /root/.ssh/id_ed25519.pub --ciuser rt --ipconfig0 ip=10.1.1.208/24,gw=10.1.1.1 --autostart 1
qm resize 208 scsi0 +20G
qm start 208
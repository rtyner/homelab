qm set 9000 --ciuser admin
qm set 9000 --cipassword "$TEMPLATE_PASSWORD"
qm set 9000 --ipconfig0 ip=dhcp
qm set 9000 --sshkeys /home/rt/.ssh/id_ed25519.pub
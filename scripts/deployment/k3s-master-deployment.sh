# Join all master nodes (10.1.1.51 to 10.1.1.52)
export FIRST_IP=10.1.1.50

for ip in {51..52}; do
  echo "Adding master node 10.1.1.$ip..."
  k3sup join \
    --ip 10.1.1.$ip \
    --user rt \
    --ssh-key ~/.ssh/id_ed25519 \
    --sudo \
    --k3s-channel stable \
    --server-ip $FIRST_IP \
    --server \
    --k3s-extra-args "--disable traefik --node-taint node-role.kubernetes.io/control-plane:NoSchedule"
  
  # Wait a few seconds between joins
  sleep 5
done

  k3sup join \
    --ip 10.1.1.59 \
    --user rt \
    --ssh-key ~/.ssh/id_ed25519 \
    --sudo \
    --k3s-channel stable \
    --server-ip $FIRST_IP \
    --server \
    --k3s-extra-args "--disable traefik --node-taint node-role.kubernetes.io/control-plane:NoSchedule"
# Worker nodes from 10.1.1.53 to 10.1.1.57
for ip in {53..57}; do
  echo "Adding worker node 10.1.1.$ip..."
  k3sup join \
    --ip 10.1.1.$ip \
    --user rt \
    --ssh-key ~/.ssh/id_ed25519 \
    --sudo \
    --k3s-channel stable \
    --server-ip $FIRST_IP
  
  # Wait a few seconds between nodes
  sleep 5
done
# Worker nodes from 10.1.1.53 to 10.1.1.58
export FIRST_IP=10.1.1.50
export VIP=10.1.1.10

for ip in {53..58}; do
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

for ip in {60..61}; do
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
k3sup install \
--ip 10.1.1.50 \
--user rt \
--ssh-key ~/.ssh/id_ed25519 \
--sudo \
--k3s-channel stable \
--tls-san 10.1.1.10 \
--cluster --local-path ~/.kube/k8s-cluster.dev.dman.cloud.yaml \
--context k8s-cluster-ha \
--k3s-extra-args "--disable traefik --disable servicelb --node-ip=10.1.1.50"

kubectl apply -f https://kube-vip.io/manifests/rbac.yaml 

alias kube-vip="ctr run --rm --net-host docker.io/plndr/kube-vip:latest vip /kube-vip"

ctr image pull docker.io/plndr/kube-vip:latest

kube-vip manifest daemonset \
--arp \
--interface eth0 \
--address 10.1.1.10 \
--controlplane \
--leaderElection \
--taint \
--inCluster | tee /var/lib/rancher/k3s/server/manifests/kube-vip.yaml

k3sup join --ip 10.1.1.51 --user rt --ssh-key ~/.ssh/id_ed25519 \ --sudo --k3s-channel stable --server --server-ip 10.1.1.10 --server-user rt --sudo --k3s-extra-args "--disable traefik  --disable servicelb --node-ip=10.1.1.51 --token={$K3S_TOKEN}"
k3sup join --ip 10.1.1.52 --user rt --ssh-key ~/.ssh/id_ed25519 \ --sudo --k3s-channel stable --server --server-ip 10.1.1.10 --server-user rt --sudo --k3s-extra-args "--disable traefik  --disable servicelb --node-ip=10.1.1.52 --token={$K3S_TOKEN}"

k3sup join --user rt --ssh-key ~/.ssh/id_ed25519 --sudo --server-ip 10.1.1.10 --ip 10.1.1.53 --k3s-channel stable -- --k3s-extra-args "--disable traefik --disable servicelb" --print-command
k3sup join --user rt --ssh-key ~/.ssh/id_ed25519 --sudo --server-ip 10.1.1.10 --ip 10.1.1.54 --k3s-channel stable -- --k3s-extra-args "--disable traefik --disable servicelb" --print-command
k3sup join --user rt --ssh-key ~/.ssh/id_ed25519 --sudo --server-ip 10.1.1.10 --ip 10.1.1.55 --k3s-channel stable -- --k3s-extra-args "--disable traefik --disable servicelb" --print-command
k3sup join --user rt --ssh-key ~/.ssh/id_ed25519 --sudo --server-ip 10.1.1.10 --ip 10.1.1.56 --k3s-channel stable -- --k3s-extra-args "--disable traefik --disable servicelb" --print-command
k3sup join --user rt --ssh-key ~/.ssh/id_ed25519 --sudo --server-ip 10.1.1.10 --ip 10.1.1.57 --k3s-channel stable -- --k3s-extra-args "--disable traefik --disable servicelb" --print-command

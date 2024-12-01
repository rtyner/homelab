k3sup install \
--ip 10.1.1.50 \
--user rt \
--ssh-key ~/.ssh/id_ed25519 \
--sudo \
--k3s-channel latest \
--tls-san 10.1.1.10 \
--tls-san prod-k3s-cls01-vip-01.local.rtyner.com \
 --cluster --local-path ~/.kube/k8s-cluster.dev.dman.cloud.yaml \
 --context k8s-cluster-ha \
 --k3s-extra-args "--disable traefik --disable servicelb --node-ip=10.1.1.50"

kubectl apply -f https://kube-vip.io/manifests/rbac.yaml 

alias kube-vip="ctr run --rm --net-host docker.io/plndr/kube-vip:latest vip /kube-vip"

kube-vip manifest daemonset \
--arp \
--interface eth0 \
--address 10.1.1.10 \
--controlplane \
--leaderElection \
--taint \
--inCluster | tee /var/lib/rancher/k3s/server/manifests/kube-vip.yaml

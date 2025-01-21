# K3S Local Install

## install k3s locally
```bash
curl -sLS https://get.k3sup.dev | sh sudo install k3sup /usr/local/bin/
```

## initialize master node 1
```bash

export FIRST_IP=10.1.1.50
export VIP=10.1.1.10

k3sup install \
  --ip $FIRST_IP \
  --user rt \
  --tls-san $VIP \
  --cluster \
  --k3s-channel stable \
  --ssh-key ~/.ssh/id_ed25519 \
  --sudo \
  --k3s-extra-args "--disable traefik --node-taint node-role.kubernetes.io/control-plane:NoSchedule" \
  --merge \
  --local-path $HOME/.kube/config
```

## verify installation
```bash
export KUBECONFIG=/Users/rt/.kube/config
kubectl config use-context default
kubectl get node -o wide
```

## join second and third masters
```bash
k3sup join \
  --ip 10.1.1.51 \
  --user rt \
  --ssh-key ~/.ssh/id_ed25519 \
  --sudo \
  --k3s-channel stable \
  --server-ip $FIRST_IP \
  --server \
  --k3s-extra-args "--disable traefik --node-taint node-role.kubernetes.io/control-plane:NoSchedule"

k3sup join \
  --ip 10.1.1.52 \
  --user rt \
  --ssh-key ~/.ssh/id_ed25519 \
  --sudo \
  --k3s-channel stable \
  --server-ip $FIRST_IP \
  --server \
  --k3s-extra-args "--disable traefik --node-taint node-role.kubernetes.io/control-plane:NoSchedule"
```

## verify masters are online
```bash
kubectl get node -o wide
```

## join all workers nodes 
```bash
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
```

## verify cluster is online
```bash
kubectl get node -o wide
```

## install metallb
```bash
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.12/config/manifests/metallb-native.yaml

# Wait for MetalLB pods to be ready
kubectl wait --namespace metallb-system \
                --for=condition=ready pod \
                --selector=app=metallb \
                --timeout=90s
```

## metallb.yml
```yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: control-plane-pool
  namespace: metallb-system
spec:
  addresses:
  - 10.1.1.10-10.1.1.10  # Control plane VIP
---
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: service-pool
  namespace: metallb-system
spec:
  addresses:
  - 10.1.1.100-10.1.1.200  # Your service IP range
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: l2-advert
  namespace: metallb-system
```

## apply metallb config
```bash
kubectl apply -f /path/to/metallb.yaml
```

## verify metallb installation
```bash
kubectl get ipaddresspools -n metallb-system
kubectl get l2advertisements -n metallb-system
```

## install nginx ingress controller
```bash
kubectl create namespace ingress-nginx

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --set controller.service.type=LoadBalancer \
  --set controller.service.annotations."metallb\.universe\.tf/address-pool"=service-pool
```

# Rancher Setup

## add rancher helm repo
```bash
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo update
```

## create namespace
```bash
kubectl create namespace cattle-system
```

## install cert-manager
```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.4/cert-manager.yaml
```

## install rancher
```bash
helm install rancher rancher-latest/rancher \
  --namespace cattle-system \
  --set hostname=rancher.local.rtyner.com \
  --set bootstrapPassword=admin \
  --set ingress.tls.source=rancher \
  --set ingress.ingressClassName=nginx \
  --set letsEncrypt.email=homelab@rtyner.com
```

## verify deployment
```bash
kubectl -n cattle-system rollout status deploy/rancher
```

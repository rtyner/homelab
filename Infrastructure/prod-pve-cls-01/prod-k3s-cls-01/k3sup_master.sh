k3sup install \
--ip 10.1.1.50 \
--tls-san 10.1.1.75 \
--tls-san prod-k3s-cls01-vip-01.local.rtyner.com \
--cluster \
--k3s-channel latest \
--k3s-extra-args "--disable servicelb --disable traefik" \
--local-path $HOME/.kube/config \
--user rt \
--merge
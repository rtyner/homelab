#!/bin/bash

#vars
USER=rt
HOME=/home/${USER}
PUBKEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOexRWaRt+sGaH/edtNHmaTGxsQQxwxw0z/5VsAos3RJ rt@DESKTOP-3U6QGH9"

#make user and dirs
useradd --create-home ${USER} --shell "/bin/bash"
usermod -aG sudo ${USER}

#ssh config
mkdir ${HOME}/.ssh/
chown -R ${USER}:${USER} ${HOME}/.ssh/
touch "${HOME}/.ssh/authorized_keys"
chmod 0700 "${HOME}/.ssh" 
chmod 0600 "${HOME}/.ssh/authorized_keys"
echo $PUBKEY >> ${HOME}/.ssh/authorized_keys && chown ${USER}:${USER} ${HOME}/.ssh/authorized_keys

#nopasswd for user
echo "rt  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/rt

#disable root login
echo "PermitRootLogin no" >> /etc/ssh/sshd_config 
echo "PermitEmptyPasswords no" /etc/ssh/sshd_config

# Message of the day 
wget https://raw.githubusercontent.com/jwandrews99/Linux-Automation/master/misc/motd.sh
mv motd.sh /etc/update-motd.d/05-info
chmod +x /etc/update-motd.d/05-info

# Automatic downloads of security updates
apt-get install -y unattended-upgrades
echo "Unattended-Upgrade::Allowed-Origins {
#    "${distro_id}:${distro_codename}-security";
#//  "${distro_id}:${distro_codename}-updates";
#//  "${distro_id}:${distro_codename}-proposed";
#//  "${distro_id}:${distro_codename}-backports";
#Unattended-Upgrade::Automatic-Reboot "true"; 
#}; " >> /etc/apt/apt.conf.d/50unattended-upgrades

#timezone
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime

#bashrc
wget https://raw.githubusercontent.com/rtyner/dotfiles/master/.bashrc -O ${HOME}/.bashrc

#update and install
apt-get update -y && apt-get upgrade -y
apt install -y \
    vim \
    git \
    curl \
    htop \
    unzip \
    python3-pip \
    python3-setuptools \
    build-essential \
    rclone \
    rsync \
    gpg \
    dnsutils

# tailscale install
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.gpg | sudo apt-key add -
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.list | sudo tee /etc/apt/sources.list.d/tailscale.list
sudo apt-get update
sudo apt-get install tailscale

# qemu-gust-agent install
apt-get install qemu-guest-agent -y
systemctl enable qemu-guest-agent
systemctl start qemu-guest-agent

# docker install
echo "
######################################################################################################
Do you want to install docker? If so type y / If you dont want to install enter n
######################################################################################################
"
read docker

if [[ $docker -eq "y" ]] || [[ $docker -eq "yes" ]]; then
    sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
    sudo apt-get update -y
    sudo apt-cache policy docker-ce
    sudo apt install docker-ce -y
    sudo apt-get install docker-compose -y 
    sudo usermod -aG docker ${USER}
   
    echo "
#####################################################################################################    
                            Congrats Docker has been installed
######################################################################################################
"
    docker -v

else 
    echo "Docker was not installed"
 
fi

#clean
apt autoremove -v 
apt clean -v 

echo " 
##################################
Do you want to reboot now? y / n
##################################
"
read reboot
if [[ $reboot -eq "y" ]] || [[ $reboot -eq "yes" ]] ; then 
    reboot
else 
    echo "Reboot was not initiated"
fi

exit 0

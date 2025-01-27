#!/bin/bash
set -euo pipefail

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Use sudo or switch to root."
    exit 1
fi

# Configuration variables
local_user="rt"
share_uri="//10.20.1.5/shares"
share_mountpoint="/home/${local_user}/mount/shares"
mount_username="$local_user"
mount_password=""

# Function to handle errors in sudoers modification
handle_sudoers_error() {
    echo "Error in sudoers modification. Reverting changes."
    mv /etc/sudoers.bak /etc/sudoers
    exit 1
}

# Setup authorized keys
echo "Configuring SSH authorized keys..."
mkdir -p "/home/${local_user}/.ssh"
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIITrPYcULQ4WTZs65pFDiSFS1hdsjVRo4DK+02pnRlYc" >> "/home/${local_user}/.ssh/authorized_keys"
chown -R "${local_user}:${local_user}" "/home/${local_user}/.ssh"
chmod 700 "/home/${local_user}/.ssh"
chmod 600 "/home/${local_user}/.ssh/authorized_keys"

# Configure sudoers for passwordless sudo
echo "Configuring sudo privileges..."
cp /etc/sudoers /etc/sudoers.bak
sed -i '/^%wheel.*/d' /etc/sudoers
echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
visudo -cf /etc/sudoers || handle_sudoers_error

# Disable root SSH login
echo "Securing SSH configuration..."
sed -i.bak 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl restart sshd

# System update and upgrade
echo "Updating system packages..."
pacman -Sy --noconfirm
pacman -Syu --noconfirm

# Install packages
echo "Installing system packages..."
packages=(
    vim curl wget htop gnupg git unzip rsync bind-tools nfs-utils cifs-utils
    python python-pip base-devel python-setuptools sqlite postgresql rust go docker docker-compose kubectl k9s
    zsh zsh-syntax-highlighting tmux fzf ripgrep fd bat tree ncdu
    jq yq diff-so-fancy lazygit meld ctags shellcheck
    nmap tcpdump mtr iperf wireshark-cli netcat socat sshfs openssh openvpn
    sysstat iotop atop strace lsof perf
    ranger rclone neofetch neovim
)
pacman -S --noconfirm "${packages[@]}"

# Configure user environment
echo "Setting up user environment..."
curl -o "/home/${local_user}/.bashrc" "https://raw.githubusercontent.com/rtyner/homelab/refs/heads/main/configs/.bashrc"
chown "${local_user}:${local_user}" "/home/${local_user}/.bashrc"

# Create directories
mkdir -p "/home/${local_user}/working"
chown "${local_user}:${local_user}" "/home/${local_user}/working"
chmod 755 "/home/${local_user}/working"

mkdir -p "/home/${local_user}/mount"
chown "${local_user}:${local_user}" "/home/${local_user}/mount"
chmod 755 "/home/${local_user}/mount"

mkdir -p "$share_mountpoint"
chown "${local_user}:${local_user}" "$share_mountpoint"
chmod 755 "$share_mountpoint"

# Ensure cifs-utils is installed
pacman -S --noconfirm cifs-utils

# Mount network share
echo "Mounting network share..."
mount -t cifs -o "username=${mount_username},password=${mount_password},user,nofail" "$share_uri" "$share_mountpoint"

# Persist mount in fstab
echo "Persisting network share mount..."
fstab_entry="${share_uri} ${share_mountpoint} cifs username=${mount_username},password=${mount_password},user,nofail 0 0"
if ! grep -q "$fstab_entry" /etc/fstab; then
    echo "$fstab_entry" >> /etc/fstab
fi

echo "Server setup completed successfully!"
apt update -y && apt install libguestfs-tools -y
wget https://cloud-images.ubuntu.com/releases/24.04/release-20241106/ubuntu-24.04-server-cloudimg-amd64.img
virt-customize -a ubuntu-24.04-server-cloudimg-amd64.img --install qemu-guest-agent
virt-customize -a ubuntu-24.04-server-cloudimg-amd64.img --root-password file:rootpw.txt
virt-customize -a ubuntu-24.04-server-cloudimg-amd64.img --run-command "useradd -m -s /bin/bash rt"
virt-customize -a ubuntu-24.04-server-cloudimg-amd64.img --password myuser:file:userpw.txt
virt-customize -a ubuntu-24.04-server-cloudimg-amd64.img --update

# Next, we create a Proxmox VM template.
# Change values for your bridge and storage and change defaults to your liking.
qm create 9000 --name "ubuntu-24.04-template" --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0
qm importdisk 9000 ubuntu-24.04-server-cloudimg-amd64.img zfs
qm set 9000 --scsihw virtio-scsi-pci --scsi0 local-zfs:vm-9000-disk-0
qm set 9000 --boot c --bootdisk scsi0
qm set 9000 --ide2 local-zfs:cloudinit
qm set 9000 --serial0 socket --vga serial0
qm set 9000 --agent enabled=1
qm template 9000

# Now we can create new VMs by cloning this template or reference it with Terraform Proxmox etc.
# Login with SSH only possible with user "ubuntu" and SSH keys specified in cloudinit image.
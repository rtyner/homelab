# creating vm images with cloud-init

- https://registry.terraform.io/modules/sdhibit/cloud-init-vm/proxmox/latest/examples/ubuntu_single_vm
- https://matthewkalnins.com/posts/home-lab-setup-part-1-proxmox-cloud-init/
- https://www.cyberciti.biz/faq/how-to-add-ssh-public-key-to-qcow2-linux-cloud-images-using-virt-sysprep/
- https://austinsnerdythings.com/2021/08/30/how-to-create-a-proxmox-ubuntu-cloud-init-image/  

- download cloud image 
```bash
wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img
```
- can edit the img and install packages
```bash
sudo virt-customize -a focal-server-cloudimg-amd64.img --install qemu-guest-agent
```
- create vm from cloud image
```shell
mkdir cloud-images
cd cloud-images/
wget https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.img
sudo qm create 9000 --memory 2048 --core 2 --name ubuntu-cloud --net0 virtio,bridge=vmbr0
sudo qm disk import 9000 ubuntu-24.04-server-cloudimg-amd64.img local-zfs
sudo qm set 9000 --scsihw virtio-scsi-pci --scsi0 local-zfs:vm-9000-disk-0
sudo qm set 9000 --ide2 local-zfs:cloudinit
sudo qm set 9000 --boot c --bootdisk scsi0
sudo qm set 9000 --serial0 socket --vga serial0
sudo qm template 9000
```

- set pw for cloud image
```bash
virt-customize -a focal-server-cloudimg-amd64.img --root-password password:PASSWORD
```
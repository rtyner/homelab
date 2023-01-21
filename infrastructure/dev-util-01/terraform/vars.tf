#Set your public SSH key here
variable "ssh_key" {
  default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOexRWaRt+sGaH/edtNHmaTGxsQQxwxw0z/5VsAos3RJ"
}
#Establish which Proxmox host you'd like to spin a VM up on
variable "proxmox_host" {
    default = "pve-1"
}
#Specify which template name you'd like to use
variable "template_name" {
    default = "win-22-dc-template"
}
#Establish which nic you would like to utilize
variable "nic_name" {
    default = "vmbr0"
}

variable "api_url" {
    default = "https://10.1.1.2:8006/api2/json"
}
#Blank var for use by terraform.tfvars
variable "token_secret" {
}
#Blank var for use by terraform.tfvars
variable "token_id" {
}
# variables.tf
variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  default     = "prod-dns-01"
}

variable "memory" {
  description = "RAM in MB"
  type        = number
  default     = 2048  # 8GB
}

variable "vcpu" {
  description = "Number of virtual CPUs"
  type        = number
  default     = 2
}

variable "disk_size" {
  description = "Disk size in bytes"
  type        = number
  default     = 26843545600  # 25GB
}

variable "domain" {
  description = "Domain name for the VM"
  type        = string
  default     = "local.rtyner.com"
}

variable "debian_image_url" {
  description = "URL of the Debian cloud image"
  type        = string
  default     = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"
}

variable "remote_user" {
  description = "Username for the remote libvirt host"
  type        = string
}

variable "remote_host" {
  description = "Hostname or IP of the remote libvirt host"
  type        = string
}
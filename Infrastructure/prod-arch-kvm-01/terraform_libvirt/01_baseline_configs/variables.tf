# variables.tf
variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  default     = "prod-docker-03"
}

variable "memory" {
  description = "RAM in MB"
  type        = number
  default     = 8192  # 8GB
}

variable "vcpu" {
  description = "Number of virtual CPUs"
  type        = number
  default     = 4
}

variable "disk_size" {
  description = "Disk size in bytes"
  type        = number
  default     = 68719476736  # 64GB
}

variable "domain" {
  description = "Domain name for the VM"
  type        = string
  default     = "local"
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
variable "master_count" {
  description = "Number of master nodes"
  type        = number
  default     = 1
}

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 3
}

variable "master_memory" {
  description = "RAM in MB for master nodes"
  type        = number
  default     = 8192 # 8GB
}

variable "worker_memory" {
  description = "RAM in MB for worker nodes"
  type        = number
  default     = 4096 # 4GB
}

variable "master_vcpu" {
  description = "Number of virtual CPUs for master nodes"
  type        = number
  default     = 4
}

variable "worker_vcpu" {
  description = "Number of virtual CPUs for worker nodes"
  type        = number
  default     = 2
}

variable "master_disk_size" {
  description = "Disk size in bytes for master nodes"
  type        = number
  default     = 68719476736 # 64GB
}

variable "worker_disk_size" {
  description = "Disk size in bytes for worker nodes"
  type        = number
  default     = 34359738368 # 32GB
}

variable "domain" {
  description = "Domain name for the VMs"
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
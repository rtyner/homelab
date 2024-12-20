# versions.tf
terraform {
  required_version = ">= 1.0"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.3"
    }
  }
}
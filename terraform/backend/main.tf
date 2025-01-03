# backend/main.tf
terraform {
  backend "gitlab" {
    project        = "username/homelab"
    state_name     = "terraform.tfstate"
    address        = "https://gitlab.local.rtyner.com/api/v4"
    lock_address   = "https://gitlab.local.rtyner.com/api/v4/projects/1/terraform/state/terraform.tfstate/lock"
    unlock_address = "https://gitlab.local.rtyner.com/api/v4/projects/1/terraform/state/terraform.tfstate/lock"
  }
}
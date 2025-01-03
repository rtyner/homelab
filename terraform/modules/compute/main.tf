# modules/compute/main.tf
module "vm" {
  source = "../base"
  
  name         = var.name
  cpu          = var.cpu
  memory       = var.memory
  disk_size    = var.disk_size
  network_conf = var.network_conf
  
  tags = merge(var.tags, {
    environment = var.environment
    role        = var.role
  })
}
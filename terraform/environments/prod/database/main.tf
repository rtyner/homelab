module "postgres_01" {
  source      = "../../../modules/server-roles/postgres"
  vm_name     = "prod-pg-01"
  target_node = "pve-01"
  ip_address  = "10.1.1.15"
}

module "postgres_02" {
  source      = "../../../modules/server-roles/postgres"
  vm_name     = "prod-pg-02"
  target_node = "pve-02"
  ip_address  = "10.1.1.18"
}

resource "hcloud_ssh_key" "default" {
  name       = "hz-e1-dk-prod-01-ssh-key"
  public_key = file(var.ssh_public_key)
}

resource "hcloud_network" "private_network" {
  name     = "hz-e1-net98"
  ip_range = "10.98.1.0/24"
}

resource "hcloud_network_subnet" "private_subnet" {
  network_id   = hcloud_network.private_network.id
  type         = "cloud"
  network_zone = "us-east"
  ip_range     = "10.98.1.0/24"
}

resource "hcloud_firewall" "hz-e1-dk-prod-01-firewall" {
  name = "hz-e1-dk-prod-01-firewall"
  rule {
    direction = "in"
    protocol  = "icmp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = [
      "97.71.208.213/32",
    ]
  }

}

resource "hcloud_server" "debian_vm" {
  name         = "hz-e1-dk-prod-01"
  image        = "debian-12"
  server_type  = "cpx21"
  location     = "ash"
  ssh_keys     = [hcloud_ssh_key.default.id]
  firewall_ids = [hcloud_firewall.hz-e1-dk-prod-01-firewall.id]
  backups      = true 

  network {
    network_id = hcloud_network.private_network.id
    ip         = "10.98.1.10"
  }

  depends_on = [
    hcloud_network_subnet.private_subnet
  ]
}

resource "dns_a_record_set" "vm_records" {
  zone      = "rtyner.com."               # Ensure the zone ends with a dot
  name      = "hz-e1-dk-prod-01"          # Name of the record (without the zone)
  addresses = [hcloud_server.debian_vm.ipv4_address]  # Use the server's public IP
  ttl       = 300

  depends_on = [hcloud_server.debian_vm]
}

output "server_ip" {
  value = hcloud_server.debian_vm.ipv4_address
}
# provider.tf

provider "libvirt" {
  # For local connection use:
  #uri = "qemu+ssh://rt@10.1.1.2/system?known_hosts_verify=ignore"
  uri = "qemu+ssh://rt@10.1.1.2/system?keyfile=${path.cwd}/.ssh/id_ed25519&known_hosts_verify=ignore"
  
  # For remote connection use:
  # uri = "qemu+ssh://username@hostname/system"
  
  # Example for remote:
  # uri = "qemu+ssh://admin@192.168.1.100/system"
}


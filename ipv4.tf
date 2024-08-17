moved {
  from = scaleway_instance_ip.this
  to   = scaleway_instance_ip.public_ipv4
}

moved {
  from = scaleway_instance_ip_reverse_dns.this
  to   = scaleway_instance_ip_reverse_dns.public_ipv4
}

moved {
  from = scaleway_domain_record.ip4
  to   = scaleway_domain_record.ipv4
}

resource "scaleway_instance_ip" "public_ipv4" {
  count = var.enable_public_ipv4 ? 1 : 0

  project_id = var.project_id
  type       = var.routed_ip_enabled ? "routed_ipv4" : "nat"
  zone       = var.zone
}

resource "scaleway_instance_ip_reverse_dns" "public_ipv4" {
  count = var.enable_public_ipv4 && (var.domainname != null) ? 1 : 0

  ip_id   = scaleway_instance_ip.public_ipv4[count.index].id
  reverse = local.effective_fqdn
  zone    = var.zone
}

data "scaleway_instance_private_nic" "this" {
  count = length(var.private_networks)

  server_id          = scaleway_instance_server.this.id
  private_network_id = var.private_networks[count.index]
}


data "scaleway_ipam_ip" "private_ipv4" {
  count = length(var.private_networks)

  type = "ipv4"
  resource {
    id   = data.scaleway_instance_private_nic.this[count.index].id
    type = "instance_private_nic"
  }
}

resource "scaleway_domain_record" "ipv4" {
  count = var.enable_public_ipv4 && (var.domainname != null) ? 1 : length(var.private_networks)

  data     = var.enable_public_ipv4 ? scaleway_instance_server.this.public_ip : data.scaleway_ipam_ip.private_ipv4[count.index].address
  dns_zone = var.domainname
  name     = local.effective_hostname
  type     = "A"
}

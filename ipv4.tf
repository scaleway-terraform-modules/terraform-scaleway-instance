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

resource "scaleway_domain_record" "ipv4" {
  count = var.domainname != null ? 1 : 0

  data     = var.enable_public_ipv4 ? scaleway_instance_server.this.public_ip : scaleway_instance_server.this.private_ip
  dns_zone = var.domainname
  name     = local.effective_hostname
  type     = "A"
}

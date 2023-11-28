moved {
  from = scaleway_domain_record.ip6
  to   = scaleway_domain_record.ipv6
}

resource "scaleway_instance_ip" "ipv6" {
  count = var.enable_ipv6 && var.routed_ip_enabled ? 1 : 0

  project_id = var.project_id
  type       = "routed_ipv6"
  zone       = var.zone
}

resource "scaleway_instance_ip_reverse_dns" "ipv6" {
  count = var.enable_ipv6 && var.routed_ip_enabled && (var.domainname != null) ? 1 : 0

  ip_id   = scaleway_instance_ip.ipv6[count.index].id
  reverse = local.effective_fqdn
  zone    = var.zone
}

resource "scaleway_domain_record" "ipv6" {
  count = var.domainname != null && var.enable_ipv6 && var.state != "stopped" ? 1 : 0

  data     = var.routed_ip_enabled ? one([for item in scaleway_instance_server.this.public_ips[*].address : item if can(regex(":", item))]) : scaleway_instance_server.this.ipv6_address
  dns_zone = var.domainname
  name     = local.effective_hostname
  type     = "AAAA"
}

moved {
  from = scaleway_instance_ip.public_ipv4
  to   = scaleway_instance_ip.this
}

locals {
  requested_fqdn     = (var.name != null && var.dns_zone != null) ? format("%s.%s", var.name, var.dns_zone) : var.name
  effective_hostname = var.dns_zone != null ? trimsuffix(trimsuffix(scaleway_instance_server.this.name, var.dns_zone), ".") : scaleway_instance_server.this.name
  effective_fqdn     = var.dns_zone != null ? format("%s.%s", local.effective_hostname, var.dns_zone) : local.effective_hostname
}

resource "scaleway_instance_ip" "this" {
  count = var.enable_public_ipv4 ? 1 : 0

  project_id = var.project_id
  zone       = var.zone
}

resource "scaleway_instance_ip_reverse_dns" "this" {
  count = var.enable_public_ipv4 && (var.dns_zone != null) ? 1 : 0

  ip_id   = scaleway_instance_ip.this[count.index].id
  reverse = local.effective_fqdn
  zone    = var.zone

  depends_on = [
    scaleway_domain_record.ip4,
  ]
}

resource "scaleway_instance_server" "this" {
  image = var.image
  type  = var.instance_type

  name               = local.requested_fqdn
  placement_group_id = var.placement_group_id
  security_group_id  = var.security_group_id
  tags               = var.tags

  additional_volume_ids = var.additional_volume_ids
  # root_volume           = var.root_volume

  enable_dynamic_ip = var.enable_public_ipv4
  enable_ipv6       = var.enable_ipv6
  ip_id             = var.enable_public_ipv4 == true ? scaleway_instance_ip.this[0].id : null

  dynamic "private_network" {
    for_each = toset(var.private_networks)
    content {
      pn_id = private_network.value
    }
  }

  boot_type     = var.boot_type
  bootscript_id = var.bootscript_id
  state         = var.state
  #  user_data     = var.user_data

  project_id = var.project_id
  zone       = var.zone
}

resource "scaleway_domain_record" "ip4" {
  count = var.dns_zone != null ? 1 : 0

  data     = var.enable_public_ipv4 ? scaleway_instance_server.this.public_ip : scaleway_instance_server.this.private_ip
  dns_zone = var.dns_zone
  name     = local.effective_hostname
  type     = "A"
}

resource "scaleway_domain_record" "ip6" {
  count = var.dns_zone != null && var.enable_ipv6 && var.state != "stopped" ? 1 : 0

  data     = scaleway_instance_server.this.ipv6_address
  dns_zone = var.dns_zone
  name     = local.effective_hostname
  type     = "AAAA"
}

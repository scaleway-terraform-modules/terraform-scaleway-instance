moved {
  from = scaleway_instance_ip.public_ipv4
  to   = scaleway_instance_ip.this
}

locals {
  requested_fqdn     = (var.hostname != null && var.domainname != null) ? format("%s.%s", var.hostname, var.domainname) : var.hostname
  effective_hostname = var.domainname != null ? trimsuffix(trimsuffix(scaleway_instance_server.this.name, var.domainname), ".") : scaleway_instance_server.this.name
  effective_fqdn     = var.domainname != null ? format("%s.%s", local.effective_hostname, var.domainname) : local.effective_hostname
}

resource "scaleway_instance_ip" "this" {
  count = var.enable_public_ipv4 ? 1 : 0

  project_id = var.project_id
  type       = var.routed_ip_enabled ? "routed_ipv4" : "nat"
  zone       = var.zone
}

resource "scaleway_instance_ip_reverse_dns" "this" {
  count = var.enable_public_ipv4 && (var.domainname != null) ? 1 : 0

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

  dynamic "root_volume" {
    for_each = var.root_volume != null ? [1] : []
    content {
      delete_on_termination = var.root_volume["delete_on_termination"]
      size_in_gb            = var.root_volume["size_in_gb"]
      volume_id             = var.root_volume["volume_id"]
      volume_type           = var.root_volume["volume_type"]
    }
  }

  enable_dynamic_ip = var.enable_public_ipv4
  enable_ipv6       = var.enable_ipv6
  ip_id             = var.enable_public_ipv4 == true ? scaleway_instance_ip.this[0].id : null
  routed_ip_enabled = var.routed_ip_enabled

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
  count = var.domainname != null ? 1 : 0

  data     = var.enable_public_ipv4 ? scaleway_instance_server.this.public_ip : scaleway_instance_server.this.private_ip
  dns_zone = var.domainname
  name     = local.effective_hostname
  type     = "A"
}

resource "scaleway_domain_record" "ip6" {
  count = var.domainname != null && var.enable_ipv6 && var.state != "stopped" ? 1 : 0

  data     = scaleway_instance_server.this.ipv6_address
  dns_zone = var.domainname
  name     = local.effective_hostname
  type     = "AAAA"
}

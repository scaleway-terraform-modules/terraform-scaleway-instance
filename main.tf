moved {
  from = scaleway_instance_ip.public_ipv4
  to   = scaleway_instance_ip.this
}

resource "scaleway_instance_ip" "this" {
  count = var.enable_public_ipv4 == true ? 1 : 0
}

resource "scaleway_instance_ip_reverse_dns" "this" {
  count = var.enable_public_ipv4 == true ? 1 : 0

  ip_id   = scaleway_instance_ip.this[count.index].id
  reverse = format("%s.%s", var.name, var.dns_zone)
}

resource "scaleway_instance_server" "this" {
  image = var.image
  type  = var.instance_type

  name               = format("%s.%s", var.name, var.dns_zone)
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
}

resource "scaleway_domain_record" "ip4" {
  data     = var.enable_public_ipv4 == true ? scaleway_instance_server.this.public_ip : scaleway_instance_server.this.private_ip
  dns_zone = var.dns_zone
  name     = var.name
  type     = "A"
}

resource "scaleway_domain_record" "ip6" {
  count = var.enable_ipv6 == true && var.state != "stopped" ? 1 : 0

  data     = scaleway_instance_server.this.ipv6_address
  dns_zone = var.dns_zone
  name     = var.name
  type     = "AAAA"
}

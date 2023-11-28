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
  enable_ipv6       = var.routed_ip_enabled ? null : var.enable_ipv6
  routed_ip_enabled = var.routed_ip_enabled

  ip_ids = tolist([
    var.enable_public_ipv4 ? scaleway_instance_ip.public_ipv4[0].id : null,
    var.enable_ipv6 && var.routed_ip_enabled ? scaleway_instance_ip.ipv6[0].id : null,
  ])

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

resource "scaleway_instance_server" "private_server" {
  count = var.enable_ipv4 == true ? 0 : 1
  image             = var.image_name
  type              = var.server_type

  enable_dynamic_ip = false
  enable_ipv6       = var.enable_ipv6
  name              = var.server_name
  state             = var.server_state
  tags              = var.server_tags
}

resource "scaleway_instance_ip" "public_ipv4" {
  count = var.enable_ipv4 == true ? 1 : 0
}

resource "scaleway_instance_server" "public_server" {
  count             = var.enable_ipv4 == true ? 1 : 0
  image             = var.image_name
  type              = var.server_type

  enable_dynamic_ip = false
  enable_ipv6       = var.enable_ipv6
  ip_id             = scaleway_instance_ip.public_ipv4[count.index].id
  name              = var.server_name
  state             = var.server_state
  tags              = var.server_tags
}

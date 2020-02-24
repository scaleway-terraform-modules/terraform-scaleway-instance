resource "scaleway_instance_server" "instance_with_ip" {
  count       = var.enable_ipv4 == true ? 1 : 0
  enable_ipv6 = var.enable_ipv6
  image       = var.image_name
  ip_id       = var.public_ipv4
  name        = var.server_name
  state       = var.server_state
  type        = var.server_type
}

resource "scaleway_instance_server" "server_without_ip" {
  count       = var.enable_ipv4 == true ? 0 : 1
  enable_ipv6 = var.enable_ipv6
  image       = var.image_name
  name        = var.server_name
  state       = var.server_state
  type        = var.server_type
}

resource "scaleway_instance_ip" "public_ipv4" {
  count     = var.enable_ipv4 == true ? 1 : 0
}

resource "scaleway_instance_server" "server" {
  enable_ipv6 = var.enable_ipv6
  image       = var.image_name
  name        = var.server_name
  state       = var.server_state
  type        = var.server_type
}

resource "scaleway_instance_ip" "public_ipv4" {
  count     = var.enable_ipv4 == true ? 1 : 0
  server_id = scaleway_server.server.id
}

output "ip4" {
  description = "IPv4 address of the intance."
  value       = var.enable_public_ipv4 ? scaleway_instance_ip.public_ipv4[0].address : scaleway_instance_server.this.private_ip
}

output "ip6" {
  description = "IPv6 address of the instance."
  value       = var.enable_ipv6 ? one([for item in scaleway_instance_server.this.public_ips[*].address : item if can(regex(":", item))]) : scaleway_instance_server.this.ipv6_address
}

output "name" {
  description = "Name of the instance."
  value       = scaleway_instance_server.this.name
}

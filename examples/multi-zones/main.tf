locals {
  perco_masters = {
    "0" = {
      name = "instance-0"
      zone = "fr-par-1"
    }
    "1" = {
      name = "instance-1"
      zone = "fr-par-2"
    }
  }
  unique_zones = toset([
    for instance in local.perco_masters : instance.zone
  ])
}

module "instances" {
  source  = "scaleway-terraform-modules/instance/scaleway"
  version = "3.2.1"

  for_each = local.perco_masters

  instance_type = "PLAY2-NANO" # 2 vCPU, 8GB RAM
  image         = "debian_bookworm"

  # Network
  private_networks  = []
  security_group_id = scaleway_instance_security_group.perco_master_security_group[each.value.zone].id
  zone              = each.value.zone

  additional_volume_ids = null

  # Naming
  hostname = each.value.name

  # IPs
  enable_ipv6        = false
  enable_public_ipv4 = true
}

resource "scaleway_instance_security_group" "perco_master_security_group"{
  for_each = local.unique_zones

  name = "instance-sg"

  # Default policies - drop everything except explicitly allowed
  inbound_default_policy  = "drop"
  outbound_default_policy = "accept"
  zone                    = each.value

  inbound_rule {
    action   = "accept"
    port     = 22
    ip_range = "0.0.0.0/22"
  }

  # Outbound rules - allow all traffic out
  outbound_rule {
    action     = "accept"
    port_range = "1-65535"
    ip_range   = "0.0.0.0/0"
  }

  outbound_rule {
    action     = "accept"
    protocol   = "UDP"
    port_range = "1-65535"
    ip_range   = "0.0.0.0/0"
  }
}

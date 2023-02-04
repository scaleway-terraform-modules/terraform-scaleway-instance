# Terraform / Scaleway

## Purpose

This repository is used to deploy an instance on scaleway using terraform.

## Usage

- Setup the [scaleway provider](https://www.terraform.io/docs/providers/scaleway/index.html) in your tf file.
- Include this module in your tf file. Refer to [documentation](https://www.terraform.io/docs/modules/sources.html#generic-git-repository).

```hcl
module "my_instance" {
  source  = "scaleway-terraform-modules/instance/scaleway"
  version = "1.0.1"

  instance_type = "PLAY2-PICO"
  image         = "fr-par-2/3f9ace44-c310-4a9e-b28f-960b9c7fc848"

  name     = "my_instance"
  dns_zone = "example.com"

  enable_ipv6        = false
  enable_public_ipv4 = false
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 0.13 |
| <a name="requirement_scaleway"></a> [scaleway](#requirement_scaleway) | >= 2.2.0 |

## Resources

| Name | Type |
|------|------|
| [scaleway_domain_record.ip4](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/domain_record) | resource |
| [scaleway_domain_record.ip6](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/domain_record) | resource |
| [scaleway_instance_ip.this](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/instance_ip) | resource |
| [scaleway_instance_ip_reverse_dns.this](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/instance_ip_reverse_dns) | resource |
| [scaleway_instance_server.this](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/instance_server) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_image"></a> [image](#input_image) | UUID or the label of the base image used by the server. | `string` | n/a | yes |
| <a name="input_additional_volume_ids"></a> [additional_volume_ids](#input_additional_volume_ids) | Additional volumes attached to the server. Updates to this field will trigger a stop/start of the server. | `list(string)` | `[]` | no |
| <a name="input_boot_type"></a> [boot_type](#input_boot_type) | The boot Type of the server. Default to 'local'. Possible values are: 'local', 'bootscript' or 'rescue'. | `string` | `"local"` | no |
| <a name="input_bootscript_id"></a> [bootscript_id](#input_bootscript_id) | ID of the bootscript to use (set boot_type to bootscript). | `string` | `null` | no |
| <a name="input_dns_zone"></a> [dns_zone](#input_dns_zone) | DNS Zone of the domain. | `string` | `null` | no |
| <a name="input_enable_ipv6"></a> [enable_ipv6](#input_enable_ipv6) | Determines if IPv6 is enabled for the server. | `bool` | `false` | no |
| <a name="input_enable_public_ipv4"></a> [enable_public_ipv4](#input_enable_public_ipv4) | Determines if a public IPv4 will be attached to the server. | `bool` | `false` | no |
| <a name="input_instance_type"></a> [instance_type](#input_instance_type) | Commercial type of the server. Default to 'DEV1-S'. Updates to this field will recreate a new resource. | `string` | `"DEV1-S"` | no |
| <a name="input_name"></a> [name](#input_name) | Name of the server. | `string` | `null` | no |
| <a name="input_placement_group_id"></a> [placement_group_id](#input_placement_group_id) | ID of the placement group the server is attached to. | `string` | `null` | no |
| <a name="input_private_networks"></a> [private_networks](#input_private_networks) | Private networks associated with the server. | `list(string)` | `[]` | no |
| <a name="input_security_group_id"></a> [security_group_id](#input_security_group_id) | ID of the security group the server is attached to. | `string` | `null` | no |
| <a name="input_state"></a> [state](#input_state) | State of the server. Default to 'started'. Possible values are: 'started', 'stopped' or 'standby'. | `string` | `"started"` | no |
| <a name="input_tags"></a> [tags](#input_tags) | Tags associated with the server and dedicated ip address. | `list(any)` | `[]` | no |
<!-- END_TF_DOCS -->

## Authors

Module is maintained with help from [the community](https://github.com/scaleway-terraform-modules/terraform-scaleway-instance/graphs/contributors).

## License

Mozilla Public License 2.0 Licensed. See [LICENSE](https://github.com/scaleway-terraform-modules/.github/tree/master/LICENSE) for full details.

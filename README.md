# Terraform / Scaleway

## Pupose

This repository is used to deploy an instance on scaleway using terraform.

## Usage

- Setup the [scaleway provider](https://www.terraform.io/docs/providers/scaleway/index.html) in your tf file.
- Include this module in your tf file. Refer to [documentation](https://www.terraform.io/docs/modules/sources.html#generic-git-repository).

## Input variables

Use the following variables to setup your instance:

- **enable_ipv4**: If set to true, instance will have a reserved IPv4 public address.
- **enable_ipv6**: If set to true, instance will be reachable using ipv6.
- **image_name**: ID of the image used to start instance. Refer to [API documentation](https://developer.scaleway.com/#images-images-get) for additional details.
- **server_name**: Instance name.
- **server_state**: Indicate if instance should be running or be stopped.
- **server_type**: Instance type.

## Output variables

For now, there's no output variables.

## Known issues

- Default value don't work on ams1.
- Terraform will create a 50gb system disk. As some instance types are restricted to smaller disk, build will fail. Do not use for 'DEV1-S' instances.
- Some instances can't have IPv6 enabled.
- Module don't handle:
  - Additional volumes.
  - Boot options.
  - Security groups.
  - Tags.
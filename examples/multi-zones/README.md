# Multi-Zones Instance Deployment Example

This example demonstrates how to deploy instances across multiple Scaleway availability zones using the `terraform-scaleway-instance` module.

## Overview

This configuration creates two instances in different availability zones (`fr-par-1` and `fr-par-2`) with their respective security groups. This example showcases the module's ability to handle multi-zone deployments correctly, particularly with the fix for the `scaleway_instance_private_nic` data source that now properly includes the zone parameter.

## Architecture

- **Instance 0**: Deployed in `fr-par-1` zone
- **Instance 1**: Deployed in `fr-par-2` zone
- **Security Groups**: One per zone to ensure proper network isolation
- **Instance Type**: PLAY2-NANO (2 vCPU, 8GB RAM)
- **Image**: Debian Bookworm

## Key Features

### Zone-Aware Configuration

The example uses a local configuration to define instances across zones:

```hcl
locals {
  instances = {
    "0" = {
      name = "instance-0"
      zone = "fr-par-1"
    }
    "1" = {
      name = "instance-1"
      zone = "fr-par-2"
    }
  }
}
```

### Dynamic Security Group Creation

Security groups are created dynamically for each unique zone:

```hcl
resource "scaleway_instance_security_group" "instances_security_group" {
  for_each = local.unique_zones
  
  zone = each.value
  # ... other configuration
}
```

## Usage

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Plan the deployment:
   ```bash
   terraform plan
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```

## Files

- `main.tf`: Main configuration with instance and security group definitions
- `versions.tf`: Terraform and provider version constraints
- `mise.toml`: Development environment configuration

This example validates that the module correctly handles multi-zone deployments and demonstrates best practices for zone-aware infrastructure deployment on Scaleway.

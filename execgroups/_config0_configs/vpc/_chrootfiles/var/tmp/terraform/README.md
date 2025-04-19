# AWS VPC Terraform Module

This module creates an AWS Virtual Private Cloud (VPC) with public and private subnets across multiple availability zones, along with the necessary NAT gateways for outbound internet access from private subnets.

## Features

- Creates a VPC with customizable CIDR block
- Automatically creates public and private subnets across all available AZs
- Configurable NAT gateway deployment (single, per-AZ, or none)
- Proper tagging for Kubernetes/EKS compatibility
- Flexible configuration options for different environments

## Usage

```hcl
module "vpc" {
  source = "./path/to/module"
  
  environment        = "dev"
  vpc_name           = "my-vpc"
  main_network_block = "10.0.0.0/16"
  
  vpc_tags = {
    Project = "MyProject"
  }
  
  nat_gw_tags = {
    Project = "MyProject"
  }
  
  cloud_tags = {
    Owner       = "DevOps"
    Provisioner = "Terraform"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| OpenTofu | >= 1.8.8 |
| AWS Provider | >= 4.0 |

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | Environment identifier such as dev, staging, prod | string | n/a | yes |
| aws_default_region | AWS region where resources will be deployed | string | "eu-west-1" | no |
| vpc_name | Name of the VPC to be created | string | n/a | yes |
| main_network_block | Base CIDR block to be used in the VPC (e.g., 10.0.0.0/16) | string | n/a | yes |
| subnet_prefix_extension | CIDR block bits extension to calculate CIDR blocks of each subnetwork | number | 4 | no |
| zone_offset | CIDR block bits extension offset to calculate Public subnets, avoiding collisions with Private subnets | number | 8 | no |
| enable_nat_gateway | Should be true if you want to provision NAT Gateways for each of your private networks | bool | true | no |
| single_nat_gateway | Should be true if you want to provision a single shared NAT Gateway across all of your private networks | bool | true | no |
| enable_dns_hostnames | Should be true to enable DNS hostnames in the VPC | bool | true | no |
| reuse_nat_ips | Should be true if you don't want EIPs to be created for your NAT Gateways and will instead pass them in | bool | true | no |
| one_nat_gateway_per_az | Should be true if you want only one NAT Gateway per availability zone | bool | false | no |
| vpc_tags | Additional tags to apply to the VPC resources | map(string) | n/a | yes |
| nat_gw_tags | Additional tags to apply to the NAT Gateway resources | map(string) | n/a | yes |
| public_subnet_tags | Additional tags for the public subnets | map(string) | `{ "kubernetes.io/role/elb" : "1" }` | no |
| private_subnet_tags | Additional tags for the private subnets | map(string) | `{ "kubernetes.io/role/internal_elb" : "1" }` | no |
| cloud_tags | Global tags to apply to all resources | map(string) | `{}` | no |

## Outputs

This module doesn't define explicit outputs, but you can access the outputs from the nested VPC module if needed.

## Notes

- By default, this configuration creates a single NAT Gateway for all private subnets to reduce costs, but this introduces a single point of failure. For production environments, consider setting `single_nat_gateway = false` and `one_nat_gateway_per_az = true`.
- The subnet CIDR blocks are calculated automatically based on the provided main network block and extension parameters.

## License

Copyright (C) 2025 Gary Leong <gary@config0.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3 of the License.
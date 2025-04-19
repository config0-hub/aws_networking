# NAT Gateway Module

This module creates an AWS NAT Gateway in a specified public subnet, along with the necessary Elastic IP and route configuration to enable outbound internet access for instances in private subnets.

## Overview

A NAT Gateway allows instances in private subnets to connect to the internet or other AWS services while preventing the internet from initiating connections to those instances. This module:

1. Creates an Elastic IP (EIP) to assign to the NAT Gateway
2. Deploys a NAT Gateway in the specified public subnet
3. Configures a route in the private route table to direct internet traffic through the NAT Gateway

## Usage

```hcl
module "nat_gateway" {
  source                = "./path/to/module"
  public_subnet_id      = "subnet-0123456789abcdef0"
  private_route_table_id = "rtb-0123456789abcdef0"
  nat_gateway_name      = "my-nat-gateway"
  
  cloud_tags = {
    Environment = "Production"
    Project     = "Network Infrastructure"
  }
}
```

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws_default_region | The AWS region where resources will be created | string | "eu-west-1" | no |
| public_subnet_id | The ID of the public subnet where the NAT Gateway will be deployed | string | n/a | yes |
| private_route_table_id | The ID of the private route table that will use the NAT Gateway | string | n/a | yes |
| nat_gateway_name | The name tag to assign to the NAT Gateway | string | n/a | yes |
| cloud_tags | Additional tags as a map to apply to all resources | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| connectivity_type | The connectivity type of the NAT Gateway (public or private) |
| network_interface_id | The ID of the network interface associated with the NAT Gateway |
| private_ip | The private IP address of the NAT Gateway |
| public_ip | The public IP address of the NAT Gateway |
| allocation_id | The allocation ID of the Elastic IP address for the gateway |

## Notes

- This module assumes you already have a VPC with appropriate public and private subnets configured.
- NAT Gateways incur AWS charges as long as they are running. Refer to AWS pricing for details.
- Each NAT Gateway is created in a specific Availability Zone and is implemented with redundancy within that zone.

## License

Copyright (C) 2025 Gary Leong <gary@config0.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3 of the License.
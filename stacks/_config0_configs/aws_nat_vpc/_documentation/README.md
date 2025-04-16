# AWS NAT Gateway

## Description
This stack creates an AWS NAT Gateway in a public subnet and configures it for private subnet routing.

## Variables

### Required

| Name | Description | Default |
|------|-------------|---------|
| nat_gateway_name | Identifier for the NAT Gateway | |
| public_subnet_ids | Public subnet IDs for NAT Gateway placement | |
| private_route_table_id | Private route table ID for NAT Gateway configuration | |

### Optional

| Name | Description | Default |
|------|-------------|---------|
| aws_default_region | Default AWS region | eu-west-1 |
| timeout | Configuration for timeout | 600 |

## Features
- Creates a NAT Gateway in the first available public subnet
- Configures routing for private subnets through the NAT Gateway
- Provides outputs for NAT Gateway properties including public IP and connectivity type

## Dependencies

### Substacks
- [config0-publish:::tf_executor](https://api-app.config0.com/web_api/v1.0/stacks/config0-publish/tf_executor)

### Execgroups
- [config0-publish:::aws_networking::natgw_vpc](https://api-app.config0.com/web_api/v1.0/exec/groups/config0-publish/aws_networking/natgw_vpc)

## License
Copyright (C) 2025 Gary Leong <gary@config0.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3 of the License.
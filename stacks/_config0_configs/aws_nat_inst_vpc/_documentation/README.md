# AWS NAT Instance with Auto Scaling Group

## Description
This stack creates a NAT instance using an Auto Scaling Group (ASG) in an AWS VPC. The NAT instance allows private subnets to access the internet while maintaining security by preventing direct inbound access from the internet to those private instances.

## Variables

### Required Variables

| Name | Description | Default |
|------|-------------|---------|
| service_name | NAT instance service name | |
| vpc_id | VPC network identifier | |
| public_subnet_ids | Public subnet IDs where NAT instance will be deployed | |
| private_route_table_id | Private route table ID for routing through NAT | |

### Optional Variables

| Name | Description | Default |
|------|-------------|---------|
| instance_types | EC2 instance types for NAT instance | t3.nano,t3a.nano,t3.micro,t3a.micro,t3.small,t3a.small |
| cidr_ingress_accept | Allowed CIDR blocks for NAT traffic | 10.0.0.0/16,10.10.0.0/16,10.20.0.0/16,10.30.0.0/16 |
| ssh_key_name | SSH key identifier for resource access | null |
| aws_default_region | Default AWS region | eu-west-1 |
| timeout | Configuration for timeout | 600 |

## Features
- Deploys NAT instance in an Auto Scaling Group for high availability
- Uses configurable instance types for cost optimization
- Configurable CIDR blocks for traffic control
- Attaches to public subnet for internet access
- Routes private subnet traffic through NAT instance

## Dependencies

### Substacks
- [config0-publish:::tf_executor](https://api-app.config0.com/web_api/v1.0/stacks/config0-publish/tf_executor)

### Execgroups
- [config0-publish:::aws_networking::nat_inst_vpc](https://api-app.config0.com/web_api/v1.0/exec/groups/config0-publish/aws_networking/nat_inst_vpc)

## License
Copyright (C) 2025 Gary Leong <gary@config0.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3 of the License.













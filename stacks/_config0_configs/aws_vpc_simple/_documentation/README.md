# AWS VPC with Security Groups

## Description
This stack creates an AWS Virtual Private Cloud (VPC) with appropriate security groups. It supports optional EKS cluster configuration by adding the necessary tags to the VPC and subnets.

## Variables

### Required Variables

| Name | Description | Default |
|------|-------------|---------|
| vpc_name | VPC network name | |

### Optional Variables

| Name | Description | Default |
|------|-------------|---------|
| tier_level | Configuration for tier level | |
| vpc_id | VPC network identifier | null |
| eks_cluster | EKS cluster name | |
| aws_default_region | Default AWS region | eu-west-1 |

## Features
- Creates a new AWS VPC with the specified name
- Configures public and private subnets
- Sets up appropriate tags for EKS cluster integration when specified
- Creates and configures security groups for the VPC
- Supports optional tier levels for security group configuration

## Dependencies

### Substacks
- [config0-publish:::tf_executor](https://api-app.config0.com/web_api/v1.0/stacks/config0-publish/tf_executor)
- [config0-publish:::aws_sg](https://api-app.config0.com/web_api/v1.0/stacks/config0-publish/aws_sg)

### Execgroups
- [config0-publish:::aws_networking::vpc_simple](https://api-app.config0.com/web_api/v1.0/exec/groups/config0-publish/aws_networking/vpc_simple)

## License
Copyright (C) 2025 Gary Leong <gary@config0.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3 of the License.
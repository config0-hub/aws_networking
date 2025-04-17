# AWS 3-Tier Security Groups

## Description
This stack creates a set of security groups for a three-tier architecture in AWS, organizing them based on the VPC provided. The stack establishes security groups for bastion, web, API, and database tiers, enabling proper network segmentation and access control.

## Variables

### Required Variables

| Name | Description | Default |
|------|-------------|---------|
| vpc_name | VPC network name | |
| tier_level | Configuration for tier level | 3 |

### Optional Variables

| Name | Description | Default |
|------|-------------|---------|
| vpc_id | VPC network identifier | null |
| aws_default_region | Default AWS region | eu-west-1 |

## Features
- Creates security groups for a 3-tier architecture
- Supports existing VPC configuration
- Configurable tier level
- Automatically retrieves VPC ID if not provided

## Dependencies

### Substacks
- [config0-publish:::tf_executor](https://api-app.config0.com/web_api/v1.0/stacks/config0-publish/tf_executor)

### Execgroups
- [config0-publish:::aws_networking::sg_3tier](https://api-app.config0.com/web_api/v1.0/exec/groups/config0-publish/aws_networking/sg_3tier)

## License
Copyright (C) 2025 Gary Leong <gary@config0.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3 of the License.












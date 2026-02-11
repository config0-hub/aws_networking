# NAT Instance Module for OpenTofu/Terraform

This module provisions a NAT instance using an Auto Scaling Group with optional spot instances for cost-effective networking in AWS environments.

## Overview

This module sets up:

- An Auto Scaling Group with a single NAT instance (spot or on-demand)
- Security group configuration for NAT functionality
- IAM roles and policies for SSM access and route management
- Route table updates for private subnets

The NAT instance provides outbound internet access for instances in private subnets at a significantly lower cost than managed NAT Gateways, especially when using spot instances.

## Usage

```hcl
module "nat_instance" {
  source = "path/to/module"

  service_name               = "myapp"
  vpc_id                     = "vpc-12345678"
  public_subnet_id           = "subnet-12345678"
  private_cidr_ingress_accept = ["10.0.0.0/8"]
  route_table_private_ids    = ["rtb-12345678"]
  
  # Optional parameters
  use_spot_instance          = true
  ssh_key_name               = "my-key-pair"
  instance_types             = ["t3.nano", "t3a.nano"]
  cloud_tags = {
    Environment = "Production"
  }
}
```

## Requirements

- OpenTofu >= 1.8.8 or Terraform >= 1.0
- AWS provider

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws_default_region | AWS Region for the resources | `string` | `"us-east-1"` | no |
| cloud_tags | Additional tags to apply to all resources created by this module | `map(string)` | `{}` | no |
| enabled | Whether to enable the NAT instance (resources will still be created but ASG will have 0 instances if false) | `bool` | `true` | no |
| host_ip | Host IP address (last octet) of NAT instance | - | `null` | no |
| image_id | AMI ID for the NAT instance (defaults to latest Amazon Linux 2 if not specified) | `string` | `""` | no |
| instance_types | List of EC2 instance types to use in the mixed instances policy (in order of preference) | `list(string)` | `["t3.nano", "t3a.nano", "t3.micro", "t3a.micro", "t3.small", "t3a.small"]` | no |
| private_cidr_ingress_accept | List of CIDR blocks allowed to connect to the NAT instance | `list(string)` | - | yes |
| public_subnet_id | ID of the public subnet where the NAT instance will be placed | `string` | - | yes |
| route_table_private_ids | List of route table IDs for private subnets that will use the NAT instance as their gateway | `list(string)` | `[]` | no |
| service_name | Name of the service/component for resource naming and tagging | `string` | - | yes |
| ssh_key_name | Name of the EC2 key pair to assign to the NAT instance for SSH access | `string` | `""` | no |
| ssm_policy_arn | ARN of the IAM policy for AWS Systems Manager to be attached to the instance profile | `string` | `"arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"` | no |
| use_spot_instance | Whether to use spot instances (lower cost but may be terminated) or on-demand instances | `bool` | `true` | no |
| user_data_runcmd | Additional commands to run via cloud-init (see cloud-init runcmd documentation for format) | `list(list(string))` | `[]` | no |
| user_data_write_files | Additional files to write via cloud-init (see cloud-init write_files documentation for format) | `list(any)` | `[]` | no |
| vpc_id | ID of the VPC where the NAT instance will be deployed | `string` | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| arn | ARN of the Auto Scaling Group for the NAT instance |

## Warning

While this module provides a cost-effective alternative to NAT Gateways, it comes with several trade-offs:

1. Single point of failure (unless you deploy multiple NAT instances in different AZs)
2. Limited bandwidth compared to NAT Gateways
3. When using spot instances, potential for interruption

Consider using AWS-managed NAT Gateways for production workloads where reliability is more important than cost.

## License

Copyright (C) 2025 Gary Leong <gary@config0.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3 of the License.
# AWS Network Security Groups Module

This Terraform/OpenTofu module creates a set of security groups designed for a layered application architecture:

- **Bastion**: Entry point for administrative access
- **Web**: Public-facing web servers
- **API**: Internal API servers
- **Database**: Backend database servers

## Architecture

The security groups are designed to enforce a layered security model:

1. The Bastion layer allows SSH access from the internet
2. Web layer allows HTTP/HTTPS from the internet and SSH from the Bastion layer
3. API layer only allows traffic from the Web layer and SSH from the Bastion layer
4. Database layer only allows traffic from the API layer and SSH from the Bastion layer

## Usage

```hcl
module "security_groups" {
  source = "path/to/module"

  vpc_id   = "vpc-1234567890abcdef0"
  vpc_name = "my-vpc"
  
  cloud_tags = {
    Environment = "Production"
    Project     = "MyApp"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_id | ID of the VPC where security groups will be created | `string` | n/a | yes |
| vpc_name | Name of the VPC where security groups will be created | `string` | n/a | yes |
| aws_default_region | Default AWS region for resource deployment | `string` | `"us-east-1"` | no |
| cloud_tags | Additional tags to apply to all resources as a map | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| bastion_sg_id | ID of the bastion security group |
| web_sg_id | ID of the web security group |
| api_sg_id | ID of the API security group | 
| db_sg_id | ID of the database security group |

## Security Considerations

- The Bastion security group allows SSH (port 22) access from anywhere (0.0.0.0/0)
- Consider restricting SSH access to specific IP addresses or ranges for production environments
- All security groups include rules that allow all traffic between instances within the same security group

## Requirements

- OpenTofu >= 1.8.8
- AWS Provider

## License

Copyright (C) 2025 Gary Leong <gary@config0.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3 of the License.
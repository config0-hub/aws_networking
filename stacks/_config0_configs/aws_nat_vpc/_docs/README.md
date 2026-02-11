# AWS NAT Gateway

## Description
This stack creates an AWS NAT Gateway in a public subnet and configures it for private subnet routing.

## Variables

### Required

| Name | Description | Default |
|------|-------------|---------|
| nat_gateway_name | Identifier for the NAT Gateway | &nbsp; |
| public_subnet_ids | Public subnet IDs for NAT Gateway placement | &nbsp; |
| private_route_table_id | Private route table ID for NAT Gateway configuration | &nbsp; |

### Optional

| Name | Description | Default |
|------|-------------|---------|
| aws_default_region | Default AWS region | eu-west-1 |
| timeout | Configuration for timeout | 600 |

## Dependencies

### Substacks
- [config0-publish:::tf_executor](http://config0.http.redirects.s3-website-us-east-1.amazonaws.com/assets/stacks/config0-publish/tf_executor/default)

### Execgroups
- [config0-publish:::aws_networking::natgw_vpc](http://config0.http.redirects.s3-website-us-east-1.amazonaws.com/assets/exec/groups/config0-publish/aws_networking/natgw_vpc/default)

### Shelloutconfigs
- [config0-publish:::terraform::resource_wrapper](http://config0.http.redirects.s3-website-us-east-1.amazonaws.com/assets/shelloutconfigs/config0-publish/terraform/resource_wrapper/default)

## License
<pre>
Copyright (C) 2025 Gary Leong <gary@config0.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3 of the License.
</pre>
# AWS NAT Instance with Auto Scaling Group

## Description
This stack creates a NAT instance using an Auto Scaling Group (ASG) in an AWS VPC. The NAT instance allows private subnets to access the internet while maintaining security by preventing direct inbound access from the internet to those private instances.

## Variables

### Required Variables

| Name | Description | Default |
|------|-------------|---------|
| service_name | NAT instance service name | &nbsp; |
| vpc_id | VPC network identifier | &nbsp; |
| public_subnet_ids | Public subnet IDs where NAT instance will be deployed | &nbsp; |
| private_route_table_id | Private route table ID for routing through NAT | &nbsp; |

### Optional Variables

| Name | Description | Default |
|------|-------------|---------|
| instance_types | EC2 instance types for NAT instance | t3.nano,t3a.nano,t3.micro,t3a.micro,t3.small,t3a.small |
| cidr_ingress_accept | Allowed CIDR blocks for NAT traffic | 10.0.0.0/16,10.10.0.0/16,10.20.0.0/16,10.30.0.0/16 |
| ssh_key_name | SSH key identifier for resource access | null |
| aws_default_region | Default AWS region | eu-west-1 |
| timeout | Configuration for timeout | 600 |

## Dependencies

### Substacks
- [config0-publish:::tf_executor](http://config0.http.redirects.s3-website-us-east-1.amazonaws.com/assets/stacks/config0-publish/tf_executor/default)

### Execgroups
- [config0-publish:::aws_networking::nat_inst_vpc](http://config0.http.redirects.s3-website-us-east-1.amazonaws.com/assets/exec/groups/config0-publish/aws_networking/nat_inst_vpc/default)

### Shelloutconfigs
- [config0-publish:::terraform::resource_wrapper](http://config0.http.redirects.s3-website-us-east-1.amazonaws.com/assets/shelloutconfigs/config0-publish/terraform/resource_wrapper/default)

## License
<pre>
Copyright (C) 2025 Gary Leong <gary@config0.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3 of the License.
</pre>
# AWS VPC with Security Groups

## Description
This stack creates an AWS Virtual Private Cloud (VPC) with appropriate security groups. It supports optional EKS cluster configuration by adding the necessary tags to the VPC and subnets.

## Variables

### Required Variables

| Name | Description | Default |
|------|-------------|---------|
| vpc_name | VPC network name | &nbsp; |

### Optional Variables

| Name | Description | Default |
|------|-------------|---------|
| tier_level | Configuration for tier level | &nbsp; |
| vpc_id | VPC network identifier | null |
| eks_cluster | EKS cluster name | &nbsp; |
| aws_default_region | Default AWS region | eu-west-1 |

## Dependencies

### Substacks
- [config0-publish:::tf_executor](http://config0.http.redirects.s3-website-us-east-1.amazonaws.com/assets/stacks/config0-publish/tf_executor/default)
- [config0-publish:::aws_sg](http://config0.http.redirects.s3-website-us-east-1.amazonaws.com/assets/stacks/config0-publish/aws_sg/default)

### Execgroups
- [config0-publish:::aws_networking::vpc_simple](http://config0.http.redirects.s3-website-us-east-1.amazonaws.com/assets/exec/groups/config0-publish/aws_networking/vpc_simple/default)

### Shelloutconfigs
- [config0-publish:::terraform::resource_wrapper](http://config0.http.redirects.s3-website-us-east-1.amazonaws.com/assets/shelloutconfigs/config0-publish/terraform/resource_wrapper/default)
- [config0-publish:::github::lambda_trigger_stepf](http://config0.http.redirects.s3-website-us-east-1.amazonaws.com/assets/shelloutconfigs/config0-publish/github/lambda_trigger_stepf/default)

## License
<pre>
Copyright (C) 2025 Gary Leong <gary@config0.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3 of the License.
</pre>
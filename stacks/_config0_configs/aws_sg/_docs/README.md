# AWS 3-Tier Security Groups

## Description
This stack creates a set of security groups for a three-tier architecture in AWS, organizing them based on the VPC provided. The stack establishes security groups for bastion, web, API, and database tiers, enabling proper network segmentation and access control.

The Config0 resource is recorded as `<sg_name>-security-groups` and the four AWS groups are named `<sg_name>-bastion`, `<sg_name>-web`, `<sg_name>-api`, and `<sg_name>-database`. `sg_name` defaults to `vpc_name`, so with no `sg_name` the names are `<vpc_name>-security-groups` and `<vpc_name>-bastion|web|api|database`.

### Owning your own security groups in a VPC that already has some
AWS security-group names are unique inside a VPC, and Config0 refuses to create a resource whose name already exists. The `aws_vpc_simple` stack already runs this stack once for every VPC it creates, under the VPC's name. A project that needs its own set of groups inside such a VPC (for example, a project that replays its own security-group Terraform and wants Config0 to record and export those groups as its own) sets `sg_name` to a name of its own:

```yaml
stacks:
  my_sg:
    stack: config0-hub:::aws_networking::aws_sg
    arguments:
      vpc_name: shared-vpc
      sg_name: my-project
```

This records the resource `my-project-security-groups` and creates the groups `my-project-bastion|web|api|database` next to the VPC's `shared-vpc-*` groups. `vpc_name` stays required: it locates the VPC (when `vpc_id` is not given) and stays on the record.

## Variables

### Required Variables

| Name | Description | Default |
|------|-------------|---------|
| vpc_name | VPC network name | &nbsp; |
| tier_level | Configuration for tier level | 3 |

### Optional Variables

| Name | Description | Default |
|------|-------------|---------|
| vpc_id | VPC network identifier | null |
| aws_default_region | Default AWS region | eu-west-1 |
| sg_name | Base for the resource name and the four security-group names (`<sg_name>-security-groups`, `<sg_name>-bastion|web|api|database`). Set it when the VPC already carries another set of these groups. | vpc_name |

## Dependencies

### Substacks
- [config0-hub:::config0_core::tf_executor](http://config0.http.redirects.s3-website-us-east-1.amazonaws.com/assets/stacks/config0-hub/tf_executor/default)

### Execgroups
- [config0-hub:::aws_networking::sg_3tier](http://config0.http.redirects.s3-website-us-east-1.amazonaws.com/assets/exec/groups/config0-hub/aws_networking/sg_3tier/default)

### Scripts
- [config0-hub:::terraform::resource_wrapper](http://config0.http.redirects.s3-website-us-east-1.amazonaws.com/assets/scripts/config0-hub/terraform/resource_wrapper/default)

## License
<pre>
Copyright (C) 2025 Gary Leong <gary@config0.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3 of the License.
</pre>
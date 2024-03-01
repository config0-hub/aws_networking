**Description**

  - This adds an AWS Nat Gateway to an existing VPC.

**Infrastructure**

  - expects an existing VPC/security groups created by Config0 (e.g. config0-publish:::aws_vpc_simple)
  - the public (not private) subnet id needs to be used
  - the private (not public) route table id needs to be used

**Required**

| argument               | description                                      | var type | default      |
|------------------------|--------------------------------------------------| -------- | ------------ |
| private_route_table_id | the private route table to associate with NAT gw | string   | None         |
| public_subnet_id      | the public subnet id to attached to nat gateway | string   | None         |

**Sample launch - simple**


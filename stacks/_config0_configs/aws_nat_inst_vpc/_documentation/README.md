**Description**

  - This adds an AWS Nat Instance to an existing VPC.

**Infrastructure**

  - expects an existing VPC/security groups created by Config0 (e.g. config0-publish:::aws_vpc_simple)
  - the public (not private) subnet id needs to be used
  - the private (not public) route table id needs to be used

**Required**

| argument               | description                                                                     | var type           | default |
|------------------------|---------------------------------------------------------------------------------|--------------------|---------|
| service_name           | the name of the nat instance service                                            | string             | None    | 
| vpc_id                 | the vpc id for the nat instance                                                 | string             | None |
| instance_types         | the list of instance types in the autoscaling group                             | list in string csv | None|
| cidr_ingress_accept    | the list of cidrs to accept by the nat for traffice                             | list in string csv | None|
| public_subnet_ids      | the public subnet ids to attached to nat gateway (only one will be selected)    | string             | None    |
| private_route_table_id | the private route table to associate with NAT gw                                | string             | None    |
| ssh_key_name           | the ssh key name used for the instance | string             | None    |

**Sample launch - simple**


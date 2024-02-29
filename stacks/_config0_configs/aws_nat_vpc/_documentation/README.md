**Description**

  - The stack adds a NAT to an existing VPC

**Infrastructure**

  - expects an existing VPC/security groups created by Config0 (e.g. config0-publish:::aws_vpc_simple)

**Required**

| argument      | description                            | var type | default      |
| ------------- | -------------------------------------- | -------- | ------------ |
| route_table_id   | the route table to add the NAT route             | string   | None         |
| subnet_ids   | the subnet_ids separated by comma - csv | string   | None         |

**Sample launch - simple**


# AWS VPC Peering Request

## Description

This stack creates requester VPC-B and its main route table in the default AWS account, verifies accepter VPC-A through an aliased AWS provider, and creates the cross-account VPC peering request.

The Terraform boundary passes the live peer credentials as `TF_VAR_AWS_ACCESS_KEY_ID_PEER`, `TF_VAR_AWS_SECRET_ACCESS_KEY_PEER`, and `TF_VAR_AWS_SESSION_TOKEN_PEER`. The aliased provider consumes the matching sensitive Terraform variables without storing their values in stack order data.

## Required variables

- `vpc_peering_name`
- `vpc_b_name`
- `vpc_a_id`
- `vpc_a_account_id`
- `vpc_a_region`

## Optional variables

- `vpc_b_cidr_block` defaults to `10.21.0.0/16`
- `aws_default_region` defaults to `eu-west-1`

## Dependencies

- Stack: `config0-hub:::config0_core::tf_executor`
- Execgroup: `config0-hub:::aws_networking::vpc_peering_request`

## License

GPL-3.0

# AWS VPC Peering Acceptance

## Description

This stack runs in account A. It accepts a pending VPC peering connection and creates VPC-A's route to VPC-B. It promotes the accepted connection and routing inputs needed by the account-B route stack.

## Required variables

- `vpc_peering_name`
- `vpc_peering_connection_id`
- `vpc_a_id`
- `vpc_a_route_table_id`
- `vpc_a_cidr_block`
- `vpc_b_id`
- `vpc_b_route_table_id`
- `vpc_b_cidr_block`

## Optional variables

- `aws_default_region` defaults to `eu-west-1`

## Dependencies

- Stack: `config0-hub:::config0_core::tf_executor`
- Execgroup: `config0-hub:::aws_networking::vpc_peering_accept`

## License

GPL-3.0

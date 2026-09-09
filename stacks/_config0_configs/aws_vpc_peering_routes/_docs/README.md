# AWS VPC Peering Routes

## Description

This stack runs in account B after account A accepts the VPC peering request. It creates VPC-B's route to VPC-A through the accepted peering connection.

## Required variables

- `vpc_peering_name`
- `vpc_peering_connection_id`
- `vpc_b_route_table_id`
- `vpc_a_cidr_block`

## Optional variables

- `aws_default_region` defaults to `eu-west-1`

## Dependencies

- Stack: `config0-hub:::config0_core::tf_executor`
- Execgroup: `config0-hub:::aws_networking::vpc_peering_routes`

## License

GPL-3.0

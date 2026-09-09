resource "aws_route" "to_vpc_a" {
  route_table_id            = var.vpc_b_route_table_id
  destination_cidr_block    = var.vpc_a_cidr_block
  vpc_peering_connection_id = var.vpc_peering_connection_id
}

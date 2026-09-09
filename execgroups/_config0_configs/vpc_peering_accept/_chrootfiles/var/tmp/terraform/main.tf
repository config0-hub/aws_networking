resource "aws_vpc_peering_connection_accepter" "accept" {
  vpc_peering_connection_id = var.vpc_peering_connection_id
  auto_accept               = true

  tags = {
    Name    = var.vpc_peering_name
    Product = "vpc-peering"
  }
}

resource "aws_route" "to_vpc_b" {
  route_table_id            = var.vpc_a_route_table_id
  destination_cidr_block    = var.vpc_b_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.accept.id
}

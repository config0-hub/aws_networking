# NAT Gateway Configuration
# Allows instances in private subnets to connect to the internet

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = var.public_subnet_id
  tags = merge(
    var.cloud_tags,
    {
      Product = "vpc_endpoint"
      Name    = var.nat_gateway_name
    },
  )
}

resource "aws_eip" "nat_eip" {
  domain = "vpc" # Updated from 'vpc = true' to match OpenTofu 1.8.8 standard
}

resource "aws_route" "private_route" {
  route_table_id         = var.private_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}


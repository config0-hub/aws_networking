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
  vpc = true
}

resource "aws_route" "private_route" {
  route_table_id         = var.private_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}

output "connectivity_type" {
  value = aws_nat_gateway.nat_gateway.connectivity_type
}

output "network_interface_id" {
  value = aws_nat_gateway.nat_gateway.network_interface_id
}

output "private_ip" {
  value = aws_nat_gateway.nat_gateway.private_ip
}

output "public_ip" {
  value = aws_nat_gateway.nat_gateway.public_ip
}

output "allocation_id" {
  value = aws_nat_gateway.nat_gateway.allocation_id
}
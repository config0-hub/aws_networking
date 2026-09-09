output "vpc_peering_connection_id" {
  description = "ID of the accepted VPC peering connection"
  value       = var.vpc_peering_connection_id
}

output "vpc_b_route_id" {
  description = "ID of VPC-B's route to VPC-A"
  value       = aws_route.to_vpc_a.id
}

output "vpc_b_route_table_id" {
  description = "ID of VPC-B's route table"
  value       = var.vpc_b_route_table_id
}

output "vpc_a_cidr_block" {
  description = "IPv4 CIDR block of VPC-A"
  value       = var.vpc_a_cidr_block
}

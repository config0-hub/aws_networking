output "vpc_peering_connection_id" {
  description = "ID of the accepted VPC peering connection"
  value       = aws_vpc_peering_connection_accepter.accept.id
}

output "vpc_peering_status" {
  description = "Status of the accepted VPC peering connection"
  value       = aws_vpc_peering_connection_accepter.accept.accept_status
}

output "vpc_a_route_id" {
  description = "ID of VPC-A's route to VPC-B"
  value       = aws_route.to_vpc_b.id
}

output "vpc_a_route_table_id" {
  description = "ID of VPC-A's route table"
  value       = var.vpc_a_route_table_id
}

output "vpc_a_cidr_block" {
  description = "IPv4 CIDR block of VPC-A"
  value       = var.vpc_a_cidr_block
}

output "vpc_a_id" {
  description = "ID of VPC-A"
  value       = var.vpc_a_id
}

output "vpc_b_route_table_id" {
  description = "ID of VPC-B's route table"
  value       = var.vpc_b_route_table_id
}

output "vpc_b_cidr_block" {
  description = "IPv4 CIDR block of VPC-B"
  value       = var.vpc_b_cidr_block
}

output "vpc_b_id" {
  description = "ID of VPC-B"
  value       = var.vpc_b_id
}

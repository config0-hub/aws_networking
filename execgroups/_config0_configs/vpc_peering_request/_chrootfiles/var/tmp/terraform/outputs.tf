output "vpc_b_id" {
  description = "ID of requester VPC-B"
  value       = aws_vpc.requester.id
}

output "vpc_b_cidr_block" {
  description = "IPv4 CIDR block of requester VPC-B"
  value       = aws_vpc.requester.cidr_block
}

output "vpc_b_route_table_id" {
  description = "ID of VPC-B's main route table"
  value       = aws_default_route_table.requester.id
}

output "vpc_a_id" {
  description = "ID of accepter VPC-A"
  value       = data.aws_vpc.peer.id
}

output "vpc_a_cidr_block" {
  description = "IPv4 CIDR block of accepter VPC-A"
  value       = data.aws_vpc.peer.cidr_block
}

output "vpc_a_account_id" {
  description = "AWS account ID that owns accepter VPC-A"
  value       = data.aws_caller_identity.peer.account_id
}

output "vpc_a_region" {
  description = "AWS region containing accepter VPC-A"
  value       = var.vpc_a_region
}

output "vpc_peering_connection_id" {
  description = "ID of the VPC peering connection request"
  value       = aws_vpc_peering_connection.request.id
}

output "vpc_peering_status" {
  description = "Status of the VPC peering connection request"
  value       = aws_vpc_peering_connection.request.accept_status
}

output "connectivity_type" {
  description = "The connectivity type of the NAT Gateway (public or private)"
  value       = aws_nat_gateway.nat_gateway.connectivity_type
}

output "network_interface_id" {
  description = "The ID of the network interface associated with the NAT Gateway"
  value       = aws_nat_gateway.nat_gateway.network_interface_id
}

output "private_ip" {
  description = "The private IP address of the NAT Gateway"
  value       = aws_nat_gateway.nat_gateway.private_ip
}

output "public_ip" {
  description = "The public IP address of the NAT Gateway"
  value       = aws_nat_gateway.nat_gateway.public_ip
}

output "allocation_id" {
  description = "The allocation ID of the Elastic IP address for the gateway"
  value       = aws_nat_gateway.nat_gateway.allocation_id
}
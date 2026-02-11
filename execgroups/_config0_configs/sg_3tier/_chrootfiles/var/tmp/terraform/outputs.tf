output "bastion_sg_id" {
  value       = aws_security_group.bastion.id
  description = "ID of the bastion security group"
}

output "web_sg_id" {
  value       = aws_security_group.web.id
  description = "ID of the web security group"
}

output "api_sg_id" {
  value       = aws_security_group.api.id
  description = "ID of the API security group"
}

output "db_sg_id" {
  value       = aws_security_group.database.id
  description = "ID of the database security group"
}


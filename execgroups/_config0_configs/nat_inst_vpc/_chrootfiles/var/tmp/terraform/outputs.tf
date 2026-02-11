output "arn" {
  description = "ARN of the Auto Scaling Group for the NAT instance"
  value       = aws_autoscaling_group.default.arn
}


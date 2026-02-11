variable "aws_default_region" {
  description = "The AWS region where resources will be created"
  type        = string
  default     = "eu-west-1"
}

variable "public_subnet_id" {
  description = "The ID of the public subnet where the NAT Gateway will be deployed"
  type        = string
}

variable "private_route_table_id" {
  description = "The ID of the private route table that will use the NAT Gateway"
  type        = string
}

variable "nat_gateway_name" {
  description = "The name tag to assign to the NAT Gateway"
  type        = string
}

variable "cloud_tags" {
  description = "Additional tags as a map to apply to all resources"
  type        = map(string)
  default     = {}
}


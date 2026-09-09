variable "aws_default_region" {
  type        = string
  description = "AWS region containing requester VPC-B"
}

variable "vpc_peering_name" {
  type        = string
  description = "Name of the VPC peering connection"
}

variable "vpc_peering_connection_id" {
  type        = string
  description = "ID of the accepted VPC peering connection"
}

variable "vpc_b_route_table_id" {
  type        = string
  description = "ID of VPC-B's route table"
}

variable "vpc_a_cidr_block" {
  type        = string
  description = "IPv4 CIDR block of VPC-A"
}

variable "cloud_tags" {
  type        = map(string)
  description = "Tags applied to managed AWS resources"
  default     = {}
}

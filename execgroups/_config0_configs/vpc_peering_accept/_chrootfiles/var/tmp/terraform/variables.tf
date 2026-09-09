variable "aws_default_region" {
  type        = string
  description = "AWS region containing accepter VPC-A"
}

variable "vpc_peering_name" {
  type        = string
  description = "Name tag for the accepted VPC peering connection"
}

variable "vpc_peering_connection_id" {
  type        = string
  description = "ID of the pending VPC peering connection"
}

variable "vpc_a_id" {
  type        = string
  description = "ID of accepter VPC-A"
}

variable "vpc_a_route_table_id" {
  type        = string
  description = "ID of VPC-A's route table"
}

variable "vpc_a_cidr_block" {
  type        = string
  description = "IPv4 CIDR block of VPC-A"
}

variable "vpc_b_id" {
  type        = string
  description = "ID of requester VPC-B"
}

variable "vpc_b_route_table_id" {
  type        = string
  description = "ID of VPC-B's route table"
}

variable "vpc_b_cidr_block" {
  type        = string
  description = "IPv4 CIDR block of VPC-B"
}

variable "cloud_tags" {
  type        = map(string)
  description = "Tags applied to managed AWS resources"
  default     = {}
}

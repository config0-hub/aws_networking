variable "aws_default_region" {
  type        = string
  description = "AWS region containing requester VPC-B"
}

variable "vpc_peering_name" {
  type        = string
  description = "Name tag for the VPC peering connection"
}

variable "vpc_b_name" {
  type        = string
  description = "Name tag for requester VPC-B"
}

variable "vpc_b_cidr_block" {
  type        = string
  description = "IPv4 CIDR block for requester VPC-B"
}

variable "vpc_a_id" {
  type        = string
  description = "ID of accepter VPC-A"
}

variable "vpc_a_account_id" {
  type        = string
  description = "AWS account ID that owns accepter VPC-A"
}

variable "vpc_a_region" {
  type        = string
  description = "AWS region containing accepter VPC-A"
}

variable "AWS_ACCESS_KEY_ID_PEER" {
  type        = string
  description = "Access key for the VPC-A account's aliased AWS provider"
  sensitive   = true
}

variable "AWS_SECRET_ACCESS_KEY_PEER" {
  type        = string
  description = "Secret key for the VPC-A account's aliased AWS provider"
  sensitive   = true
}

variable "AWS_SESSION_TOKEN_PEER" {
  type        = string
  description = "Session token for the VPC-A account's aliased AWS provider"
  sensitive   = true
}

variable "cloud_tags" {
  type        = map(string)
  description = "Tags applied to managed AWS resources"
  default     = {}
}

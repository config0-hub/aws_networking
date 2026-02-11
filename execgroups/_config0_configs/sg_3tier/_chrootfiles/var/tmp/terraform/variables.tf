variable "vpc_name" {
  type        = string
  description = "Name of the VPC where security groups will be created"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC where security groups will be created"
}

variable "aws_default_region" {
  type        = string
  description = "Default AWS region for resource deployment"
  default     = "us-east-1"
}

variable "cloud_tags" {
  description = "Additional tags to apply to all resources as a map"
  type        = map(string)
  default     = {}
}
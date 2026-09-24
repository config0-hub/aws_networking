variable "vpc_name" {
  type        = string
  description = "Name of the VPC where security groups will be created"
}

variable "sg_name" {
  type        = string
  description = "Base for the four security-group names and Name tags (<sg_name>-bastion|web|api|database); defaults to vpc_name"
  default     = null
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
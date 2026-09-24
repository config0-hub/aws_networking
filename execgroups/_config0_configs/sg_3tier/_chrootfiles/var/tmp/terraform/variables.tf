variable "vpc_name" {
  type        = string
  description = "Name of the VPC where security groups will be created"
}

variable "sg_name" {
  type        = string
  description = "Prefix for the four security-group names and Name tags (<sg_name>-bastion|web|api|database); unset keeps the bare tier names and <vpc_name>-<tier> tags"
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
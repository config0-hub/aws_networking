variable "vpc_id" {
  type        = string
  description = "vpc id"
}

variable "route_table_ids" {}

variable "aws_default_region" {
  default = "us-east-1"
}

variable "s3_gateway_name" {
  default = "s3_gateway"
}

variable "cloud_tags" {
  description = "additional tags as a map"
  type        = map(string)
  default     = {}
}

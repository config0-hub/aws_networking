variable "aws_default_region" {
  default = "eu-west-1"
}

variable "public_subnet_id" {}
variable "private_route_table_id" {}
variable "nat_gateway_name" {}

variable "cloud_tags" {
  description = "additional tags as a map"
  type        = map(string)
  default     = {}
}




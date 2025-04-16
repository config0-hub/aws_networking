variable "aws_default_region" {
  default = "us-east-1"
}

variable "vpc_name" {
  type        = string
  description = "vpc name"
  default     = "default_vpc_name_config0"
}

variable "vpc_tags" {
  description = "VPC resource tags"
  type        = map(string)
  default     = {}
}

variable "public_subnet_tags" {
  default     = { "kubernetes.io/role/elb" : "1" }
  description = "public subnet tags"
  type        = map(string)
}

variable "private_subnet_tags" {
  default     = { "kubernetes.io/role/internal_elb" : "1" }
  description = "private subnet tags"
  type        = map(string)
}

variable "cloud_tags" {
  description = "additional tags as a map"
  type        = map(string)
  default     = {}
}



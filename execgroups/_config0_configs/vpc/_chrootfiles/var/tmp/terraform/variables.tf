variable "environment" {
  type        = string
  description = "Environment identifier such as dev, staging, prod"
}

variable "aws_default_region" {
  type        = string
  description = "AWS region where resources will be deployed"
  default     = "eu-west-1"
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC to be created"
}

variable "main_network_block" {
  type        = string
  description = "Base CIDR block to be used in the VPC (e.g., 10.0.0.0/16)"
}

variable "subnet_prefix_extension" {
  type        = number
  description = "CIDR block bits extension to calculate CIDR blocks of each subnetwork"
  default     = 4
}

variable "zone_offset" {
  type        = number
  description = "CIDR block bits extension offset to calculate Public subnets, avoiding collisions with Private subnets"
  default     = 8
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  default     = true
}

variable "single_nat_gateway" {
  type        = bool
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  default     = true
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Should be true to enable DNS hostnames in the VPC"
  default     = true
}

variable "reuse_nat_ips" {
  type        = bool
  description = "Should be true if you don't want EIPs to be created for your NAT Gateways and will instead pass them in via the 'external_nat_ip_ids' variable"
  default     = true
}

# enable single NAT Gateway to save some money
# WARNING: this could create a single point of failure, since we are creating a NAT Gateway in one AZ only
variable "one_nat_gateway_per_az" {
  type        = bool
  description = "Should be true if you want only one NAT Gateway per availability zone. Requires 'var.single_nat_gateway = false'"
  default     = false
}

variable "vpc_tags" {
  description = "Additional tags to apply to the VPC resources"
  type        = map(string)
}

variable "nat_gw_tags" {
  description = "Additional tags to apply to the NAT Gateway resources"
  type        = map(string)
}

variable "public_subnet_tags" {
  description = "Additional tags for the public subnets, often used for Kubernetes ELB configuration"
  type        = map(string)
  default     = { "kubernetes.io/role/elb" : "1" }
}

variable "private_subnet_tags" {
  description = "Additional tags for the private subnets, often used for Kubernetes internal ELB configuration"
  type        = map(string)
  default     = { "kubernetes.io/role/internal_elb" : "1" }
}

variable "cloud_tags" {
  description = "Global tags to apply to all resources"
  type        = map(string)
  default     = {}
}
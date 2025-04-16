variable "aws_default_region" { default = "us-east-1" }

variable "enabled" {
  description = "Enable or not costly resources"
  type        = bool
  default     = true
}

variable "service_name" {
  description = "the service name"
}

variable "host_ip" {
  description = "host ipaddress (last octet) of nat instance"
  default     = null
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_id" {
  description = "ID of the public subnet to place the NAT instance"
  type        = string
}

variable "private_cidr_ingress_accept" {
  type = list(string)
}

variable "route_table_private_ids" {
  description = "List of ID of the route tables for the private subnets. You can set this to assign the each default route to the NAT instance"
  type        = list(string)
  default     = []
}

variable "image_id" {
  description = "AMI of the NAT instance. Default to the latest Amazon Linux 2"
  type        = string
  default     = ""
}

variable "instance_types" {
  description = "Candidates of spot instance type for the NAT instance. This is used in the mixed instances policy"
  type        = list(string)
  default     = ["t3.nano", "t3a.nano", "t3.micro", "t3a.micro", "t3.small", "t3a.small"]
}

variable "use_spot_instance" {
  description = "Whether to use spot or on-demand EC2 instance"
  type        = bool
  default     = true
}

variable "ssh_key_name" {
  description = "Name of the key pair for the NAT instance. You can set this to assign the key pair to the NAT instance"
  type        = string
  default     = ""
}

variable "cloud_tags" {
  description = "Tags applied to resources created with this module"
  type        = map(string)
  default     = {}
}

variable "user_data_write_files" {
  description = "Additional write_files section of cloud-init"
  type        = list(any)
  default     = []
}

variable "user_data_runcmd" {
  description = "Additional runcmd section of cloud-init"
  type        = list(list(string))
  default     = []
}

variable "ssm_policy_arn" {
  description = "SSM Policy to be attached to instance profile"
  type        = string
  default     = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}



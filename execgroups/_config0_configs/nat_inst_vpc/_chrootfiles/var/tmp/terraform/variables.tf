variable "aws_default_region" {
  description = "AWS Region for the resources"
  type        = string
  default     = "us-east-1"
}

variable "enabled" {
  description = "Whether to enable the NAT instance (resources will still be created but ASG will have 0 instances if false)"
  type        = bool
  default     = true
}

variable "service_name" {
  description = "Name of the service/component for resource naming and tagging"
  type        = string
}

variable "host_ip" {
  description = "Host IP address (last octet) of NAT instance"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "ID of the VPC where the NAT instance will be deployed"
  type        = string
}

variable "public_subnet_id" {
  description = "ID of the public subnet where the NAT instance will be placed"
  type        = string
}

variable "private_cidr_ingress_accept" {
  description = "List of CIDR blocks allowed to connect to the NAT instance"
  type        = list(string)
}

variable "route_table_private_ids" {
  description = "List of route table IDs for private subnets that will use the NAT instance as their gateway"
  type        = list(string)
  default     = []
}

variable "image_id" {
  description = "AMI ID for the NAT instance (defaults to latest Amazon Linux 2 if not specified)"
  type        = string
  default     = ""
}

variable "instance_types" {
  description = "List of EC2 instance types to use in the mixed instances policy (in order of preference)"
  type        = list(string)
  default     = ["t3.nano", "t3a.nano", "t3.micro", "t3a.micro", "t3.small", "t3a.small"]
}

variable "use_spot_instance" {
  description = "Whether to use spot instances (lower cost but may be terminated) or on-demand instances"
  type        = bool
  default     = true
}

variable "ssh_key_name" {
  description = "Name of the EC2 key pair to assign to the NAT instance for SSH access"
  type        = string
  default     = ""
}

variable "cloud_tags" {
  description = "Additional tags to apply to all resources created by this module"
  type        = map(string)
  default     = {}
}

variable "user_data_write_files" {
  description = "Additional files to write via cloud-init (see cloud-init write_files documentation for format)"
  type        = list(any)
  default     = []
}

variable "user_data_runcmd" {
  description = "Additional commands to run via cloud-init (see cloud-init runcmd documentation for format)"
  type        = list(list(string))
  default     = []
}

variable "ssm_policy_arn" {
  description = "ARN of the IAM policy for AWS Systems Manager to be attached to the instance profile"
  type        = string
  default     = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
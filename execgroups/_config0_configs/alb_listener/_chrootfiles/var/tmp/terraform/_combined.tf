####FILE####:::main.tf
resource "aws_lb_target_group" "this" {
  name     = var.name
  port     = var.target_port
  protocol = var.target_protocol
  vpc_id   = var.vpc_id
  target_type = var.target_type
  
  health_check {
    path                = var.health_check_path
    port                = var.health_check_port
    protocol            = var.health_check_protocol
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    matcher             = var.health_check_matcher
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = var.alb_arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = var.alb_arn
  port              = 80
  protocol          = "HTTP"
  
  default_action {
    type = "redirect"
    
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

####FILE####:::variables.tf
variable "name" {
  description = "Name of the target group"
  type        = string
}

variable "alb_arn" {
  description = "ARN of the ALB"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "target_port" {
  description = "Port on which targets receive traffic"
  type        = number
  default     = 80
}

variable "target_protocol" {
  description = "Protocol to use for routing traffic to the targets"
  type        = string
  default     = "HTTP"
}

variable "target_type" {
  description = "Type of target to register with the target group"
  type        = string
  default     = "instance"
}

variable "certificate_arn" {
  description = "ARN of the certificate to use for HTTPS listener"
  type        = string
}

variable "ssl_policy" {
  description = "SSL policy for HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
}

variable "health_check_path" {
  description = "Path for health checks"
  type        = string
  default     = "/"
}

variable "health_check_port" {
  description = "Port for health checks"
  type        = string
  default     = "traffic-port"
}

variable "health_check_protocol" {
  description = "Protocol for health checks"
  type        = string
  default     = "HTTP"
}

variable "health_check_interval" {
  description = "Interval between health checks in seconds"
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "Timeout for health checks in seconds"
  type        = number
  default     = 5
}

variable "health_check_healthy_threshold" {
  description = "Number of consecutive successful health checks before considering the target healthy"
  type        = number
  default     = 3
}

variable "health_check_unhealthy_threshold" {
  description = "Number of consecutive failed health checks before considering the target unhealthy"
  type        = number
  default     = 3
}

variable "health_check_matcher" {
  description = "HTTP codes to use when checking for a successful response from a target"
  type        = string
  default     = "200-399"
}

variable "cloud_tags" {
  type        = map(string)
  description = "Global tags to apply to all resources"
  default     = {}
}

####FILE####:::outputs.tf
output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.this.arn
}

output "target_group_name" {
  description = "Name of the target group"
  value       = aws_lb_target_group.this.name
}

output "https_listener_arn" {
  description = "ARN of the HTTPS listener"
  value       = aws_lb_listener.https.arn
}

output "http_listener_arn" {
  description = "ARN of the HTTP listener"
  value       = aws_lb_listener.http_redirect.arn
}

####FILE####:::provider.tf
# AWS Provider Configuration
# Configures the AWS provider with region and default tagging strategy

# Local block to sort tags for consistent ordering
locals {
  # Convert user-provided tags map to sorted list
  sorted_cloud_tags = [
    for k in sort(keys(var.cloud_tags)) : {
      key   = k
      value = var.cloud_tags[k]
    }
  ]

  # Create a sorted and consistent map of all tags
  all_tags = merge(
    # Convert sorted list back to map
    { for item in local.sorted_cloud_tags : item.key => item.value },
    {
      # Tag indicating resources are managed by config0
      orchestrated_by = "config0"
    }
  )
}

provider "aws" {
  # Region where AWS resources will be created
  region = var.aws_default_region

  # Default tags applied to all resources with consistent ordering
  default_tags {
    tags = local.all_tags
  }

  # Optional: Configure tags to be ignored by the provider
  ignore_tags {
    # Uncomment and customize if specific tags should be ignored
    # keys = ["TemporaryTag", "AutomationTag"]
  }
}

# Terraform Version Configuration
# Specifies the required Terraform and provider versions
terraform {
  # Minimum Terraform version required
  required_version = ">= 1.1.0"

  # Required providers with version constraints
  required_providers {
    aws = {
      source  = "hashicorp/aws" # AWS provider source
      version = "~> 5.0"        # Compatible with AWS provider v5.x
    }
  }
}

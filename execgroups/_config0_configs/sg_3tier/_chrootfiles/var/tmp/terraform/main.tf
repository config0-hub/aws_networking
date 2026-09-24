/**
 * # AWS Security Groups Module
 *
 * This module creates a set of security groups for a layered architecture:
 * - Bastion: Entry point for administrative access
 * - Web: Public-facing web servers
 * - API: Internal API servers
 * - Database: Backend database servers
 */

locals {
  # sg_name falls back to vpc_name, so an unset sg_name keeps the vpc-named groups
  sg_name = coalesce(var.sg_name, var.vpc_name)
}

resource "aws_security_group" "bastion" {
  name        = "${local.sg_name}-bastion"
  description = "Bastion Layer Security Group for administrative access"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow all TCP traffic within bastion security group"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "Allow all UDP traffic within bastion security group"
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    self        = true
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.cloud_tags,
    {
      Name    = "${local.sg_name}-bastion"
      Product = "security_group"
    },
  )
}

resource "aws_security_group" "web" {
  name        = "${local.sg_name}-web"
  description = "Web Layer Security Group for public-facing web servers"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description     = "SSH access from bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  ingress {
    description = "Allow all TCP traffic within web security group"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "Allow all UDP traffic within web security group"
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    self        = true
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.cloud_tags,
    {
      Name    = "${local.sg_name}-web"
      Product = "security_group"
    },
  )
}

resource "aws_security_group" "api" {
  name        = "${local.sg_name}-api"
  description = "API Layer Security Group for internal API servers"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow all traffic from web layer"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.web.id]
  }

  ingress {
    description     = "SSH access from bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  ingress {
    description = "Allow all TCP traffic within API security group"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "Allow all UDP traffic within API security group"
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    self        = true
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.cloud_tags,
    {
      Name    = "${local.sg_name}-api"
      Product = "security_group"
    },
  )
}

resource "aws_security_group" "database" {
  name        = "${local.sg_name}-database"
  description = "Database Layer Security Group for backend database servers"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow all traffic from API layer"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.api.id]
  }

  ingress {
    description     = "SSH access from bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  ingress {
    description = "Allow all TCP traffic within database security group"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "Allow all UDP traffic within database security group"
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    self        = true
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.cloud_tags,
    {
      Name    = "${local.sg_name}-database"
      Product = "security_group"
    },
  )
}

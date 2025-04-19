resource "aws_security_group_rule" "web_allow_tcp" {
  description              = "Allow all TCP traffic within web security group"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.web.id
  source_security_group_id = aws_security_group.web.id
}

resource "aws_security_group_rule" "web_allow_udp" {
  description              = "Allow all UDP traffic within web security group"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "udp"
  security_group_id        = aws_security_group.web.id
  source_security_group_id = aws_security_group.web.id
}

resource "aws_security_group_rule" "bastion_allow_tcp" {
  description              = "Allow all TCP traffic within bastion security group"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.bastion.id
  source_security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "bastion_allow_udp" {
  description              = "Allow all UDP traffic within bastion security group"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "udp"
  security_group_id        = aws_security_group.bastion.id
  source_security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "database_allow_tcp" {
  description              = "Allow all TCP traffic within database security group"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.database.id
  source_security_group_id = aws_security_group.database.id
}

resource "aws_security_group_rule" "database_allow_udp" {
  description              = "Allow all UDP traffic within database security group"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "udp"
  security_group_id        = aws_security_group.database.id
  source_security_group_id = aws_security_group.database.id
}

resource "aws_security_group_rule" "api_allow_tcp" {
  description              = "Allow all TCP traffic within API security group"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.api.id
  source_security_group_id = aws_security_group.api.id
}

resource "aws_security_group_rule" "api_allow_udp" {
  description              = "Allow all UDP traffic within API security group"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "udp"
  security_group_id        = aws_security_group.api.id
  source_security_group_id = aws_security_group.api.id
}


resource "aws_security_group" "default" {
  name        = "${var.service_name}-nat-inst"
  vpc_id      = var.vpc_id
  description = "Security group for NAT instance ${var.service_name}"
  tags        = local.common_tags
}

resource "aws_security_group_rule" "egress" {
  security_group_id = aws_security_group.default.id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
}

resource "aws_security_group_rule" "ingress_any" {
  security_group_id = aws_security_group.default.id
  type              = "ingress"
  cidr_blocks       = var.private_cidr_ingress_accept
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
}

resource "aws_security_group_rule" "ssh" {
  security_group_id = aws_security_group.default.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}


# original source code
# https://github.com/int128/terraform-aws-nat-instance
# remove the network interface and just attach the instance id directly
# since the network interface wasn't working
#

data "aws_caller_identity" "current" {}

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

locals {
  common_tags = merge(
    {
      Name = "${var.service_name}-nat-inst"
    },
    var.cloud_tags,
  )
}

# AMI of the latest Amazon Linux 2 
data "aws_ami" "default" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }
}

resource "aws_launch_template" "default" {
  name     = "${var.service_name}-nat-inst"
  image_id = var.image_id != "" ? var.image_id : data.aws_ami.default.id
  key_name = var.ssh_key_name

  iam_instance_profile {
    arn = aws_iam_instance_profile.default.arn
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.default.id]
    delete_on_termination       = true
  }

  tag_specifications {
    resource_type = "instance"
    tags          = local.common_tags
  }

  user_data = base64encode(join("\n", [
    "#cloud-config",
    yamlencode({
      # https://cloudinit.readthedocs.io/en/latest/topics/modules.html
      write_files : concat([
        {
          path : "/opt/nat/configure.sh",
          content : templatefile("${path.module}/configure.sh", { route_table_id = var.route_table_private_ids[0] }),
          permissions : "0755",
        }
      ], var.user_data_write_files),
      runcmd : concat([
        ["/opt/nat/configure.sh"],
      ], var.user_data_runcmd),
    })
  ]))

  description = "Launch template for NAT instance ${var.service_name}"
  tags        = local.common_tags
}

resource "aws_autoscaling_group" "default" {
  name                = "${var.service_name}-nat-inst"
  desired_capacity    = var.enabled ? 1 : 0
  min_size            = var.enabled ? 1 : 0
  max_size            = 1
  vpc_zone_identifier = [var.public_subnet_id]

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = var.use_spot_instance ? 0 : 1
      on_demand_percentage_above_base_capacity = var.use_spot_instance ? 0 : 100
    }
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.default.id
        version            = "$Latest"
      }
      dynamic "override" {
        for_each = var.instance_types
        content {
          instance_type = override.value
        }
      }
    }
  }

  dynamic "tag" {
    for_each = local.common_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = false
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_instance_profile" "default" {
  name = "${var.service_name}-nat-inst"
  role = aws_iam_role.default.name

  tags = local.common_tags
}

resource "aws_iam_role" "default" {
  name               = "${var.service_name}-nat-inst"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "ssm" {
  policy_arn = var.ssm_policy_arn
  role       = aws_iam_role.default.name
}

resource "aws_iam_role_policy" "ec2" {
  role   = aws_iam_role.default.name
  name   = "${var.service_name}-nat-inst"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AttachNetworkInterface",
                "ec2:ModifyInstanceAttribute"
            ],
            "Resource": [ "arn:aws:ec2:${var.aws_default_region}:${data.aws_caller_identity.current.account_id}:instance/*" ]
        },
        {
            "Sid": "EC2RouteManagement",
            "Effect": "Allow",
            "Action": [
                "ec2:CreateRoute",
                "ec2:ReplaceRoute",
                "ec2:DescribeRouteTables",
                "ec2:DescribeInstances"
            ],
            "Resource": [ "arn:aws:ec2:${var.aws_default_region}:${data.aws_caller_identity.current.account_id}:route-table/${var.route_table_private_ids[0]}" ]
        }
    ]
}
EOF
}

output "arn" {
  value = aws_autoscaling_group.default.arn
}
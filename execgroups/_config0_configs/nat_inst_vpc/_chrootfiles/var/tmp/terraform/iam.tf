resource "aws_iam_instance_profile" "default" {
  name = "${var.service_name}-nat-inst"
  role = aws_iam_role.default.name

  tags = local.common_tags
}

resource "aws_iam_role" "default" {
  name = "${var.service_name}-nat-inst"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "ssm" {
  policy_arn = var.ssm_policy_arn
  role       = aws_iam_role.default.name
}

resource "aws_iam_role_policy" "ec2" {
  role = aws_iam_role.default.name
  name = "${var.service_name}-nat-inst"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:AttachNetworkInterface",
          "ec2:ModifyInstanceAttribute"
        ]
        Resource = ["arn:aws:ec2:${var.aws_default_region}:${data.aws_caller_identity.current.account_id}:instance/*"]
      },
      {
        Sid    = "EC2RouteManagement"
        Effect = "Allow"
        Action = [
          "ec2:CreateRoute",
          "ec2:ReplaceRoute",
          "ec2:DescribeRouteTables",
          "ec2:DescribeInstances"
        ]
        Resource = ["arn:aws:ec2:${var.aws_default_region}:${data.aws_caller_identity.current.account_id}:route-table/${var.route_table_private_ids[0]}"]
      }
    ]
  })
}


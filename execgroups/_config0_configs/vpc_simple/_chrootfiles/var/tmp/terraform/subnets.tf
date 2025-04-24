resource "aws_subnet" "public" {
  count      = length(local.public_subnets)
  cidr_block = element(values(local.public_subnets), count.index)
  vpc_id     = aws_vpc.main.id

  map_public_ip_on_launch = true
  availability_zone       = element(keys(local.public_subnets), count.index)

  lifecycle {
    ignore_changes = [tags]
  }

  tags = merge(
    var.cloud_tags,
    var.vpc_tags,
    var.public_subnet_tags,
    {
      Name               = "${var.vpc_name}-service-public"
      subnet_environment = "public"
    },
  )
}

resource "aws_subnet" "private" {
  count      = length(local.private_subnets)
  cidr_block = element(values(local.private_subnets), count.index)
  vpc_id     = aws_vpc.main.id

  map_public_ip_on_launch = true
  availability_zone       = element(keys(local.private_subnets), count.index)

  lifecycle {
    ignore_changes = [tags]
  }

  tags = merge(
    var.cloud_tags,
    var.vpc_tags,
    var.private_subnet_tags,
    {
      Name               = "${var.vpc_name}-service-private"
      subnet_environment = "private"
    },
  )
}



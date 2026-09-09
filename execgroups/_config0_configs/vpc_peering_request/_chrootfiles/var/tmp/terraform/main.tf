data "aws_caller_identity" "peer" {
  provider = aws.peer
}

data "aws_vpc" "peer" {
  provider = aws.peer
  id       = var.vpc_a_id
}

resource "aws_vpc" "requester" {
  cidr_block           = var.vpc_b_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = var.vpc_b_name
    Product = "vpc"
  }
}

resource "aws_default_route_table" "requester" {
  default_route_table_id = aws_vpc.requester.default_route_table_id

  tags = {
    Name    = "${var.vpc_b_name}-route-main"
    Product = "route-table"
  }
}

resource "aws_vpc_peering_connection" "request" {
  vpc_id        = aws_vpc.requester.id
  peer_vpc_id   = data.aws_vpc.peer.id
  peer_owner_id = var.vpc_a_account_id
  peer_region   = var.vpc_a_region
  auto_accept   = false

  lifecycle {
    precondition {
      condition     = data.aws_caller_identity.peer.account_id == var.vpc_a_account_id
      error_message = "The aliased peer credentials do not belong to vpc_a_account_id."
    }
  }

  tags = {
    Name    = var.vpc_peering_name
    Product = "vpc-peering"
  }
}

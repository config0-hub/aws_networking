locals {
  public_subnets = {
    "${var.aws_default_region}a" = "10.10.101.0/24"
    "${var.aws_default_region}b" = "10.10.102.0/24"
  }
  private_subnets = {
    "${var.aws_default_region}a" = "10.10.201.0/24"
    "${var.aws_default_region}b" = "10.10.202.0/24"
  }
}


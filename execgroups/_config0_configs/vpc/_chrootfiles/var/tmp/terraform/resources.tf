# reserve Elastic IP to be used in our NAT gateway
resource "aws_eip" "nat_gw_elastic_ip" {
  domain = "vpc" # Updated from the deprecated 'vpc = true' syntax

  tags = merge(
    var.nat_gw_tags,
    var.cloud_tags,
    {
      Name            = var.vpc_name
      iac_environment = var.environment
      environment     = var.environment
    },
  )
}

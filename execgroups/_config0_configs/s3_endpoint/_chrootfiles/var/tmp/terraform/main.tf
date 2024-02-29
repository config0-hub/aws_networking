resource "aws_vpc_endpoint" "s3" {
  vpc_id      = var.vpc_id
  service_name = "com.amazonaws.${var.aws_default_region}.s3"
  route_table_ids = var.route_table_ids
  tags = merge(
    var.cloud_tags,
    {
      Product = "vpc_endpoint"
      Name    = var.s3_gateway_name
    },
  )

}

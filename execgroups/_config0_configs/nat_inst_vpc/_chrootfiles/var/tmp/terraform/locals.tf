locals {
  common_tags = merge(
    {
      Name = "${var.service_name}-nat-inst"
    },
    var.cloud_tags,
  )
}


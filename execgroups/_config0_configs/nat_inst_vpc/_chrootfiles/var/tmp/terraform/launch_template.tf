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


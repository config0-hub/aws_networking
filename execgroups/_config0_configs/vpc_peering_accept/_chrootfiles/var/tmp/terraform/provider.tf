locals {
  all_tags = merge(
    var.cloud_tags,
    {
      orchestrated_by = "config0"
    },
  )
}

provider "aws" {
  region = var.aws_default_region

  default_tags {
    tags = local.all_tags
  }
}

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

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

provider "aws" {
  alias      = "peer"
  region     = var.vpc_a_region
  access_key = var.AWS_ACCESS_KEY_ID_PEER
  secret_key = var.AWS_SECRET_ACCESS_KEY_PEER
  token      = var.AWS_SESSION_TOKEN_PEER

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

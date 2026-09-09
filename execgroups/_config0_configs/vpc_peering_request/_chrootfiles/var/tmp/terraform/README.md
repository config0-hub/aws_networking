# VPC peering request Terraform

Creates requester VPC-B and its main route table in the default AWS account, verifies VPC-A through the `aws.peer` provider, and requests cross-account VPC peering. The peer provider receives short-lived `_PEER` credentials through sensitive Terraform variables.

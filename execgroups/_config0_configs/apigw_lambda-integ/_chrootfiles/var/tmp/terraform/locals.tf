locals {
  # Store the current AWS account ID for use in ARN construction
  aws_account_id = data.aws_caller_identity.current.account_id
}


# Variable definitions with improved documentation and types

variable "stage" {
  description = "The deployment stage for the API Gateway"
  type        = string
  default     = "v1"
}

variable "resource_name" {
  description = "The name of the resource path for the API Gateway"
  type        = string
  default     = "codebuild"
}

variable "lambda_invoke_arn" {
  description = "The ARN of the Lambda function to invoke"
  type        = string
  # Required field with no default
}

variable "lambda_name" {
  description = "The name of the Lambda function"
  type        = string
  # Required field with no default
}

variable "apigateway_name" {
  description = "The name for the API Gateway"
  type        = string
  default     = "api-test"
}

variable "aws_default_region" {
  description = "The AWS region where resources will be created"
  type        = string
  default     = "eu-west-1"
}

variable "cloud_tags" {
  description = "Additional tags to apply to cloud resources"
  type        = map(string)
  default     = {}
}
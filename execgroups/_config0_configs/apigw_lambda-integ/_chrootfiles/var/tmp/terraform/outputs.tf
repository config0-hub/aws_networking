# Output the base URL for the API Gateway
output "base_url" {
  description = "The base URL for the API Gateway"
  value       = "${aws_api_gateway_deployment.default.invoke_url}/${var.resource_name}"
}

# Output the ARN for the API Gateway
output "arn" {
  description = "The execution ARN of the API Gateway"
  value       = aws_api_gateway_rest_api.default.execution_arn
}


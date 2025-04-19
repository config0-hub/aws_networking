# API Gateway REST API resource
resource "aws_api_gateway_rest_api" "default" {
  description = "Config0/Terraform API gateway"
  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = var.apigateway_name
      version = "1.0"
    }
    post = {
      x-amazon-apigateway-integration = {
        httpMethod           = "POST"
        payloadFormatVersion = "1.0"
        type                 = "HTTP_PROXY"
      }
    }
  })

  name = var.apigateway_name

  tags = merge(
    var.cloud_tags,
    {
      Product = "apigateway"
    },
  )

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# API Gateway resource path configuration
resource "aws_api_gateway_resource" "default" {
  parent_id   = aws_api_gateway_rest_api.default.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.default.id
  path_part   = "{${var.resource_name}+}"
}

# API Gateway POST method for the resource path
resource "aws_api_gateway_method" "post" {
  rest_api_id   = aws_api_gateway_rest_api.default.id
  resource_id   = aws_api_gateway_resource.default.id
  http_method   = "POST"
  authorization = "NONE"
}

# API Gateway integration for the non-root resource
resource "aws_api_gateway_integration" "lambda_non_root" {
  rest_api_id = aws_api_gateway_rest_api.default.id
  resource_id = aws_api_gateway_method.post.resource_id
  http_method = aws_api_gateway_method.post.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

# API Gateway POST method for the root path
resource "aws_api_gateway_method" "post_root" {
  rest_api_id   = aws_api_gateway_rest_api.default.id
  resource_id   = aws_api_gateway_rest_api.default.root_resource_id
  http_method   = "POST"
  authorization = "NONE"
}

# API Gateway integration for the root resource
resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = aws_api_gateway_rest_api.default.id
  resource_id = aws_api_gateway_method.post_root.resource_id
  http_method = aws_api_gateway_method.post_root.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

# API Gateway method response configuration
resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.default.id
  resource_id = aws_api_gateway_resource.default.id
  http_method = aws_api_gateway_method.post.http_method
  status_code = "200"
}

# API Gateway integration response configuration
resource "aws_api_gateway_integration_response" "IntegrationResponse" {
  depends_on = [
    aws_api_gateway_integration.lambda_non_root,
    aws_api_gateway_integration.lambda_root,
  ]
  rest_api_id = aws_api_gateway_rest_api.default.id
  resource_id = aws_api_gateway_resource.default.id
  http_method = aws_api_gateway_method.post.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code

  # Transforms the backend JSON response to json. The space is required
  response_templates = {
    "application/json" = <<EOF
 
 EOF
  }
}

# API Gateway deployment configuration
resource "aws_api_gateway_deployment" "default" {
  depends_on = [
    aws_api_gateway_integration.lambda_non_root,
    aws_api_gateway_integration_response.IntegrationResponse,
  ]

  rest_api_id = aws_api_gateway_rest_api.default.id
  stage_name  = var.stage
}


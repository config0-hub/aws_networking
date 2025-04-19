# AWS API Gateway Lambda Integration

This OpenTofu module creates an AWS API Gateway with Lambda integration. It configures both root and non-root paths to forward requests to a Lambda function.

## Features

- Creates a regional API Gateway REST API
- Configures both root and non-root endpoints
- Sets up necessary permissions for Lambda invocation
- Supports custom tagging

## Usage

```hcl
module "api_gateway" {
  source = "./path/to/module"

  lambda_invoke_arn  = aws_lambda_function.example.invoke_arn
  lambda_name        = aws_lambda_function.example.function_name
  apigateway_name    = "my-api-gateway"
  resource_name      = "api"
  stage              = "v1"
  aws_default_region = "us-west-2"
  
  cloud_tags = {
    Environment = "Production"
    Project     = "MyProject"
  }
}
```

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `lambda_invoke_arn` | The ARN of the Lambda function to invoke | `string` | n/a | yes |
| `lambda_name` | The name of the Lambda function | `string` | n/a | yes |
| `apigateway_name` | The name for the API Gateway | `string` | `"api-test"` | no |
| `resource_name` | The name of the resource path for the API Gateway | `string` | `"codebuild"` | no |
| `stage` | The deployment stage for the API Gateway | `string` | `"v1"` | no |
| `aws_default_region` | The AWS region where resources will be created | `string` | `"eu-west-1"` | no |
| `cloud_tags` | Additional tags to apply to cloud resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `base_url` | The base URL for the API Gateway |
| `arn` | The execution ARN of the API Gateway |

## Requirements

- OpenTofu >= 1.8.8
- AWS Provider

## Note

This module configures both a root endpoint and a path-based endpoint that both forward to the same Lambda function.

## License

Copyright (C) 2025 Gary Leong <gary@config0.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3 of the License.
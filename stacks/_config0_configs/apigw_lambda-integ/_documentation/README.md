# AWS API Gateway Lambda Integration

## Description
This stack creates an API Gateway that integrates with an AWS Lambda function. It establishes the necessary connection between the API Gateway and Lambda function, allowing HTTP requests to trigger Lambda execution.

## Variables

### Required Variables

| Name | Description | Default |
|------|-------------|---------|
| apigateway_name | API Gateway resource name |  |
| lambda_name | Lambda function name |  |

### Optional Variables

| Name | Description | Default |
|------|-------------|---------|
| stage | API Gateway deployment stage | v1 |
| aws_default_region | Default AWS region | eu-west-1 |

## Features
- Creates an API Gateway REST API
- Integrates the API Gateway with an existing Lambda function
- Configures the necessary permissions and routes
- Outputs the API Gateway base URL and ARN

## Dependencies

### Substacks
- [config0-publish:::tf_executor](https://api-app.config0.com/web_api/v1.0/stacks/config0-publish/tf_executor)

### Execgroups
- [config0-publish:::aws_networking::apigw_lambda-integ](https://api-app.config0.com/web_api/v1.0/exec/groups/config0-publish/aws_networking/apigw_lambda-integ)

## License
Copyright (C) 2025 Gary Leong <gary@config0.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3 of the License.












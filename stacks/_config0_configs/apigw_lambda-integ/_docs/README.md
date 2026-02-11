# AWS API Gateway Lambda Integration

## Description
This stack creates an API Gateway that integrates with an AWS Lambda function. It establishes the necessary connection between the API Gateway and Lambda function, allowing HTTP requests to trigger Lambda execution.

## Variables

### Required Variables

| Name | Description | Default |
|------|-------------|---------|
| apigateway_name | API Gateway resource name | &nbsp; |
| lambda_name | Lambda function name | &nbsp; |

### Optional Variables

| Name | Description | Default |
|------|-------------|---------|
| stage | API Gateway deployment stage | v1 |
| aws_default_region | Default AWS region | eu-west-1 |

## Dependencies

### Substacks
- [config0-publish:::tf_executor](http://config0.http.redirects.s3-website-us-east-1.amazonaws.com/assets/stacks/config0-publish/tf_executor/default)

### Execgroups
- [config0-publish:::aws_networking::apigw_lambda-integ](http://config0.http.redirects.s3-website-us-east-1.amazonaws.com/assets/exec/groups/config0-publish/aws_networking/apigw_lambda-integ/default)

### Shelloutconfigs
- [config0-publish:::terraform::resource_wrapper](http://config0.http.redirects.s3-website-us-east-1.amazonaws.com/assets/shelloutconfigs/config0-publish/terraform/resource_wrapper/default)

## License
<pre>
Copyright (C) 2025 Gary Leong <gary@config0.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3 of the License.
</pre>
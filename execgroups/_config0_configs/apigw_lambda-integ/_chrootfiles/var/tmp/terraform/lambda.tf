# Lambda permission to allow API Gateway to invoke the Lambda function
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_default_region}:${local.aws_account_id}:${aws_api_gateway_rest_api.default.id}/*/${aws_api_gateway_method.post.http_method}${aws_api_gateway_resource.default.path}"
}


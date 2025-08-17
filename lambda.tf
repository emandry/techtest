# IAM for Lambda
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Add Permission
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# Zip python script for upload
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/function_code/lambda_function.py"
  output_path = "${path.module}/function_code/lambda_function.zip"
}

# Lambda
resource "aws_lambda_function" "merapar_lambda" {
  function_name    = "merapar_lambda"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "lambda_function.handler"
  runtime          = "python3.13"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  vpc_config {
    subnet_ids                  = [aws_subnet.merapar_private.id]
    security_group_ids          = [aws_security_group.merapar_private_web_allow.id]
    ipv6_allowed_for_dual_stack = false # Enable IPv6 support
  }
}

# API Gateway HTTP
resource "aws_apigatewayv2_api" "http_api" {
  name          = "merapar-lambda-api"
  protocol_type = "HTTP"
}

# Lambda <-> API Gateway
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.merapar_lambda.invoke_arn
}

# Route
resource "aws_apigatewayv2_route" "default" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# Deploy
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}

# Invoke Lambda from API Gateway
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.merapar_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

# Output URL
output "api_url" {
  value = aws_apigatewayv2_api.http_api.api_endpoint
}
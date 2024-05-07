resource "aws_api_gateway_method" "method" {
  rest_api_id   = var.api_id
  resource_id   = var.resource_id
  http_method   = var.http_method
  authorization = var.authorization
  authorizer_id = var.cognito_authorizer_id
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id          = var.api_id
  resource_id          = var.resource_id
  http_method          = aws_api_gateway_method.method.http_method
  passthrough_behavior = var.passthrough_behavior
  request_templates    = var.integration_request_templates
  content_handling     = var.integration_content_handling

  integration_http_method = "POST"
  type                    = var.integration_type
  uri = var.lambda_invoke_arn
}

resource "aws_api_gateway_method_response" "method_response_200" {
  rest_api_id         = var.api_id
  resource_id         = var.resource_id
  http_method         = aws_api_gateway_method.method.http_method
  status_code         = "200"
  response_models     = var.method_response_models
  response_parameters = var.method_response_parameters
}

resource "aws_api_gateway_integration_response" "integration_response" {
  rest_api_id = var.api_id
  resource_id = var.resource_id
  http_method = aws_api_gateway_method.method.http_method
  status_code = aws_api_gateway_method_response.method_response_200.status_code

  response_templates  = var.integration_response_templates
  response_parameters = var.integration_response_parameters

  depends_on = [aws_api_gateway_integration.integration]
}

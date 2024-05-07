resource "aws_api_gateway_rest_api" "api" {
  name = var.rest_api_name
}

resource "aws_api_gateway_authorizer" "cognito_authorizer" {
 name                   = var.cognito_authorizer_name
 rest_api_id            = aws_api_gateway_rest_api.api.id
 type                   = "COGNITO_USER_POOLS"
 provider_arns          = [var.user_pool_arn]
 identity_source        = "method.request.header.Authorization"
}

resource "aws_api_gateway_resource" "productResource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "product"
}

module "optionIntegration" {
  source = "../api-gateway-integration-module"
  api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.productResource.id
  http_method = "OPTIONS"
  integration_type = "MOCK"
  passthrough_behavior = "WHEN_NO_MATCH"
  integration_request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  method_response_models = {
    "application/json" = "Empty"
  }
  method_response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = false
    "method.response.header.Access-Control-Allow-Methods" = false
    "method.response.header.Access-Control-Allow-Origin"  = false
  }
  integration_response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" : "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" : "'DELETE,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin" : "'*'"
  }
}

module "postIntegration" {
  source = "../api-gateway-integration-module"
  api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.productResource.id
  authorization = "COGNITO_USER_POOLS"
  cognito_authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
  integration_content_handling = "CONVERT_TO_TEXT"
  http_method = "POST"
  method_response_models = {
    "application/json" = "Empty"
  }
  lambda_invoke_arn = var.post_lambda_function.invoke_arn
}

module "deleteIntegration" {
  source = "../api-gateway-integration-module"
  api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.productResource.id
  authorization = "COGNITO_USER_POOLS"
  cognito_authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
  integration_content_handling = "CONVERT_TO_TEXT"
  http_method = "DELETE"
  method_response_models = {
    "application/json" = "Empty"
  }
  lambda_invoke_arn = var.delete_lambda_function.invoke_arn
}

module "getIntegration" {
  source = "../api-gateway-integration-module"
  api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.productResource.id

  authorization = "COGNITO_USER_POOLS"
  cognito_authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
  http_method = "GET"
  lambda_invoke_arn = var.get_lambda_function.invoke_arn
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    module.postIntegration,
    module.deleteIntegration,
    module.getIntegration
  ]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "prod"
}

resource "aws_lambda_permission" "post_api_to_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.post_lambda_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "delete_api_to_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.delete_lambda_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "get_api_to_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.get_lambda_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}
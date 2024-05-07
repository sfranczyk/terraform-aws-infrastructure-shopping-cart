output "api_execution_arn" {
  description = "The ARN of the API Gateway execution role"
  value       = aws_api_gateway_rest_api.api.execution_arn
}

output "deployment_invoke_url" {
  description = "The ARN of the API Gateway execution role"
  value       = aws_api_gateway_deployment.deployment.invoke_url
}
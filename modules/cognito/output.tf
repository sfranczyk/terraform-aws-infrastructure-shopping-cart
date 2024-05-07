output "user_pool_arn" {
  value       = aws_cognito_user_pool.user_pool.arn
  description = "Value of the user pool ARN"
}

output "user_pool_client_id" {
  value       = aws_cognito_user_pool_client.user_pool_client.id
  description = "Value of the user pool client ID"
}
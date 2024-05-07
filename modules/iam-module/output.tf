output "shopping_cart_lambda_role" {
    description = "The IAM role for the Lambda function"
    value       = aws_iam_role.shopping_cart_lambda_role
}
resource "aws_iam_policy" "dynamodb_policy" {
  name        = "ShoppingCartDynamoDB${var.policy_type}Policy"
  description = var.policy_description

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = var.action
        Resource = var.resource_arns
      }
    ]
  })
}


resource "aws_iam_role" "shopping_cart_lambda_role" {
  name = "ShopingCartLambda${var.policy_type}Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "shoppingCartLambdaBasicExecutionRole" {
  role       = aws_iam_role.shopping_cart_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_iam_role_policy_attachment" "shoppingCartlambdaPolicyAttachment" {
  role       = aws_iam_role.shopping_cart_lambda_role.name
  policy_arn = aws_iam_policy.dynamodb_policy.arn
}

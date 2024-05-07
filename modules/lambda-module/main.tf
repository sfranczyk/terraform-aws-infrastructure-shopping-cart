data "archive_file" "archive_code_file" {
  type        = "zip"
  source_file  = "${path.root}/source/${var.lambda_code_filename}.py"
  output_path = "${path.root}/source/archive/${var.lambda_code_filename}.zip"
}

module "to_dynamodb_role" {
    source = "../iam-module"
    policy_type = var.iam_policy_type
    policy_description = var.iam_policy_description
    action = var.iam_policy_action
    resource_arns = var.iam_policy_resource_arns
}

resource "aws_lambda_function" "lambda_function" {
  depends_on = [ data.archive_file.archive_code_file ]
  function_name = var.function_name
  handler       = "${var.lambda_code_filename}.lambda_handler"
  runtime       = "python3.12"
  role          = module.to_dynamodb_role.shopping_cart_lambda_role.arn
  filename      = data.archive_file.archive_code_file.output_path
  environment {
    variables = {
      DYNAMODB_TABLE_NAME = var.dynamodb_table_name
    }
  }
}
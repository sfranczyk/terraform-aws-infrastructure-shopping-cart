module "shopping_cart_table" {
  source              = "../../modules/dynamodb-module"
  dynamodb_table_name = "ShoppingCartTable"
}

module "add_item_to_shopping_cart" {
  source                   = "../../modules/lambda-module"
  dynamodb_table_name      = module.shopping_cart_table.dynamodb_table_name
  iam_policy_action        = ["dynamodb:PutItem", "dynamodb:UpdateItem", "dynamodb:BatchWriteItem"]
  iam_policy_resource_arns = [module.shopping_cart_table.dynamodb_table_arn]
  iam_policy_type          = "Write"
  iam_policy_description   = "Policy for writing to DynamoDB"
  lambda_code_filename     = "add_item"
  function_name            = "AddItemToShoppingCart"
}

module "delete_item_from_shopping_cart" {
  source                   = "../../modules/lambda-module"
  dynamodb_table_name      = module.shopping_cart_table.dynamodb_table_name
  iam_policy_action        = ["dynamodb:DeleteItem"]
  iam_policy_resource_arns = [module.shopping_cart_table.dynamodb_table_arn]
  iam_policy_type          = "Delete"
  iam_policy_description   = "Policy for deleting from DynamoDB"
  lambda_code_filename     = "remove_item"
  function_name            = "RemoveItemFromShoppingCart"
}

module "query_shopping_cart" {
  source                   = "../../modules/lambda-module"
  dynamodb_table_name      = module.shopping_cart_table.dynamodb_table_name
  iam_policy_action        = ["dynamodb:Query"]
  iam_policy_resource_arns = [module.shopping_cart_table.dynamodb_table_arn]
  iam_policy_type          = "Query"
  iam_policy_description   = "Policy for quering to DynamoDB"
  lambda_code_filename     = "get_cart"
  function_name            = "GetShoppingCart"
}

module "cognito" {
  source = "../../modules/cognito"
  user_pool_name = "ShoppingCartAuth"
}

module "api" {
  source                            = "../../modules/api-gateway-module"
  rest_api_name                     = "ShoppingCartApi"
  post_lambda_function   = module.add_item_to_shopping_cart
  delete_lambda_function = module.delete_item_from_shopping_cart
  get_lambda_function    = module.query_shopping_cart
  user_pool_arn = module.cognito.user_pool_arn
}

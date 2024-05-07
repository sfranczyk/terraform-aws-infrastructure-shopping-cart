variable "rest_api_name" {
  type = string
  default = "ShoppingCart"
}

variable "user_pool_arn" {
  type = string
  default = null
}

variable "cognito_authorizer_name" {
  type = string
  default = "ShoppingCartAuthorizer"
}

variable "post_lambda_function" {
  type = object({
    invoke_arn = string
    function_name = string
  })
}

variable "delete_lambda_function" {
  type = object({
    invoke_arn = string
    function_name = string
  })
}

variable "get_lambda_function" {
  type = object({
    invoke_arn = string
    function_name = string
  })
}
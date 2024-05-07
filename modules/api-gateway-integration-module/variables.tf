variable "api_id" {
  type = string
}

variable "resource_id" {
  type = string
}

variable "http_method" {
  type = string
}

variable "authorization" {
  type = string
  default = "NONE"
}

variable "cognito_authorizer_id" {
  type = string
  default = null
}

variable "passthrough_behavior" {
  type = string
  default = "WHEN_NO_TEMPLATES"
}

variable "integration_content_handling" {
  type = string
  default = null
}

variable "integration_request_templates" {
    type = map(string)
    default = null
}

variable "integration_type" {
  type = string
  default = "AWS_PROXY"
}

variable "lambda_invoke_arn" {
  type = string
  default = null
}

variable "method_response_models" {
  type = map(string)
  default = null
}

variable "method_response_parameters" {
  type = map(string)
  default = {
    "method.response.header.Access-Control-Allow-Origin" = false
  }
}

variable "integration_response_templates" {
  type = map(string)
  default = {}
}

variable "integration_response_parameters" {
  type = map(string)
  default = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}
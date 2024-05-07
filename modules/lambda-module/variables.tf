variable "lambda_code_filename" {
  type = string
}

variable "function_name" {
  type = string
}

variable "dynamodb_table_name" {
  type = string
}

variable "iam_policy_type" {
    type        = string
    description = "Type of policy"
}

variable "iam_policy_description" {
    type        = string
    description = "Description of the policy"
}

variable "iam_policy_action" {
    type        = list(string)
    description = "Action to be allowed"
}

variable "iam_policy_resource_arns" {
    type        = list(string)
    description = "Resource to be allowed"
}

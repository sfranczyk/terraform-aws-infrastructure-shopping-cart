variable "policy_type" {
    type        = string
    description = "Type of policy"
}

variable "policy_description" {
    type        = string
    description = "Description of the policy"
}

variable "action" {
    type        = list(string)
    description = "Action to be allowed"
}

variable "resource_arns" {
    type        = list(string)
    description = "Resource to be allowed"
}
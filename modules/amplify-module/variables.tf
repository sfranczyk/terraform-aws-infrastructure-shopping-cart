variable "frontend_app_name" {
    type        = string
    description = "The name of the frontend app"
}

variable "frontend_app_repository" {
    type        = string
    description = "The repository of the frontend app"
}

variable "repository_access_token" {
    type        = string
    description = "The access token of the repository"
}

variable "api_gateway_deployment_invoke_url" {
    type        = string
    description = "The invoke URL of the API Gateway deployment"
}
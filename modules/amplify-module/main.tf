resource "aws_amplify_app" "app_frontend" {

  name       = var.frontend_app_name
  repository = var.frontend_app_repository

  access_token = var.repository_access_token

  build_spec = <<EOF
version: 1
frontend:
  phases:
    preBuild:
      commands:
        - npm ci --cache .npm --prefer-offline
    build:
      commands:
        - npm run build
  artifacts:
    baseDirectory: build
    files:
      - '**/*'
  cache:
    paths:
      - .npm/**/*
EOF

  environment_variables = {
    REACT_APP_API_URL = var.api_gateway_deployment_invoke_url
  }

  enable_auto_branch_creation = true

  auto_branch_creation_patterns = [
    "*",
    "*/**",
  ]

  auto_branch_creation_config {
    enable_auto_build       = true
  }

}

resource "aws_amplify_branch" "master" {
  app_id            = aws_amplify_app.app_frontend.id
  branch_name       = "master"
  display_name      = "master"
  enable_auto_build = true
  framework         = "React"
  stage             = "PRODUCTION"
}

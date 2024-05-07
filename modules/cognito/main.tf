resource "aws_cognito_user_pool" "user_pool" {
  name = var.user_pool_name

  password_policy {
    minimum_length    = 8
    require_uppercase = false
    require_lowercase = true
    require_numbers   = true
    require_symbols   = false
    temporary_password_validity_days = 3
  }

  alias_attributes = ["preferred_username"]

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
  }

  mfa_configuration = "OFF"

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  admin_create_user_config {
    allow_admin_create_user_only = true
  }

  username_configuration {
    case_sensitive = false
  }

  account_recovery_setting {
    recovery_mechanism {
      priority = 1
      name     = "admin_only"
    }
  }
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name                          = var.user_pool_client_name
  user_pool_id                  = aws_cognito_user_pool.user_pool.id
  prevent_user_existence_errors = "ENABLED"
  explicit_auth_flows           = ["ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_SRP_AUTH"]
}

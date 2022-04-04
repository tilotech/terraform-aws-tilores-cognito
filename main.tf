resource "aws_cognito_user_pool" "pool" {
  name = local.prefix

  account_recovery_setting {
    recovery_mechanism {
      name     = "admin_only"
      priority = 1
    }
  }

  admin_create_user_config {
    allow_admin_create_user_only = true
  }
}

resource "aws_cognito_resource_server" "resource" {
  identifier = var.resource_server_identifier
  name       = var.resource_server_identifier

  dynamic "scope" {
    for_each = var.available_scopes
    content {
      scope_name        = scope.value["name"]
      scope_description = scope.value["description"]
    }
  }

  user_pool_id = aws_cognito_user_pool.pool.id
}

resource "aws_cognito_user_pool_client" "client" {
  depends_on = [
    aws_cognito_resource_server.resource
  ]

  for_each = var.clients

  name                 = each.key
  allowed_oauth_flows  = try(each.value["allowed_oauth_flows"], ["client_credentials"])
  allowed_oauth_scopes = try(each.value["allowed_scopes"], [])
  generate_secret      = try(each.value["generate_secret"], true)
  explicit_auth_flows = try(each.value["explicit_auth_flows"], [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ])
  allowed_oauth_flows_user_pool_client = true

  access_token_validity  = try(each.value["access_token_validity"], var.access_token_validity)
  id_token_validity      = try(each.value["id_token_validity"], 60)
  refresh_token_validity = try(each.value["refresh_token_validity"], 30)

  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }

  prevent_user_existence_errors = "ENABLED"

  callback_urls                = try(each.value["callback_urls"], null)
  logout_urls                  = try(each.value["logout_urls"], null)
  supported_identity_providers = try(each.value["supported_identity_providers"], null)

  user_pool_id = aws_cognito_user_pool.pool.id
}

resource "aws_cognito_user_pool_domain" "domain" {
  domain       = local.prefix
  user_pool_id = aws_cognito_user_pool.pool.id
}

# Plans the module with the AWS provider mocked, so the test needs no AWS
# access. Run with `terraform init && terraform test`.

mock_provider "aws" {}

variables {
  resource_prefix = "test"

  available_scopes = [
    {
      name        = "read"
      description = "allows all read requests"
    },
    {
      name        = "write"
      description = "allows all write requests"
    }
  ]

  clients = {
    # Without settings of its own, a client gets the defaults for machine to
    # machine access.
    client = {
      allowed_scopes = ["tilores/read", "tilores/write"]
    }
    # A client for a user interface sets its own flow and has no secret.
    ui_client = {
      allowed_oauth_flows = ["code"]
      allowed_scopes      = ["openid"]
      generate_secret     = false
      callback_urls       = ["http://localhost:3000/login"]
    }
  }
}

run "user_pool_plans" {
  command = plan

  # The token URL contains the region of the user pool.
  override_data {
    target = data.aws_region.current
    values = {
      region = "eu-central-1"
    }
  }

  assert {
    condition = (
      one(aws_cognito_user_pool.pool.admin_create_user_config).allow_admin_create_user_only == true
      && alltrue([for m in one(aws_cognito_user_pool.pool.account_recovery_setting).recovery_mechanism : m.name == "admin_only"])
    )
    error_message = "Only an administrator may create users and recover accounts: nobody may sign up or reset a password on their own."
  }

  assert {
    condition = (
      aws_cognito_user_pool.pool.name == "test-tilores"
      && aws_cognito_user_pool_domain.domain.domain == "test-tilores"
      && output.token_url == "https://test-tilores.auth.eu-central-1.amazoncognito.com/oauth2/token"
    )
    error_message = "The user pool and its domain must be named after the resource prefix, and the token URL must point at that domain."
  }

  assert {
    condition = (
      aws_cognito_user_pool_client.client["client"].allowed_oauth_flows == toset(["client_credentials"])
      && aws_cognito_user_pool_client.client["client"].generate_secret == true
      && aws_cognito_user_pool_client.client["ui_client"].allowed_oauth_flows == toset(["code"])
      && aws_cognito_user_pool_client.client["ui_client"].generate_secret == false
    )
    error_message = "A client without settings must use the client credentials flow with a secret; a client with settings must keep them."
  }

  assert {
    condition = (
      aws_cognito_user_pool_client.client["client"].access_token_validity == 60
      && one(aws_cognito_user_pool_client.client["client"].token_validity_units).access_token == "minutes"
    )
    error_message = "An access token must expire after 60 minutes unless the client sets another validity."
  }
}

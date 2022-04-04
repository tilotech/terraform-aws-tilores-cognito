# TiloRes Cognito Module for Terraform

Public Terraform Module for creating a cognito user pool for usage with the default TiloRes authentication and authorization.

## Usage

```hcl
module "cognito" {
  source = "tilotech/tilores-cognito/aws"

  resource_prefix = "mycompany-dev"
  
  available_scopes = [
    {
      name : "write"
      description : "allows all write requests"
    },
    {
      name : "read"
      description : "allows all read requests"
    }
  ]

  resource_server_identifier = "myproduct"
  clients = tomap({
    client = {
      allowed_scopes = ["myproduct/write", "myproduct/read"]
    }
  })
}
```

## Configuring the Application Clients

By default the module should be used like this:

```hcl
module "cognito" {
  source = "tilotech/tilores-cognito/aws"
  ...
  clients = {
    client = {
      allowed_scopes = [
        ...
      ]
    }
  }
}
```

This will create an application client with the name "client", which can be used
for machine to machine communication using the client credentials flow.

If you want to create a client that can be used with other flows, you have to
customize the configuration.

```hcl
module "cognito" {
  source = "tilotech/tilores-cognito/aws"
  ...
  clients = {
    client = {
      allowed_scopes = [
        ...
      ]
    }
    ui_client = {
      allowed_oauth_flows = ["code"]
      allowed_scopes = [
        "openid",
        "profile",
        ...
      ]
      generate_secret = false
      explicit_auth_flows = [
        "ALLOW_USER_SRP_AUTH",
        "ALLOW_REFRESH_TOKEN_AUTH"
      ]
      access_token_validity = 120
      id_token_validity = 120
      refresh_token_validity = 60
      callback_urls = [
        "http://localhost:3000/login"
      ]
      logout_urls = [
        "http://localhost:3000/logout"
      ]
      supported_identity_providers = [
        "COGNITO"
      ]
    }
  }
}
```

This will add a second application client with the name "ui_client", that uses a
code flow, doesn't have a secret generated (public client) and uses custom token
validity times.

The default values are as follows:

```
allowed_oauth_flows = ["client_credentials"]
allowed_scopes = []
generate_secret = true
explicit_auth_flows = [
  "ALLOW_USER_PASSWORD_AUTH",
  "ALLOW_REFRESH_TOKEN_AUTH"
]
access_token_validity = 60
id_token_validity = 60
refresh_token_validity = 30
callback_urls = null
logout_urls = null
supported_identity_providers = null
```

Access and ID token validity are provided in hours. The refresh token validity is provided in days.
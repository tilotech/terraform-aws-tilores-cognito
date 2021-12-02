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
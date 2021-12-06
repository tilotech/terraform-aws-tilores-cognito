output "issuer_url" {
  value       = format("https://%s", aws_cognito_user_pool.pool.endpoint)
  description = "The issuer URL of the created Cognito User Pool for use with the API Gateway."
}

output "token_url" {
  value       = format("https://%s.auth.%s.amazoncognito.com/oauth2/token", aws_cognito_user_pool_domain.domain.domain, data.aws_region.current.name)
  description = "The URL for receiving an access token using the OAuth 2.0 client credentials flow."
}

output "client_ids" {
  value = tomap({
    for k, client in aws_cognito_user_pool_client.client : k => client.id
  })
  description = "The client IDs."
}

output "client_secrets" {
  value = tomap({
    for k, client in aws_cognito_user_pool_client.client : k => client.client_secret
  })
  description = "The client secrets."
}

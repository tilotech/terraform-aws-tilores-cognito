output "issuer_url" {
  value       = format("https://%s", aws_cognito_user_pool.pool.endpoint)
  description = "The issuer URL of the created Cognito User Pool for use with the API Gateway."
}

output "token_url" {
  value       = format("https://%s.auth.%s.amazoncognito.com/oauth2/token", aws_cognito_user_pool_domain.domain.domain, data.aws_region.current.name)
  description = "The URL for receiving an access token using the OAuth 2.0 client credentials flow."
}

output "user_pool_domain" {
  value       = format("%s.auth.%s.amazoncognito.com", aws_cognito_user_pool_domain.domain.domain, data.aws_region.current.name)
  description = "The domain name of the user pool, used by all OAuth 2.0 flows."
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

output "cloudfront_distribution_arn" {
  value       = aws_cognito_user_pool_domain.domain.cloudfront_distribution_arn
  description = "The URL of the CloudFront distribution. This is required to generate the ALIAS aws_route53_record."
}

output "user_pool_id" {
  value       = aws_cognito_user_pool.pool.id
  description = "The ID of the created Cognito user pool."
}

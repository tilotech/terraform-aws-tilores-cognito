variable "resource_prefix" {
  type        = string
  description = "The text every created resource will be prefixed with."
}

variable "resource_server_identifier" {
  type        = string
  default     = "tilores"
  description = "The name of the resource server that will be created."
}

variable "available_scopes" {
  type = list(object({
    name        = string
    description = string
  }))
  description = "The available scopes that can be assigned to a client. Note, that each scope when used will be prefixed with the resource_server_identifier."
}

variable "clients" {
  type        = any
  description = "The clients to create."
}

variable "access_token_validity" {
  type        = number
  default     = 60
  description = "The time (in minutes) after which the access token is no longer valid and cannot be used. Valid values are between 5 and 1440 minutes (1 day)."
}

locals {
  prefix = format("%s-tilores", var.resource_prefix)
}

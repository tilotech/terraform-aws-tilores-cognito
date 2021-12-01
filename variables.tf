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
  type = map(object({
    allowed_scopes = list(string)
  }))
  description = "The clients to create."
}

locals {
  prefix = format("%s-tilores", var.resource_prefix)
}

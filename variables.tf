variable "resource_prefix" {
  type        = string
  description = "The text every created resource will be prefixed with."
}

locals {
  prefix = format("%s-tilores", var.resource_prefix)
}

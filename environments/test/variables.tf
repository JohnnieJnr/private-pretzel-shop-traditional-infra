# -----------------------------------------------------------------------------
# Test environment variables
# -----------------------------------------------------------------------------

variable "environment" {
  description = "Environment name (e.g. test, prod)."
  type        = string
}

variable "project_name" {
  description = "Project name used in resource naming and tags."
  type        = string
}

variable "digitalocean_token" {
  description = "DigitalOcean API token."
  type        = string
  sensitive   = true
}

variable "region" {
  description = "DigitalOcean region slug (e.g. nyc3, sfo3, sgp1)."
  type        = string
  default     = "nyc3"
}

variable "common_tags" {
  description = "Additional tags applied to all resources (key-value pairs)."
  type        = map(string)
  default     = {}
}

# variable "vpc_cidr" {
#   description = "CIDR block for the VPC (RFC1918, /16 to /24)."
#   type        = string
#   default     = "10.10.0.0/24"
# }

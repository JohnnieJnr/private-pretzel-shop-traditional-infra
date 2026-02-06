variable "project_name" {
  description = "Project name used in resource naming and tags."
  type        = string
  default     = "pretzel-shop"
}

variable "common_tags" {
  description = "Additional tags applied to all resources (key-value pairs)."
  type        = map(string)
  default = {
    Project     = "pretzel-shop"
    Environment = "production"
    Managedby   = "Terraform"
    Team        = "devops"
  }
}

variable "ghcr_credentials" {
  description = "Credentials for GHCR (GitHub Container Registry). Credentials should be in the format 'username:token'."
  type        = string
  sensitive   = true
}
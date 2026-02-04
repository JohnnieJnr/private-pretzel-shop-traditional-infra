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
    Environment = "staging"
    Managedby   = "Terraform"
    Team        = "devops"
  }
}

variable "ghcr_credentials" {
  description = "Credentials for GHCR (GitHub Container Registry). Credentials should be in the format 'username:token'."
  type        = string
  sensitive   = true

  validation {
    condition     = can(regex("^[a-z0-9_]+:(github_pat_|ghp_)[A-Za-z0-9_]+$", var.ghcr_credentials))
    error_message = "GHCR credentials must be in the format 'username:github_pat_<token>', where username is lowercase letters, numbers, or underscores, and token starts with 'github_pat_' or 'ghp_' followed by letters, numbers, or underscores."
  }
}
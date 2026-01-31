variable "project_name" {
  description = "Project name used in resource naming and tags."
  type        = string
  default     = "pretzel-shop"
}

variable "common_tags" {
  description = "Additional tags applied to all resources (key-value pairs)."
  type        = map(string)
  default     = {
  Project     = "pretzel-shop"
  Environment = "staging"
  Managedby   = "Terraform"
  Team        = "devops"
  }
}
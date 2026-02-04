variable "app_name" {
  description = "The name of the application"
  type        = string
}

variable "region" {
  description = "The region to deploy the application in"
  type        = string
  default     = "sfo3"
}

variable "backend_end" {
  description = "Environment variables for the backend"
  type        = map(string)
}
variable "backend_sensitive_env" {
  description = "Sensitive environment variables for the backend"
  type        = map(string)
  sensitive     = true
}
variable "project_id" {
  description = "The ID of the project to deploy the application in"
  type        = string
}
variable "postgres_cluster_name" {
  description = "The name of the Postgres database cluster"
  type        = string
}

variable "redis_cluster_name" {
  description = "The name of the Redis database cluster"
  type        = string
}

variable "ghcr_credentials" {
  description = "Credentials for GHCR (GitHub Container Registry). Credentials should be in the format 'username:token'."
  type        = string
  sensitive = true
}

variable "domain" {
  description = "The domain for the application"
  type        = string
  default = ""
  validation {
    condition = (
      var.domain == "" || can(regex("^([A-Za-z0-9]([A-Za-z0-9-]{0,61}[A-Za-z0-9])?\\.)+[A-Za-z]{2,63}$", var.domain))
    )
    error_message = "The domain must be a valid FQDN."
  }
}

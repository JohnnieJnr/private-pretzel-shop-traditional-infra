resource "digitalocean_project" "staging" {
  name        = "${var.project_name}-${local.environment}"
  purpose     = "Other"
  description = "Project for ${var.project_name} ${local.environment} environment"
  environment = local.environment
}
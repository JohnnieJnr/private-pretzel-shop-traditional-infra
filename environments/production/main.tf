resource "digitalocean_project" "this" {
  name        = "${var.project_name}-${local.environment}"
  purpose     = "Other"
  description = "Project for ${var.project_name} ${local.environment} environment"
  environment = local.environment
}

resource "digitalocean_domain" "app" {
  name = var.domain
}

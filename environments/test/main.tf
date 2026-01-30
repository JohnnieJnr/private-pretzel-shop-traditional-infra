terraform {
  required_version = ">= 1.13.0"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}
locals {
  environment = "staging"
}
provider "digitalocean" {
  token = var.digitalocean_token
}

resource "digitalocean_project" "this" {
  name = "${var.project_name}-${local.environment}"
  purpose = "Other"
  description = "Project for ${var.project_name} ${local.environment} environment"
  environment = local.environment
}
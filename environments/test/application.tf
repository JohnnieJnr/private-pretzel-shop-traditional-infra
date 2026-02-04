locals {

  
}

resource "digitalocean_app" "frontend" {
  spec {
    name   = "${var.project_name}-${local.environment}"
    region = "sfo3"

    service {
      name               = "frontend"
      instance_count     = 1
      instance_size_slug = "basic-xxs"

      image {
        registry_type        = "GHCR"
        registry             = "ghcr.io"
        repository           = "johnniejnr/pretzel-shop-fe"
        tag                  = "latest"
        registry_credentials = var.ghcr_credentials
      }

      http_port = 80

      health_check {
        http_path             = "/health"
        initial_delay_seconds = 10
        period_seconds        = 2
        timeout_seconds       = 2
        success_threshold     = 1
        failure_threshold     = 3
      }
    }


  }

}

module "app" {
  source                = "../../modules/app"
  app_name              = "${var.project_name}-${local.environment}"
  region                = local.region
  project_id            = digitalocean_project.this.id
  backend_end           = local.backend_end
  backend_sensitive_env = local.backend_sensitive_env
  postgres_cluster_name = module.postgres.postgres_cluster_name
  redis_cluster_name    = module.redis.redis_cluster_name
  ghcr_credentials      = var.ghcr_credentials
}
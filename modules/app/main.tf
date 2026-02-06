resource "digitalocean_app" "backend" {
  spec {
    name   = var.app_name
    region = var.region

    dynamic "domain" {
      for_each = var.domain != "" ? [1] : []
      content {
        name     = var.domain
        type     = "PRIMARY"
        wildcard = false
        zone     = var.domain
      }
    }

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
    service {
      name               = "backend"
      instance_count     = 1
      instance_size_slug = "basic-xxs"

      image {
        registry_type        = "GHCR"
        registry             = "ghcr.io"
        repository           = "johnniejnr/pretzel-shop-be"
        tag                  = "latest"
        registry_credentials = var.ghcr_credentials
      }

      http_port = 3000

      health_check {
        http_path             = "/health"
        initial_delay_seconds = 10
        period_seconds        = 2
        timeout_seconds       = 2
        success_threshold     = 1
        failure_threshold     = 3
      }

      dynamic "env" {
        for_each = var.backend_end
        content {
          key   = env.key
          value = env.value
          type  = "GENERAL"
        }
      }

      dynamic "env" {
        for_each = var.backend_sensitive_env
        content {
          key   = env.key
          value = env.value
          type  = "SECRET"
        }
      }
    }
    database {
      name         = "postgres"
      engine       = "PG"
      production   = true
      cluster_name = var.postgres_cluster_name
    }

    database {
      name         = "redis"
      engine       = "VALKEY"
      production   = true
      cluster_name = var.redis_cluster_name
    }

    ingress {
      rule {
        component {
          name = "backend"
        }
        match {
          path {
            prefix = "/api"
          }
        }
      }
      rule {
        component {
          name = "frontend"
        }
        match {
          path {
            prefix = "/"
          }
        }
      }
    }
  }

  project_id = var.project_id
}

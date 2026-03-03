resource "digitalocean_app" "this" {
  spec {
    name   = var.app_name
    region = substr(var.region, 0, length(var.region) - 1)

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
      name = "otel-collector"
      instance_count = 1
      instance_size_slug = "basic-xxs" 
      image {
        registry_type        = "GHCR"
        registry             = "ghcr.io"
        repository           = "johnniejnr/pretzel-shop-observability-otel"
        tag                  = "latest"
        registry_credentials = var.ghcr_credentials
      }

      internal_ports = [4317, 4318]

    }

    service {
      name               = "tempo"
      instance_count     = 1
      instance_size_slug = "basic-xxs"
      image {
        registry_type        = "GHCR"
        registry             = "ghcr.io"
        repository           = "johnniejnr/pretzel-shop-observability-tempo"
        tag                  = "latest"
        registry_credentials = var.ghcr_credentials
      }

      http_port      = 3200
      internal_ports = [4319, 4320]
    }

    service {
      name               = "loki"
      instance_count     = 1
      instance_size_slug = "basic-xxs"
      image {
        registry_type        = "GHCR"
        registry             = "ghcr.io"
        repository           = "johnniejnr/pretzel-shop-observability-loki"
        tag                  = "latest"
        registry_credentials = var.ghcr_credentials
      }

      http_port = 3100
    }

    service {
      name               = "prometheus"
      instance_count     = 1
      instance_size_slug = "basic-xxs"
      image {
        registry_type        = "GHCR"
        registry             = "ghcr.io"
        repository           = "johnniejnr/pretzel-shop-observability-prometheus"
        tag                  = "latest"
        registry_credentials = var.ghcr_credentials
      }

      http_port = 9090
    }

    service {
      name               = "grafana"
      instance_count     = 1
      instance_size_slug = "basic-xxs"
      image {
        registry_type        = "GHCR"
        registry             = "ghcr.io"
        repository           = "johnniejnr/pretzel-shop-observability-grafana"
        tag                  = "latest"
        registry_credentials = var.ghcr_credentials
      }

      http_port = 3000

      env {
        key   = "GF_SECURITY_ADMIN_USER"
        value = "admin"
        type  = "GENERAL"
      }

      env {
        key   = "GF_SECURITY_ADMIN_PASSWORD"
        value = "admin"
        type  = "GENERAL"
      }

      env {
        key   = "GF_SERVER_DOMAIN"
        value = var.domain
        type  = "GENERAL"
      }

      env {
        key   = "GF_SERVER_PROTOCOL"
        value = "http"
        type  = "GENERAL"
      }

      env {
        key   = "GF_SERVER_ROOT_URL"
        value = "https://${var.domain}/grafana/"
        type  = "GENERAL"
      }
    }

    # Frontend service
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
 
    # Backend service
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
        for_each = var.backend_env
        content {
          key   = env.key
          value = env.value
          type  = "GENERAL"
        }
      }

      env {
        key   = "LOKI_URL"
        value = "http://loki:3100"
        type  = "GENERAL"
      }

      env {
        key   = "LOKI_LABELS"
        value = "env=staging"
        type  = "GENERAL"
      }

      env {
        key   = "OTEL_EXPORTER_OTLP_ENDPOINT"
        value = "http://otel-collector:4318"
        type  = "GENERAL"
      }

      env {
        key   = "OTEL_SERVICE_NAME"
        value = "${var.app_name}-backend"
        type  = "GENERAL"
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
          name = "grafana"
        }
        match {
          path {
            prefix = "/grafana"
          }
        }
      }
      rule {
        component {
          name = "prometheus"
        }
        match {
          path {
            prefix = "/prometheus"
          }
        }
      }
      rule {
        component {
          name = "loki"
        }
        match {
          path {
            prefix = "/loki"
          }
        }
      }
      rule {
        component {
          name = "tempo"
        }
        match {
          path {
            prefix = "/tempo"
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

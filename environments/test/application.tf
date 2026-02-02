locals {

  backend_end = {
    PORT = 3000
    NODE_ENV   = "production"
    DB_HOST     = module.postgres.postgres_uri
    DB_PORT     = module.postgres.postgres_port
    DB_NAME     = module.postgres.postgres_database
    DB_USER     = module.postgres.postgres_user
    
    REDIS_HOST = module.redis.redis_uri
    REDIS_PORT = module.redis.redis_port
    REDIS_USER = module.redis.redis_user

    CORS_ORIGIN = ""

  }
  backend_sensitive_env = {
    REDIS_PASSWORD = module.redis.redis_password
    DB_SSl_CA = module.postgres.postgres_ca
    DB_PASSWORD = module.postgres.postgres_password
    }
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
        registry_type = "GHCR"
        registry      = "ghcr.io"
        repository    = "johnniejnr/pretzel-shop-fe"
        tag           = "latest"
        registry_credentials = var.ghcr_credentials
        }
    
        http_port  = 80
        
        health_check {
            http_path = "/health"
            initial_delay_seconds = 10
            period_seconds = 2
            timeout_seconds = 2
            success_threshold = 1
            failure_threshold = 3
        }
    }
        
        
}
    
}

resource "digitalocean_app" "backend" {
spec {
    name   = "${var.project_name}-${local.environment}"
    region = local.region

    service {
        name               = "backend"
        instance_count     = 1
        instance_size_slug = "basic-xxs"

        image {
        registry_type = "GHCR"
        registry      = "ghcr.io"
        repository    = "johnniejnr/pretzel-shop-be"
        tag           = "latest"
        registry_credentials = var.ghcr_credentials
        }
     
        http_port = 3000

        health_check {
            http_path = "/health"
            initial_delay_seconds = 10
            period_seconds = 2
            timeout_seconds = 2
            success_threshold = 1
            failure_threshold = 3
        }
        
        dynamic "env" {
            for_each = local.backend_end
            content {
                key   = env.key
                value = env.value
                type = "GENERAL"
            }
          }

        dynamic "env" {
            for_each = local.backend_sensitive_env
            content {
                key   = env.key
                value = env.value
                type = "SENSITIVE"
            }
          }
        }
        database {
          name = "postgres"
          engine = "POSTGRES"
          production = true
          cluster_name = module.postgres.postgres_cluster_name
        }
        database {
          name = "redis"
          engine = "REDIS"
          production = true
          cluster_name = module.redis.redis_cluster_name
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
    project_id = digitalocean_project.this.id

}
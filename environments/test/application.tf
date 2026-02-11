module "app" {
  source                = "../../modules/app"
  app_name              = "${var.project_name}-${local.environment}"
  region                = local.region
  project_id            = digitalocean_project.this.id
  backend_env           = local.backend_env
  backend_sensitive_env = local.backend_sensitive_env
  postgres_cluster_name = module.postgres.postgres_cluster_name
  redis_cluster_name    = module.redis.redis_cluster_name
  ghcr_credentials      = var.ghcr_credentials
}

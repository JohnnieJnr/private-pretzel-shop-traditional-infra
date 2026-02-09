module "redis" {
  source = "../../modules/database"

  cluster_name = "${var.project_name}-${local.environment}-redis"
  create_redis = true
  project_id   = digitalocean_project.staging.id
  environment  = local.environment
  tags         = local.tags
}

module "postgres" {
  source = "../../modules/database"

  cluster_name    = "${var.project_name}-${local.environment}-postgres"
  create_postgres = true
  project_id      = digitalocean_project.staging.id
  environment     = local.environment
  tags            = local.tags
}

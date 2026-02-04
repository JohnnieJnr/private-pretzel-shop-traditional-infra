module "redis" {
  source = "../../modules/database"

  cluster_name = "${var.project_name}-${local.environment}"
  create_redis = true
  project_id   = digitalocean_project.this.id
  environment  = local.environment
  tags         = local.tags
}

module "postgres" {
  source = "../../modules/database"

  cluster_name    = "${var.project_name}-${local.environment}"
  create_postgres = true
  project_id      = digitalocean_project.this.id
  environment     = local.environment
  tags            = local.tags
}
locals {
  redis_node_count = {
    staging = 1
    production = 2
  }
  region = "sfo3"

  redis_size = {
    staging = "db-s-1vcpu-1gb"
    production = "db-s-2vcpu-2gb"
  }
  postgres_node_count = {
    staging = 1
    production = 2
  }

  postgres_size = {
    staging = "db-s-1vcpu-1gb"
    production = "db-s-2vcpu-2gb"
  }
}

resource "digitalocean_database_cluster" "redis" {
    count = var.create_redis ? 1 : 0
  name       = var.cluster_name
  engine     = "valkey"
  version    = "8"
  size       = local.redis_size[var.environment]
  region     = local.region
  node_count = local.redis_node_count[var.environment]

  tags = var.tags
  
  project_id = var.project_id
}

resource "digitalocean_database_cluster" "postgres" {
    count = var.create_postgres ? 1 : 0
  name       = var.cluster_name
  engine     = "pg"
  version    = "15"
  size       = local.postgres_size[var.environment]
  region     = local.region
  node_count = local.postgres_node_count[var.environment]

  tags = var.tags
  
  project_id = var.project_id

  
}

data "digitalocean_database_ca" "ca" {
  count = var.create_postgres ? 1 : 0
  cluster_id = digitalocean_database_cluster.postgres[0].id
}

data "digitalocean_database_ca" "redis_ca" {
  count = var.create_redis ? 1 : 0
  cluster_id = digitalocean_database_cluster.redis[0].id
}

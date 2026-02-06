output "postgres_uri" {
  description = "The connection URI of the database cluster."
  value = length(digitalocean_database_cluster.postgres) > 0 ? digitalocean_database_cluster.postgres[0].host: null
  sensitive = true
}

output "postgres_private_uri" {
  description = "The private URI of the database cluster."
  value = length(digitalocean_database_cluster.postgres) > 0 ? digitalocean_database_cluster.postgres[0].private_uri : null
  sensitive = true
}
output "postgres_cluster_id" {
  description = "The ID of the Postgres database cluster."
  value = length(digitalocean_database_cluster.postgres) > 0 ? digitalocean_database_cluster.postgres[0].id : null
}

output "postgres_user" {
  description = "The username for the database cluster."
  value = length(digitalocean_database_cluster.postgres) > 0 ? digitalocean_database_cluster.postgres[0].user : null
  sensitive = true
}

output "postgres_port" {
  description = "The port number for the database cluster."
  value = length(digitalocean_database_cluster.postgres) > 0 ? digitalocean_database_cluster.postgres[0].port : null
}

output "postgres_database" {
  description = "The name of the database cluster."
  value = length(digitalocean_database_cluster.postgres) > 0 ? digitalocean_database_cluster.postgres[0].name : null
}

output "postgres_password" {
  description = "The password for the database cluster."
  value = length(digitalocean_database_cluster.postgres) > 0 ? digitalocean_database_cluster.postgres[0].password : null
  sensitive = true
}

output "postgres_ca" {
    description = "The CA certificate for the Postgres cluster."
    value = length(data.digitalocean_database_ca.ca) > 0 ? data.digitalocean_database_ca.ca[0].certificate : null
    sensitive = true
}
output "redis_uri" {
  description = "The Redis URI."
  value = length(digitalocean_database_cluster.redis) > 0 ? digitalocean_database_cluster.redis[0].uri : null
  sensitive = true
}

output "redis_ca" {
  description = "The CA certificate for the Redis/Valkey cluster."
  value = length(data.digitalocean_database_ca.redis_ca) > 0 ? data.digitalocean_database_ca.redis_ca[0].certificate : null
  sensitive = true
}

output "redis_private_uri" {
  description = "The private URI of the Redis cluster."
  value = length(digitalocean_database_cluster.redis) > 0 ? digitalocean_database_cluster.redis[0].private_uri : null
  sensitive = true
}


output "redis_cluster_id" {
  description = "The ID of the Redis database cluster."
  value = length(digitalocean_database_cluster.redis) > 0 ? digitalocean_database_cluster.redis[0].id : null
}

output "redis_cluster_name" {
  description = "The name of the Redis database cluster."
  value = length(digitalocean_database_cluster.redis) > 0 ? digitalocean_database_cluster.redis[0].name : null
}

output "postgres_cluster_name" {
  description = "The name of the Postgres database cluster."
  value = length(digitalocean_database_cluster.postgres) > 0 ? digitalocean_database_cluster.postgres[0].name : null
}

output "project_id" {
  description = "Id of the project"
  value = digitalocean_project.this.id  
}

# output "redis_uri" {
#   description = "Redis connection URI (contains password - mark sensitive in caller)."
#   value       = digitalocean_database_cluster.redis.uri
#   sensitive   = true
# }

# output "redis_private_uri" {
#   description = "Redis private URI for in-VPC access."
#   value       = digitalocean_database_cluster.redis.private_uri
#   sensitive   = true
# }
# output "redis_cluster_password" {
#   description = "password for the Redis database cluster."
#   value       = digitalocean_database_cluster.redis.password
#   sensitive   = true
# }

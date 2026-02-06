locals {
  tags        = [for k, v in var.common_tags : "${k}:${v}"]
  environment = "staging"
  region      = "sfo3"
  backend_end = {
    PORT     = 3000
    NODE_ENV = "production"
    DB_HOST  = module.postgres.postgres_uri
    DB_PORT  = module.postgres.postgres_port
    DB_NAME  = module.postgres.postgres_database
    DB_USER  = module.postgres.postgres_user
    PGSSLMODE = "require"

    CORS_ORIGIN = ""

  }
  backend_sensitive_env = {
    REDIS_URI   = module.redis.redis_uri
    REDIS_CA    = module.redis.redis_ca
    DB_SSl_CA   = module.postgres.postgres_ca
    DB_SSL_CA   = module.postgres.postgres_ca
    PGSSLROOTCERT = module.postgres.postgres_ca
    DB_PASSWORD = module.postgres.postgres_password
  }
}

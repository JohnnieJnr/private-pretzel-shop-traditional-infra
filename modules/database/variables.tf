variable "cluster_name" {
  type = string
  description = "Name of the database cluster. use variable to customize the name of the database"
}

variable "create_postgres" {
  type = bool
  description = "Whether to create a PostgreSQL database."
  default = false
}

variable "create_redis" {
  type = bool
  description = "Whether to create a Redis database."
  default = false
}

variable "tags" {
  type = list(string)
  description = "Tags to apply to the database cluster."
  default = [  ]
}

variable "project_id" {
  type = string
  description = "ID of the project to create the databse cluster in."
  default = null
}

variable "environment" {
  type = string
  description = "Environment to create the database cluster in."
  default = "staging"
}
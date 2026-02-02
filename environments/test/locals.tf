locals {
    tags = [ for k, v in var.common_tags : "${k}:${v}" ]
    environment = "staging"
    region      = "sfo3"
}
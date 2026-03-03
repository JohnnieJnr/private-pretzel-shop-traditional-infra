terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.78"
    }
  }
}

provider "digitalocean" {}

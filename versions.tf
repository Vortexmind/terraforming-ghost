terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
    template = {
      source = "hashicorp/template"
    }
  }
  required_version = "~> 0.13"
}

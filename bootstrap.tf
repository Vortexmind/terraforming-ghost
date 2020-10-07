provider "digitalocean" {
  version = "1.22.1"
  token = var.digitalocean_token
}

provider "cloudflare" {
  version = "2.11.0"
  api_key = var.cloudflare_api_key
  email = var.cloudflare_email
}

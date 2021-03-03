provider "digitalocean" {
  version = "2.5.1"
  token = var.digitalocean_token
}

provider "cloudflare" {
  version = "2.18.0"
  api_key = var.cloudflare_api_key
  email = var.cloudflare_email
}

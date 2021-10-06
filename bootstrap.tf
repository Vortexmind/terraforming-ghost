provider "digitalocean" {
  token = var.digitalocean_token
}

provider "cloudflare" {
  api_key = var.cloudflare_api_key
  email = var.cloudflare_email
}

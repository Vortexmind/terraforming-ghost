provider "digitalocean" {
  version = "1.22.1"
  token = var.digitalocean_token
}

provider "template" {
  version = "2.1.2"
}

provider "cloudflare" {
  version = "2.11.0"
  api_key = var.cloudflare_api_key
  email = var.cloudflare_email
}

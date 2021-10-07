provider "digitalocean" {
  token = var.digitalocean_token
}

provider "cloudflare" {
  api_key = var.cloudflare_api_key
  email = var.cloudflare_email
}

locals {
    cloudflare_fqdn = format("%s.%s",var.cloudflare_cname_record,var.cloudflare_domain)
    user_from_mail = split("@", var.user_email)[0]
}
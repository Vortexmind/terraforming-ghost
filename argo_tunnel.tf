

resource "cloudflare_tunnel" "ssh_browser" {
  account_id = var.cloudflare_account_id
  name       = "cloudflare_ssh_browser"
  secret     = base64encode(var.cloudflare_tunnel_secret)
}

resource "cloudflare_record" "ssh_app" {
  zone_id = lookup(data.cloudflare_zones.ghost_domain_zones.zones[0], "id")
  name    = var.cloudflare_cname_record
  value   = "${cloudflare_tunnel.ssh_browser.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_access_application" "ssh_browser" {
  zone_id          = lookup(data.cloudflare_zones.ghost_domain_zones.zones[0], "id")
  name             = format("%s - Auth",local.cloudflare_fqdn)
  type             = "ssh"
  domain           = local.cloudflare_fqdn
  session_duration = "30m"
}

resource "cloudflare_access_policy" "ssh_policy" {
  application_id = cloudflare_access_application.ssh_browser.id
  zone_id        = lookup(data.cloudflare_zones.ghost_domain_zones.zones[0], "id")
  name           = "Allow Configured Users"
  precedence     = "1"
  decision       = "allow"

  include {
    email = [var.user_email]
  }

}

resource "cloudflare_access_ca_certificate" "ssh_short_lived" {
  account_id     = var.cloudflare_account_id
  application_id = cloudflare_access_application.ssh_browser.id
}
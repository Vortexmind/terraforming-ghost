data "cloudflare_zones" "ghost_domain_zones" {
  filter {
    name   = var.cloudflare_domain
    status = "active"
  }
}

resource "cloudflare_record" "ghost_blog_record" {
  zone_id = lookup(data.cloudflare_zones.ghost_domain_zones.zones[0], "id")
  type    = "A"
  name    = var.ghost_blog_dns
  value   = data.digitalocean_droplet.web.ipv4_address
  ttl     = "1"
	proxied = true
 }

 resource "cloudflare_record" "commento_record" {
  zone_id = lookup(data.cloudflare_zones.ghost_domain_zones.zones[0], "id")
  type    = "A"
  name    = var.commento_dns
  value   = data.digitalocean_droplet.web.ipv4_address
  ttl     = "1"
	proxied = true
 }

 resource "cloudflare_record" "static_record" {
  zone_id = lookup(data.cloudflare_zones.ghost_domain_zones.zones[0], "id")
  type    = "A"
  name    = var.static_dns
  value   = data.digitalocean_droplet.web.ipv4_address
  ttl     = "1"
	proxied = true
 }

resource "cloudflare_zone_settings_override" "ghost_zone_settings" {
    zone_id = lookup(data.cloudflare_zones.ghost_domain_zones.zones[0], "id")
    settings {
        always_use_https = "on"
        automatic_https_rewrites = "on"
        always_online = "on"
        http3 = "on"
        min_tls_version = "1.2"
        brotli = "on"
        ssl = "full"
        minify {
            css = "on"
            js = "on"
            html = "on"
        }
    }
}

resource "cloudflare_authenticated_origin_pulls" "auth_origin_pull" {
  zone_id     = lookup(data.cloudflare_zones.ghost_domain_zones.zones[0], "id")
  enabled     = true
}
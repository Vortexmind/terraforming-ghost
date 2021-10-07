resource "digitalocean_project" "ghost-terraform" {
  name        = "ghost-terraform"
  description = "A Ghost blog with Commento, using Terraform and docker-compose"
  purpose     = "Web Application"
  environment = "Production"
  resources = [digitalocean_droplet.web.urn]
}

data "digitalocean_ssh_key" "default" {
  name       = var.digitalocean_key_name  
}

data "digitalocean_volume" "block-volume" {
  name   = var.digitalocean_volume_name
  region = var.digitalocean_droplet_region
}

resource "digitalocean_droplet" "web" {
  image  = var.digitalocean_droplet_image
  name   = "terraforming-ghost-droplet"
  region = var.digitalocean_droplet_region
  size   = var.digitalocean_droplet_size
  ssh_keys = [
    data.digitalocean_ssh_key.default.id
  ]
  user_data = templatefile("${path.module}/cloud-init/web-cloud-init.yaml", {
    "PWD" = "$${PWD}",
    "certbot_email" = var.certbot_email
    "mysql_user" = var.mysql_user
    "mysql_password" = var.mysql_password
    "postgres_user" = var.postgres_user
    "postgres_password" = var.postgres_password
    "ghost_blog_dns" = var.ghost_blog_dns
    "commento_dns" = var.commento_dns
    "static_dns" = var.static_dns
    "cloudflare_email" = var.cloudflare_email
    "cloudflare_api_key" = var.cloudflare_api_key
    "cloudflare_domain" = var.cloudflare_domain
    "digitalocean_volume_name" = var.digitalocean_volume_name
    "fqdn" = local.cloudflare_fqdn
    "cloudflare_tunnel_id" = cloudflare_argo_tunnel.ssh_browser.id
    "cloudflare_tunnel_name" = cloudflare_argo_tunnel.ssh_browser.name
    "cloudflare_tunnel_secret" = cloudflare_argo_tunnel.ssh_browser.secret
    "trusted_pub_key" = cloudflare_access_ca_certificate.ssh_short_lived.public_key
    "user" = local.user_from_mail
    "account_id" = var.cloudflare_account_id
  })

  connection {
      user  = "root"
      type  = "ssh"
      host  = self.ipv4_address
      private_key = file(var.digitalocean_priv_key_path)
      timeout = "10m"
  }
}

resource "digitalocean_volume_attachment" "vol-attachment" {
  droplet_id = digitalocean_droplet.web.id
  volume_id  = data.digitalocean_volume.block-volume.id
}

data "digitalocean_droplet" "web" {
  name = "terraforming-ghost-droplet"
  depends_on = [digitalocean_droplet.web]
}

data "cloudflare_ip_ranges" "cloudflare" {}

resource "digitalocean_firewall" "web" {
  name = "terraform-ghost-fw"
  
  droplet_ids = [digitalocean_droplet.web.id]

  inbound_rule {
    protocol    = "tcp"
    port_range  = "443"
    source_addresses = data.cloudflare_ip_ranges.cloudflare.cidr_blocks
  }

  inbound_rule {
    protocol    = "tcp"
    port_range  = "22"
    source_addresses = data.cloudflare_ip_ranges.cloudflare.cidr_blocks
  }

  inbound_rule {
    protocol    = "icmp"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol    = "tcp"
    port_range = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol    = "udp"
    port_range = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol    = "icmp"
    port_range = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
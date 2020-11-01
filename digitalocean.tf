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
    "certbot_email" = var.certbot_email,
    "mysql_user" = var.mysql_user,
    "mysql_password" = var.mysql_password,
    "postgres_user" = var.postgres_user,
    "postgres_password" = var.postgres_password,
    "ghost_blog_dns" = var.ghost_blog_dns,
    "commento_dns" = var.commento_dns,
    "static_dns" = var.static_dns,
    "cloudflare_email" = var.cloudflare_email,
    "cloudflare_api_key" = var.cloudflare_api_key,
    "cloudflare_domain" = var.cloudflare_domain
  })

  connection {
      user  = "root"
      type  = "ssh"
      host  = self.ipv4_address
      private_key = file(var.digitalocean_priv_key_path)
      timeout = "10m"
  }
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
    source_addresses = ["0.0.0.0/0", "::/0"]
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
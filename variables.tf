/*
 *  Digitalocean
 */
variable "digitalocean_token" { 
    type = string
}

variable "digitalocean_droplet_image" {
    type = string
    default = "docker-18-04"
}

variable "digitalocean_droplet_region" {
  type = string
  default = "lon1"
}

variable "digitalocean_droplet_size" {
  type = string
  default = "s-1vcpu-1gb"
}

variable "digitalocean_key_name" {
  type = string
}

variable "digitalocean_priv_key_path" {
  type = string
}

/*
 *  Cloudflare
 */
variable "cloudflare_email" {
  type = string
}

variable "cloudflare_api_key" {
  type = string
}

variable "cloudflare_domain" {
  type = string
}

variable "ghost_blog_dns" {
  type = string
}

variable "commento_dns" {
  type = string
}

variable "static_dns" {
  type = string
}

variable "certbot_email" {
  type = string
}

variable "mysql_user" {
  type = string
}

variable "mysql_password" {
  type = string
}

variable "postgres_user" {
  type = string
}

variable "postgres_password" {
  type = string
}

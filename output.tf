output "digitalocean_ipv4_addr" { 
    value = digitalocean_droplet.web.ipv4_address
    description = "The public IPv4 address of the Digitalocean Droplet"
}
output "digitalocean_ipv4_addr" { 
    value = <<EOF
    
    Your droplet is up and running at ${digitalocean_droplet.web.ipv4_address}
    
    In-browser SSH terminal: https://${local.cloudflare_fqdn} 

    SSH Command (Only if manually allowing port 22 for this IP in digitalocean.tf): 
        ssh -i ${var.digitalocean_priv_key_path} root@${digitalocean_droplet.web.ipv4_address}

    URLs:
        https://${var.ghost_blog_dns}
        https://${var.commento_dns}
        https://${var.static_dns}

    Cloud Init Logs (on Droplet):
        less /var/log/cloud-init-output.log

    EOF
}
#!/bin/sh

curl -X POST -H "Content-Type: application/json" \
-H "Authorization: Bearer ${DO_TOKEN}" \
-d '{"size_gigabytes":15, "name": "ghostvol", "description": "Persistent volume for terraforming-ghost project", "region": "lon1", "filesystem_type": "ext4"}' \
"https://api.digitalocean.com/v2/volumes"

#!/bin/sh

curl -X DELETE -H "Content-Type: application/json" \
-H "Authorization: Bearer ${DO_TOKEN}" "https://api.digitalocean.com/v2/volumes?name=ghostvol&region=lon1"
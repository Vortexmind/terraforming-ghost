#!/bin/bash

while getopts r:n:o: flag
do
    case "${flag}" in
        r) region=${OPTARG};;
        n) name=${OPTARG};;
        o) op=${OPTARG};;
    esac
done

if [ -z "$DO_TOKEN" ]
then
    echo 'Error: please set the DO_TOKEN environment variable with your Digital Ocean API token'
    exit 0
fi

if [[ -z "$op" || -z "$region" ]]
then
    echo 'Error: Please specify operation (create/delete) and region.'
    echo ''
    echo 'For example ./manage_volume.sh -o create -r lon1'
    exit 0
fi

if [ -z "$name" ]
then
    name='ghostvol'
fi

if [ -z "$region" ]
then
    region='lon1'
fi

if [[ "$op" != "create" && "$op" != "delete" ]]
then
    echo "Error: -o must be one of 'create' or 'delete'"
    exit 0
fi


if [[ "$op" == "create" ]]
then 
    echo "'$op' '$name' in '$region'"
    curl -X POST -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${DO_TOKEN}" \
    -d '{"size_gigabytes":15, "name": "ghostvol", "description": "Persistent volume for terraforming-ghost project", "region": "lon1", "filesystem_type": "ext4"}' \
    "https://api.digitalocean.com/v2/volumes"
fi

if [[ "$op" == "delete" ]]
then 
    echo "'$op' '$name' in '$region'"
    curl -X DELETE -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${DO_TOKEN}" "https://api.digitalocean.com/v2/volumes?name=ghostvol&region=lon1"
fi




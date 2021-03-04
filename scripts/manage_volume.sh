#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage:"
    echo "./manage_volume.sh -o create -r lon1 -s 15 -n ghostvol"
    echo 
    echo "  -o : 'create' or 'delete' - REQUIRED" 
    echo "  -r : Digitalocean region parameter (default lon1)"
    echo "  -s : the size in GB for your volume (default 15)"
    echo "  -n : the name of your volume (default ghostvol)"
    echo
    exit 1
fi

while getopts r:n:o: flag
do
    case "${flag}" in
        r) region=${OPTARG};;
        n) name=${OPTARG};;
        o) op=${OPTARG};;
        s) size=${OPTARG};;
    esac
done

if [ -z "$DO_TOKEN" ]
then
    echo 'Error: please set the DO_TOKEN environment variable with your Digital Ocean API token'
    exit 0
fi

if [[ -z "$op" ]]
then
    echo 'Error: Please specify operation (create/delete)'
    exit 1
fi

if [[ "$op" != "create" && "$op" != "delete" ]]
then
    echo "Error: -o must be one of 'create' or 'delete'"
    exit 1
fi

if [ -z "$name" ]
then
    name='ghostvol'
fi

if [ -z "$region" ]
then
    region='lon1'
fi

if [ -z "$size" ]
then
    size='15'
fi

echo "'$op' volume '$name' in '$region' (size $size GB)"
read -p "Are you sure? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    if [[ "$op" == "create" ]]
    then 
        curl -X POST -H "Content-Type: application/json" \
        -H "Authorization: Bearer ${DO_TOKEN}" \
        -d "{\"size_gigabytes\":15, \"name\": \"${name}\", \"description\": \"Persistent volume for terraforming-ghost project\", \"region\": \"${region}\", \"filesystem_type\": \"ext4\"}" \
        "https://api.digitalocean.com/v2/volumes"
    fi

    if [[ "$op" == "delete" ]]
    then 
        curl -X DELETE -H "Content-Type: application/json" \
        -H "Authorization: Bearer ${DO_TOKEN}" "https://api.digitalocean.com/v2/volumes?name=${name}&region=${region}"
    fi
fi



#!/bin/bash

# Create a new node on Digital Ocean
# By Jason Gegere <jason@htmlgraphic.com>

function quit {
   exit
}
function create_node {

    echo "TIP: Create the environmental variable 'DO_TOKEN' with your Digital Ocean key"

    read -p "Would you like to create a new Digital Ocean node? [y/n]" create

    if [ "$create" == "y" ]; then
      echo "Creating node..."
    elif [ "$create" != "n" ] || [ "$create" == "n" ]; then
      quit
    fi

    #CLOUD_INIT=echo | cat cloud-config.yaml

VARS=$(cat <<EOF
{
    "name": "coreos71",
    "backups" : false,
    "region" : "nyc3",
    "size" : "512mb",
    "private_networking" : true,
    "image" : "coreos-stable",
    "ssh_keys" : [98825],
    "user_data" : "$(cat cloud-config.yaml)"
}
EOF
)

    echo "${VARS}"
    echo "${DO_TOKEN}"

    curl -X POST "https://api.digitalocean.com/v2/droplets" \
    -H "Content-type: application/json" \
    -H "Authorization: Bearer ${DO_TOKEN}" \
    -d "${VARS}"


}



create_node
quit
#!/bin/bash

docker rm -f `docker ps -aq -f name=backend_*`

# variables defined from now on to be automatically exported:
set -a
source .env

# To avoid substituting nginx-related variables, lets specify only the
# variables that we will substitute with envsubst:
NGINX_VARS='$DOMAINS:$MY_DOMAIN_NAME'
envsubst "$NGINX_VARS" < nginx.conf > nginx-envsubst.conf

envsubst "$NGINX_VARS" < nginx-acme-challenge.conf > nginx-acme-challenge-envsubst.conf

cat compose.yml | envsubst | docker-compose -f - -p backend_ up -d

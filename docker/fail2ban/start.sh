#!/usr/bin/env sh

crond &
mkdir -p /var/log/nginx
docker logs -f michel 1>&2 > /var/log/nginx/michel-access.log
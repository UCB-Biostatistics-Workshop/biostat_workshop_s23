#!/bin/bash
set -e

# find other nodes
/fly/check-nodes.sh

# start nginx but delay it a bit so there is time for the shiny server to start
sleep 3
exec nginx -c /etc/nginx/nginx.conf
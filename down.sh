#!/bin/sh
set -e

if [ `docker ps -f "name=minecraft-my-server" | wc -l` -lt 2 ];
then
    echo "Not running. Skip" >&2
    exit 1
fi

cd $(dirname $0)
docker compose stop && docker compose down

#!/bin/sh
set -e

if [ `docker ps -f "name=minecraft-my-server" | wc -l` -ge 2 ];
then
    echo "Already running. Skip" >&2
    exit 1
fi

cd $(dirname $0)
docker pull itzg/minecraft-bedrock-server
docker compose up -d --build

#!/bin/sh

if [ `docker ps -f "name=inecraft-my-conf" | wc -l` -ge 2 ];
then
    echo "Already running. Skip" >&2
    exit 1
fi

cd $(dirname $0)
docker pull itzg/minecraft-bedrock-server
docker-compose up -d

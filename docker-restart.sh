#! /bin/bash

STARTED=`docker ps -q -f name=twlandsat`
if [ $STARTED ]; then
  docker stop twlandsat
fi
docker rm twlandsat
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
$DIR/docker-start.sh

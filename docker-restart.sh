#! /bin/sh

STARTED=`docker ps -q -f name=twlandsat`
if [ $STARTED ]; then
  docker stop twlandsat
fi
docker rm twlandsat
./docker-start.sh

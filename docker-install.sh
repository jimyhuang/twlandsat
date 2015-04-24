#! /bin/sh

DOCKER_CMD=`which docker`
if [ ! -d /home/landsat/processed ]; then
  mkdir -p /home/landsat/processed
fi 

if [ $DOCKER_CMD ]; then
  echo "docker pull jimyhuang/twlandsat-util ..."
  $DOCKER_CMD pull jimyhuang/twlandsat-util

  echo "docker pull jimyhuang/twlandsat ..."
  $DOCKER_CMD pull jimyhuang/twlandsat
fi

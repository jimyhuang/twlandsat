#! /bin/sh

DOCKER_CMD=`which docker`
PWD=`pwd`
if [ ! -d $PWD/landsat/processed ]; then
  mkdir -p $PWD/landsat/processed
fi 

if [ $DOCKER_CMD ]; then
  echo "docker pull jimyhuang/twlandsat-util ..."
  $DOCKER_CMD pull jimyhuang/twlandsat-util

  echo "docker pull jimyhuang/twlandsat ..."
  $DOCKER_CMD pull jimyhuang/twlandsat

  echo "update current code base"
  git pull
fi

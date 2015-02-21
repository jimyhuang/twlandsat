#! /bin/sh

STARTED=`docker ps -q -f name=twlandsat`
STOPPED=`docker ps -aq -f name=twlandsat`
if [ $STARTED ]; then
  echo "Docker attach exists container ... "
  docker attach twlandsat
  exit
fi
if [ $STOPPED ]; then
  echo "Docker start and attach ... "
  docker start twlandsat
  docker attach twlandsat
  exit
fi
if [ ! $STARTED ] && [ ! $STOPPED ]; then
  echo "Docker run ... "
  docker run --name twlandsat -e "RSYNC_PASSWORD=1A5%QfFx%S8%" -v /home/landsat:/root/landsat -i -t jimyhuang/twlandsat /bin/bash
  exit
fi

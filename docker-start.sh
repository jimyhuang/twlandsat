#! /bin/sh

STARTED=`docker ps | grep twlandsat`
STOPPED=`docker ps -a -f exited=0 | grep twlandsat`

if [ -n "$STARTED" ]; then
  echo "Docker attach exists container ... "
  docker attach twlandsat
  exit
fi
if [ -n "$STOPPED" ]; then
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

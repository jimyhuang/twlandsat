#! /bin/sh

STARTED=`docker ps | grep twlandsat`
STOPPED=`docker ps -a -f exited=0 | grep twlandsat`

PWD=`pwd`

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
  mkdir -p $PWD/landsat
  echo "Docker run ... "
  docker run \
    --rm --name twlandsat \
    -v $PWD/landsat:/root/landsat \
    -i -t jimyhuang/twlandsat $1
#    --entrypoint /home/twlandsat/start.sh 
  exit
fi

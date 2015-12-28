#! /bin/bash

function unshift {
  FILE=$1
  FIRST=`head -1 $FILE`
  tail -n +2 "$FILE" > $HOME/.landsat-queue.swp
  cp $HOME/.landsat-queue.swp $FILE
  echo $FIRST
}

QUEUE="$HOME/.landsat-queue"
REALPATH=`realpath $0`
WORKDIR=`dirname $REALPATH`

if [ -f $QUEUE ]; then
  LANDSAT=`unshift $QUEUE`
  if [ -n "$LANDSAT" ]; then
    if [ -f "/var/log/twlandsat.log" ]; then
      DT=`date '+%Y-%m-%d %H:%M:%S'`
      echo "$DT $LANDSAT" >> /var/log/twlandsat.log
    fi
    cd $WORKDIR && ./docker-start.sh $LANDSAT 
  fi
else
  echo "Local queue not exists."
fi
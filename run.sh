#! /bin/bash
QUEUE="$HOME/.landsat-queue"
RUNNING="$HOME/.landsat-running"
REALPATH=`realpath $0`
WORKDIR=`dirname $REALPATH`
OUTPUTDIR="$HOME/landsat"

dt=`date '+%Y-%m-%d %H:%M:%S'`

function unshift {
  FILE=$1
  FIRST=`head -1 $FILE`
  tail -n +2 "$FILE" > $HOME/.landsat-queue.swp
  cp $HOME/.landsat-queue.swp $FILE
  rm $HOME/.landsat-queue.swp
  echo $FIRST
}

# check if running in 60 mins
RUNNING=`find $RUNNING -mmin -60`
if [ -n "$RUNNING" ]; then
  $RUN=`cat $RUNNING`
  if [ -n "$RUN" ]; then
    echo -e "\e[33m$dt\e[0m Already processing $RUN"
    exit 0
  fi
fi
echo "" > $RUNNING

if [ ! $1 ]; then
  echo -e "\e[33m$dt\e[0m Not specify landsat id, use ~/.landsat-queue instead"
  if [ !-f $QUEUE ]; then
    echo -e "\e[33m$dt\e[0m File not found at $HOME/.landsat-queue, stop."
    exit 0
  else
    LAST=`unshift $QUEUE`
    if [ -n "$last" ] && [ ! -d "$OUTPUTDIR/procssed/$LANDSAT" ]; then
      LANDSAT=$LAST
    fi
  fi
else
  LANDSAT=$1
fi

if [ -z "$LANDSAT" ]; then
  echo "\e[31m$dt\e[0m Cannot find any landsat id in queue or argument"
  exit 1
else
  echo "$LANDSAT" > $RUNNING
fi

dt=`date '+%Y-%m-%d %H:%M:%S'`
echo -e "\e[42m$dt Start process $LANDSAT e[0m"
echo -e "\e[32m$dt\e[0m Download"
docker run --rm -it -v $OUTPUTDIR:/root/landsat developmentseed/landsat-util:latest landsat download $LANDSAT -b 2345

dt=`date '+%Y-%m-%d %H:%M:%S'`
echo -e "\e[32m$dt\e[0m Process rgb"
docker run --rm -it -v $OUTPUTDIR:/root/landsat developmentseed/landsat-util:latest landsat process /root/landsat/downloads/$LANDSAT

dt=`date '+%Y-%m-%d %H:%M:%S'`
echo -e "\e[32m$dt\e[0m Process NDVI"
docker run --rm -it -v $OUTPUTDIR:/root/landsat developmentseed/landsat-util:latest landsat process /root/landsat/downloads/$LANDSAT --ndvi

dt=`date '+%Y-%m-%d %H:%M:%S'`
echo -e "\e[32m$dt\e[0m Generate tiles"
docker run --rm --entrypoint /home/twlandsat/scripts/gdal2tiles.sh -v $OUTPUTDIR:/root/landsat jimyhuang/twlandsat $LANDSAT ${LANDSAT}_bands_432.TIF tiles-rgb
docker run --rm --entrypoint /home/twlandsat/scripts/gdal2tiles.sh -v $OUTPUTDIR:/root/landsat jimyhuang/twlandsat $LANDSAT ${LANDSAT}_NDVI.TIF tiles-ndvi

dt=`date '+%Y-%m-%d %H:%M:%S'`
echo -e "\e[32m$dt\e[0m Generate preview"
docker run --rm --entrypoint /home/twlandsat/scripts/imagemagick.sh -v $OUTPUTDIR:/root/landsat jimyhuang/twlandsat $LANDSAT ${LANDSAT}_bands_432.TIF -scale 25% rgb.jpg
docker run --rm --entrypoint /home/twlandsat/scripts/imagemagick.sh -v $OUTPUTDIR:/root/landsat jimyhuang/twlandsat $LANDSAT ${LANDSAT}_NDVI.TIF -scale 25% ndvi.jpg

dt=`date '+%Y-%m-%d %H:%M:%S'`
echo -e "\e[32m$dt\e[0m Final clear"
echo "" > $RUNNING
if [ -d "$OUTPUTDIR/downloads/$LANDSAT" ]; then
  rm -Rf "$OUTPUTDIR/downloads/$LANDSAT"
fi

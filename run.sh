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
  echo $FIRST
}

# check if running in 60 mins
ISRUN=`find $RUNNING -mmin -60`
if [ -n "$ISRUN" ]; then
  RUN=`cat $RUNNING`
  if [ -n "$RUN" ]; then
    echo -e "\e[33m$dt\e[0m Already processing $RUN"
    exit 0
  fi
fi
echo "" > $RUNNING

if [ ! $1 ]; then
  echo -e "\e[33m$dt\e[0m Not specify landsat id, use ~/.landsat-queue instead."
  if [ ! -f $QUEUE ]; then
    echo -e "\e[33m$dt\e[0m File not found at $HOME/.landsat-queue, stop."
    exit 0
  else
    NUM_QUEUE=`cat $QUEUE | wc -l`
    LAST=`unshift $QUEUE`
    if [ -n "$LAST" ]; then
      LANDSAT=$LAST
    fi
  fi
else
  LANDSAT=$1
fi

if [ -z "$LANDSAT" ]; then
  echo -e "\e[31m$dt\e[0m Cannot find any landsat id in queue or argument"
  exit 1
fi

echo "$LANDSAT" > $RUNNING
touch $RUNNING
dt=`date '+%Y-%m-%d %H:%M:%S'`
echo -e "\e[42m$dt Start process $LANDSAT\e[0m"
if [ -n "$NUM_QUEUE" ]; then
  echo -e "\e[34m$dt\e[0m $NUM_QUEUE scences left in queue."
fi
echo -e "\e[34m$dt\e[0m Download"
if [ ! -f $OUTPUTDIR/downloads/${LANDSAT}/${LANDSAT}_B5.TIF ]; then
  docker run --rm -it -v $OUTPUTDIR:/root/landsat jimyhuang/landsat-util:latest landsat download $LANDSAT -b 2345 1> /dev/null
  if [ -f $OUTPUTDIR/downloads/${LANDSAT}.tar.bz ]; then
    mkdir $OUTPUTDIR/downloads/${LANDSAT}
    tar -xf $OUTPUTDIR/downloads/${LANDSAT}.tar.bz -C $OUTPUTDIR/downloads/${LANDSAT}
    rm -f $OUTPUTDIR/downloads/${LANDSAT}.tar.bz
  fi
fi

dt=`date '+%Y-%m-%d %H:%M:%S'`
echo -e "\e[34m$dt\e[0m Process rgb"
if [ ! -f $OUTPUTDIR/processed/${LANDSAT}/${LANDSAT}_bands_432.TIF ]; then
  docker run --rm -it -v $OUTPUTDIR:/root/landsat jimyhuang/landsat-util:latest landsat process /root/landsat/downloads/$LANDSAT
fi

dt=`date '+%Y-%m-%d %H:%M:%S'`
echo -e "\e[34m$dt\e[0m Process NDVI"
if [ ! -f $OUTPUTDIR/processed/${LANDSAT}/${LANDSAT}_NDVI.TIF ]; then
  docker run --rm -it -v $OUTPUTDIR:/root/landsat jimyhuang/landsat-util:latest landsat process /root/landsat/downloads/$LANDSAT --ndvi
fi

dt=`date '+%Y-%m-%d %H:%M:%S'`
echo -e "\e[34m$dt\e[0m Generate tiles"
docker run --rm --entrypoint /home/twlandsat/scripts/gdal2tiles.sh -v $OUTPUTDIR:/root/landsat jimyhuang/twlandsat $LANDSAT ${LANDSAT}_bands_432.TIF tiles-rgb
docker run --rm --entrypoint /home/twlandsat/scripts/gdal2tiles.sh -v $OUTPUTDIR:/root/landsat jimyhuang/twlandsat $LANDSAT ${LANDSAT}_NDVI.TIF tiles-ndvi

dt=`date '+%Y-%m-%d %H:%M:%S'`
echo -e "\e[34m$dt\e[0m Generate preview"
cd $OUTPUTDIR/processed/$LANDSAT && convert ${LANDSAT}_NDVI.TIF -scale 600 -fuzz 5% -transparent black ndvi.png
cd $OUTPUTDIR/processed/$LANDSAT && convert ${LANDSAT}_NDVI.TIF -scale 1920 ndvi.jpg
cd $OUTPUTDIR/processed/$LANDSAT && convert ${LANDSAT}_bands_432.TIF -scale 600 -fuzz 5% -transparent black rgb.png
cd $OUTPUTDIR/processed/$LANDSAT && convert ${LANDSAT}_bands_432.TIF -scale 1920 rgb.jpg

dt=`date '+%Y-%m-%d %H:%M:%S'`
echo -e "\e[34m$dt\e[0m Final clear"
echo "" > $RUNNING
cp -f $HOME/.landsat-queue.swp $QUEUE
if [ -d "$OUTPUTDIR/downloads/$LANDSAT" ]; then
  rm -Rf "$OUTPUTDIR/downloads/$LANDSAT"
fi

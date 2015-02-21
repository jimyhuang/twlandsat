#! /bin/bash

# how many times to process image
if [ "$#" -ne 1 ]
then
  N=1
else
  N=$1
fi
 
# this will limit imagemagick doesn't eat more than 4GB
export MAGICK_MEMORY_LIMIT=1024
export MAGICK_MAP_LIMIT=2048

PENDING=1f8cfkxar1
DOWNLOADED=wn9wlxessv
FINISHED=c9kytykh4g
WORKDIR=`pwd`

for i in {1..$N}
do
  echo "Start process $i / $N"
  # get queue list
  curl -s https://www.ethercalc.org/${PENDING}.csv | tr -d ',' > queue-pending.txt
  curl -s https://www.ethercalc.org/${DOWNLOADED}.csv | tr -d ',' > queue-downloaded.txt
  curl -s https://www.ethercalc.org/${FINISHED}.csv | tr -d ',' > queue-finished.txt

  # get lastest landsat filename to process
  NAME=`head -n1 queue-pending.txt`

  # 1. download landsat
  if [ ! -f ~/landsat/zip/${NAME}.tar.bz ]; then
    echo "Downloading ${NAME} ..."
    landsat download ${NAME}
  fi

  # 2. download completed, processing image bands, pansharp
  TMP=/tmp/${NAME}
  FINAL=${TMP}/final
  if [ ! -f ${TMP}/final/final-rgb.TIF ]; then
    mkdir -p $FINAL

    # image process
    echo "Processing ${NAME} to RGB..."
    if [ ! -f ${TMP}/${NAME}_B8.TIF ]; then
      echo "Un-tar ${NAME}.tar.bz , need several minutes ... "
      tar -jxf ~/landsat/zip/${NAME}.tar.bz -C ${TMP}
    fi

    # process rgb
    $WORKDIR/process/l8-pan.sh ${TMP} 4,3,2 final-rgb.TIF
    $WORKDIR/process/l8-combine-rgb.sh ${TMP}/final/final-rgb.TIF
  fi

  # 3. Generate tiles
  if [ -f $FINAL/final-rgb.TIF ]; then
    cd $FINAL
    gdal2tiles.py final-rgb.TIF tiles-rgb
    bzip2 --best final-rgb.TIF
  fi
  if [ -f $FINAL/final-swirnir.TIF]; then
    cd $FINAL
    gdal2tiles.py final-swirnir.TIF tiles-swirnir
    bzip2 --best final-swirnir.TIF
  fi

  # 4. finish and upload
  if [ ! -f ~/landsat/processed/${NAME}/final-rgb.TIF.bz ]; then
    mv -f $FINAL/*.bz ~/landsat/processed/${NAME}/
    mv -f $FINAL/tile-* ~/landsat/processed/${NAME}/ 

    # upload
    rsync -rtv --bwlimit=1024 ~/landsat/processed/${NAME} rsync://twlandsat@twlandsat.jimmyhub.net/twlandsat/processed/
    rm -Rf ${TMP}

    cd $WORKDIR
    echo "Writing finish record for ${NAME} ..."
    echo "$(tail -n +2 queue-pending.txt)" > queue-pending.txt
    sed 's/$/,,/g' queue-pending.txt > queue-pending.csv
    curl -X PUT -H 'Content-Type: text/csv' --data-binary @queue-pending.csv https://www.ethercalc.org/_/${PENDING}
    echo "${NAME}" >> queue-finished.txt
    sed 's/$/,,/g' queue-finished.txt > queue-finished.csv
    curl -X PUT -H 'Content-Type: text/csv' --data-binary @queue-finished.csv https://www.ethercalc.org/_/${FINISHED}
  fi
done

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
TMP=/tmp

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
  BANDDIR=${TMP}/${NAME}
  FINAL=${BANDDIR}/final
  if [ ! -d ${BANDDIR} ] && [ ! -f ~/landsat/processed/${NAME}/final-rgb.TIF.bz ] ; then
    mkdir -p $FINAL

    # update queue list
    echo "${NAME}" >> queue-downloaded.txt
    sed 's/$/,,/g' queue-downloaded.txt > queue-downloaded.csv
    curl -X PUT -H 'Content-Type: text/csv' --data-binary @queue-downloaded.csv https://www.ethercalc.org/_/${DOWNLOADED}

    # image process
    echo "Image processing ${NAME} ..."
    tar -jxf ~/landsat/zip/${NAME}.tar.bz -C ${BANDDIR}

    # process rgb
    $WORKDIR/process/l8-pan.sh ${BANDDIR} 4,3,2 final-rgb.TIF
    $WORKDIR/process/l8-combine-rgb.sh ${BANDDIR}/final/final-rgb.TIF
    # $WORKDIR/process/l8-pan.sh ${BANDDIR} 7,5,3 ${NAME}
    # $WORKDIR/process/l8-combine-swirnir.sh ${NAME} ${BANDDIR}
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

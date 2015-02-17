#! /bin/bash

# this will limit imagemagick doesn't eat more than 4GB
export MAGICK_MEMORY_LIMIT=1024
export MAGICK_MAP_LIMIT=2048

PENDING=1f8cfkxar1
DOWNLOADED=wn9wlxessv
FINISHED=c9kytykh4g
WORKDIR=`pwd`

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

# 2. download completed, processing
if [ -f ~/landsat/zip/${NAME}.tar.bz ] && [ ! -f ~/landsat/processed/${NAME}/final-pan.TIF ] ; then
  # update queue list
  echo "${NAME}" >> queue-downloaded.txt
  sed 's/$/,,/g' queue-downloaded.txt > queue-downloaded.csv
  curl -X PUT -H 'Content-Type: text/csv' --data-binary @queue-downloaded.csv https://www.ethercalc.org/_/${DOWNLOADED}

  # image process, pansharping
  echo "Image processing ${NAME} ..."
  landsat process --pansharpen --ndvi --noclouds ~/landsat/zip/${NAME}.tar.bz

  # TODO: NDVI version of pan
  # TODO: tilelize file
fi

# 3. finished processing
if [ -f ~/landsat/processed/${NAME}/final-pan.TIF ]; then
  cd ~/landsat/processed/${NAME}/

  # manupulating tiles
  convert final-ndvi.TIF final-ndvi.png
  gdalwarp -srcnodata 0 -dstnodata 0 final-pan.TIF final-pan.tif
  gdalwarp -srcnodata 0 -dstnodata 0 final.TIF final.tif
  gdal2tiles.py final-pan.tif tiles
  bzip2 --best ./*.tif

  # cleanup
  rm -f *.TIF
  rsync -rtv ~/landsat/processed/${NAME} rsync://twlandsat@twlandsat.jimmyhub.net/twlandsat/processed/

  cd $WORKDIR
  # TODO: upload image which successful processing
  
  echo "Writing finish record for ${NAME} ..."
  echo "$(tail -n +2 queue-pending.txt)" > queue-pending.txt
  sed 's/$/,,/g' queue-pending.txt > queue-pending.csv
  curl -X PUT -H 'Content-Type: text/csv' --data-binary @queue-pending.csv https://www.ethercalc.org/_/${PENDING}
  echo "${NAME}" >> queue-finished.txt
  sed 's/$/,,/g' queue-finished.txt > queue-finished.csv
  curl -X PUT -H 'Content-Type: text/csv' --data-binary @queue-finished.csv https://www.ethercalc.org/_/${FINISHED}
fi

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
export MAGICK_MAP_LIMIT=512

WORKDIR=`pwd`
QUEUE=/tmp/queue

for (( i=1; i<=$N; i++ ))
do
  echo "Start process $i / $N"
  # get queue list

  # get lastest landsat filename to process
  rsync -rtv rsync://twlandsat@twlandsat.jimmyhub.net/twlandsat-queue/ $QUEUE
  NAME=`grep -v -x -f $QUEUE/completed $QUEUE/pending | head -n1`
  tail -n +2 $QUEUE/pending > $TMP/pending && cp -f $TMP/pending $QUEUE/pending
  echo "$NAME" >> $QUEUE/processing
  rsync -rtv $QUEUE/p* rsync://twlandsat@twlandsat.jimmyhub.net/twlandsat-queue/

  # 1. download landsat
  if [ ! -f ~/landsat/zip/${NAME}.tar.bz ]; then
    echo "Downloading ${NAME} ..."
    landsat download ${NAME}
  fi

  # 2. Processing image bands, pansharp
  TMP=/tmp/${NAME}
  FINAL=${TMP}/final
  mkdir -p $FINAL
  mkdir -p ~/landsat/processed/${NAME}
  if [ ! -f ~/landsat/processed/${NAME}/final-rgb-pan.TIF.bz2 ]; then
    echo "Processing ${NAME} to RGB..."
    if [ ! -f ${TMP}/${NAME}_B8.TIF ]; then
      echo "Un-tar ${NAME}.tar.bz , need several minutes ... "
      tar -jxf ~/landsat/zip/${NAME}.tar.bz -C ${TMP}
    fi

    # process rgb
    $WORKDIR/process/l8-pan.sh ${TMP} 4,3,2 final-rgb-pan.TIF
    $WORKDIR/process/l8-combine-rgb.sh ${TMP}/final/final-rgb-pan.TIF ${TMP}/final/final-rgb.TIF

    if [ -f $FINAL/final-rgb.TIF ]; then
      cd $FINAL
      gdal2tiles.py final-rgb.TIF tiles-rgb
      mv -f tiles-rgb ~/landsat/processed/${NAME}/ 
      bzip2 final-rgb-pan.TIF
      mv -f final-rgb-pan.TIF.bz2 ~/landsat/processed/${NAME}/
    fi
  fi

  # 3. Generate SWIR-NIR false color 
  if [ ! -f ~/landsat/processed/${NAME}/final-swirnir-pan.TIF.bz2 ]; then
    # image process
    echo "Processing ${NAME} to SWIR-NIR false color..."
    if [ ! -f ${TMP}/${NAME}_B8.TIF ]; then
      echo "Un-tar ${NAME}.tar.bz , need several minutes ... "
      tar -jxf ~/landsat/zip/${NAME}.tar.bz -C ${TMP}
    fi

    # process swirnir
    $WORKDIR/process/l8-pan.sh ${TMP} 7,5,3 final-swirnir-pan.TIF
    $WORKDIR/process/l8-combine-swirnir.sh ${TMP}/final/final-swirnir-pan.TIF ${TMP}/final/final-swirnir.TIF

    if [ -f $FINAL/final-swirnir.TIF ]; then
      cd $FINAL
      gdal2tiles.py final-swirnir.TIF tiles-swirnir
      mv -f tiles-swirnir ~/landsat/processed/${NAME}/ 
      bzip2 final-swirnir-pan.TIF
      mv -f final-swirnir-pan.TIF.bz2 ~/landsat/processed/${NAME}/
    fi
  fi

  # 4. finish and upload
  if [ -f ~/landsat/processed/${NAME}/final-rgb-pan.TIF.bz2 ]; then
    # upload
    echo "Uploading pan-sharped geotiff ..."
    rsync -rtv --progress --ignore-existing --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r ~/landsat/processed/${NAME}/*.bz2 rsync://twlandsat@twlandsat.jimmyhub.net/twlandsat/processed/${NAME}/
    echo "Uploading tiles ..."
    rsync -rtv --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r ~/landsat/processed/${NAME}/tiles-rgb rsync://twlandsat@twlandsat.jimmyhub.net/twlandsat/processed/${NAME}/
    rsync -rtv --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r ~/landsat/processed/${NAME}/tiles-swirnir rsync://twlandsat@twlandsat.jimmyhub.net/twlandsat/processed/${NAME}/

    # update queue
    rsync -rtv rsync://twlandsat@twlandsat.jimmyhub.net/twlandsat-queue/completed $QUEUE/
    echo "$NAME" >> $QUEUE/completed
    rsync -rtv $QUEUE/completed rsync://twlandsat@twlandsat.jimmyhub.net/twlandsat-queue/

    # Clean uploaded file
    echo "Clean up tmp and uploaded files"
    rm -Rf ~/landsat/processed/${NAME}/
    rm -f ~/landsat/zip/${NAME}.tar.bz
    rm -Rf ${TMP}
  fi
done

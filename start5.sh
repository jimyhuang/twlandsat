#! /bin/bash

RSYNC="rsync://twlandsat@static.jimmyhub.net"

# how many times to process image
if [ "$#" -ne 2 ]; then
  echo -e "\e[1;31m[please add at least 2 argument]\e[0m eg:"
  echo "  $0 <times> <your_name_without_space>"
  echo "  $0 5 jimmy"
  exit
fi

N=$1
if [ -n "$2" ]; then
  CREDIT=$2
fi
 
# this will limit imagemagick doesn't eat more than 4GB
export MAGICK_MEMORY_LIMIT=1024
export MAGICK_MAP_LIMIT=512

WORKDIR=`pwd`
mkdir -p ~/landsat/zip

for (( i=1; i<=$N; i++ ))
do
  echo "Start process $i / $N"
  # get queue list
  QUEUE=/tmp/queue

  # get lastest landsat filename to process
  NAME=`curl --data "action=pending&type=LT5&name=${CREDIT}" http://static.jimmyhub.net/bin/queue.php`
  LTVER=${NAME:0:3}
  if [ "$LTVER" != "LT5" ] && [ "$LTVER" != "LT4" ] ; then
    echo "Landsat version wrong";
    exit 1;
  fi

  # 1. download landsat
  if [ ! -f ~/landsat/zip/${NAME}.tar.gz ]; then
    echo "Step 1. Downloading ${NAME} ..."
    $WORKDIR/download5.py jimyhuang NwdBdCMF333p ${NAME}
    if [ -f $WORKDIR/${NAME}.tar.gz ]; then
      mv $WORKDIR/${NAME}.tar.gz ~/landsat/zip/${NAME}.tar.gz
    fi
  fi

  # 2. Processing image bands, pansharp
  TMP=/tmp/${NAME}
  FINAL=${TMP}/final
  mkdir -p $FINAL
  mkdir -p ~/landsat/processed/${NAME}
  if [ ! -f ~/landsat/processed/${NAME}/final-rgb.TIF.bz2 ]; then
    echo "Step 2. Processing ${NAME} to RGB..."
    if [ ! -f ${TMP}/${NAME}_B1.TIF ]; then
      echo "Un-tar ${NAME}.tar.gz , need several minutes ... "
      tar -zxf ~/landsat/zip/${NAME}.tar.gz -C ${TMP}
    fi

    # process rgb
    $WORKDIR/process/l5-combine-rgb.sh ${TMP} $FINAL/final-rgb.TIF

    if [ -f $FINAL/final-rgb.TIF ]; then
      cd $FINAL
      gdal2tiles.py final-rgb.TIF tiles-rgb
      mv -f tiles-rgb ~/landsat/processed/${NAME}/ 
      bzip2 final-rgb.TIF
      mv -f final-rgb.TIF.bz2 ~/landsat/processed/${NAME}/
    fi
  fi

  # 4. finish and upload
  if [ -f ~/landsat/processed/${NAME}/final-rgb.TIF.bz2 ]; then
    # upload
    echo "Step 4. Uploading pan-sharped geotiff ..."
    rsync -rtv --progress --ignore-existing --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r ~/landsat/processed/${NAME}/*.bz2 $RSYNC/twlandsat/processed/${NAME}/
    echo "Uploading tiles-rgb in ${NAME} at $(date)"
    rsync -rt --info=progress2 --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r ~/landsat/processed/${NAME}/tiles-rgb $RSYNC/twlandsat/processed/${NAME}/

    # update queue
    echo "Step 5. Writing completed log"
    curl --data "action=completed&type=LT5&name=${CREDIT}&landsat=${NAME}" http://static.jimmyhub.net/bin/queue.php

    # Clean uploaded file
    echo "Clean up tmp and uploaded files"
    rm -Rf ~/landsat/processed/${NAME}/
    rm -f ~/landsat/zip/${NAME}.tar.bz
    rm -Rf ${TMP}
  fi
  cd $WORKDIR
done

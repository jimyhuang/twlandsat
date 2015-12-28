#! /bin/bash
cd /home/twlandsat && git pull

if [ "$#" -ne 1 ]; then
  echo -e "\e[1;31m[please add at least 2 argument]\e[0m eg:"
  echo "  $0 <landsat-name>"
  echo "  $0 LC80090452014008LGN00"
  exit
fi

# this will limit imagemagick doesn't eat more than 4GB
export MAGICK_MEMORY_LIMIT=1024
export MAGICK_MAP_LIMIT=512

WORKDIR=`pwd`

# get lastest landsat filename to process
NAME=$1
TMP=/tmp/${NAME}
FINAL=${TMP}/final
mkdir -p $FINAL

# 1. download landsat
if [ ! -f $TMP/${NAME}.tar.bz ]; then
  echo "Step 1. Downloading ${NAME} ..."
  landsat download ${NAME}
  mv ~/landsat/downloads/${NAME}.tar.bz ${TMP}/
fi

# 2. Processing image bands, pansharp
mkdir -p ~/landsat/processed/${NAME}
if [ ! -f ~/landsat/processed/${NAME}/final-rgb-pan.TIF.bz2 ] && [ ! -d ~/landsat/processed/${NAME}/tiles-rgb/ ]; then
  echo "Step 2. Processing ${NAME} to RGB..."
  if [ ! -f ${TMP}/${NAME}_B8.TIF ]; then
    echo "Un-tar ${NAME}.tar.bz , need several minutes ... "
    tar -jxf $TMP/${NAME}.tar.bz -C ${TMP}
  fi

  # process rgb
  $WORKDIR/process/l8-pan.sh ${TMP} 4,3,2 final-rgb-pan.TIF
  $WORKDIR/process/l8-combine-rgb.sh ${TMP}/final/final-rgb-pan.TIF ${TMP}/final/final-rgb.TIF

  if [ -f $FINAL/final-rgb.TIF ]; then
    cd $FINAL
    gdal2tiles.py final-rgb.TIF tiles-rgb
    mv -f tiles-rgb ~/landsat/processed/${NAME}/ 
  fi
fi

# 3. Generate SWIR-NIR false color 
if [ ! -f ~/landsat/processed/${NAME}/final-swirnir-pan.TIF.bz2 ] && [ ! -d ~/landsat/processed/${NAME}/tiles-swirnir/ ]; then
  # image process
  echo "Step 3. Processing ${NAME} to SWIR-NIR false color..."
  if [ ! -f ${TMP}/${NAME}_B8.TIF ]; then
    echo "Un-tar ${NAME}.tar.bz , need several minutes ... "
    tar -jxf $TMP/${NAME}.tar.bz -C ${TMP}
  fi

  # process swirnir
  $WORKDIR/process/l8-pan.sh ${TMP} 7,5,3 final-swirnir-pan.TIF
  $WORKDIR/process/l8-combine-swirnir.sh ${TMP}/final/final-swirnir-pan.TIF ${TMP}/final/final-swirnir.TIF

  if [ -f $FINAL/final-swirnir.TIF ]; then
    cd $FINAL
    gdal2tiles.py final-swirnir.TIF tiles-swirnir
    mv -f tiles-swirnir ~/landsat/processed/${NAME}/ 
  fi
fi

# 4. finish and upload
if [ -f ~/landsat/processed/${NAME}/final-rgb-pan.TIF.bz2 ]; then
  # Clean uploaded file
  echo "Clean up tmp and uploaded files"
  rm -f ~/landsat/processed/${NAME}/*.bz2
  rm -Rf ${TMP}
fi

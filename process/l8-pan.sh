#!/bin/bash
if [ "$#" -ne 3 ]
then
  echo "    Usage: $0 [band dir] [bands separate by comma] [landsat name]"
  echo "  Example: $0 /tmp/LC81180442014356LGN00 4,3,2 final-rgb.TIF"
  exit 1
fi

# from https://gist.github.com/oeon/8007457
export ITK_AUTOLOAD_PATH=/usr/local/bin/
export LD_LIBRARY_PATH=/usr/local/lib/otb/
FILENAME=$3
NAME=${FILENAME%.*}
LANDSAT=`dirname $1`
BANDS=$2
DIR=$1
TMP="$1/tmp"
FINAL="$1/final"

mkdir -p $TMP
mkdir -p $FINAL

if [ -f $DIR/${LANDSAT}_B8.TIF ]; then
  echo "Pan 1. Building Virtual Dataset (VRT) of given bands... "
  VRT=${DIR}/${NAME}.vrt
  VRTARG=''
  for BAND in $(echo $BANDS| sed "s/,/ /g")
  do
    VRTARG+="${DIR}/${LANDSAT}_B${BAND}.TIF "
  done

  gdalbuildvrt -separate -q -srcnodata "0 0 0" -vrtnodata "0 0 0" $VRT $VRTARG

  # from https://www.mapbox.com/blog/pansharpening-satellite-imagery-openstreetmap/ , missing ColorInterp
  sed -i '6 i\
  <ColorInterp>Red</ColorInterp>' $VRT && \
  sed -i '18  i\
  <ColorInterp>Green</ColorInterp>' $VRT && \
  sed -i '30 i\
  <ColorInterp>Blue</ColorInterp>' $VRT

  echo "Pan 2. Real pansharpening processing ... "
  otbcli_BundleToPerfectSensor -ram 1024 -inp ${DIR}/${LANDSAT}_B8.TIF -inxs ${VRT} -out $TMP/pan.tif uint16

  echo "Pan 3. Generate geoinfo for later usage"
  listgeo -tfw $DIR/${LANDSAT}_B8.TIF
  mv $DIR/${LANDSAT}_B8.tfw $TMP/${NAME}.tfw

  echo "Pan 4. Remove black border of image and scale"
  gdal_translate -ot Byte -scale 0 65535 0 255 -a_nodata "0 0 0" $TMP/pan.tif $TMP/pan-scaled.tif
  gdalwarp -r cubic -wm 4096 -multi -srcnodata "0 0 0" -dstnodata "0 0 0" -dstalpha -wo OPTIMIZE_SIZE=TRUE -wo UNIFIED_SRC_NODATA=YES -t_srs EPSG:3857 -co TILED=YES -co COMPRESS=LZW $TMP/pan-scaled.tif $TMP/${FILENAME}

  echo "Pan 5. Move processed file to final path, clean up"
  mv -f $TMP/{$FILENAME} $FINAL/
  mv -f $TMP/{$NAME}.tfw $FINAL/
  rm -Rf $TMP
fi

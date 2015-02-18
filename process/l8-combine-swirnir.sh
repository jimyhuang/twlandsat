# /bin/bash

if [ "$#" -ne 2 ]
then
  echo "    Usage: $0 [File name]"
  echo "  Example: $0 /path-to/final-swirnir-pan.TIF /tmp/LC81180442014356LGN00/final/final-swirnir.TIF"
  exit 1
fi

FINAL=$2
FILENAME=`basename $2`
NAME=${FILENAME%.*}
DIR=`dirname $2`
TMP="${DIR}/tmp"
mkdir -p $TMP

cp $1 $TMP/swirnir-pan.tif

# processing image
convert -monitor -channel RGB -sigmoidal-contrast 5x15% -channel R -brightness-contrast 30x70% -channel G -brightness-contrast 10x10% -channel B -brightness-contrast 35x30% $TMP/swirnir-pan.tif $TMP/swirnir-pan-light.tif
cp -f $TMP/swirnir-pan-light.tif $FINAL

# append geotiff into image
if [ -f $DIR/warp_B8.tfw ]; then
  mv $DIR/warp_B8.tfw $DIR/${NAME}.tfw
  gdal_edit.py -a_srs EPSG:3857 $FINAL
fi

# clean up
if [ -f $FINAL ]; then
  rm -Rf $TMP
fi

# /bin/bash

if [ "$#" -ne 2 ]
then
  echo "    Usage: $0 [File name]"
  echo "  Example: $0 /path-to/final-rgb-pan.TIF /tmp/LC81180442014356LGN00/final/final-rgb.TIF"
  exit 1
fi

FINAL=$2
FILENAME=`basename $2`
NAME=${FILENAME%.*}
DIR=`dirname $2`
TMP="${DIR}/tmp"
mkdir -p $TMP

cp $1 $TMP/rgb-pan.tif

# processing image
convert -monitor -channel B -gamma 0.98 -channel R -gamma 1.03 -channel RGB -sigmoidal-contrast 30x15% $TMP/rgb-pan.tif $TMP/rgb-pan-light.tif
cp -f $TMP/rgb-pan-light.tif $FINAL

# append geotiff into image
if [ -f $DIR/${NAME}.tfw ]; then
  gdal_edit.py -a_srs EPSG:3857 $FINAL
fi

# clean up
if [ -f $FINAL ]; then
  rm -Rf $TMP
fi

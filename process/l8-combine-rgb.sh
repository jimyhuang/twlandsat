# /bin/bash

if [ "$#" -ne 1 ]
then
  echo "    Usage: $0 [File name]"
  echo "  Example: $0 /tmp/LC81180442014356LGN00/final/final-rgb.TIF"
  exit 1
fi

FINAL=$1
FILENAME=`basename $1`
NAME=${FILENAME%.*}
DIR=`dirname $1`
TMP="${DIR}/tmp"
mkdir -p $TMP

cp $1 $TMP/

# processing image
convert -monitor -channel B -gamma 0.98 -channel R -gamma 1.03 -sigmoidal-contrast 30x15% $TMP/$FILENAME $TMP/rgb.tif
cp -f $TMP/rgb.tif $FINAL

# append geotiff into image
if [ -f $DIR/${NAME}.tfw ]; then
  gdal_edit.py -a_srs EPSG:3857 $FINAL
fi

# clean up
rm -Rf $TMP

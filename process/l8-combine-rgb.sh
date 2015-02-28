# /bin/bash

if [ "$#" -ne 2 ]
then
  echo "    Usage: $0 [File name]"
  echo "  Example: $0 /path-to/final-rgb-pan.TIF /tmp/LC81180442014356LGN00/final/final-rgb.TIF"
  exit 1
fi

THREADHOLD=40
FINAL=$2
FILENAME=`basename $2`
NAME=${FILENAME%.*}
DIR=`dirname $2`
TMP="${DIR}/tmp"
mkdir -p $TMP

cp $1 $TMP/rgb-pan.tif
listgeo -tfw $TMP/rgb-pan.tif

# processing image
echo "Auto detect brightness, needs a few minutes to process large img ..."
BRIGHT=`identify -verbose $TMP/rgb-pan.tif 2>/dev/null | grep mean | awk '{print $2}' | sed -n 5p`
BRIGHT=${BRIGHT%.*}
echo "Brightness is $BRIGHT, going to convert image..."

if [ "$BRIGHT" -lt "$THREADHOLD" ]; then
  convert -channel B -gamma 0.98 -channel R -gamma 1.02 -channel RGB -sigmoidal-contrast 50x13% -gamma 1.07 $TMP/rgb-pan.tif $TMP/rgb-pan-light.tif
else
  convert -channel B -gamma 0.98 -channel R -gamma 1.02 -channel RGB -sigmoidal-contrast 30x13% -gamma 1.05 $TMP/rgb-pan.tif $TMP/rgb-pan-light.tif
fi

cp -f $TMP/rgb-pan-light.tif $FINAL

# append geotiff into image
if [ -f $TMP/rgb-pan.tfw ]; then
  mv $TMP/rgb-pan.tfw $DIR/${NAME}.tfw
  gdal_edit.py -a_srs EPSG:3857 $FINAL
fi

# clean up
if [ -f $FINAL ]; then
  rm -Rf $TMP
fi

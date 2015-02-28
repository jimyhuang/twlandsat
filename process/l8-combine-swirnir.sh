# /bin/bash

if [ "$#" -ne 2 ]
then
  echo "    Usage: $0 [File name]"
  echo "  Example: $0 /path-to/final-swirnir-pan.TIF /tmp/LC81180442014356LGN00/final/final-swirnir.TIF"
  exit 1
fi

THREADHOLD=39
FINAL=$2
FILENAME=`basename $2`
NAME=${FILENAME%.*}
DIR=`dirname $2`
TMP="${DIR}/tmp"
mkdir -p $TMP

cp $1 $TMP/swirnir-pan.tif
listgeo -tfw $TMP/swirnir-pan.tif

# processing image
echo "Auto detect brightness, needs a few minutes to process large img ..."
BRIGHT=`identify -verbose $TMP/swirnir-pan.tif 2>/dev/null | grep mean | awk '{print $2}' | sed -n 5p`
BRIGHT=${BRIGHT%.*}
echo "Brightness is $BRIGHT, going to convert image..."

if [ "$BRIGHT" -lt "$THREADHOLD" ]; then
  convert -channel RGB -sigmoidal-contrast 10x15% -channel R -brightness-contrast 30x80% -channel G -brightness-contrast 5x30% -channel B -brightness-contrast 35x30% $TMP/swirnir-pan.tif $TMP/swirnir-pan-light.tif
else
  convert -channel RGB -sigmoidal-contrast 5x15% -channel R -brightness-contrast 30x80% -channel G -brightness-contrast 5x30% -channel B -brightness-contrast 35x30% $TMP/swirnir-pan.tif $TMP/swirnir-pan-light.tif
fi
cp -f $TMP/swirnir-pan-light.tif $FINAL

# append geotiff into image
if [ -f $TMP/swirnir-pan.tfw ]; then
  mv $TMP/swirnir-pan.tfw $DIR/${NAME}.tfw
  gdal_edit.py -a_srs EPSG:3857 $FINAL
fi

# clean up
if [ -f $FINAL ]; then
  rm -Rf $TMP
fi

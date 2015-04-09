# /bin/bash

if [ "$#" -ne 2 ]
then
  echo "    Usage: $0 [File name]"
  echo "  Example: $0 /tmp/LC81180442014356LGN00 /tmp/LC81180442014356LGN00/final/final-rgb.TIF"
  exit 1
fi

THREADHOLD=40
FINAL=$2
FILENAME=`basename $2`
NAME=${FILENAME%.*}
LANDSAT=`basename $1`
DIR=$1
TMP="${DIR}/tmp"
mkdir -p $TMP
cd $DIR

for BAND in {3,2,1}; do
  if [ ! -f $BAND-projected.tif ]; then
    FILE=$DIR/${LANDSAT}_B${BAND}.TIF
    gdalwarp -t_srs EPSG:3857 $FILE $DIR/$BAND-projected.tif;
  fi
done
convert -monitor -combine $DIR/{3,2,1}-projected.tif $TMP/rgb.tif

echo "Pan 4. Remove black border of image and scale"
gdal_translate -ot Byte -scale 0 65535 0 255 -a_nodata "0 0 0" $TMP/rgb.tif $TMP/rgb-scaled.tif
gdalwarp -r cubic -wm 1024 -multi -srcnodata "0 0 0" -dstnodata "0 0 0" -dstalpha -wo OPTIMIZE_SIZE=TRUE -wo UNIFIED_SRC_NODATA=YES -t_srs EPSG:3857 -co TILED=YES -co COMPRESS=LZW $TMP/rgb-scaled.tif $TMP/rgb-s.tif

gdalwarp -t_srs EPSG:3857  $DIR/${LANDSAT}_B1.TIF $DIR/warp_B1.TIF
listgeo -tfw $DIR/warp_B1.TIF
mv $DIR/warp_B1.tfw $DIR/${NAME}.tfw

convert -monitor -channel B -gamma 0.6 -channel R -gamma 1.01 -channel RGB -sigmoidal-contrast 33x12% $TMP/rgb-s.tif $TMP/${NAME}.tif

gdal_edit.py -a_srs EPSG:3857 $TMP/${NAME}.tif
cp -f $TMP/${NAME}.tif $FINAL

# clean up
if [ -f $FINAL ]; then
  rm -Rf $TMP
fi

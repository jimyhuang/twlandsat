#!/bin/bash
if [ "$#" -ne 1 ]
then
  echo "Usage: $0 LC81180442014356LGN00"
  exit 1
fi

# from https://gist.github.com/oeon/8007457
export ITK_AUTOLOAD_PATH=/usr/local/bin/
export LD_LIBRARY_PATH=/usr/local/lib/otb/
BASE=$1
DIR=/media/sf_landsat8/$BASE
cd /usr/local/bin
gdalbuildvrt -separate -q -srcnodata "0 0 0" -vrtnodata "0 0 0" ${DIR}/rgb.vrt ${DIR}/${BASE}_B4.TIF ${DIR}/${BASE}_B3.TIF ${DIR}/${BASE}_B2.TIF

# from https://www.mapbox.com/blog/pansharpening-satellite-imagery-openstreetmap/ , missing ColorInterp
sed -i '6 i\
<ColorInterp>Red</ColorInterp>' $DIR/rgb.vrt && \
sed -i '18  i\
<ColorInterp>Green</ColorInterp>' $DIR/rgb.vrt && \
sed -i '30 i\
<ColorInterp>Blue</ColorInterp>' $DIR/rgb.vrt 

otbcli_BundleToPerfectSensor -ram 4096 -inp ${DIR}/${BASE}_B8.TIF -inxs ${DIR}/rgb.vrt -out /tmp/pansharp.tif uint16

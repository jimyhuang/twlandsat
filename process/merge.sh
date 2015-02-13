#!/bin/bash

##########################################
# Simple script for merge different band #
##########################################

if [ "$#" -ne 1 ]
then
  echo "Usage: $0 LC81180442014356LGN00"
  exit 1
fi

BASE=$1
cd /media/sf_landsat8/$BASE
for BAND in {2,3,4,5,6,7,10}; do
  if [ ! -f $BAND-projected.tif ]; then
    FILE=${BASE}_B${BAND}.TIF
    echo $FILE
    gdalwarp -t_srs EPSG:3857 $FILE $BAND-projected.tif;
  fi
done

# script from https://www.mapbox.com/blog/processing-landsat-8/
if [ ! -f c_RGB.tif ]; then
  convert -combine {4,3,2}-projected.tif c_RGB.tif
  convert -monitor -sigmoidal-contrast 45x12% c_RGB.tif c_RGB_adj.tif
fi

# Color Infrared
if [ ! -f c_543.tif ]; then
  convert -combine {5,4,3}-projected.tif c_543.tif
  convert -monitor -sigmoidal-contrast 30x18% c_543.tif c_543_adj.tif
fi

# False color 2
if [ ! -f c_764.tif ]; then
  convert -combine {7,6,4}-projected.tif c_764.tif
  convert -monitor -sigmoidal-contrast 30x18% c_764.tif c_764_adj.tif
fi

# False color 4
if [ ! -f c_1073.tif ]; then
  convert -combine {10,7,3}-projected.tif c_1073.tif
  convert -monitor -sigmoidal-contrast 30x18% c_1073.tif c_1073_adj.tif
fi

# Agriculture
if [ ! -f c_652.tif ]; then
  convert -combine {6,5,2}-projected.tif c_652.tif
  convert -monitor -sigmoidal-contrast 30x18% c_652.tif c_652_adj.tif
fi

# Atmospheric Penetration
if [ ! -f c_765.tif ]; then
  convert -combine {7,6,5}-projected.tif c_765.tif
  convert -monitor -sigmoidal-contrast 30x18% c_765.tif c_765_adj.tif
fi

# Healthy Vegetation
if [ ! -f c_562.tif ]; then
  convert -combine {5,6,2}-projected.tif c_562.tif
  convert -monitor -sigmoidal-contrast 30x18% c_562.tif c_562_adj.tif
fi

# Land/Water
if [ ! -f c_564.tif ]; then
  convert -combine {5,6,4}-projected.tif c_564.tif
  convert -monitor -channel B -gamma 1.25 -channel G -gamma 1.25 -channel RGB -sigmoidal-contrast 30x18% c_564.tif c_564_adj3.tif
fi

# Natural With Atmospheric Removal
if [ ! -f c_753.tif ]; then
  convert -combine {7,5,3}-projected.tif c_753.tif
  convert -monitor -sigmoidal-contrast 30x18% c_753.tif c_753_adj.tif
fi

# Shortwave Infrared
if [ ! -f c_754.tif ]; then
  convert -combine {7,5,4}-projected.tif c_754.tif
  convert -monitor -sigmoidal-contrast 30x18% c_754.tif c_754_adj.tif
fi

# Vegetation Analysis
if [ ! -f c_654.tif ]; then
  convert -combine {6,5,4}-projected.tif c_654.tif
  convert -monitor -sigmoidal-contrast 30x18% c_654.tif c_654_adj.tif
fi

# 
if [ ! -f c_751.tif ]; then
  convert -combine {7,5,1}-projected.tif c_751.tif
  convert -monitor -sigmoidal-contrast 30x18% c_751.tif c_751_adj.tif
fi

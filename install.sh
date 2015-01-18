#!/bin/bash

# Install GDAL and ImageMagick
apt-get install wget dans-gdal-scripts imagemagick

# Install OTB 3.20
#
# This guide using OTB 3.20 and debian wheezy
# reference guide of OTB
# http://orfeo-toolbox.sourceforge.net/FAQ/OTB-FAQ.html#SECTION00050000000000000000
# http://www.orfeo-toolbox.org/packages/archives/Doc/OTB-FAQ-3.8.pdf
 
# you needs all theses ...
apt-get -y install libfltk1.1 cmake gdal-bin libgdal-dev geotiff-bin  libgeotiff-dev
 
# download package first at http://sourceforge.net/projects/orfeo-toolbox/files/OTB/OTB-3.20/
cd /usr/local/
wget http://goo.gl/nM7dxT -O OTB-3.20.0.tgz
tar -zxvf OTB-3.20.0.tgz
mkdir otb
cd otb
cmake ../OTB-3.20.0
 
# Here have alert for turn off OpenGL
sed -i 's/OTB_USE_VISU_GUI:BOOL=ON/OTB_USE_VISU_GUI:BOOL=OFF/g' CMakeCache.txt
# find OTB_USE_VISU_GUI:BOOL=ON replace to OTB_USE_VISU_GUI:BOOL=OFF
 
# run cmake again
cmake ../OTB-3.20.0
 
# Now everything ok
make
 
# after hour of compile ...
make install

#! /bin/bash
NAME=`head -n1 queue-pending.txt`
URL=http://earthexplorer.usgs.gov/download/4923/$NAME/STANDARD/EE
mkdir -p `pwd`/data
#wget --save-cookies /tmp/cookies.txt --post-data 'username=twlandsat&password=NwdBdCMF333p' \
#  $URL \
#  -O data/

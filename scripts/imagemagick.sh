#!/bin/bash
# Usage:
#   LC81170442015336LGN00 final-rgb.TIF tiles-rgb
#   docker run --rm --entrypoint -v ~/landsat/:/root/landsat /home/twlandsat/imagemagick-convert.sh jimyhuang/twlandsat LC81170442015336LGN00 final-rgb.TIF final-rgb.jpg

NAME=$1
FROM=$2
TO=$3
if [ -n "$4" ]; then
  SIZE=$4
else
  SIZE=600
fi

cd ~/landsat/processed/${NAME}
convert $FROM -scale $SIZE -fuzz 5% -transparent black $TO

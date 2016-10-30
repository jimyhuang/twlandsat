#!/bin/bash
# Usage:
#   LC81170442015336LGN00 final-rgb.TIF tiles-rgb
#   docker run --rm --entrypoint -v ~/landsat/:/root/landsat /home/twlandsat/imagemagick-convert.sh jimyhuang/twlandsat LC81170442015336LGN00 final-rgb.TIF final-rgb.jpg

NAME=$1
FROM=$2
TO=$3

cd ~/landsat/processed/${NAME}
convert $2 $3

#!/bin/bash
# Usage:
#   docker run --rm --entrypoint /home/twlandsat/gdal2tiles.sh jimyhuang/twlandsat LC81170442015336LGN00 final-rgb.TIF tiles-rgb

NAME=$1
FROM=$2
TO=$3

cd ~/landsat/processed/${NAME}
gdal2tiles.py $FROM $TO

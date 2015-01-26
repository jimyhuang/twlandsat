if [ ! -f test.png ]; then
  convert -monitor c_RGB_adj.tif test.png
fi

convert -monitor -limit map 0 -limit memory 0 test.png -crop 256x256 -set filename:tile "%[fx:page.x/256]_%[fx:page.y/256]" +repage +adjoin "tile_%[filename:tile].png"

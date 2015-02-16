#! /bin/bash
# remove twlandsat image
while true; do
  read -p "Uninstall twlandsat, remove docker and remove /home/landsat directory. y/n?" yn
  case $yn in
    [Yy]* ) docker stop twlandsat && docker rm twlandsat && rm -Rf /home/landsat/; break;;
    [Nn]* ) exit;;
    * ) echo "Please answer yes or no.";;
  esac
done

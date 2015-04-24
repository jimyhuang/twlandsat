#! /bin/sh
# remove twlandsat image
while true; do
  read -p "Uninstall twlandsat, remove docker and remove current_dir/landsat directory. y/n?" yn
  case $yn in
    [Yy]* ) docker stop twlandsat && docker rm twlandsat; break;;
    [Nn]* ) exit;;
    * ) echo "Please answer yes or no.";;
  esac
done

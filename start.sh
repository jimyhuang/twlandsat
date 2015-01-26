#! /bin/bash
PENDING=1f8cfkxar1
DOWNLOADED=wn9wlxessv

# get queue list
curl -s https://www.ethercalc.org/${PENDING}.csv | tr -d ',' > queue-pending.txt
curl -s https://www.ethercalc.org/${DOWNLOADED}.csv | tr -d ',' > queue-downloaded.txt
NAME=`head -n1 queue-pending.txt`

# download landsat
mkdir -p `pwd`/data
cd data
echo "Downloading ${NAME}"
# landsat download ${NAME}
cd ../

# update queue list
#if [ -f ${NAME}.tar.gz ]; then
  echo "$(tail -n +2 queue-pending.txt)" > queue-pending.txt
  echo "${NAME}" >> queue-downloaded.txt
  sed 's/$/,,/g' queue-pending.txt > queue-pending.csv
  sed 's/$/,,/g' queue-downloaded.txt > queue-downloaded.csv
  curl -X PUT -H 'Content-Type: text/csv' --data-binary @queue-pending.csv https://www.ethercalc.org/_/${PENDING}
  curl -X PUT -H 'Content-Type: text/csv' --data-binary @queue-downloaded.csv https://www.ethercalc.org/_/${DOWNLOADED}
#fi

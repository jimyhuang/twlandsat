#! /bin/bash
PENDING=1f8cfkxar1
DOWNLOADED=wn9wlxessv
FINISHED=c9kytykh4g

# get queue list
curl -s https://www.ethercalc.org/${PENDING}.csv | tr -d ',' > queue-pending.txt
curl -s https://www.ethercalc.org/${DOWNLOADED}.csv | tr -d ',' > queue-downloaded.txt
curl -s https://www.ethercalc.org/${FINISHED}.csv | tr -d ',' > queue-finished.txt

# get lastest landsat filename to process
NAME=`head -n1 queue-pending.txt`

# download landsat
echo "Downloading ${NAME}"
landsat download ${NAME}

# download completed
if [ -f ~/landsat/${NAME}.tar.gz ]; then
  # update queue list
  echo "$(tail -n +2 queue-pending.txt)" > queue-pending.txt
  echo "${NAME}" >> queue-downloaded.txt
  sed 's/$/,,/g' queue-pending.txt > queue-pending.csv
  sed 's/$/,,/g' queue-downloaded.txt > queue-downloaded.csv
  curl -X PUT -H 'Content-Type: text/csv' --data-binary @queue-pending.csv https://www.ethercalc.org/_/${PENDING}
  curl -X PUT -H 'Content-Type: text/csv' --data-binary @queue-downloaded.csv https://www.ethercalc.org/_/${DOWNLOADED}

  # image process, pansharping
  landsat process --pansharpen ~/landsat/${NAME}.tar.gz

  # TODO: tilelize file
  # TODO: upload image which successful processing

  # after long time process
  echo "${NAME}" >> queue-finished.txt
  sed 's/$/,,/g' queue-finished.txt > queue-finished.csv
  curl -X PUT -H 'Content-Type: text/csv' --data-binary @queue-finished.csv https://www.ethercalc.org/_/${FINISHED}
fi

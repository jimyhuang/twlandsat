#! /bin/bash
apt-get install -y nodejs npm
apt-get install -y libfreetype6 libfreetype6-dev libfontconfig1
ln -s /usr/bin/nodejs /usr/bin/node
npm install -g phantomjs casperjs

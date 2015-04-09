#!/usr/bin/env python
# -.- coding: utf-8 -.-

"""
Usage:
  landsat5.py <username> <password> <landsat5-filename>

Requirements: 
  beautifulsoup4==4.0.5
  requests==2.0.1
"""
import sys

import requests
from bs4 import BeautifulSoup

LOGIN_URL = 'https://earthexplorer.usgs.gov/login/'
DOWNLOAD_URL = 'http://earthexplorer.usgs.gov/download/options/3119/'

def main(uname, passwd, l5file):
    sess = requests.session()
    payload = {
    'username': uname,
    'password': passwd,
    'rememberMe': 1
    }
    print ('[1/3] login...')
    login = sess.post(LOGIN_URL, data=payload)
    if login.status_code == 200:
        print ('[2/3] get download page and parse html to find file')
        r = sess.get(DOWNLOAD_URL+l5file)
        soup = BeautifulSoup(r.text)
        tags = soup.select('#optionsPage .list .button input')
        url = tags[3]['onclick'].split('=')[1][1:-1]

        print ('[4/3] download file')
        r = sess.get(url, stream=True)
        fname = 'out.tgz'
        content = r.headers['content-disposition']
        if 'filename=' in content:
            fname = content.split('=')[1].replace('"', '')
        chunk_size = 1024
        with open(fname, 'wb') as f:
            for chunk in r.iter_content(chunk_size):
                f.write(chunk)
        f.close()
    

if __name__ == '__main__':
    if len(sys.argv) > 2:
        main(sys.argv[1], sys.argv[2], sys.argv[3])
    else:
        print ('usage: landsat5.py <username> <password> <landsat5-filename>')

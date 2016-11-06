### Directory Structure
- $HOME/landsat - all output files will goes here
- $HOME/landsat/processed - processed tif, preview jpg
- $HOME/landsat/processed/tils-rgb  - processed tiles of rgb
- $HOME/landsat/processed/tils-ndvi - processed tiles of ndvi
- $HOME/landsat/downloads - bands which downloads, purge automatically
- $HOME/.landsat-queue - you should save your files here to schedule processing by cron
- $HOME/.landsat-running - temp file for monitor if exists process running

### INSTALL

1. Prepare your docker host enviromnet.
  > read https://docs.docker.com/userguide/

2. Make sure you have required package
  ```
  sudo apt-get install realpath
  ```

### Run

Just simplely execute script will process $HOME/.landsat-queue line by line
```
./run.sh
```

Download and process specify landsat scence id, not queue
```
./run.sh LC81170442015336LGN00
```

Redirect processing log
```
./run.sh 2> /var/log/twlandsat.log
```

### Queue File Sample

What should I put in $HOME/.landsat-queue?
Per scence id per line like below:
```
LC81180442015103LGN00
LC81180452015103LGN00
LC81180432015103LGN00
LC81180422015087LGN00
```

### Hardware Requirement
- RAM: At least 1GB
- Harddisk: Each landsat will generate 500 MB include rgb and ndvi TIF and tiles.
- CPU: Multi-core will save you a lot of time.


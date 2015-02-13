Landsat Taiwan Public Image
============================
  > switch to [中文說明](https://github.com/jimyhuang/twlandsat/blob/master/README.zh_TW.md)
  
The goal of this project is generate high quality satellite map tiles using Landsat from USGS, and pubish these images to everyone using popular map browsing tool. This's a sort of call for government open data project. For now, daily satellite image owned by Taiwan government doesn't open for everyone.


Install and Use
---------------
For now, we use docker for build image processing server. 

1. Prepare your docker host enviromnet.

2. Pull prepared image from [Docker hub](https://registry.hub.docker.com/u/jimyhuang/twlandsat/)
  ```
  Docker pull jimyhuang/twlandsat
  ```
3. Run Docker and start processing

  > *Attention* this will exhause all of your cpu, memory, even if disk space. Please check *hardware requirement* below.
After each run, this docker container will processing image into host directory, then upload processed image to central server.

  ```
  git pull https://github.com/jimyhuang/twlandsat.git
  ./docker-run.sh
  docker attach twlandsat
  # after enter container
  ./start.sh
  ```

Hardware Requirement
--------------------
- RAM: 8GB
- Harddisk: at least 10 GB. Will generate 2.5 GB per landsat image
- CPU: Multi-core will save you a lot of time.

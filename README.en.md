Landsat Taiwan Public Image
============================
  > switch to [中文說明](https://github.com/jimyhuang/twlandsat/blob/master/README.md)
  
The goal of this project is generate high quality satellite map tiles using Landsat from USGS, and pubish these images to everyone using popular map browsing tool. This's a sort of call for government open data project. For now, daily satellite image owned by Taiwan government doesn't open for everyone.


Install and Use
---------------
### __Install__

1. Prepare your docker host enviromnet.
  > read https://docs.docker.com/userguide/

2. Pull prepared image from [Docker hub](https://registry.hub.docker.com/u/jimyhuang/twlandsat/)
  > just using this shell to speed up things.
  ```
  git pull https://github.com/jimyhuang/twlandsat.git
  ./docker-install.sh
  ```

3. Run Docker and start processing
  > *Attention* this will exhause all of your cpu, memory, even if disk space. Please check *hardware requirement* below.
After each run, this docker container will processing image into host directory, then upload processed image to central server.

  ```
  ./docker-start.sh
  # after enter container, start processing 1 image
  ./start.sh 1
  # you can processing many images, we suggest 1.5 hour per image. 10 images means 15 hours
  ./start.sh 10
  ```
  > You can also restart docker container using this
  
  ```
  ./docker-restart.sh
    # after enter container
  ./start.sh 1
  ```

### __Uninstall__
  > Uninstall will purge docker image, and /home/landsat directory.
  
  ```
  ./docker-uninstall.sh
  ```

### __Update__
  > Just pull image again
  
  ```
  ./docker-install.sh
  ```

Hardware Requirement
--------------------
- RAM: 8GB
- Harddisk: at least 10 GB. Will generate 2.5 GB per landsat image
- CPU: Multi-core will save you a lot of time.

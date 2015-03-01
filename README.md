**賽豬公上太空計畫**
====================
  > switch to [English Readme](https://github.com/jimyhuang/twlandsat/blob/master/README.en.md)

計畫目標：
  - [x] 提供台灣1980年至今內授權無虞的可見光衛星空照圖，供NPO、研究領域、新聞媒體 ...等各界，免費進行各種應用
    - [x] Landsat 8 衛星圖，每當新增自動演算增加（2013至今）
    - [ ] Landsat 5 衛星圖（1981-2011）
    - [ ] Corona 衛星圖（1960-1972） 
  - [x] 提供開放原始碼衛星圖資，分散協同運算解決方案（詳看[技術細節]）
    - [x] 多人共同運算，每個人電腦皆可安裝簡單指令協助算圖
    - [x] 全色態銳化(Pansharpening)運算以提高解析度
    - [x] RGB色彩圖資自動校準季節色
    - [x] SWIR-NIR，短波紅外線、近紅外線反色圖產生
    - [ ] 分群演算
  - [x] 提供 Web 瀏覽器供一般人輕易就可以檢視、重組衛星圖
    - [x] 提供時間前後差異比較瀏覽功能
    - [ ] 提供多時間自動播放功能
    - [ ] 提供多種不同地圖疊圖

計畫現況：
  - [討論區](https://www.facebook.com/groups/610479852418250/)
  - [線上地圖](http://twlandsat.jimmyhub.net/)
  - [Gallery](https://www.flickr.com/search/?q=twlandsat&m=tags) (歡迎將捷圖上傳至Flickr，Tag twlandsat)

**緣起與構想**
====================
「賽豬公上太空」 計畫的名字緣起，來自 Dan Berkenstock 在 [TED 的演講](https://www.ted.com/talks/dan_berkenstock_the_world_is_one_big_dataset_now_how_to_photograph_it?language=zh-tw)，提到：「發射衛星進行空照圖有必要這麼貴嗎？」
然後 Dan Berkenstock 創立的公司，就開始發射小型衛星 SkySat，來提供全球圖資。深感佩服的當下，卻反觀台灣現階段仍在掙扎跟政府取得衛星圖，當真是別人已上外太空，我們還在殺豬公的真實寫照。

不過賽豬公的自力救濟還是有點機會，因為美國NASA提供的免費圖資，可以拼湊出台灣過去數十年的地表影像紀錄。期待本計畫提供的 Open Source 技術解決方案越亦成熟下，真正能夠拉近網路科技、地理資訊應用，與環境監測的距離。

**參與與協助**
==========================

加入社團：
> 目前有一群關心環境、地理資訊、程式高手組成的Facebook社團，在這社團可以一起討論如何運用衛星圖，以及分享相關GIS資訊。
  - [現在就加入](https://www.facebook.com/groups/610479852418250/)

應用圖資：
> 時間的軌跡，需要了解台灣過去發展歷史的朋友，才知道該怎麼看圖。例如：海岸線變化，地表的種植地增加減少，城市擴張...
  - [線上瀏覽地圖](http://twlandsat.jimmyhub.net)

撰寫程式：
> 眼尖的你，會發現計畫目標中的勾選框，並沒有全部完成。這當然是因為需要你一起加入 -- 
  - [加入開發者](https://github.com/jimyhuang/twlandsat/issues/1)

演算衛星圖：
> 只要你有下列規格的電腦，優良的網路速度，即可一同協助我們演算過往30年的圖資
  - 硬體需求
    - CPU：多核心，會讓你算圖時還可做別的事情，瀏覽網頁
    - RAM：至少 2GB，建議4GB
    - 硬碟空間：至少剩餘 10 GB
    - 網路：穩定不中斷的網路。算圖結果會上傳至Server，512KB 上傳，至少需要30-40分鐘完成。

**安裝說明**
------------
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


MAC安裝與使用
----------
1. Mac跑docker, 要先裝boot2docker

  ```
  brew install boot2docker
  ```
2. init boot2docker

  ```
  boot2docker init
  ```
3. 如果要提升ram, 用下面的指令調整

  ```
  VBoxManage modifyvm boot2docker-vm --memory xxx(MB)
  ```
4. start boot2docker

  ```
  boot2docker up
  ```
5. 接下來docker的指令一樣
6. 結束以後, 記得把boo2docker停下來

  ```
  boot2docker stop
  boot2docker delete
  ```

資源
====

非技術/參考案例
-----------------

Landsat 圖資與解析
  - Landsat 8 圖層解析 - https://www.mapbox.com/blog/putting-landsat-8-bands-to-work/
  - 瀏覽Landsat圖資 - http://earthexplorer.usgs.gov/
  - 線上瀏覽 Landsat 可見光圖 - http://landsatlook.usgs.gov/viewer.html

Louisiana Project - Landsat 長時間監測土地流失調查報導
  - https://projects.propublica.org/louisiana/
  - http://towcenter.org/sensors-and-journalism/sensors-and-journalism-propublica-satellites-and-the-shrinking-louisiana-coast/

MapKnitter - 自己的地圖自己畫
  - http://mapknitter.org/

Open IR - 運用 IR 圖層監測洪水災害研究
  - http://openir.media.mit.edu/main/?p=305
  - https://github.com/DuKode/OpenIR_ImageProcAndPrep

環境、污染與資訊（建案、環評）之地理套疊 (from g0v 提案)
  - https://g0v.hackpad.com/3IlRBxAKgVg

技術參考
--------

Landsat process (by imagemagick)
  - http://joelarson.com/landsat/2013/12/17/landsat-pan-sharpening-and-processing/
  - https://www.mapbox.com/blog/processing-landsat-8/
  - http://a-chien.blogspot.tw/2014/04/imagejlandsat.html

Band combination / analysis
  - http://blogs.esri.com/esri/arcgis/2013/07/24/band-combinations-for-landsat-8/
  - http://www.slideshare.net/kabiruddin/introduce-variable
  - http://www.dgeo.udec.cl/wp-content/uploads/2014/01/javier-concha_enero-2014_sat%C3%A9lite.pdf

Convert image to tile
  - https://github.com/moagrius/TileView/wiki/Creating-Tiles
  - http://www.imagemagick.org/discourse-server/viewtopic.php?t=22939
  - https://github.com/klokantech/tileserver-php/
  - http://openlayers.org/en/v3.1.1/examples/wmts.html

GDAL Manipulating
  - https://github.com/dwtkns/gdal-cheat-sheet/blob/master/README.md#raster-operations
  - http://joelarson.com/tags.html#gdal2tiles-ref

Others
  - Landsat wrs converter: http://blog.rtwilson.com/converting-latitudelongitude-co-ordinates-to-landsat-wrs-2-pathsrows/comment-page-1/
  - 衛星偵測水污染方法(可惜不是 Landsat) http://www.csprs.org.tw/Temp/200912-14-4-287-302.pdf

Used Repositories
-----------------
  - https://github.com/jimyhuang/twlandsat-browse - Website browser
  - https://github.com/jimyhuang/twlandsat-docker-util - Dockerfile for landsat
  - https://github.com/jimyhuang/twlandsat-docker - Dockerfile image for twlandsat
  - https://github.com/jimyhuang/landsat-util - forked from developmentseed
  - https://github.com/jimyhuang/indicar-tools - forked from ibamacsr
  - https://registry.hub.docker.com/u/jimyhuang/twlandsat - Docker image
  - https://registry.hub.docker.com/u/jimyhuang/twlandsat-util/ - Docker base image

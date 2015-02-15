**賽豬公上太空計畫**
====================
  > switch to [English Readme](https://github.com/jimyhuang/twlandsat/blob/master/README.zh_TW.md)

別人已經上太空，我們還在賽豬公，也算是對於台灣自有衛星圖 Open Data 的現況描述。期待本計畫提供的 Open Source 技術解決方案越亦成熟下，真正能夠拉近網路科技、地理資訊應用，與環境監測的距離。

衛星圖資與運算方式
------------------
圖資來自美國 [USGS](http://earthexplorer.usgs.gov) 供應的免費、定期的科研 Landsat 衛星空照圖，取出 Landsat 衛星經過台灣4塊經緯度，進行全色態銳化(Pansharpening)以提高解析度，並裁切成可供 Web 地圖瀏覽程式運用的 Tile。

現況展示
--------
1. [線上地圖](http://twlandsat.jimmyhub.net/?landsat=LC81180442014308LGN00|LC81180442015023LGN00)
  - 線上比較 2014-11-04 / 2015-01-23 兩個時間點的西部穀倉，可以輕易看到收割前後的種植覆蓋

2.  2014-12-31 青境農場(Pansharpening)
  
  <img src="https://farm9.staticflickr.com/8659/16335256707_bb9aa4f666_o.png" width="300" alt="RGB">

3. NDVI - Normalized Difference Vegetation Index ([常態化差值植生指標](http://zh.wikipedia.org/wiki/%E5%B8%B8%E6%85%8B%E5%8C%96%E5%B7%AE%E5%80%BC%E6%A4%8D%E7%94%9F%E6%8C%87%E6%A8%99))
  應用近紅外光反射取得植生的生長狀態
  
  <img src="https://farm9.staticflickr.com/8620/16332528928_1221c120d0_o.png" width="300px" alt="Taipei-NDVI" />

4. 植生變遷(TODO)
  運用NDVI的差異，了解過去16天內植物的生長差異，並產出 geojson 供線上檢視
  
  <img src="https://farm9.staticflickr.com/8652/16334142509_f5989b377d_o.png" width="300px" alt="NDVI-diff-geojson" />

困境
----------
  - 目前應用 landsat-util 來進行取圖、全像銳化（Pansharpening），然而得算很久，一張圖算完含上傳要算1-2小時
  - NDVI 的 geojson 差異比較，等圖都取完後再比較才準
  - 空間佔用很大，一張圖壓縮後約需要 2gb 空間儲存

TODO List
---------
  - 請到這裡[一起討論](https://g0v.hackpad.com/oZjrZwHKc8r)新功能


**你也可以參與算圖的行列**
==========================
只要你有 Docker 環境，就可以協力算圖！一起算圖現在就來[簽名一下](https://g0v.hackpad.com/oZjrZwHKc8r)...

安裝與使用
----------

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

硬體需求
--------------------
- RAM: 8GB
- Harddisk: at least 10 GB. Will generate 2.5 GB per landsat image
- CPU: Multi-core will save you a lot of time.


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

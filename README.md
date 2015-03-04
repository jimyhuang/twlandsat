**賽豬公上太空計畫**
====================
  > switch to [English Readme](https://github.com/jimyhuang/twlandsat/blob/master/README.en.md)
  
<img src="https://farm9.staticflickr.com/8594/16633417271_4daf4b34cd_o.png" width="100%">

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

緣起與構想
====================
「賽豬公上太空」 計畫的名字緣起，來自 Dan Berkenstock 在 [TED 的演講](https://www.ted.com/talks/dan_berkenstock_the_world_is_one_big_dataset_now_how_to_photograph_it?language=zh-tw)，提到：「發射衛星進行空照圖有必要這麼貴嗎？」
然後 Dan Berkenstock 創立的公司，就開始發射小型衛星 SkySat，來提供全球圖資。深感佩服的當下，卻反觀台灣現階段仍在掙扎跟政府取得授權無虞的衛星圖，當真是別人已上外太空，我們還在殺豬公的真實寫照。

不過賽豬公的自力救濟還是有點機會，讓技術或觀看的權力，不再把持於菁英手上，因為美國NASA提供的免費圖資，可以拼湊出台灣過去數十年的地表影像紀錄。期待本計畫提供的 Open Source 技術解決方案越亦成熟下，真正能夠拉近網路科技、地理資訊應用，與環境監測的距離。

參與與協助
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

安裝與技術說明
------------

### __技術細節__

協同式算圖，應用以下Open Source工具：
  - Docker Image：
    - Docker是一種Portable Linux，可以輕易在任何平台運行同一套配置的Linux，所有的運算在 Docker 中執行，表示無須擔心執行程式的人有其他的 Linux 環境配置，甚至執行的人無須有Linux。
  - Ofero Toolbox：
    - 主要進行 Pan-sharpening 的運算，可將 Landsat 7 / Landsat 8 的衛星圖，從30M的解析度放大至15M
  - Gdal Utilities：
    - gdalwarp，進行影像的投影變換（衛星影像和Online Map不同）
    - gdaledit，將TIF檔案得地理資訊儲存回去。
    - gdal2tiles，將GEOTIFF檔案，轉換成線上地圖可用的切圖檔案。
  - ImageMagick：
    - 像素基礎影像處理，合成衛星不同頻譜的影像，調色、亮度調整
  - Rsync：
    - 進行影像同步及上傳，分派Queue檔案

Web瀏覽，應用以下Open Source工具：
  - Leaflet
    - Open Source Map Browser，有多種Plugin處理
  - Map Before After
    - JQuery Based 地圖前後比較工具

### __安裝__

1. 準備你的Docker環境
  > 閱讀 [Windows 安裝 Docker 指引](https://github.com/zhangpeihao/LearningDocker/blob/master/manuscript/01-DownloadAndInstall.md)

2. 複製本計畫檔案於目錄下
  > git clone 可以直接複製專案
  ```
  git clone https://github.com/jimyhuang/twlandsat.git
  ./docker-install.sh
  ```

3. 啟動
  > *注意* ，這可能會耗盡你的記憶體和CPU、甚至硬碟空間，請先確認是否有足夠的硬體配置。
  > 登入docker
  ```
  ./docker-start.sh
  ```
  登入後，可以進行第一次的算圖，start.sh 1，表示算一張圖的意思
  ```
  ./start.sh 1
  ```
  當順利算完一張圖後，也可以一次排程很多張，會慢慢算到完為止。一張圖演算加上傳以 1.5小時計，10張圖就要15小時。
  ```
  ./start.sh 10
  ```
  
4. 重啟  
  > 碰到死機，可以在 docker 裡頭按下 Ctrl + C，然後 ./start.sh 繼續。
  > 或是更直接的方式，乾脆登出Docker，然後重新開啟、重新start.sh
  ```
  ./docker-restart.sh
    # after enter container
  ./start.sh 1
  ```

### __反安裝/刪除__
  > 反安裝程式將會釋放所有這運算所佔用的圖片除存空間，刪除 /home/landsat 的資料，以及 /tmp/ 相關的資料，和Docker本身。
  
  ```
  ./docker-uninstall.sh
  ```

### __更新最新的twlandsat__
  > 執行以下指令即可
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

參考資源
========

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

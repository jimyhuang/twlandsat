**賽豬公上太空計畫**
====================
  > switch to [English Readme](https://github.com/jimyhuang/twlandsat/blob/master/README.zh_TW.md)

別人已經上太空，我們還在賽豬公，也算是對於台灣自有衛星圖 Open Data 的現況描述。期待本計畫提供的 Open Source 技術解決方案越亦成熟下，真正能夠拉近網路科技、地理資訊應用，與環境監測的距離。

衛星圖資與運算方式
------------------
圖資來自美國 [USGS](http://earthexplorer.usgs.gov) 供應的免費、定期的科研 Landsat 衛星空照圖，取出 Landsat 衛星經過台灣4塊經緯度，進行全色態銳化(Pansharpening)以提高解析度，並裁切成可供 Web 地圖瀏覽程式運用的 Tile。

成果展示
--------
Online map viewer: http://twlandsat.jimmyhub.net

NDVI - Normalized Difference Vegetation Index ([常態化差值植生指標](http://zh.wikipedia.org/wiki/%E5%B8%B8%E6%85%8B%E5%8C%96%E5%B7%AE%E5%80%BC%E6%A4%8D%E7%94%9F%E6%8C%87%E6%A8%99))
  應用近紅外光反射取得植生的生長狀態
  
  <img src="https://farm9.staticflickr.com/8620/16332528928_1221c120d0_o.png" width="300px" alt="Taipei-NDVI" />

植生變遷
  運用NDVI的差異，了解過去16天內植物的生長差異，並產出 geojson 供線上檢視
  
  <img src="https://farm9.staticflickr.com/8652/16334142509_f5989b377d_o.png" width="300px" alt="NDVI-diff-geojson" />

困境與現況
----------

**如何協力**
============

安裝
----


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

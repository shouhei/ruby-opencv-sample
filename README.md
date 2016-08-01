# 準備

```
brew tap homebrew/science
brew install opencv
bundle config build.opencv --local -- --with-opencv-dir=`brew --prefix opencv`
```

上記の手順を踏み、opencvがインストールされいている状態を作り、`./.bundle/config` 内に

```
BUNDLE_BUILD__OPENCV: "-- --with-opencv-dir=/usr/local/opt/opencv"
```

上記が記述されている状態を作った後に

```
bundle install --path=vendor/bundle
```

あとは顔の画像を適当に用意する

また、必要に応じてソース内の `data_dir` を書き換える

brewでopencvをインストールしているとおそらく `/usr/local/Cellar/opencv/2.4.13/share/OpenCV/haarcascades/` がdata_dirとなる

# ファイル説明

* `load_image.rb` 画像読込のチェック
* `*_detect.rb` 検知チェック
* `eye_resize.rb` 目のリサイズ

# eye_resize.rbの動作

```
bundle exec ruby eye_resize.rb input output resize(float)
```

第一引数: input
第二引数: output
第三引数: 拡大比率(1~1.1の間)

# coding: utf-8
require 'opencv'
include OpenCV

# 第一引数が入力ファイル
# 第二引数が出力ファイル
# 第三引数が拡大の比率
if ARGV.length < 3
  puts "Usage: ruby #{__FILE__} source dest"
  exit
end

# お手軽実装でなんとかなるのは1.1倍くらいまで
# 1.1倍以上を実現するには、もっと別の手法が必要
ARGV[2] = ARGV[2].to_f
if ARGV[2] > 1.1 || ARGV[2] < 1
  puts 'リサイズの比率は1~1.1の間で指定してください'
  exit
end

# opencvのデータディレクトリ
data_dir = './data'
# 以下のxmlを変更すると検知の対象を変えることが出来る
data = "#{data_dir}/haarcascades_cuda/haarcascade_eye.xml"
detector = CvHaarClassifierCascade::load(data)
image = IplImage.load(ARGV[0])

detector.detect_objects(image).each do |region|
  # 検知した対象を切り出す
  sub_image = image.sub_rect region

  # 検知した対象を指定した比率で拡大もしくは縮小する
  # 実装の問題で現状は1.1倍までの拡大のみ
  resized_height = region.height * ARGV[2]
  resized_width = region.width * ARGV[2]
  resized_image = sub_image.resize(CvSize.new(resized_height, resized_width))

  changed_height = resized_height - region.height
  changed_width = resized_width - region.width

  resized_x = region.x - changed_height / 2
  resized_y = region.y - changed_width / 2

  # リサイズした分だけ座標をずらして合成
  image.set_roi CvAvgComp.new resized_x, resized_y, resized_height, resized_width
  (resized_image.rows * resized_image.cols).times do |i|
    if resized_image[i][0].to_i > 0 or resized_image[i][1].to_i > 0 or resized_image[i][2].to_i > 0
      image[i] = resized_image[i]
    end
  end
  # 座標をリセット
  image.reset_roi
end

image.save_image(ARGV[1])

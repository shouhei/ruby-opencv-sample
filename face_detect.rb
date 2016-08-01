require 'opencv'
include OpenCV

if ARGV.length < 2
  puts "Usage: ruby #{__FILE__} source dest"
  exit
end

data_dir = './data'
data = "#{data_dir}/haarcascades_cuda/haarcascade_frontalface_alt.xml"
detector = CvHaarClassifierCascade::load(data)
image = IplImage.load(ARGV[0])
detector.detect_objects(image).each do |region|
  color = CvColor::Blue
  image.rectangle! region.top_left, region.bottom_right, :color => color
end

image.save_image(ARGV[1])

require 'mini_magick'
require 'opencv'

module Paperclip
  class Cropper < Processor

    def make
      detector = OpenCV::CvHaarClassifierCascade::load('./haarcascade_frontalface_alt.xml')
      image = OpenCV::CvMat.load(@file.path)
      regions = detector.detect_objects(image, scale_factor: 1.99)
      region = regions.max{|r| r.width}

      width=region.width*2
      height=width*6/5
      x = region.x-((width-region.width)/2)
      y = region.y-(height*0.2)

      cropped_image=MiniMagick::Image::open(@file.path).crop("#{width}x#{height}+#{x}+#{y}")
      dst = TempfileFactory.new.generate() #filename)
      cropped_image.write(dst)
      dst
    end
  end
end

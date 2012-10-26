# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  process :convert => 'png'

  version :standard do
    process :resize_to_fill => [150, 150, :north]
  end
  
  version :large do
    process :resize_to_fill => [400, 400]
  end
  
  version :thumbnail do
    process :resize_to_fill => [50, 50]
  end

  version :gravatar do
    process :resize_to_fill => [75, 100]
  end

  # def crop
    # if model.crop_x.present?
    #   resize_to_limit(600, 600)
    #   manipulate! do |img|
    #     x = model.crop_x.to_i
    #     y = model.crop_y.to_i
    #     w = model.crop_w.to_i
    #     h = model.crop_h.to_i
    #     img.crop!(x, y, w, h)
    #   end
    # end
  # end
  
  # protected
    
  #   def add_crop_data picture
  #     x = model.crop_x.to_i
  #     y = model.crop_y.to_i
  #     w = model.crop_w.to_i
  #     h = model.crop_h.to_i
  #     return [x,y,w,h]
  #   end
end

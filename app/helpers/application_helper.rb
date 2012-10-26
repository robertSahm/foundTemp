module ApplicationHelper
  
  def merchant_tag(user)
    if user.providers
      link_to "Merchant Sign In", merchants_path      
    else
      link_to "Merchant Sign Up", new_provider_path
    end
  end
  
  def download_img_url_for(photo)
    # if !photo.nil?
    #   AWS::S3::S3Object.url_for(photo, THUMB, :authenticated => false)
    # end
  end

# SUPER RAD CUSTOM IMAGE TAG

  # def custom_image_tag(object,width,height)
  #   # receive object (user or provider) and width and height
  #   if object.photo.blank?
  #     if object.kind_of? User
  #       # if object is a User then give user ghost image
  #       photo = "http://res.cloudinary.com/drinkboard/image/upload/c_fill,h_#{height},w_#{width}/v1349148077/ezsucdxfcc7iwrztkags.png"
  #     else
  #       # if object is provider use ghost provider image
  #       photo = "http://res.cloudinary.com/drinkboard/image/upload/c_fill,h_#{height},w_#{width}/v1349150293/upqygknnlerbevz4jpnw.png"
  #     end
  #   else
  #     # user the image in the object's photo of database
  #     photo_url = object.photo.dup.to_s
  #     photo_array = photo_url.split('upload/')
  #     photo = "http://res.cloudinary.com/drinkboard/image/upload/c_fill,h_#{height},w_#{width}/#{photo_array[1]}"      
  #   end 
  #   # create cloudinary image tag with custom url 
  #   image_tag(photo, alt: "customImageTag", :class => 'gravatar' )
  # end
  
end

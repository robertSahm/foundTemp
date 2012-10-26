# == Schema Information
#
# Table name: providers
#
#  id          :integer         not null, primary key
#  name        :string(255)     not null
#  zinger      :string(255)
#  description :text
#  address     :string(255)
#  address_2   :string(255)
#  city        :string(32)
#  state       :string(2)
#  zip         :string(16)
#  user_id     :integer         not null
#  logo        :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  phone       :string(255)
#  email       :string(255)
#  twitter     :string(255)
#  facebook    :string(255)
#  website     :string(255)
#  photo       :string(255)
#  staff_id    :string(255)
#

class Provider < ActiveRecord::Base
  attr_accessible :address, :city, :description, :logo, :name, :state, :user_id, :staff_id, :zip, :zinger, :phone, :email, :twitter, :facebook, :website, :users, :photo, :photo_cache, :logo_cache, :box, :box_cache, :portrait, :portrait_cache, :account_name, :aba, :routing, :bank_account_name, :bank_address, :bank_city, :bank_state, :bank_zip


  has_many   :users, :through => :employees                                                                              
  has_many   :employees
  has_one    :menu                                                                              
  has_many   :orders                                                                            
  has_one    :menu_string
  has_many   :gifts
  has_many   :servers, class_name: "Employee"

  # mount_uploader :photo,    ImageUploader
  # mount_uploader :logo,     ImageUploader
  # mount_uploader :box,      ImageUploader
  # mount_uploader :portrait, ImageUploader
  

  def self.allWithinBounds(bounds)
    Provider.where(:latitude => (bounds[:botLat]..bounds[:topLat]), :longitude => (bounds[:leftLng]..bounds[:rightLng]))
  end

  def full_address
    "#{self.address},  #{self.city}, #{self.state}"
  end
  
  def get_servers
    # this means get people who are at work not just employed
    # for now without location data, its just employees
    self.employees
  end
  
  def server_codes
    self.employees.collect {|e| e.server_code}
  end

  def get_server_from_code(code)
    self.employees.select {|e| e.server_code == code}
  end
   
  def server_to_iphone
    self.employees.servers_hash
  end
end


  # [{"first_name"=>"Larry",
  #  "id"=>19, 
  #  "last_name"=>"Page", 
  #  "photo"=>{
  #     "url"=>"http://res.cloudinary.com/drinkboard/image/upload/v1347955675/19.png", 
  #     :standard=>{
  #       "url"=>"http://res.cloudinary.com/drinkboard/image/upload/c_fill,g_north,h_150,w_100/v1347955675/19.png"
  #     }, 
  #     :large=>{
  #       "url"=>"http://res.cloudinary.com/drinkboard/image/upload/c_fill,h_400,w_400/v1347955675/19.png"
  #     }, 
  #     :thumbnail=>{
  #       "url"=>"http://res.cloudinary.com/drinkboard/image/upload/c_fit,h_100,w_75/v1347955675/19.png"
  #     }
  #   }, 
  #   "server_code"=>"1234"
  # }] 








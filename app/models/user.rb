# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  email           :string(255)     not null
#  admin           :boolean         default(FALSE)
#  photo           :string(255)
#  password_digest :string(255)     not null
#  remember_token  :string(255)     not null
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  address         :string(255)
#  address_2       :string(255)
#  city            :string(20)
#  state           :string(2)
#  zip             :string(16)
#  credit_number   :string(255)
#  phone           :string(255)
#  first_name      :string(255)
#  last_name       :string(255)
#  provider_id     :string(255)
#  facebook_id     :string(255)
#  handle          :string(255)
#

class User < ActiveRecord::Base

  attr_accessible  :email, :password, :password_confirmation, :photo, :photo_cache, :first_name, :last_name, :phone, :address, :address_2, :city, :state, :zip, :credit_number, :admin, :facebook_id, :facebook_access_token, :facebook_expiry, :foursquare_id, :foursquare_access_token, :provider_id, :handle, :server_code, :sex
  # mount_uploader   :photo, ImageUploader
   
  has_many :employees
  has_many :providers, :through => :employees
  has_many :orders,    :through => :providers
  has_many :gifts
  # has_many :givers, through: :connections, source: "giver"
  # has_many :connections,          foreign_key: "receiver_id", dependent: :destroy
  # has_many :reverse_connections,  foreign_key: "giver_id",
  #                                class_name: "Connection",
  #                                dependent: :destroy
  # has_many :receivers, through: :reverse_connections, source: :receiver
  # has_many :microposts, dependent: :destroy
  has_many :followed_users, through: :relationships, source: "followed"
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_relationships, foreign_key: "followed_id",
                                  class_name: "Relationship",
                                  dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  has_secure_password

  #  User.next(user) & previous functions for rails console
  self.class_eval do
    scope :previous,  lambda { |i| {:conditions => ["#{self.table_name}.id < ?", i], :order => "#{self.table_name}.id DESC", :limit => 1 }}
    scope :next,      lambda { |i| {:conditions => ["#{self.table_name}.id > ?", i], :order => "#{self.table_name}.id ASC",  :limit => 1 }}
  end
  
  
  # save data to db with proper cases
  before_save { |user| user.email      = email.downcase  }
  before_save { |user| user.first_name = first_name.capitalize if first_name}
  before_save { |user| user.last_name  = last_name.capitalize  if last_name }
  before_save   :extract_phone_digits       # remove all non-digits from phone
  
  before_create :create_remember_token      # creates unique remember token for user

      # searches gift db for ghost gifts that belong to new user 
      # after_create for new accounts
      # after_update , :if => :added_social_media TODO
      # this after_save covers both those situations , but also runs the code unnecessarily
  after_save    :collect_incomplete_gifts   

  # after_update  :crop_photo
  
  # validates_presence_of :city, :state, :zip, :address, :credit_number
  # unique validation code for facebook_id & foursquare_id TODO
  validates :first_name  , presence: true, length: { maximum: 50 }
  validates :last_name  ,  length: { maximum: 50 }
  validates :phone , format: { with: VALID_PHONE_REGEX }, uniqueness: true, :if => :phone_exists?
  validates :email , format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 },      on: :create
  validates :password_confirmation, presence: true, on: :create
  validates :server_code, length: {is: 4}, numericality: { only_integer: true }, :if => :check_for_server_code
  # validates_with ServerCodeValidator, :record => self

  #/---------------------------------------------------------------------------------------------/
  def feed
    Micropost.from_users_followed_by(self)
  end
  
  def username
    if self.last_name.blank?
      "#{self.first_name}"
    else
      "#{self.first_name} #{self.last_name}"
    end
  end
  
  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end
  
  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end
  
  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end
  
  def full_address
    "#{self.address},  #{self.city}, #{self.state}"
  end
  
  def checkin_to_foursquare(fsq_id, lat, lng)
    requrl = "https://foursquare.com/oauth2/access_token"
    response = HTTParty.post(url, :query => {:venueId => fsq_id, :ll => ["?,?",lat,lng], :oauth_token => self.foursquare_access_token})
    return false if response.code != 200
    return true
  end
  
  private
    
    def collect_incomplete_gifts
              # check Gift.rb for ghost gifts connected to newly created user 
      gifts = []
      if self.facebook_id
        g = Gift.where("status = :stat AND facebook_id = :fb_id",    :stat => 'incomplete', :fb_id   => self.facebook_id)
        gifts.concat g
      end
      if self.foursquare_id
        g = Gift.where("status = :stat AND foursquare_id = :fsq_id", :stat => 'incomplete', :fsq_id  => self.foursquare_id)
        gifts.concat g      
      end 
      if self.phone
        g = Gift.where("status = :stat AND receiver_phone = :phone", :stat => 'incomplete', :phone   => self.phone)
        gifts.concat g     
      end
     
              # update incomplete gifts to open gifts with receiver info
      if gifts.count > 0
        error   = 0
        success = 0

        gifts.each do |g|
          gift_changes                  = {}
          gift_changes[:status]         = "open"
          gift_changes[:receiver_phone] = self.phone if self.phone
          gift_changes[:receiver_id]    = self.id
          gift_changes[:receiver_name]  = self.username
                  
          if g.update_attributes(gift_changes)
            success += 1
          else
            error   += 1
          end
        end
                # build success & error messages for reference
        if  error  == 0
          response = "#{success} incomplete gift(s) updated SUCCESSfully on create of #{self.username} #{self.id}"
        else
          response = "#{error} ERRORS updating ghost gifts for #{self.username} #{self.id}"
        end       
                
      else
                # no incomplete gifts found
        response   = "ZERO incomplete ghost gifts for  #{self.username} #{self.id}"
      end
        
                # log the messages output for the method
      puts "COLLECT INCOMPLETE GIFTS"
      puts response
    end
    
    # def crop_photo
    #   # photo.recreate_versions! if crop_x.present?
    # end
    
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
    
    def extract_phone_digits
      if self.phone
        phone_raw   = self.phone
        phone_match = phone_raw.match(VALID_PHONE_REGEX)
        self.phone  = phone_match[1] + phone_match[2] + phone_match[3]
      end
    end

    def phone_exists?
      self.phone != nil
    end

    def check_for_server_code
      self.server_code != nil
    end

end

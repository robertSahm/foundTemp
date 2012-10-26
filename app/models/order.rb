# == Schema Information
#
# Table name: orders
#
#  id          :integer         not null, primary key
#  redeem_id   :integer
#  gift_id     :integer
#  redeem_code :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Order < ActiveRecord::Base
  attr_accessible :gift_id, :redeem_code, :redeem_id, :server_code, :server_id, :provider_id
  
  belongs_to  :provider
  belongs_to  :redeem
  belongs_to  :gift
  belongs_to  :server, class_name: "User"


  # order must be unique for each gift and redeem 
        # validation for provider_id is in callback until data is being sent from iPhone
  validates_presence_of :server_id 
  validates :gift_id   , presence: true, uniqueness: true
  validates :redeem_id , presence: true, uniqueness: true
    
  before_validation :add_gift_id,     :if => :no_gift_id
  before_validation :add_provider_id, :if => :no_provider_id
  before_validation :authenticate_via_code
  after_create      :update_gift_status
    
  private
    
    def add_server
      server_ary      = self.provider.get_server_from_code(self.server_code)
      server_obj      = server_ary.pop
      self.server_id  = server_obj.user.id
      puts "found server #{server_obj.name} #{server_obj.id}" 
    end

    def update_gift_status
      self.gift.update_attributes({status: 'redeemed'})
    end
    
    def authenticate_via_code
      puts "AUTHENTICATE VIA CODE"
      if self.redeem_code
                  # authentication code for redeem_code
        redeem_obj = self.redeem
                  # set flag for approved/denied - true/false
        if self.redeem_code == redeem_obj.redeem_code
          flag = true
        else
          flag = false
          puts "CUSTOMER REDEEM CODE INCORRECT"
        end
      elsif self.server_code
                  # authenticate for server_code
        codes = self.provider.server_codes
                  # set flag for approval/denied - true/false
        if codes.include? self.server_code
          flag = true
          add_server
        else
          flag = false
          puts "MERCHANT REDEEM CODE INCORRECT"
        end
      else
                  # no code provided - set flag to denied - false
        flag = false
      end
      return flag
    end
    
    def no_gift_id
      self.gift_id.nil?
    end
    
    def add_gift_id
      puts "ADD GIFT ID"
      self.gift_id = self.redeem.gift_id
    end

    def no_provider_id
      self.provider_id.nil?
    end
    
    def add_provider_id
      puts "ADD PROVIDER ID"
      self.provider_id = self.gift.provider_id
    end
  
end

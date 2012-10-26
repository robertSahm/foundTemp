# == Schema Information
#
# Table name: gifts
#
#  id                   :integer         not null, primary key
#  giver_name           :string(255)
#  receiver_name        :string(255)
#  provider_name        :string(255)
#  item_name            :string(255)
#  giver_id             :integer
#  receiver_id          :integer
#  item_id              :integer
#  price                :string(20)
#  quantity             :integer         not null
#  total                :string(20)
#  credit_card          :string(100)
#  provider_id          :integer
#  message              :text
#  special_instructions :text
#  redeem_id            :integer
#  status               :string(255)     default("open")
#  category             :string(255)
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#  receiver_phone       :string(255)
#

class Gift < ActiveRecord::Base
  attr_accessible :credit_card, :giver_id, :item_id, :message, :price, :provider_id, :quantity, :receiver_id, :redeem_id, :special_instructions, :status, :total, :giver_name, :receiver_name, :receiver_name ,  :provider_name, :item_name , :category, :receiver_phone, :tip, :tax, :facebook_id, :foursquare_id
  
  has_one     :redeem
  belongs_to  :provider
  belongs_to  :item
  has_one     :order
  belongs_to  :giver,    class_name: "User"
  belongs_to  :receiver, class_name: "User"
  
  # add tax and tip when the iphone is ready 
  validates_presence_of :giver_id, :item_id, :price, :provider_id, :quantity, :total
  # validates_numericality_of  :total, :quantity
  
  before_create :add_category, :if => :no_category
  before_create :pluralizer
  before_save   :set_status

  def self.get_gifts(user)
    Gift.where(receiver_id: user).where("status = :open OR status = :notified", :open => 'open', :notified => 'notified').order("created_at DESC")
  end

  def self.get_past_gifts(user)
    gifts = Gift.where( receiver_id: user).where(status: 'redeemed').order("created_at DESC")
  end

  def self.get_all_gifts(user)
    Gift.where( receiver_id: user).order("created_at DESC")
  end
  
  def self.get_all_gifts(user)
    Gift.where(receiver_id: user).order("created_at DESC")
  end
  
  def self.get_buy_history(user)
    gifts = Gift.where( giver_id: user).where("status = :open OR status = :notified", :open => 'open', :notified => 'notified').order("created_at DESC") 
    past_gifts = Gift.where( giver_id: user).where(status: 'redeemed').order("created_at DESC")
    return gifts, past_gifts
  end
  
  def self.get_buy_recents(user)
    Gift.where( giver_id: user).order("created_at DESC").limit(10)
  end
  
  def self.get_activity
    Gift.order("created_at DESC")
  end
  
  def self.get_user_activity(user)
    Gift.where("giver_id = :user OR receiver_id = :user", :user => user.id).order("created_at ASC")
  end
  
  def self.get_activity_at_provider(provider)
    Gift.where(provider_id: provider.id).order("created_at ASC")
  end
  
  def self.get_provider(provider)
    Gift.where(provider_id: provider.id).where("status = :open OR status = :notified", :open => 'open', :notified => 'notified').order("created_at DESC")
  end
  
  def self.get_all_orders(provider)
    Gift.where(provider_id: provider.id).order("updated_at DESC")
  end
  
  def self.get_history_provider(provider)
    Gift.where(provider_id: provider.id).where(status: 'redeemed').order("created_at DESC") 
  end
  
  private
    
    def set_status    
      if !self.receiver_id
        self.status =  "incomplete"
      end
    end
    
    def pluralizer
      if self.quantity > 1
        name_to_match = self.item_name
              # if item name already has a /'s/ then abort 
        if !name_to_match.match /'s/
           self.item_name << "'s"
        end 
      end
    end
    
    def add_category
      self.category = self.item.category
    end
    
    def no_category
      self.category.nil?
    end
    
end

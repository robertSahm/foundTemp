# == Schema Information
#
# Table name: menus
#
#  id          :integer         not null, primary key
#  provider_id :integer         not null
#  item_id     :integer         not null
#  price       :string(20)
#  position    :integer(8)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Menu < ActiveRecord::Base
  attr_accessible :item_id, :position, :price, :provider_id 

  belongs_to   :provider
  # has_and_belongs_to_many   :items
  # has_many     :menu_strings
  
end

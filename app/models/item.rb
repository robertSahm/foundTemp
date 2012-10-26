# == Schema Information
#
# Table name: items
#
#  id          :integer         not null, primary key
#  item_name   :string(50)      not null
#  detail      :string(255)
#  description :text
#  category    :integer(20)     not null
#  proof       :string(255)
#  type_of     :string(255)
#

class Item < ActiveRecord::Base
  attr_accessible :category, :detail, :item_name, :proof, :type_of, :description 
                                                
  has_many  :gifts
  # has_and_belongs_to_many  :menus
end

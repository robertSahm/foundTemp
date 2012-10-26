# == Schema Information
#
# Table name: menu_strings
#
#  id           :integer         not null, primary key
#  version      :integer
#  provider_id  :integer         not null
#  full_address :string(255)
#  data         :text            not null
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

class MenuString < ActiveRecord::Base
  attr_accessible :full_address, :data, :provider_id, :version
  
 # belongs_to :menu
  belongs_to :provider
  
end

# == Schema Information
#
# Table name: connections
#
#  id          :integer         not null, primary key
#  giver_id    :integer
#  receiver_id :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Connection < ActiveRecord::Base
  attr_accessible :giver_id, :receiver_id
  
  belongs_to :giver,    class_name: "User"
  belongs_to :receiver, class_name: "User"
  
  validates :giver_id, presence: true
  validates :receiver_id, presence: true
end

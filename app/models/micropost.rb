# == Schema Information
#
# Table name: microposts
#
#  id         :integer         not null, primary key
#  content    :string(255)     not null
#  user_id    :integer         not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Micropost < ActiveRecord::Base
  attr_accessible :content
  
  belongs_to :user
  belongs_to :video
  
  validates :content, :length => { :maximum => 140 }
  validates :user_id, presence: true
  
  default_scope order: 'microposts.created_at DESC'
  
  # Returns microposts from the users being followed by the given user.
  scope :from_users_followed_by, lambda { |user| followed_by(user) }

  
  private
  
  # Returns an SQL condition for users followed by the given user.
  # We include the user's own id as well.
    def self.followed_by(user)
      followed_user_ids = %(SELECT followed_id FROM relationships WHERE follower_id = :user_id)
      where("user_id IN (#{followed_user_ids})", { user_id: user })
    end
end

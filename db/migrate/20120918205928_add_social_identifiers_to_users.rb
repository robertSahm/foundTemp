class AddSocialIdentifiersToUsers < ActiveRecord::Migration
  def change
    add_column :users, :foursquare_id,            :string
    add_column :users, :facebook_access_token,    :string
    add_column :users, :facebook_expiry,          :datetime
    add_column :users, :foursquare_access_token,  :string
  end
end

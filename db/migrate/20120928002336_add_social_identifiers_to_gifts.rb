class AddSocialIdentifiersToGifts < ActiveRecord::Migration
  def change
    add_column :gifts, :foursquare_id,  :string
    add_column :gifts, :facebook_id,    :string
  end
end

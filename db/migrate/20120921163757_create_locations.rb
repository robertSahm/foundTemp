class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.float   :latitude
      t.float   :longitude
      t.integer :provider_id
      t.integer :user_id
      t.string  :foursquare_venue_id

      t.timestamps
    end
  end
end

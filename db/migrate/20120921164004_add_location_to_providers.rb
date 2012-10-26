class AddLocationToProviders < ActiveRecord::Migration
  def change
    add_column :providers, :latitude,       :float
    add_column :providers, :longitude,      :float
    add_column :providers, :foursquare_id,  :string
  end
end

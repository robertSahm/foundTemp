class AddPhotoToProviders < ActiveRecord::Migration
  def change
    add_column :providers, :photo, :string
  end
end

class AddPortraitAndBoxToProviders < ActiveRecord::Migration
  def change
    add_column :providers, :portrait, :string
    add_column :providers, :box, :string
  end
end

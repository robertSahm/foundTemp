class AddActiveToUsersProviders < ActiveRecord::Migration
  def up
    add_column :providers, :active, :boolean, default: true
    add_column :users, :active, :boolean, default: true
    add_column :users, :persona, :string, default: ""
  end
  
  def down
    remove_column :providers, :active
    remove_column :users, :active
    remove_column :users, :persona
  end
end

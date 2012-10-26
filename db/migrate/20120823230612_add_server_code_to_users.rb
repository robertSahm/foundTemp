class AddServerCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :server_code, :string
  end
end

class AddMerchantCodeAndServerIdToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :server_code, :string
    add_column :orders, :server_id, :integer
  end
end

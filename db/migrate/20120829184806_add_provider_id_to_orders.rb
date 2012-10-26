class AddProviderIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :provider_id, :integer
  end
end

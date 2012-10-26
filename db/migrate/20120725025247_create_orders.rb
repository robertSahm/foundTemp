class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :redeem_id
      t.integer :gift_id
      t.string  :redeem_code

      t.timestamps
    end
  end
end

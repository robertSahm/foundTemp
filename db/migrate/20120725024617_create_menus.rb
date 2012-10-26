class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.integer :provider_id, null: false
      t.integer :item_id, null: false
      t.string  :price, limit: 20
      t.integer :position, limit: 8 

      t.timestamps
    end
  end
end

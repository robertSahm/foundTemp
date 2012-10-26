class CreateItemsMenusJoinTable < ActiveRecord::Migration

  create_table :items_menus, id: false do |t|
    t.integer :item_id
    t.integer :menu_id
  end

end

class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string  :item_name, limit: 50, null: false 
      t.string  :detail
      t.text    :description
      t.integer :category, limit: 20, null: false
    end
  end
end

class CreateGifts < ActiveRecord::Migration
  def change
    create_table :gifts do |t|
      t.string  :giver_name
      t.string  :receiver_name
      t.string  :provider_name
      t.string  :item_name
      t.integer :giver_id
      t.integer :receiver_id
      t.integer :item_id
      t.string  :price, limit: 20
      t.integer :quantity, null: false
      t.string  :total, limit: 20
      t.string  :credit_card, limit: 100
      t.integer :provider_id
      t.text    :message
      t.text    :special_instructions
      t.integer :redeem_id 
      t.string  :status, default: "open"
      t.string  :category

      t.timestamps
    end
  end
end

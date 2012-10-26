class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.string  :name, null: false
      t.string  :zinger
      t.text    :description
      t.string  :address
      t.string  :address_2
      t.string  :city, limit: 32
      t.string  :state, limit: 2
      t.string  :zip, limit: 16
      t.integer :user_id, null: false
      t.string  :logo

      t.timestamps
    end
  end
end

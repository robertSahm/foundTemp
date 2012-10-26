class CreateMenuStrings < ActiveRecord::Migration
  def change
    create_table :menu_strings do |t|
      t.integer :version
      t.integer :provider_id,   null: false
      t.string  :full_address
      t.text    :data,          null: false

      t.timestamps
    end
  end
end

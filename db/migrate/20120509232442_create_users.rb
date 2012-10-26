class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :email, null: false
      t.boolean :admin, default: false
      t.string  :photo
      t.string  :password_digest, null: false
      t.string  :remember_token, null: false

      t.timestamps
    end
  end
end

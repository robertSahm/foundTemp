class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.integer  :provider_id, null: false
      t.integer  :user_id, null: false
      t.string   :clearance,  default: "staff"
      t.boolean  :active, default: true
      t.timestamps
    end
  end
end

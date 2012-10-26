class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.integer :giver_id
      t.integer :receiver_id

      t.timestamps
    end
    
    add_index	:connections, :giver_id
  	add_index	:connections, :receiver_id
  end
end

class AddTypeOfToItems < ActiveRecord::Migration
  def change
    add_column :items,     :proof,      :string    
    add_column :items,     :type_of,    :string    
  end
end

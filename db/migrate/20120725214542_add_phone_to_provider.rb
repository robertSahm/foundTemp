class AddPhoneToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :phone,    :string
    add_column :providers, :email,    :string
    add_column :providers, :twitter,  :string
    add_column :providers, :facebook, :string
    add_column :providers, :website,  :string    
  end
end

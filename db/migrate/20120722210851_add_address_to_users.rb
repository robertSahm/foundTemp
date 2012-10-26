class AddAddressToUsers < ActiveRecord::Migration
  def change
    add_column    :users, :address,     :string
    add_column    :users, :address_2,   :string
    add_column    :users, :city,         :string, limit: 20 
    add_column    :users, :state,         :string, limit: 2 
    add_column    :users, :zip,           :string, limit: 16
    add_column    :users, :credit_number, :string, length: { maximum: 20 }
    add_column    :users, :phone,         :string, length: { maximum: 30 }
    add_column    :users, :first_name,    :string, length: { maximum: 50 }
    add_column    :users, :last_name,     :string, length: { maximum: 50 }
  end
end

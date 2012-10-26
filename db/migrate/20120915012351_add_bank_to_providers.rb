class AddBankToProviders < ActiveRecord::Migration
  def change
    add_column :providers, :account_name, :string
    add_column :providers, :aba, :string
    add_column :providers, :routing, :string
    add_column :providers, :bank_account_name, :string
    add_column :providers, :bank_address, :string
    add_column :providers, :bank_city, :string
    add_column :providers, :bank_state, :string
    add_column :providers, :bank_zip, :string
  end
end

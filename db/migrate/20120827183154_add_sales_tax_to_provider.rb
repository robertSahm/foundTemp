class AddSalesTaxToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :sales_tax, :string
  end
end

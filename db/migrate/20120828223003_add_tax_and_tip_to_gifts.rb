class AddTaxAndTipToGifts < ActiveRecord::Migration
  def change
    add_column :gifts, :tax, :string
    add_column :gifts, :tip, :string
  end
end

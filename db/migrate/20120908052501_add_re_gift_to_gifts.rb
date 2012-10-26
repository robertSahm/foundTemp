class AddReGiftToGifts < ActiveRecord::Migration
  def change
    add_column :gifts, :gift_id, :integer
  end
end

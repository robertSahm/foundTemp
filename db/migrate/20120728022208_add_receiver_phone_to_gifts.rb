class AddReceiverPhoneToGifts < ActiveRecord::Migration
  def change
    add_column :gifts, :receiver_phone, :string
  end
end

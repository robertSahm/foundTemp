class RemoveStaffIdFromProviders < ActiveRecord::Migration
  def up
    remove_column :providers, :staff_id
    remove_column :providers, :user_id
    remove_column :users,     :provider_id
  end

  def down
    add_column    :providers,  :staff_id,      :string
    add_column    :providers,  :user_id,       :integer
    add_column    :users,      :provider_id,   :integer
  end
end

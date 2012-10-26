class AddStaffIdToProviders < ActiveRecord::Migration
  def change
    add_column :providers, :staff_id, :string
  end
end

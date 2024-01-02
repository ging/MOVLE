class AddOwnerIdToLinks < ActiveRecord::Migration[7.0]
  def change
    add_column :links, :owner_id, :integer
  end
end

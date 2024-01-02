class AddOwnerIdToEmbeds < ActiveRecord::Migration[7.0]
  def change
    add_column :embeds, :owner_id, :integer
  end
end

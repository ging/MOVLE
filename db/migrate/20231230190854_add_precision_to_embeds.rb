class AddPrecisionToEmbeds < ActiveRecord::Migration[7.0]
  def change
    change_column :embeds, :created_at, :datetime, precision: nil
    change_column :embeds, :updated_at, :datetime, precision: nil
  end
end

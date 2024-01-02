class AddCertifiedToEmbeds < ActiveRecord::Migration[7.0]
  def change
    add_column :embeds, :certified, :boolean, default: false
  end
end

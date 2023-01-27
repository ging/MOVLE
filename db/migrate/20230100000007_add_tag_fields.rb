class AddTagFields < ActiveRecord::Migration[4.2]
  def change
    add_column :tags, :plain_name, :string
    add_column :users, :tag_array_text, :text, :default => ""
  end
end
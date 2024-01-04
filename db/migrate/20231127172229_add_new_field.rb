class AddNewField < ActiveRecord::Migration[7.0]
  def change
    add_column :presentations, :views, :integer
  end
end

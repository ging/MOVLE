class AddPresentations < ActiveRecord::Migration[4.2]
	def change
		create_table(:presentations) do |t|
			t.integer  :owner_id
			t.text     :json
			t.string   :title
			t.text     :description
			t.text     :thumbnail_url
			t.string   :language
			t.integer  :age_min, :default => 0
			t.integer  :age_max, :default => 0
			t.integer  :views, :default => 0
			t.boolean  :draft, :default => false
			t.datetime :scorm2004_timestamp
			t.datetime :scorm12_timestamp
			t.boolean  :certified, :default => false
			t.text     :tag_array_text, :default => ""
			t.timestamps null: false
		end
	end
end
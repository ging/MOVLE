class User < ActiveRecord::Base
	devise :database_authenticatable, :registerable,
	:recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable

	include Taggable
	acts_as_ordered_taggable

	has_many :presentations, :foreign_key => "owner_id", :dependent => :destroy
	has_many :documents, :foreign_key => "owner_id", :dependent => :destroy
	has_many :scormfiles, :foreign_key => "owner_id", :dependent => :destroy
	has_many :pdfp, :foreign_key => "owner_id", :dependent => :destroy

	before_save :fillTags
	before_save :save_tag_array_text

	validates_presence_of :name

	def files
		self.documents + self.scormfiles
	end

end
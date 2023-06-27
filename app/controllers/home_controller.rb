class HomeController < ApplicationController
	before_action :authenticate_user!, :except => [:frontpage]
	skip_authorization_check :only => [:frontpage,:home]

	def frontpage
		@popularItems = Presentation.public_items.sample(12)
		if user_signed_in?
			redirect_to "/home"
		else
			respond_to do |format|
				format.html { render layout: "application" }
			end
		end
	end

	def home
		publicItems = Presentation.public_items
		@latestItems = publicItems.sample(6)
		@recommendedItems = publicItems.where("id NOT in (?)",@latestItems.map{|r| r.id}).sample(6)
		@popularItems = publicItems.where("id NOT in (?)",@latestItems.map{|r| r.id} + @recommendedItems.map{|r| r.id}).sample(6)

		respond_to do |format|
			format.html { render layout: "application" }
		end
	end
end
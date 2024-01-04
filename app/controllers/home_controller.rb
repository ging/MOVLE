class HomeController < ApplicationController
	before_action :authenticate_user!, :except => [:frontpage]
	skip_authorization_check :only => [:frontpage,:home]

	def frontpage
		@popularItems = Presentation.public_items.sample(14)
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
		@popularItems = publicItems.sort_by(&:views).reverse.take(7)
		@latestItems = publicItems.where("id NOT in (?)", @popularItems.map { |r| r.id })
		@latestItems = @latestItems.sort_by(&:created_at).reverse.take(7)
		@linksfiles= Link.public_items.sample(1) + Embed.public_items.sample(1) + Document.public_items.sample(5)

		respond_to do |format|
			format.html { render layout: "application" }
		end
	end
end
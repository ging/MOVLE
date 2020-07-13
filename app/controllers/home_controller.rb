class HomeController < ApplicationController
	before_action :authenticate_user!, :except => [:frontpage]
	skip_authorization_check :only => [:frontpage]

	def frontpage
		respond_to do |format|
			format.html { render layout: "application" }
		end
	end
end
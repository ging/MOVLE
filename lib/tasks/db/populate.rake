namespace :db do

	#bundle exec rake db:populate
	task :populate => :environment do
		desc "Populate database for a development environment"
		t1 = Time.now

		#1: Create demo user
		user = User.new
		user.email = "demo@upm.es"
		user.password = "demonstration"
		user.name = "Demo"
		user.ui_language = I18n.default_locale
		user.confirmed_at = DateTime.now
		user.skip_confirmation!
		user.save!
		puts "User '" + user.name + "' created with email '" + user.email + "' and password 'demonstration'"

		puts "Populate finished"
		t2 = Time.now - t1
		puts "Elapsed time:" + t2.to_s
	end

end
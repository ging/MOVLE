namespace :movle do
	#bundle exec rake movle:rebuild
	#bundle exec rake movle:rebuild RAILS_ENV=production
	task :rebuild do
		desc "Rebuild"
		system "rake movle:reset"
		system "rake db:populate"
		puts "Rebuild finished"
	end

	task :reset do
		desc "Reset"
		system "rake db:drop"
		system "rake db:create"
		system "rake db:migrate"
		system "rm -rf documents/*"
		system "rm -rf public/system/*"
		system "rm -rf public/tmp/*"
		puts "Reset finished"
	end
end
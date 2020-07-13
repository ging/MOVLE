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
		system "rm -rf public/scorm/12/presentations/*"
		system "rm -rf public/scorm/2004/presentations/*"
		system "rm -rf documents/*"
		system "rm -rf public/system/*"
		system "rm -rf public/tmp/scorm/*"
		system "rm -rf public/tmp/json/*"
		system "rm -rf public/tmp/qti/*"
		system "rm -rf public/tmp/moodlequizxml/*"
		puts "Reset finished"
	end
end
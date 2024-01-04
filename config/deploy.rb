# config valid for current version and patch releases of Capistrano
lock "~> 3.18.0"

require 'yaml'

set :application, "movle"
set :repo_url, 'https://github.com/ging/MOVLE.git'
set :branch, 'ruben-tfg'

set :ssh_options, {
  forward_agent: true,
  auth_methods: ['publickey'],
  keys: ['~/.ssh/id_rsa']
}

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/application_config.yml", 'config/database.yml'

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor", "storage"

# Default value for default_env is {}
set :ruby_path, '/home/ging/.rvm/rubies/ruby-3.0.0'
set :bundle_path, '/home/ging/.rvm/gems/ruby-3.0.0'

set :default_env, { 
  path: "#{fetch(:ruby_path)}/bin:#{fetch(:bundle_path)}/bin:$PATH" 
}

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

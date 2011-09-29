# Problem with sudo and passwords
# http://groups.google.com/group/capistrano/browse_thread/thread/e79e1e85b084e39a
# could be placed in ~/.caprc file, /etc/capistrano.conf, ./Capfile, or deploy.rb
default_run_options[:pty] = true

set :use_sudo, false

set :application, "andreord.example.com"
set :domain, "yourserver.example.com"

set :scm, :git
set :repository,  "git@github.com:andersjo/andreord-public.git"

set :deploy_via, :remote_cache

set :ssh_options, { :forward_agent => true }

role :web, domain                          # Your HTTP server, Apache/etc
role :app, domain                          # This may be the same as your `Web` server
role :db,  domain, :primary => true # This is where Rails migrations will run

# RVM on server
$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
set :rvm_type, :user

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task(:start) {}
  task(:stop) {}
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
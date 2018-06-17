# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "ask_here"
#set :repo_url, "git@github.com:rusdec/#{fetch(:application)}.git"
set :repo_url, "https://github.com/rusdec/#{fetch(:application)}.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/#{fetch(:application)}"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/cable.yml", ".env"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "public/uploads"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

# Tasks
namespace 'deploy' do
  desc 'Restart application server'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      #execute :touch, release_path.join('tmp/restart.txt')
      invoke 'unicorn:restart'
    end
  end

  desc 'Restart thinking sphinx'
  task :ts_restart do
    on roles(:db) do
      within release_path do
        execute "searchd -c #{release_path}/config/#{fetch(:rails_env)}.sphinx.conf --stop"
        execute "searchd -c #{release_path}/config/#{fetch(:rails_env)}.sphinx.conf"
      end
    end
  end

  desc 'Thinking sphinx index'
  task :ts_index do
    on roles(:db) do
      within release_path do
        execute :rake, 'ts:index'
      end
    end
  end

  after :publishing, :restart
  after :publishing, :ts_index
  after :publishing, :ts_restart
end

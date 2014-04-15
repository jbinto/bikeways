# Adapted from https://github.com/jbinto/rails4-sample-app-capistrano/blob/master/config/deploy.rb

lock '3.1.0'

set :application, 'bikeways'
set :repo_url, 'https://github.com/jbinto/bikeways.git'

set :deploy_user, 'gear'

# See https://github.com/capistrano/rbenv#usage for details
# on rbenv boilerplate.
set :rbenv_type, :user
set :rbenv_ruby, '2.1.1'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

# These are symlinks, so redeploys don't "overwrite" important files.
set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Run Rspec tests before deploying. Nifty.
# Depends on lib/capistrano/tasks/run_tests.cap
set :tests, ["spec"]

namespace :deploy do
  before :deploy, "deploy:check_revision"
  before :deploy, "deploy:run_tests"
  after 'deploy:symlink:shared', 'deploy:compile_assets_locally'
  after :finishing, 'deploy:cleanup'

  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join("tmp/restart.txt")
    end
  end
end
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
set :linked_files, %w{config/database.yml .env}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Run Rspec tests before deploying. Nifty.
# Depends on lib/capistrano/tasks/run_tests.cap
set :tests, ["spec"]


namespace :rails do
  desc 'Tail Rails log'
  task :log do
    on roles(:app) do
      execute "tail -f #{shared_path}/log/#{fetch(:rails_env)}.log"
    end
  end

  desc "Restart the rails app by touching tmp/restart.txt"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join("tmp/restart.txt")
    end
  end
end

namespace :db do
  desc 'Drop DB'
  task :drop do
    rake "environment db:drop"
  end

  desc 'Create DB'
  task :create do
    rake "db:create"
  end

  desc "Restart the rails app by touching tmp/restart.txt"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join("tmp/restart.txt")
    end
  end
end

namespace :opendata do
  desc "Run rake task to get bikeways opendata"
  task :init do
    rake "opendata:init"
  end

  desc "Run rake task to get bikeways opendata (even if it exists already, will overwrite)"
  task :reset do
    rake "opendata:reset"
  end
end

namespace :deploy do

  # See http://capistranorb.com/documentation/getting-started/flow/
  # for event flow lifecycle
  before :deploy, "deploy:check_revision"
  before :deploy, "deploy:run_tests"
  after 'deploy:migrate', 'opendata:init'
  after 'deploy:symlink:shared', 'deploy:compile_assets_locally'
  after :finishing, 'deploy:cleanup'

end

def rake(args)
  on roles(:app) do
    within release_path do
      with rails_env: fetch(:rails_env) do
        execute :rake, args
      end
    end
  end
end
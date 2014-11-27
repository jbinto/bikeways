set :stage, :staging
set :branch, "envs/staging"
set :deploy_user, "staging0"
set :rails_env, :staging

server 'staging.416.bike', user: fetch(:deploy_user), roles: %w{web app db}, primary: true

set :full_app_name, "#{fetch(:application)}"
set :deploy_to, "/home/#{fetch(:deploy_user)}/apps/#{fetch(:full_app_name)}"

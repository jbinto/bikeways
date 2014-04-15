set :stage, :staging
set :branch, "master"

server 'staging.416.bike', user: fetch(:deploy_user), roles: %w{web app db}, primary: true

set :full_app_name, "#{fetch(:application)}_staging"
set :deploy_to, "/home/#{fetch(:deploy_user)}/apps/#{fetch(:full_app_name)}"
set :rails_env, :staging
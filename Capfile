# Also see https://github.com/jbinto/rails4-sample-app-capistrano/blob/master/Capfile

require 'capistrano/setup'
require 'capistrano/deploy'

require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }

# Load helper functions from lib/capistrano.
Dir.glob('lib/capistrano/**/*.rb').each { |r| import r }

# Load application rake tasks from tasks/
Dir.glob('tasks/*.rake').each { |r| import r }
source 'https://rubygems.org'
ruby '2.1.5'

# It's a little roundabout.
# Since Rails 4.1, secrets defined in secrets.yml. But in production, they go to ENV.
# Using this gem, ENV will be populated with the contents of the .env file.
gem 'dotenv-rails'

gem 'rails', '4.1.8'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'spring',        group: :development
gem 'bootstrap-sass'
gem 'devise'
gem 'haml-rails'
gem 'pg'
group :development do
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_19, :mri_20, :mri_21, :rbx]
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'html2haml'
  gem 'quiet_assets'
  gem 'rails_layout'
  gem 'rb-fchange', :require=>false
  gem 'rb-fsevent', :require=>false
  gem 'rb-inotify', :require=>false
end
group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'thin'
  gem 'pry-rails'

  gem 'annotate', '>=2.6.0'

  gem 'capistrano',  '~> 3.1'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-rbenv', '~> 2.0'
end
group :test do
  gem 'capybara'
  gem 'database_cleaner', '1.0.1'
  gem 'email_spec'
end

gem 'activerecord-postgis-adapter',
  github: 'rgeo/activerecord-postgis-adapter'

gem 'rgeo'
gem 'rgeo-geojson', '~> 0.3.1'

gem 'jquery-datatables-rails', '~> 2.2.3'

# http://railscasts.com/episodes/340-datatables
gem 'will_paginate'

gem 'gmaps4rails'
gem 'underscore-rails'

# "Garber-Irish" style JavaScript.
# Allows per-page JavaScript in rails. JS boilerplate simple enough but hidden in this gem.
# See https://github.com/tonytonyjan/gistyle and http://viget.com/inspire/extending-paul-irishs-comprehensive-dom-ready-execution
gem 'gistyle'

# for making HTTP requests less dense
gem 'httparty'

# for reading shapefiles
gem 'rubyzip', '>= 1.0.0'
gem 'rgeo-shapefile'
gem 'dbf'

gem 'jazz_hands', github: 'nixme/jazz_hands', branch: 'bring-your-own-debugger'
gem 'pry-byebug'  

gem 'ruby-progressbar'
gem 'has_scope'

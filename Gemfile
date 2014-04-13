source 'https://rubygems.org'
ruby '2.1.1'
gem 'rails', '4.1.0'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
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

  # for reading shapefiles
  gem 'rubyzip', '>= 1.0.0'
  gem 'rgeo-shapefile'
  gem 'dbf'

  # for making HTTP requests less dense
  gem 'httparty'

  gem 'annotate', '>=2.6.0'
end
group :test do
  gem 'capybara'
  gem 'database_cleaner', '1.0.1'
  gem 'email_spec'
end

gem 'activerecord-postgis-adapter',
  github: 'neighborland/activerecord-postgis-adapter'

gem 'rgeo'

gem 'jquery-datatables-rails', git: 'git://github.com/jbinto/jquery-datatables-rails.git'

# http://railscasts.com/episodes/340-datatables
gem 'will_paginate'

# Make it so we don't have to do anything funky with jquery.
gem 'jquery-turbolinks'

gem 'gmaps4rails'
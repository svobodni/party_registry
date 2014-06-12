source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.3'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

gem 'rails_admin'

# Autentizace
gem 'devise'
gem 'devise-encryptable'

# Autorizace
gem 'cancan'

# Verzování změn objektů
gem 'paper_trail', '~> 3.0.0'

# Stavovy stroj
gem 'aasm'

# JSON serializer
gem 'active_model_serializers'

# PDF generator
gem 'prawn'
gem 'prawn-rails'

# XML parser pro import
gem 'crack'

gem 'geocoder'
gem 'httparty'

# [WEB] breadcrumbs
gem 'gretel'
# [WEB] layout
gem 'svobodni_layout', git: 'https://github.com/svobodni/svobodni_layout'
# [WEB] mapy
gem 'gmaps4rails'

# [INT] FIO banka
gem 'fio_api' # gem 'fio_api', :git => 'https://github.com/kubicek/fio_api.git'


group :test do
  gem 'cucumber-rails', :require => false
  # database_cleaner is not required, but highly recommended
  gem 'database_cleaner'
  gem 'cucumber-api-steps', :require => false
  gem 'shoulda-context'
end

group :development do
  gem 'capistrano-rails',   '~> 1.1', require: false
  gem 'capistrano-bundler', '~> 1.1', require: false
end


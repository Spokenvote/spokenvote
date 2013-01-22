source 'https://rubygems.org'

gem 'rails', '3.2.11'

# Infrastructure
# gem 'heroku'
gem 'devise'
gem 'pg'
gem 'thin'
gem 'dalli'
gem 'rack-cache'

# Javascript
gem 'jquery-rails'
gem 'jquery-tokeninput-rails'
gem 'select2-rails', "~> 3.1.1"

# UI/Forms
gem 'nested_form'
gem 'haml-rails'
gem 'simple_form'
gem 'compass'
gem 'compass-rails'
gem 'compass_twitter_bootstrap'

# Authentication
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'

# Other
gem 'ancestry'
gem 'version_fu'
gem 'activerecord-reputation-system', require: 'reputation_system'
gem 'faker'
gem 'newrelic_rpm'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.5'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'taps', :require => false
  gem 'hirb'
  gem 'annotate'
  gem 'debugger'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'populator'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
end

group :production do
  gem 'newrelic_rpm'
end

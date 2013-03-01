source 'https://rubygems.org'

gem 'rails', '3.2.12'

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
gem 'select2-rails'
gem 'backbone-on-rails'

# UI/Forms
gem 'nested_form'
gem 'haml-rails'
gem 'simple_form'
gem 'compass'
gem 'compass-rails'
gem 'compass_twitter_bootstrap'
gem 'activeadmin'

# Authentication
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'

# Other
gem 'ancestry'
gem 'version_fu'
gem 'activerecord-reputation-system', require: 'reputation_system'
gem 'rabl'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.5'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'handlebars_assets'
end

group :development do
  gem 'taps', :require => false
  gem 'hirb'
  gem 'annotate'
  gem 'debugger'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'populator'
  gem 'rspec'
  gem 'spork'
  gem 'shoulda-matchers'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
end

group :production, :staging do
  gem 'newrelic_rpm', '3.5.5.38'
  gem "airbrake"
end

source 'https://rubygems.org'
# source 'https://rails-assets.org'

ruby '2.5.0'
# ruby '2.4.5'
# ruby '2.3.3'

gem 'rails', '~> 4.2.11.3'

# Temp gems in place to enable Rails 4 upgrade, consider removing
# gem 'protected_attributes', '1.0.7'       # Remove "config.active_record.whitelist_attributes = false" when done
# gem 'strong_parameters'

# Infrastructure
gem 'devise', '~> 4.7.1'
# gem 'devise', "~> 3.4.1"
gem 'pg'
gem 'puma'
gem 'memcachier'
gem 'dalli'
gem 'rack-cache'
# gem 'responders', '~> 2.0'
# gem 'nokogiri', '1.9.1'   # remove after ruby 2.3
gem 'nokogiri', '>= 1.11.0'   # per github dependbot alert Mar 17, 2021
#gem 'thin'

# UI/Forms
# gem 'haml-rails'
gem 'slim', '~> 2.0.2'
gem 'bootstrap-sass', '~> 3.4.1'
# gem 'bootstrap-sass', '~> 3.1.1'
gem 'compass-rails'
gem 'compass'
gem 'activeadmin', '1.4.3'
# gem 'activeadmin', '1.0.0.pre5'
# gem 'activeadmin', github: 'gregbell/active_admin'

# Authentication
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'

# Other
gem 'ancestry'
gem 'version_fu'
gem 'rabl'
gem 'sitemap_generator'
# gem 'activerecord-reputation-system', require: 'reputation_system'
# gem 'google_places_autocomplete'
# gem 'places'
# gem 'mandrill-api'
gem 'premailer-rails', '~> 1.9.0' #silent dependency on Nokogiri
gem 'add-to-homescreen-rails'
gem 'sass-rails',   '~> 4.0.1'
gem 'coffee-rails', '~> 4.0.1'
gem 'uglifier', '>= 2.4.0'

# Angular
gem 'angular-rails-templates', '~> 0.1.3'

group :development do
  # gem 'taps', :require => false       # disabled  Mar 23, 2019 due to gem "rest-client", ">= 1.8.0" security issue
  gem 'hirb'
  gem 'annotate'
  gem 'pry-rails'
  gem 'pry-doc'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'lol_dba'
  gem 'web-console', '~> 2.0'       # rails 4.2 upgrade guide
  # gem "intellij-coffee-script-debugger", :git => "git://github.com/JetBrains/intellij-coffee-script-debugger.git"
  #gem 'debugger'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'rspec-activemodel-mocks', '~> 1.0.3'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'populator'
  # gem 'rspec'       # Seems duplication with rspec-rails present
  gem 'spork'
  gem 'shoulda-matchers'
  gem 'railroady'
end

group :test do
  gem 'minitest'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'email_spec'
  gem 'simplecov'
end

group :production, :staging do
  gem 'rails_12factor'
  gem 'newrelic_rpm', '3.5.5.38'
  gem 'airbrake'
  gem 'prerender_rails'
  gem 'fog'
  # gem 'ngmin-rails', '~> 0.4.0'
end

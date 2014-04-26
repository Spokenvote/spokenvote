source 'https://rubygems.org'

ruby '2.1.1'

gem 'rails', '~> 4.1.0'

# Temp gems in place to enable Rails 4 upgrade, consider removing
gem 'protected_attributes'       # Remove "config.active_record.whitelist_attributes = false" when done

# Infrastructure
gem 'devise', "~> 3.2.3"
gem 'pg'
gem 'puma'
gem 'memcachier'
gem 'dalli'
gem 'rack-cache'
#gem 'thin'

# Javascript
# gem 'jquery-rails', '< 3.0.0'
# gem 'jquery-ui-rails'
# gem 'jquery-tokeninput-rails'

# UI/Forms
# gem 'nested_form'
# gem 'simple_form'
gem 'haml-rails'
gem 'slim', '~> 2.0.2'
gem 'bootstrap-sass', '~> 3.1.0'
gem 'compass-rails'
gem 'compass'
gem 'activeadmin', github: 'gregbell/active_admin'
#gem 'activeadmin', '~> 0.6.3'    # Not compatible with Rails 4

# Authentication
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'

# Other
gem 'ancestry'
gem 'version_fu'
gem 'activerecord-reputation-system', require: 'reputation_system'
gem 'rabl'
gem 'sitemap_generator'
gem 'google_places_autocomplete'
gem 'places'
# gem 'mandrill-api'
gem 'premailer-rails' #silent dependency on Nokogiri
gem 'add-to-homescreen-rails'
gem 'sass-rails',   '~> 4.0.1'
gem 'coffee-rails', '~> 4.0.1'
gem 'uglifier', '>= 2.4.0'

group :development do
  gem 'taps', :require => false
  gem 'hirb'
  gem 'annotate'
  gem 'pry-rails'
  gem 'pry-doc'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'lol_dba'
  gem "intellij-coffee-script-debugger", :git => "git://github.com/JetBrains/intellij-coffee-script-debugger.git"
  #gem 'debugger'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'populator'
  gem 'rspec'
  gem 'spork'
  gem 'shoulda-matchers'
  gem 'railroady'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'email_spec'
end

group :production, :staging do
  gem 'rails_12factor'
  gem 'newrelic_rpm', '3.5.5.38'
  gem "airbrake"
  gem 'prerender_rails'
  gem 'fog'
  gem 'ngmin-rails', '~> 0.4.0'
end

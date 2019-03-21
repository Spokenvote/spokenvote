source 'https://rubygems.org'
# source 'https://rails-assets.org'

# ruby '2.4.5'
ruby '2.3.1'
# ruby '2.2.3'
# ruby '2.1.1'    # Make sure ruby version here matches the the .rvmrc file

gem 'rails', '~> 4.1'

# Temp gems in place to enable Rails 4 upgrade, consider removing
gem 'protected_attributes'       # Remove "config.active_record.whitelist_attributes = false" when done

# Infrastructure
gem 'devise', "~> 3.2.3"
gem 'pg'
gem 'puma'
gem 'memcachier'
gem 'dalli'
gem 'rack-cache'
# gem 'nokogiri', '1.9.1'   # remove after ruby 2.3
#gem 'thin'

# Javascript
# gem 'jquery-rails', '< 3.0.0'
# gem 'jquery-ui-rails'
# gem 'jquery-tokeninput-rails'

# UI/Forms
gem 'haml-rails'
gem 'slim', '~> 2.0.2'
gem 'bootstrap-sass', '~> 3.1.1'
gem 'compass-rails'
gem 'compass'
gem 'activeadmin', '1.0.0.pre1'
# gem 'activeadmin', github: 'gregbell/active_admin'
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

# Angular
gem 'angular-rails-templates', '~> 0.1.3'

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
  # gem "intellij-coffee-script-debugger", :git => "git://github.com/JetBrains/intellij-coffee-script-debugger.git"
  # gem 'web-console', '~> 2.0'       # rails 4.2 upgrade guide
  #gem 'debugger'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'rspec-activemodel-mocks'
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
end

group :production, :staging do
  gem 'rails_12factor'
  gem 'newrelic_rpm', '3.5.5.38'
  gem 'airbrake'
  gem 'prerender_rails'
  gem 'fog'
  gem 'ngmin-rails', '~> 0.4.0'
end

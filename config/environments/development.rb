Spokenvote::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  config.eager_load = false

  config.cache_store = :dalli_store

  # Log error messages when you accidentally call methods on nil.
  #config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  # Expands the lines which load the assets
  config.assets.debug = true

  ActionMailer::Base.smtp_settings = {
    :port =>           '587',
    :address =>        ENV['MAIL_ADDRESS'],
    # :address =>        'smtp.mandrillapp.com',
    :user_name =>      ENV['MAIL_USERNAME'],
    # :user_name =>      ENV['MANDRILL_USERNAME'],
    :password =>       ENV['MAIL_PASSWORD'],
    # :password =>       ENV['MANDRILL_APIKEY'],
    :domain =>         'spokenvote.dev',   # When using POW rails server
    # :domain =>         'localhost:3000', # Most dev's will want this one.
    :authentication => :plain,
    :enable_starttls_auto => true

  }

  Premailer::Rails.config.merge!(base_url: 'http://spokenvote.dev/')      # When using POW rails server
  # Premailer::Rails.config.merge!(base_url: 'http://localhost:3000/')    # Most dev's will want this one.

  # Use Pry instead of IRB
  silence_warnings do
    begin
      require 'pry'
      IRB = Pry
      module Pry::RailsCommands ;end
      IRB::ExtendCommandBundle = Pry::RailsCommands
    rescue LoadError
    end
  end

end


